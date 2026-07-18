import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/modules/auth/repository/doctor_verification_repository.dart';

// Doctor verification state model
class DoctorStatusState {
  final bool isLoading;
  final bool isResolved;
  final String? status; // PENDING | APPROVED | REJECTED
  final bool isUsingCache; // true when using Hive fallback
  final String? rejectionReason;
  final String? errorMessage;

  const DoctorStatusState({
    this.isLoading = false,
    this.isResolved = false,
    this.status,
    this.isUsingCache = false,
    this.rejectionReason,
    this.errorMessage,
  });

  // Sentinel to distinguish "keep old value" from "set to null"
  static const _unset = Object();

  DoctorStatusState copyWith({
    bool? isLoading,
    bool? isResolved,
    Object? status = _unset,
    bool? isUsingCache,
    Object? rejectionReason = _unset,
    Object? errorMessage = _unset,
  }) {
    return DoctorStatusState(
      isLoading: isLoading ?? this.isLoading,
      isResolved: isResolved ?? this.isResolved,
      status: identical(status, _unset) ? this.status : status as String?,
      isUsingCache: isUsingCache ?? this.isUsingCache,
      rejectionReason: identical(rejectionReason, _unset)
          ? this.rejectionReason
          : rejectionReason as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

// Single provider for doctor verification status
final doctorStatusProvider =
NotifierProvider<DoctorStatusNotifier, DoctorStatusState>(
  DoctorStatusNotifier.new,
);

// Centralized state manager for doctor verification flow
class DoctorStatusNotifier extends Notifier<DoctorStatusState> {
  Timer? _retryTimer;
  int _retryAttempt = 0;
  bool _isInitializing = false;
  static const int _maxRetryAttempts = 3;

  @override
  DoctorStatusState build() {
    // Cleanup when provider is disposed
    ref.onDispose(() {
      _stopRetry();
    });

    return const DoctorStatusState();
  }

  // Called once from SplashScreen for logged-in doctors
  Future<void> initialize() async {
    if (_isInitializing) {
      AppLogger.debug('Already initializing, skipping duplicate call',
          tag: 'DoctorStatus');
      return;
    }
    _isInitializing = true;

    AppLogger.info('Doctor verification: initializing...',
        tag: 'DoctorStatus');
    state = state.copyWith(isLoading: true, isResolved: false);

    try {
      await _fetchFromServer(isInitial: true);
    } finally {
      state = state.copyWith(isLoading: false, isResolved: true);
      _isInitializing = false;
      AppLogger.info(
          'Doctor verification: initialization complete, '
              'status=${state.status}, usingCache=${state.isUsingCache}',
          tag: 'DoctorStatus');
    }
  }

  // Called on pull-to-refresh from VerificationStatusScreen
  Future<void> checkStatus() async {
    AppLogger.info('Doctor verification: manual refresh requested',
        tag: 'DoctorStatus');
    state = state.copyWith(isLoading: true);
    try {
      await _fetchFromServer(isInitial: false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Core fetch with 5s timeout and cache fallback
  Future<void> _fetchFromServer({required bool isInitial}) async {
    try {
      final repository = ref.read(doctorVerificationRepositoryProvider);
      final response = await repository
          .getVerificationStatus()
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 && response.data['success'] == true) {
        final doctor = response.data['doctor'];
        final newStatus = doctor['status'] as String;
        final rejectionReason = doctor['rejectionReason'] as String?;

        // Update Hive cache with latest server status
        await ref.read(storageProvider).saveStatus(newStatus);

        AppLogger.success(
            'Doctor verification: server success, status=$newStatus',
            tag: 'DoctorStatus');

        // Update state - null values explicitly clear old data
        state = state.copyWith(
          status: newStatus,
          isUsingCache: false,
          rejectionReason: rejectionReason,
          errorMessage: null,
        );

        _stopRetry();
        return;
      }

      // Server returned non-success response
      AppLogger.warning(
          'Doctor verification: server returned non-success response',
          tag: 'DoctorStatus');
      _handleFailure(isInitial: isInitial);
    } on TimeoutException {
      AppLogger.warning('Doctor verification: request timed out',
          tag: 'DoctorStatus');
      _handleFailure(isInitial: isInitial);
    } catch (e) {
      AppLogger.error('Doctor verification: unexpected error',
          tag: 'DoctorStatus', error: e);
      _handleFailure(isInitial: isInitial);
    }
  }

  void _handleFailure({required bool isInitial}) {
    if (isInitial) {
      // Try Hive cache as temporary fallback
      final cached = ref.read(storageProvider).getStatus();
      if (cached != null && cached.isNotEmpty) {
        AppLogger.info('Doctor verification: using cached status=$cached',
            tag: 'DoctorStatus');
        state = state.copyWith(
          status: cached,
          isUsingCache: true,
          errorMessage: null,
        );
        _startRetry(); // Start background retry with backoff
      } else {
        AppLogger.error('Doctor verification: no cache available',
            tag: 'DoctorStatus');
        state = state.copyWith(
          status: null,
          isUsingCache: false,
          errorMessage: 'Unable to fetch status. Please try again later.',
        );
      }
    } else {
      // Non-initial fetch - keep current status, show transient error
      state = state.copyWith(
        errorMessage: 'Failed to refresh. Check your connection.',
      );
    }
  }

  // Start background retry with proper backoff: 10s → 30s → 60s
  void _startRetry() {
    _stopTimer(); // Cancel existing timer, preserve retry state
    if (_retryAttempt >= _maxRetryAttempts) {
      AppLogger.info(
          'Doctor verification: max retries ($_maxRetryAttempts) reached',
          tag: 'DoctorStatus');
      return;
    }

    final delays = [
      const Duration(seconds: 10),
      const Duration(seconds: 30),
      const Duration(seconds: 60),
    ];
    final delay = delays[_retryAttempt];

    AppLogger.info(
        'Doctor verification: scheduling retry ${_retryAttempt + 1}/$_maxRetryAttempts '
            'in ${delay.inSeconds}s',
        tag: 'DoctorStatus');

    _retryTimer = Timer(delay, () async {
      _retryAttempt++;

      try {
        final repository = ref.read(doctorVerificationRepositoryProvider);
        final response = await repository
            .getVerificationStatus()
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200 && response.data['success'] == true) {
          final doctor = response.data['doctor'];
          final newStatus = doctor['status'] as String;
          final rejectionReason = doctor['rejectionReason'] as String?;

          await ref.read(storageProvider).saveStatus(newStatus);

          AppLogger.success(
              'Doctor verification: background retry success, status=$newStatus',
              tag: 'DoctorStatus');

          state = state.copyWith(
            status: newStatus,
            isUsingCache: false,
            rejectionReason: rejectionReason,
            errorMessage: null,
          );

          _stopRetry();
          return;
        }
      } catch (e) {
        AppLogger.error('Doctor verification: background retry failed',
            tag: 'DoctorStatus', error: e);
      }

      // Retry failed - schedule next attempt if still using cache
      if (state.isUsingCache) {
        _startRetry();
      } else {
        _stopRetry();
      }
    });
  }

  // Cancel timer only, keep retry count for backoff calculation
  void _stopTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  // Full stop - cancel timer and reset retry state
  void _stopRetry() {
    _stopTimer();
    _retryAttempt = 0;
  }

  void reset() {
    _stopRetry();
    _isInitializing = false;
    state = const DoctorStatusState();

    AppLogger.info(
      'Doctor verification state reset',
      tag: 'DoctorStatus',
    );
  }

  // ---- UI helpers ----

  String get statusTitle {
    if (state.errorMessage != null) return "Connection Error";
    return switch (state.status) {
      'APPROVED' => "Account Approved",
      'REJECTED' => "Verification Failed",
      'PENDING' => "Approval Pending",
      _ => "Checking Status..."
    };
  }

  IconData get statusIcon {
    if (state.errorMessage != null) return Icons.wifi_off_rounded;
    return switch (state.status) {
      'APPROVED' => Icons.check_circle_rounded,
      'REJECTED' => Icons.error_rounded,
      'PENDING' => Icons.pending_actions_rounded,
      _ => Icons.hourglass_top_rounded
    };
  }

  String get description {
    if (state.errorMessage != null) return state.errorMessage!;
    if (state.status == 'REJECTED') {
      return state.rejectionReason ?? "Your document was rejected.";
    }
    if (state.status == 'PENDING') {
      return "Our admin team is carefully reviewing your documents.";
    }
    return "Please wait while we process your request.";
  }
}
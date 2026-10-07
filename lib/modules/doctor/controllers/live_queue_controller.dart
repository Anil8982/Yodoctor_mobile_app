import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/appointment/prescription_model.dart';
import '../models/appointment/live_queue_model.dart';
import '../repositories/doctor_appointment_repository.dart';

class LiveQueueState {
  final bool loading;
  final bool refreshing;
  final List<LiveQueueItem> queue;
  final LiveQueueItem? current;
  final LiveQueueItem? next;
  final String selectedSlot;
  final String? errorMessage;
  final bool cancellingRemaining;
  final String? cancelRemainingMessage;
  final int? cancelledCount;

  const LiveQueueState({
    this.loading = false,
    this.refreshing = false,
    this.queue = const [],
    this.current,
    this.next,
    this.selectedSlot = "MORNING",
    this.errorMessage,
    this.cancellingRemaining = false,
    this.cancelRemainingMessage,
    this.cancelledCount,
  });

  LiveQueueState copyWith({
    bool? loading,
    bool? refreshing,
    List<LiveQueueItem>? queue,
    LiveQueueItem? current,
    bool clearCurrent = false,
    LiveQueueItem? next,
    bool clearNext = false,
    String? selectedSlot,
    String? errorMessage,
    bool clearError = false,
    bool? cancellingRemaining,
    String? cancelRemainingMessage,
    int? cancelledCount,
  }) {
    return LiveQueueState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      queue: queue ?? this.queue,
      current: clearCurrent ? null : (current ?? this.current),
      next: clearNext ? null : (next ?? this.next),
      selectedSlot: selectedSlot ?? this.selectedSlot,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      cancellingRemaining:
      cancellingRemaining ?? this.cancellingRemaining,
      cancelRemainingMessage:
      cancelRemainingMessage ?? this.cancelRemainingMessage,
      cancelledCount:
      cancelledCount ?? this.cancelledCount,
    );
  }
}

final liveQueueProvider = NotifierProvider<LiveQueueNotifier, LiveQueueState>(
  LiveQueueNotifier.new,
);

class LiveQueueNotifier extends Notifier<LiveQueueState> {
  static const String _subTag = 'LiveQueueNotifier';

  // Request ID guard for race condition
  int _requestId = 0;

  @override
  LiveQueueState build() {
    AppLogger.info(
      'LiveQueueNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    const initialState = LiveQueueState();

    Future.microtask(() => loadQueue(initialState.selectedSlot));

    return initialState;
  }

  Future<void> changeSlot(String slot) async {
    if (state.selectedSlot == slot) return;

    state = state.copyWith(selectedSlot: slot);

    await loadQueue(slot, isRefresh: false);
  }

  Future<void> refresh() async {
    if (state.loading || state.refreshing) return;
    await loadQueue(state.selectedSlot, isRefresh: true);
  }

  Future<void> loadQueue(String slot, {bool isRefresh = false}) async {
    // Generate unique request ID
    final requestId = ++_requestId;

    if (isRefresh) {
      state = state.copyWith(refreshing: true, clearError: true);
    } else {
      state = state.copyWith(loading: true, clearError: true);
    }

    AppLogger.info(
      'Initializing live queue stream pipeline for slot: $slot (isRefresh: $isRefresh, requestId: $requestId)',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);

      final results = await Future.wait([
        repository.getTodayQueue(slot: slot),
        repository.getCurrentPatient(slot: slot),
        repository.getNextPatient(slot: slot),
      ]);

      // Race condition guard: ignore if this isn't the latest request
      // OR if slot changed while awaiting
      if (requestId != _requestId || state.selectedSlot != slot) {
        AppLogger.warning(
          'Stale queue response ignored for slot: $slot (requestId: $requestId, currentRequestId: $_requestId, currentSlot: ${state.selectedSlot})',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        // Important: Reset loading states before returning
        state = state.copyWith(loading: false, refreshing: false);
        return;
      }

      final queueRes = results[0];
      final currentRes = results[1];
      final nextRes = results[2];

      if ((queueRes.statusCode ?? 0) >= 200 &&
          (queueRes.statusCode ?? 0) < 300) {
        final rawList = queueRes.data["queue"] as List? ?? [];
        final queue = rawList.map((e) => LiveQueueItem.fromJson(e)).toList();

        LiveQueueItem? current;
        LiveQueueItem? next;

        if (currentRes.data?["active"] == true &&
            currentRes.data?["appointment"] != null) {
          current = LiveQueueItem.fromJson(currentRes.data["appointment"]);
        }

        if (nextRes.statusCode == 200 && nextRes.data?["appointment"] != null) {
          next = LiveQueueItem.fromJson(nextRes.data["appointment"]);
        }

        AppLogger.success(
          'Live queue pipeline synchronised flawlessly. Queue Count: ${queue.length}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        AppLogger.json(
          {
            "queue_count": queue.length,
            "current_patient": currentRes.data,
            "next_patient": nextRes.data,
          },
          tag: LogTags.doctor,
          subTag: '$_subTag/QueueSyncMatrix',
        );

        state = state.copyWith(
          loading: false,
          refreshing: false,
          queue: queue,
          current: current,
          clearCurrent: current == null,
          next: next,
          clearNext: next == null,
        );
      } else {
        AppLogger.warning(
          'Failed to read live queue bounds. Status: ${queueRes.statusCode}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(
          loading: false,
          refreshing: false,
          errorMessage: "Failed to read live queue bounds",
        );
      }
    } catch (e, st) {
      // Check if this is still the latest request
      if (requestId != _requestId || state.selectedSlot != slot) {
        // Reset loading states before returning
        state = state.copyWith(loading: false, refreshing: false);
        return;
      }

      state = state.copyWith(
        loading: false,
        refreshing: false,
        errorMessage: "Runtime synchronization pipeline crash",
      );
      AppLogger.exception(
        e,
        st,
        message: 'Fatal exception within queue loader thread',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  // Helper method for actions - uses isRefresh: true for silent updates
  Future<void> _performAction(
    String actionName,
    Future<void> Function() action,
    String slot,
  ) async {
    AppLogger.info(
      'Performing action: $actionName for slot: $slot',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      await action();
      AppLogger.success(
        'Action $actionName completed successfully',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      // Refresh silently - maintains existing UI without shimmer flash
      await loadQueue(slot, isRefresh: true);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Action $actionName failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      // Still try to refresh to show consistent state
      await loadQueue(slot, isRefresh: true);
    }
  }

  Future<void> complete(String id, String slot) async {
    await _performAction('complete', () async {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.completeAppointment(id);
    }, slot);
  }

  Future<void> recall(String id, String slot) async {
    await _performAction('recall', () async {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.recallPatient(id);
    }, slot);
  }

  Future<void> noShow(String slot) async {
    await _performAction('noShow', () async {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.noShow(slot);
    }, slot);
  }

  Future<bool> cancelRemainingAppointments({
    required String slot,
    String? reason,
  }) async {
    state = state.copyWith(
      cancellingRemaining: true,
      cancelRemainingMessage: null,
      cancelledCount: null,
    );

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);

      final response = await repository.cancelRemainingAppointments(
        slot: slot,
        reason: reason,
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;
        final affected = data['affected'] as int? ?? 0;
        final message =
            data['message']?.toString() ?? 'Appointments cancelled';

        state = state.copyWith(
          cancellingRemaining: false,
          cancelRemainingMessage: message,
          cancelledCount: affected,
        );

        await loadQueue(slot, isRefresh: true);

        return true;
      }

      state = state.copyWith(
        cancellingRemaining: false,
        cancelRemainingMessage: 'Failed to cancel appointments',
      );

      return false;
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Cancel remaining appointments failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        cancellingRemaining: false,
        cancelRemainingMessage: 'Something went wrong',
      );

      return false;
    }
  }

  Future<void> skip(String id, String slot) async {
    await _performAction('skip', () async {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.skipAppointment(id);
    }, slot);
  }

  Future<void> start(String id, String slot) async {
    await _performAction('start', () async {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.startAppointment(appointmentId: id, slot: slot);
    }, slot);
  }

  Future<void> nextToken(String slot) async {
    await _performAction('nextToken', () async {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.callNextToken(slot: slot);
    }, slot);
  }

  Future<PrescriptionModel?> getPrescription(String appointmentId) async {
    AppLogger.info(
      'Fetching prescription records for ID: $appointmentId',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.getPrescription(appointmentId);
      if (res.statusCode == 200 && res.data != null) {
        AppLogger.success(
          'Prescription retrieved on context channel',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        AppLogger.json(
          res.data,
          tag: LogTags.doctor,
          subTag: '$_subTag/PrescriptionData',
        );
        return PrescriptionModel.fromJson(res.data);
      }
      AppLogger.warning(
        'Prescription response matrix empty or non-200. Status: ${res.statusCode}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return null;
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Fetch prescription data fault',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return null;
    }
  }

  Future<bool> savePrescription({
    required String appointmentId,
    required String medicines,
    required String instructions,
  }) async {
    final payload = {
      "appointmentId": appointmentId,
      "medicines": medicines,
      "instructions": instructions,
    };

    AppLogger.info(
      'Saving prescription parameters for transaction: $appointmentId',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    AppLogger.json(
      payload,
      tag: LogTags.doctor,
      subTag: '$_subTag/PrescriptionPayload',
    );

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.addPrescription(
        appointmentId: appointmentId,
        medicines: medicines,
        instructions: instructions,
      );
      final success =
          (res.statusCode ?? 0) >= 200 && (res.statusCode ?? 0) < 300;
      if (success) {
        AppLogger.success(
          'Prescription committed to centralized data node',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      } else {
        AppLogger.warning(
          'Prescription save denied by remote branch. Status: ${res.statusCode}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      }
      return success;
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Save prescription transmission error',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }
}

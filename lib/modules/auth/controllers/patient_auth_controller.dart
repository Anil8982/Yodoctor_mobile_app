import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/enums/auth_type.dart';
import 'package:yodoctor/core/providers/otp_cooldown_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/modules/auth/models/patient_user.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/modules/auth/repositories/patient_auth_repository.dart';
import 'package:yodoctor/modules/auth/services/google_auth_service.dart';

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

final patientAuthControllerProvider =
    AsyncNotifierProvider<PatientAuthController, PatientUser?>(
      PatientAuthController.new,
    );

class PatientAuthController extends AsyncNotifier<PatientUser?> {
  static const String _subTag = 'PatientAuthController';

  Map<String, dynamic>? _pendingOtpPayload;

  @override
  FutureOr<PatientUser?> build() {
    return null;
  }

  /// Handles traditional Email & Password Sign-In flow
  Future<Map<String, dynamic>?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // 🛡️ Cooldown Guard: Prevent new network OTP triggers during active cooldown
    final remaining = ref.read(otpCooldownProvider.notifier).remainingSeconds;
    if (remaining > 0 && _pendingOtpPayload != null) {
      AppLogger.info(
        'Active OTP cooldown running (${remaining}s remaining). Returning cached pending OTP state.',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      return _pendingOtpPayload;
    }

    AppLogger.info(
      'Initiating patient email authentication stream',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = const AsyncLoading();
    final repository = ref.read(patientAuthRepositoryProvider);
    final storage = ref.read(storageProvider);

    try {
      final response = await repository.signInWithEmail(
        identifier: email,
        password: password,
      );

      if (response.requiresOtp) {
        _pendingOtpPayload = {
          'redirect': 'otp',
          'requiresOtp': true,
          'verificationId': response.verificationId,
          'channel': response.channel,
          'mobile': response.mobile,
          'maskedDestination': response.maskedDestination,
          'message': response.message,
        };
        ref.read(otpCooldownProvider.notifier).startCooldown();
        state = const AsyncData(null);
        return _pendingOtpPayload;
      }

      if (!response.success) {
        final errorMsg =
            response.message.isNotEmpty ? response.message : 'Login failed';
        state = AsyncError(errorMsg, StackTrace.current);
        return null;
      }

      final user = PatientUser(
        id: '',
        name: '',
        email: email.trim(),
        location: '',
        age: 0,
        bloodGroup: '',
        mobileNumber: '',
        dateOfBirth: '',
        gender: '',
      );

      _pendingOtpPayload = null;
      ref.read(otpCooldownProvider.notifier).reset();
      state = AsyncData(user);

      await storage.saveAuthType(AuthType.email);
      ref.read(appRoleProvider.notifier).setRole(AppRole.patient);

      AppLogger.success(
        'Patient credentials authenticated and state committed successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return {
        'redirect': 'dashboard',
        'success': true,
        'message': response.message,
        'token': response.token,
      };
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      final errorMsg = e.toString().replaceAll('Exception: ', '').trim();
      state = AsyncError(errorMsg, st);
      return null;
    }
  }

  /// Verifies OTP for patient login
  Future<Map<String, dynamic>?> verifyOtp({
    required String otp,
    required String email,
    String? verificationId,
    String? channel,
    String? mobile,
  }) async {
    AppLogger.info(
      'Initiating patient OTP verification',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = const AsyncLoading();
    final repository = ref.read(patientAuthRepositoryProvider);
    final storage = ref.read(storageProvider);

    try {
      final response = await repository.verifyLoginOtp(
        otp: otp,
        verificationId: verificationId,
        channel: channel,
        mobile: mobile,
      );

      if (!response.success) {
        final errorMsg = response.message.isNotEmpty
            ? response.message
            : 'Invalid or expired OTP';
        state = AsyncError(errorMsg, StackTrace.current);
        return null;
      }

      final user = PatientUser(
        id: '',
        name: '',
        email: email.trim(),
        location: '',
        age: 0,
        bloodGroup: '',
        mobileNumber: mobile ?? '',
        dateOfBirth: '',
        gender: '',
      );

      _pendingOtpPayload = null;
      ref.read(otpCooldownProvider.notifier).reset();
      state = AsyncData(user);

      await storage.saveAuthType(AuthType.email);
      ref.read(appRoleProvider.notifier).setRole(AppRole.patient);

      AppLogger.success(
        'Patient OTP authenticated and session committed successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return {
        'redirect': 'dashboard',
        'success': true,
        'message': response.message,
      };
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      final errorMsg = e.toString().replaceAll('Exception: ', '').trim();
      state = AsyncError(errorMsg, st);
      return null;
    }
  }

  /// Resends OTP by re-triggering authentication
  Future<Map<String, dynamic>?> resendOtp({
    required String email,
    required String password,
  }) async {
    AppLogger.info(
      'Initiating patient OTP resend request',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    final repository = ref.read(patientAuthRepositoryProvider);

    try {
      final response = await repository.signInWithEmail(
        identifier: email,
        password: password,
      );

      if (!response.success && !response.requiresOtp) {
        return {
          'success': false,
          'message': response.message.isNotEmpty
              ? response.message
              : 'Failed to resend OTP',
        };
      }

      _pendingOtpPayload = {
        'redirect': 'otp',
        'requiresOtp': true,
        'verificationId': response.verificationId ??
            _pendingOtpPayload?['verificationId'],
        'channel':
            response.channel ?? _pendingOtpPayload?['channel'],
        'mobile': response.mobile ?? _pendingOtpPayload?['mobile'],
        'maskedDestination': response.maskedDestination ??
            _pendingOtpPayload?['maskedDestination'],
        'message': response.message,
      };
      ref.read(otpCooldownProvider.notifier).startCooldown();

      return {
        'success': true,
        'message': response.message.isNotEmpty
            ? response.message
            : 'OTP resent successfully',
        'verificationId': response.verificationId,
        'channel': response.channel,
        'mobile': response.mobile,
      };
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', '').trim(),
      };
    }
  }

  /// Handles OAuth2 Google Sign-In pipeline
  Future<PatientUser?> signInWithGoogle() async {
    AppLogger.info(
      'Triggering Google Auth pipeline from UI context request',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = const AsyncLoading();
    final googleAuthService = ref.read(googleAuthServiceProvider);
    final storage = ref.read(storageProvider);

    try {
      final PatientUser? patient = await googleAuthService.signInWithGoogle();

      if (patient != null) {
        final firebaseToken = await googleAuthService.getIdToken();

        if (firebaseToken == null || firebaseToken.isEmpty) {
          throw Exception('Firebase token not found');
        }

        final repository = ref.read(patientAuthRepositoryProvider);

        final response = await repository.signInWithGoogle(
          firebaseToken: firebaseToken,
        );

        if (!response.success) {
          throw Exception(response.message);
        }

        await storage.saveAuthType(AuthType.google);
        ref.read(appRoleProvider.notifier).setRole(AppRole.patient);

        _pendingOtpPayload = null;
        ref.read(otpCooldownProvider.notifier).reset();
        state = AsyncData(patient);

        AppLogger.success(
          'Google OAuth authenticated and backend JWT session established',
          tag: LogTags.auth,
          subTag: _subTag,
        );

        return patient;
      } else {
        AppLogger.warning(
          'Google authentication sequence cancelled by user interaction parameters',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        state = const AsyncData(null);
        return null;
      }
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      final errorMsg = e.toString().replaceAll('Exception: ', '').trim();
      state = AsyncError(errorMsg, st);
      return null;
    }
  }
}

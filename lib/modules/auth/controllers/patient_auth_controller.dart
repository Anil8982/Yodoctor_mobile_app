import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/enums/auth_type.dart';
import 'package:yodoctor/core/providers/otp_cooldown_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/utils/app_error_utils.dart';
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
  String? _pendingIdentifier;

  @override
  FutureOr<PatientUser?> build() {
    return null;
  }

  /// Handles Normal Password Sign-In flow (No OTP required)
  Future<Map<String, dynamic>?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _pendingIdentifier = null;
    _pendingOtpPayload = null;
    ref.read(otpCooldownProvider.notifier).reset();

    AppLogger.info(
      'Initiating patient normal password authentication',
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
        _pendingIdentifier = email.trim().toLowerCase();
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
        final errorMsg = response.message.isNotEmpty
            ? response.message
            : 'Unable to login. Please check your credentials.';
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
      _pendingIdentifier = null;
      ref.read(otpCooldownProvider.notifier).reset();
      state = AsyncData(user);

      await storage.saveAuthType(AuthType.email);
      ref.read(appRoleProvider.notifier).setRole(AppRole.patient);

      AppLogger.success(
        'Patient normal login authenticated and session committed successfully',
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
      final errorMsg = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Unable to login. Please try again.');
      state = AsyncError(errorMsg, st);
      return null;
    }
  }

  /// Sends OTP for "Login with OTP" (without password)
  Future<Map<String, dynamic>?> sendLoginOtp({
    required String identifier,
  }) async {
    final cleanId = identifier.trim().toLowerCase();
    if (_pendingIdentifier != null && _pendingIdentifier != cleanId) {
      _pendingOtpPayload = null;
      ref.read(otpCooldownProvider.notifier).reset();
    }
    _pendingIdentifier = cleanId;

    // Prevent duplicate network triggers during active cooldown
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
      'Initiating patient send login OTP for identifier: $cleanId',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = const AsyncLoading();
    final repository = ref.read(patientAuthRepositoryProvider);

    try {
      final response = await repository.sendLoginOtp(identifier: identifier);

      if (response.requiresOtp) {
        final otpPayload = {
          'redirect': 'otp',
          'requiresOtp': true,
          'verificationId': response.verificationId,
          'channel': response.channel,
          'mobile': response.mobile,
          'maskedDestination': response.destination ?? response.maskedDestination ?? identifier,
          'expiresIn': response.expiresIn,
          'message': response.message.isNotEmpty
              ? response.message
              : 'OTP sent successfully',
        };

        _pendingOtpPayload = otpPayload;
        ref.read(otpCooldownProvider.notifier).startCooldown();
        state = const AsyncData(null);
        return otpPayload;
      }

      if (response.success && response.token?.isNotEmpty == true) {
        final user = PatientUser(
          id: '',
          name: '',
          email: identifier.trim(),
          location: '',
          age: 0,
          bloodGroup: '',
          mobileNumber: response.mobile ?? '',
          dateOfBirth: '',
          gender: '',
        );

        _pendingOtpPayload = null;
        _pendingIdentifier = null;
        ref.read(otpCooldownProvider.notifier).reset();
        state = AsyncData(user);

        final storage = ref.read(storageProvider);
        await storage.saveAuthType(AuthType.email);
        ref.read(appRoleProvider.notifier).setRole(AppRole.patient);

        return {
          'redirect': 'dashboard',
          'success': true,
          'message': response.message,
          'token': response.token,
        };
      }

      final errorMsg = response.message.isNotEmpty
          ? response.message
          : 'Failed to send OTP. Please try again.';
      state = AsyncError(errorMsg, StackTrace.current);
      return null;
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      final errorMsg = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Failed to send OTP. Please try again.');
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
    String? identifier,
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
      final effectiveVerificationId = verificationId ?? _pendingOtpPayload?['verificationId'];
      final effectiveChannel = channel ?? _pendingOtpPayload?['channel'];
      final effectiveMobile = mobile ?? _pendingOtpPayload?['mobile'];

      final response = await repository.verifyLoginOtp(
        otp: otp,
        verificationId: effectiveVerificationId,
        channel: effectiveChannel,
        mobile: effectiveMobile,
        email: email,
        identifier: identifier ?? email,
      );

      if (!response.success) {
        final errorMsg = response.message.isNotEmpty
            ? response.message
            : 'Incorrect OTP. Please check the code and try again.';
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
      final errorMsg = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Incorrect OTP. Please check the code and try again.');
      state = AsyncError(errorMsg, st);
      return null;
    }
  }

  /// Resends OTP by calling sendLoginOtp
  Future<Map<String, dynamic>?> resendOtp({
    required String identifier,
    String? password,
  }) async {
    AppLogger.info(
      'Initiating patient OTP resend request for: $identifier',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    final repository = ref.read(patientAuthRepositoryProvider);

    try {
      final response = (password != null && password.isNotEmpty)
          ? await repository.signInWithEmail(
              identifier: identifier,
              password: password,
            )
          : await repository.sendLoginOtp(identifier: identifier);

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
            _pendingOtpPayload?['maskedDestination'] ??
            identifier,
        'message': response.message.isNotEmpty
            ? response.message
            : 'OTP resent successfully',
      };
      ref.read(otpCooldownProvider.notifier).startCooldown();

      return {
        'success': true,
        'message': response.message.isNotEmpty
            ? response.message
            : 'OTP resent successfully',
        'verificationId': response.verificationId ?? _pendingOtpPayload?['verificationId'],
        'channel': response.channel ?? _pendingOtpPayload?['channel'],
        'mobile': response.mobile ?? _pendingOtpPayload?['mobile'],
      };
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return {
        'success': false,
        'message': AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Failed to resend OTP. Please try again.'),
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
          throw Exception('Google verification token could not be retrieved.');
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
          'Google authentication sequence cancelled by user interaction',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        state = const AsyncData(null);
        return null;
      }
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      final errorMsg = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Google login failed. Please try again.');
      state = AsyncError(errorMsg, st);
      return null;
    }
  }
}

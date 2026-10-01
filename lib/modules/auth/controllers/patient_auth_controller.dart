import 'dart:async';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/enums/auth_type.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/modules/auth/models/login_response.dart';
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

  @override
  FutureOr<PatientUser?> build() {
    return null;
  }

  /// Handles traditional Email & Password Sign-In flow
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required Function(String error) onFailure,
    Function(LoginResponse otpResponse)? onOtpRequired,
  }) async {
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
        state = const AsyncData(null);
        if (onOtpRequired != null) {
          onOtpRequired(response);
        }
        return;
      }

      if (!response.success) {
        onFailure(response.message);
        state = AsyncError(response.message, StackTrace.current);
        return;
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

      state = AsyncData(user);

      await storage.saveAuthType(AuthType.email);
      ref.read(appRoleProvider.notifier).setRole(AppRole.patient);

      AppLogger.success(
        'Patient credentials authenticated and state committed successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      onSuccess();
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      state = AsyncError(e, st);
      onFailure(e.toString());
    }
  }

  /// Verifies OTP for patient login
  Future<bool> verifyOtp({
    required String otp,
    required String email,
    String? verificationId,
    String? channel,
    String? mobile,
    required VoidCallback onSuccess,
    required Function(String error) onFailure,
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
        state = AsyncError(response.message, StackTrace.current);
        onFailure(response.message);
        return false;
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

      state = AsyncData(user);

      await storage.saveAuthType(AuthType.email);
      ref.read(appRoleProvider.notifier).setRole(AppRole.patient);

      AppLogger.success(
        'Patient OTP authenticated and session committed successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      onSuccess();
      return true;
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      state = AsyncError(e, st);
      onFailure(e.toString());
      return false;
    }
  }

  /// Resends OTP by re-triggering authentication
  Future<LoginResponse?> resendOtp({
    required String email,
    required String password,
    required Function(String message) onSuccess,
    required Function(String error) onFailure,
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
        onFailure(response.message);
        return null;
      }

      onSuccess(
        response.message.isNotEmpty
            ? response.message
            : 'OTP resent successfully',
      );
      return response;
    } catch (e, st) {
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      onFailure(e.toString());
      return null;
    }
  }

  /// Handles OAuth2 Google Sign-In pipeline
  Future<void> signInWithGoogle({
    required Function(PatientUser user) onSuccess,
    required VoidCallback onCanceled,
  }) async {
    AppLogger.info(
      'Triggering Google Auth pipeline from UI context request',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = const AsyncLoading();
    final googleAuthService = ref.read(googleAuthServiceProvider);
    final storage = ref.read(storageProvider);

    state = await AsyncValue.guard(() async {
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

        AppLogger.success(
          'Google OAuth authenticated and backend JWT session established',
          tag: LogTags.auth,
          subTag: _subTag,
        );

        onSuccess(patient);
        return patient;
      } else {
        AppLogger.warning(
          'Google authentication sequence cancelled by user interaction parameters',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        onCanceled();
        return null;
      }
    });
  }
}

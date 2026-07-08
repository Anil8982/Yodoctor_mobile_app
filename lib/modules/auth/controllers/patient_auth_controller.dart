import 'dart:async';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/models/patient/patient_user.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/modules/auth/services/email_auth_service.dart';
import 'package:yodoctor/modules/auth/services/google_auth_service.dart';

// 1. Dependency Injection for the Google Auth Service
final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

final emailAuthServiceProvider = Provider<EmailAuthService>((ref) {
  return EmailAuthService(
    dio: ref.read(dioProvider),
    storage: ref.read(storageProvider),
  );
});

final patientAuthControllerProvider =
    AsyncNotifierProvider<PatientAuthController, PatientUser?>(
      PatientAuthController.new,
    );

class PatientAuthController extends AsyncNotifier<PatientUser?> {
  static const String _subTag = 'PatientAuthController';

  @override
  FutureOr<PatientUser?> build() {
    // Initial state is null (not logged in yet)
    return null;
  }

  /// Handles traditional Email & Password Sign-In flow
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required Function(String error) onFailure,
  }) async {
    AppLogger.info(
      'Initiating email authentication',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = const AsyncLoading();

    final authService = ref.read(emailAuthServiceProvider);

    try {
      final response = await authService.signInWithEmail(
        identifier: email,
        password: password,
      );

      if (!response.success) {
        onFailure(response.message);

        state = AsyncError(response.message, StackTrace.current);

        return;
      }

      final user = PatientUser(
        id: '',
        name: '',
        email: email,
        location: '',
        age: 0,
        bloodGroup: '',
        mobileNumber: '',
        dateOfBirth: '',
        gender: '',
      );

      state = AsyncData(user);

      AppLogger.success(
        'Email login successful',
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

  /// Handles OAuth2 Google Sign-In pipeline
  Future<void> signInWithGoogle({
    required Function(PatientUser user) onSuccess,
    required VoidCallback onCanceled,
  }) async {
    AppLogger.info(
      'Triggering Google Auth pipeline from UI request',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = const AsyncLoading();
    final googleAuthService = ref.read(googleAuthServiceProvider);

    state = await AsyncValue.guard(() async {
      final PatientUser? patient = await googleAuthService.signInWithGoogle();

      if (patient != null) {
        AppLogger.success(
          'Google credentials verified. Profile session synchronized.',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        onSuccess(patient);
        return patient;
      } else {
        AppLogger.warning(
          'Google sign in procedure was aborted by user action',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        onCanceled();
        return null;
      }
    });
  }
}

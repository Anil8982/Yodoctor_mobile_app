import 'dart:async';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/models/patient/patient_user.dart';
import 'package:yodoctor/modules/auth/repository/patient_auth_repository.dart';
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
  }) async {
    AppLogger.info(
      'Initiating patient email authentication stream',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = const AsyncLoading();

    final repository = ref.read(patientAuthRepositoryProvider);

    try {
      final response = await repository.signInWithEmail(
        identifier: email,
        password: password,
      );

      if (!response.success) {
        onFailure(response.message);
        state = AsyncError(response.message, StackTrace.current);
        return;
      }

      final user = PatientUser(
        id: '', // Backend response mapping points inject dynamically if available
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

  /// Handles OAuth2 Google Sign-In pipeline (Maintained outside repository as per SDK rules)
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

    state = await AsyncValue.guard(() async {
      final PatientUser? patient = await googleAuthService.signInWithGoogle();

      if (patient != null) {
        AppLogger.success(
          'Google OAuth session tokens successfully synced to context state',
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
import 'dart:async';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/models/patient/patient_user.dart';
import 'package:yodoctor/modules/auth/services/google_auth_service.dart';

// 1. Dependency Injection for the Google Auth Service
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
    AppLogger.info('Initiating modern email authentication sequence', tag: LogTags.auth, subTag: _subTag);

    // Set UI state to loading automatically
    state = const AsyncLoading();

    // AsyncValue.guard automatically catches errors and wraps them beautifully
    state = await AsyncValue.guard(() async {
      // Mocking network latency matching original code delay
      await Future.delayed(const Duration(seconds: 2));

      final mockUser = PatientUser(
        id: "email_mock_uid_123",
        name: email.split('@').first.toUpperCase(),
        email: email,
        location: '', age: 0, bloodGroup: '', mobileNumber: '', dateOfBirth: '', gender: '',
      );

      AppLogger.success('Email login sequence completed inside controller', tag: LogTags.auth, subTag: _subTag);
      onSuccess();
      return mockUser;
    });

    // Check if state has an error and trigger failure callback
    if (state.hasError) {
      final error = state.error;
      AppLogger.exception(error ?? 'Email auth failed', StackTrace.current, tag: LogTags.auth, subTag: _subTag);
      onFailure(error.toString());
    }
  }

  /// Handles OAuth2 Google Sign-In pipeline
  Future<void> signInWithGoogle({
    required Function(PatientUser user) onSuccess,
    required VoidCallback onCanceled,
  }) async {
    AppLogger.info('Triggering Google Auth pipeline from UI request', tag: LogTags.auth, subTag: _subTag);

    state = const AsyncLoading();
    final googleAuthService = ref.read(googleAuthServiceProvider);

    state = await AsyncValue.guard(() async {
      final PatientUser? patient = await googleAuthService.signIn();

      if (patient != null) {
        AppLogger.success('Google credentials verified. Profile session synchronized.', tag: LogTags.auth, subTag: _subTag);
        onSuccess(patient);
        return patient;
      } else {
        AppLogger.warning('Google sign in procedure was aborted by user action', tag: LogTags.auth, subTag: _subTag);
        onCanceled();
        return null;
      }
    });
  }
}
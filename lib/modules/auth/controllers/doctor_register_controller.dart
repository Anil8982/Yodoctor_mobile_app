import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/modules/auth/repositories/doctor_auth_repository.dart';
import '../models/doctor_register_model.dart';

class DoctorRegisterSubmitResult {
  final bool success;
  final String? redirect;
  final String? message;
  final String? error;

  const DoctorRegisterSubmitResult({
    required this.success,
    this.redirect,
    this.message,
    this.error,
  });
}

class DoctorRegisterState {
  final bool isLoading;
  final String? errorMessage;
  final String? registrationToken;

  const DoctorRegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.registrationToken,
  });

  DoctorRegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? registrationToken,
  }) {
    return DoctorRegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      registrationToken: registrationToken ?? this.registrationToken,
    );
  }
}

final doctorRegisterControllerProvider =
    NotifierProvider<DoctorRegisterNotifier, DoctorRegisterState>(
      DoctorRegisterNotifier.new,
    );

class DoctorRegisterNotifier extends Notifier<DoctorRegisterState> {
  static const String _subTag = 'DoctorRegisterNotifier';

  @override
  DoctorRegisterState build() {
    DebugLog.info(
      'DoctorRegisterNotifier Initialized',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    return const DoctorRegisterState();
  }

  Future<bool> registerStep1(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    DebugLog.info(
      'Submitting onboarding Phase 1: Basic Credentials...',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep1(
        fullName: data.fullName,
        email: data.email,
        mobile: data.mobile,
        gender: data.gender,
        languages: data.languages,
        bio: data.bio,
        password: data.password,
        confirmPassword: data.confirmPassword,
      );

      final status = res.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        final token = res.data["token"];
        if (token != null) {
          await repository.saveRegistrationToken(token);
        }

        DebugLog.success(
          'Registration context key established successfully',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        state = state.copyWith(isLoading: false, registrationToken: token);
        return true;
      } else {
        final msg = res.data?["message"] ?? "Step 1 process aborted";
        DebugLog.warning(
          'Step 1 registration rejected by backend. Status: $status, Message: $msg',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Onboarding connection exception dropped",
      );
      DebugLog.error(
        'Step 1 onboarding connection exception dropped',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<bool> registerStep2(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    DebugLog.info(
      'Submitting onboarding Phase 2: Professional Validation Matrices...',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final formattedDate = data.validTill == null
          ? null
          : DateFormat("yyyy-MM-dd").format(data.validTill!);

      final res = await repository.registerStep2(
        qualification: data.qualification,
        specialization: data.specialization,
        experience: data.experience,
        regNumber: data.regNumber,
        stateCouncil: data.stateCouncil,
        validTill: formattedDate,
      );

      final status = res.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        DebugLog.success(
          'Step 2 registration parameters saved successfully',
          tag: LogTags.auth,
          subTag: _subTag,
          json: res.data ?? {},
        );
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        final msg = res.data?["message"] ?? "Step 2 failed";
        DebugLog.warning(
          'Step 2 registration rejected by backend. Status: $status, Message: $msg',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Step 2 execution panic",
      );
      DebugLog.error(
        'Step 2 execution panic',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<bool> registerStep3(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    DebugLog.info(
      'Submitting onboarding Phase 3: Clinic Workspace Structuring...',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep3(data: data);

      final status = res.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        DebugLog.success(
          'Step 3 registration parameters saved successfully',
          tag: LogTags.auth,
          subTag: _subTag,
          json: res.data ?? {},
        );
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        final msg = res.data?["message"] ?? "Step 3 processing dropped";
        DebugLog.warning(
          'Step 3 registration rejected by backend. Status: $status, Message: $msg',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Step 3 execution breakdown",
      );
      DebugLog.error(
        'Step 3 execution breakdown',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<bool> saveStep4(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    DebugLog.info(
      'Submitting onboarding Phase 4: Availability Mapping...',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep4(data: data);
      state = state.copyWith(isLoading: false);

      final status = res.statusCode ?? 0;
      final success = status >= 200 && status < 300;
      if (success) {
        DebugLog.success(
          'Step 4 availability roster saved successfully',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      } else {
        DebugLog.warning(
          'Step 4 submission rejected by backend. Status: $status',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      }
      return success;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Step 4 internal pipeline breakdown",
      );
      DebugLog.error(
        'Step 4 internal pipeline breakdown',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<bool> saveStep5(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    DebugLog.info(
      'Submitting onboarding Phase 5: Consultation Fees Structure...',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep5(data: data);
      state = state.copyWith(isLoading: false);

      final status = res.statusCode ?? 0;
      final success = status >= 200 && status < 300;
      if (success) {
        DebugLog.success(
          'Step 5 consultation configuration committed successfully',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      } else {
        DebugLog.warning(
          'Step 5 submission rejected by backend. Status: $status',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      }
      return success;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Step 5 parameters compilation failure",
      );
      DebugLog.error(
        'Step 5 parameters compilation failure',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<bool> saveStep6(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    DebugLog.info(
      'Uploading verification attachments bundle via multi-part channel...',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep6(data: data);
      state = state.copyWith(isLoading: false);

      final status = res.statusCode ?? 0;
      final success = status >= 200 && status < 300;
      if (success) {
        DebugLog.success(
          'Step 6 dynamic documents bundle uploaded successfully',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return true;
      } else {
        final msg = res.data?["message"] ?? "Step 6 verification rejected";
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } on DioException catch (e, st) {
      String errorServerMsg = "Multipart gateway connection transmission loss";
      if (e.response?.data is Map<String, dynamic>) {
        errorServerMsg =
            e.response?.data["message"]?.toString() ?? errorServerMsg;
      }

      state = state.copyWith(isLoading: false, errorMessage: errorServerMsg);
      DebugLog.error(
        errorServerMsg,
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Step 6 unexpected mapping panic",
      );
      DebugLog.error(
        'Step 6 unexpected mapping panic',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<DoctorRegisterSubmitResult> submitRegistration(
    DoctorFormData data,
  ) async {
    if (state.isLoading) {
      DebugLog.warning(
        'Submission already in progress, ignoring duplicate tap',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      return const DoctorRegisterSubmitResult(
        success: false,
        error: "Submission in progress. Please wait.",
      );
    }

    state = state.copyWith(isLoading: true, clearError: true);
    DebugLog.info(
      'Executing final registration sequence submission...',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.submitRegistration(data: data);

      final status = res.statusCode ?? 0;
      final rawData = res.data;

      bool isSuccess = false;
      String? redirect;
      String? message;
      String? token;

      if (rawData is Map<String, dynamic>) {
        isSuccess = rawData['success'] == true;
        redirect =
            rawData['redirect']?.toString() ??
            rawData['data']?['redirect']?.toString();
        message =
            rawData['message']?.toString() ??
            rawData['data']?['message']?.toString();
        token =
            rawData['token']?.toString() ??
            rawData['data']?['token']?.toString();
      } else if (status >= 200 && status < 300) {
        isSuccess = true;
      }

      if (isSuccess) {
        DebugLog.success(
          'Doctor declaration submitted successfully. redirect=$redirect, message=$message',
          tag: LogTags.auth,
          subTag: _subTag,
        );

        final effectiveToken = (token != null && token.isNotEmpty)
            ? token
            : await repository.getRegistrationToken();

        if (effectiveToken != null && effectiveToken.isNotEmpty) {
          await repository.saveSessionToken(effectiveToken);
          await repository.saveRegistrationToken(effectiveToken);
        }

        await repository.saveUserRole('doctor');
        await repository.saveStatus('PENDING');

        final storage = ref.read(storageProvider);
        await storage.saveActiveSubscription(false);

        ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);

        state = state.copyWith(isLoading: false);

        return DoctorRegisterSubmitResult(
          success: true,
          redirect: redirect,
          message: message,
        );
      } else {
        final serverError =
            message ?? "Declaration submission was rejected by the server.";
        DebugLog.warning(
          'Declaration rejected. Status: $status, Message: $serverError',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        state = state.copyWith(isLoading: false, errorMessage: serverError);
        return DoctorRegisterSubmitResult(
          success: false,
          redirect: redirect,
          message: message,
          error: serverError,
        );
      }
    } on DioException catch (e, st) {
      String errorMessage = "Failed to submit declaration. Please try again.";
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        errorMessage = data['message']?.toString() ?? errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage =
            "Connection timeout. Please check your network and try again.";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            "Network connection failed. Please verify your internet connection.";
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      DebugLog.error(
        errorMessage,
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return DoctorRegisterSubmitResult(success: false, error: errorMessage);
    } catch (e, st) {
      const errorMessage = "An unexpected error occurred during submission.";
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      DebugLog.error(
        errorMessage,
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return const DoctorRegisterSubmitResult(
        success: false,
        error: errorMessage,
      );
    }
  }

  void clear() {
    DebugLog.info(
      'Clearing registration error flags locally',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    state = state.copyWith(clearError: true, isLoading: false);
  }

  Future<void> logoutRegistration() async {
    try {
      DebugLog.info(
        'Clearing registration temporary state tokens...',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      final repository = ref.read(doctorAuthRepositoryProvider);
      await repository.clearAuthSession();
      state = const DoctorRegisterState();
      DebugLog.success(
        'Registration temporary session flushed and state reset',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      DebugLog.error(
        'Fatal failure during registration logout pipeline',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
    }
  }
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/auth/repositories/doctor_auth_repository.dart';
import '../models/doctor_register_model.dart';

class DoctorRegisterState {
  final bool isLoading;
  final String? errorMessage;
  final String? registrationToken;

  const DoctorRegisterState({this.isLoading = false, this.errorMessage, this.registrationToken});

  DoctorRegisterState copyWith({bool? isLoading, String? errorMessage, bool clearError = false, String? registrationToken}) {
    return DoctorRegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      registrationToken: registrationToken ?? this.registrationToken,
    );
  }
}

final doctorRegisterControllerProvider = NotifierProvider<DoctorRegisterNotifier, DoctorRegisterState>(
  DoctorRegisterNotifier.new,
);

class DoctorRegisterNotifier extends Notifier<DoctorRegisterState> {
  static const String _subTag = 'DoctorRegisterNotifier';

  @override
  DoctorRegisterState build() {
    AppLogger.info('DoctorRegisterNotifier Initialized', tag: LogTags.auth, subTag: _subTag);
    return const DoctorRegisterState();
  }

  Future<bool> registerStep1(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info('Submitting onboarding Phase 1: Basic Credentials...', tag: LogTags.auth, subTag: _subTag);

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

        AppLogger.success('Registration context key established successfully', tag: LogTags.auth, subTag: _subTag);
        state = state.copyWith(isLoading: false, registrationToken: token);
        return true;
      } else {
        final msg = res.data?["message"] ?? "Step 1 process aborted";
        AppLogger.warning('Step 1 registration rejected by backend. Status: $status, Message: $msg', tag: LogTags.auth, subTag: _subTag);
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(isLoading: false, errorMessage: "Onboarding connection exception dropped");
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return false;
    }
  }

  Future<bool> registerStep2(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info('Submitting onboarding Phase 2: Professional Validation Matrices...', tag: LogTags.auth, subTag: _subTag);

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final formattedDate = data.validTill == null ? null : DateFormat("yyyy-MM-dd").format(data.validTill!);

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
        AppLogger.success('Step 2 registration parameters saved successfully', tag: LogTags.auth, subTag: _subTag);
        AppLogger.json(res.data ?? {}, tag: LogTags.auth, subTag: '$_subTag/Step2MatrixLog');
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        final msg = res.data?["message"] ?? "Step 2 failed";
        AppLogger.warning('Step 2 registration rejected by backend. Status: $status, Message: $msg', tag: LogTags.auth, subTag: _subTag);
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(isLoading: false, errorMessage: "Step 2 execution panic");
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return false;
    }
  }

  Future<bool> registerStep3(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info('Submitting onboarding Phase 3: Clinic Workspace Structuring...', tag: LogTags.auth, subTag: _subTag);

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep3(data: data);

      final status = res.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        AppLogger.success('Step 3 registration parameters saved successfully', tag: LogTags.auth, subTag: _subTag);
        AppLogger.json(res.data ?? {}, tag: LogTags.auth, subTag: '$_subTag/Step3MatrixLog');
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        final msg = res.data?["message"] ?? "Step 3 processing dropped";
        AppLogger.warning('Step 3 registration rejected by backend. Status: $status, Message: $msg', tag: LogTags.auth, subTag: _subTag);
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(isLoading: false, errorMessage: "Step 3 execution breakdown");
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return false;
    }
  }

  Future<bool> saveStep4(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info('Submitting onboarding Phase 4: Availability Mapping...', tag: LogTags.auth, subTag: _subTag);

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep4(data: data);
      state = state.copyWith(isLoading: false);

      final status = res.statusCode ?? 0;
      final success = status >= 200 && status < 300;
      if (success) {
        AppLogger.success('Step 4 availability roster saved successfully', tag: LogTags.auth, subTag: _subTag);
      } else {
        AppLogger.warning('Step 4 submission rejected by backend. Status: $status', tag: LogTags.auth, subTag: _subTag);
      }
      return success;
    } catch (e, st) {
      state = state.copyWith(isLoading: false, errorMessage: "Step 4 internal pipeline breakdown");
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return false;
    }
  }

  Future<bool> saveStep5(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info('Submitting onboarding Phase 5: Consultation Fees Structure...', tag: LogTags.auth, subTag: _subTag);

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep5(data: data);
      state = state.copyWith(isLoading: false);

      final status = res.statusCode ?? 0;
      final success = status >= 200 && status < 300;
      if (success) {
        AppLogger.success('Step 5 consultation configuration committed successfully', tag: LogTags.auth, subTag: _subTag);
      } else {
        AppLogger.warning('Step 5 submission rejected by backend. Status: $status', tag: LogTags.auth, subTag: _subTag);
      }
      return success;
    } catch (e, st) {
      state = state.copyWith(isLoading: false, errorMessage: "Step 5 parameters compilation failure");
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return false;
    }
  }


  Future<bool> saveStep6(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info('Uploading verification attachments bundle via multi-part channel...', tag: LogTags.auth, subTag: _subTag);

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.registerStep6(data: data);
      state = state.copyWith(isLoading: false);

      final status = res.statusCode ?? 0;
      final success = status >= 200 && status < 300;
      if (success) {
        AppLogger.success('Step 6 dynamic documents bundle uploaded successfully', tag: LogTags.auth, subTag: _subTag);
        return true;
      } else {
        final msg = res.data?["message"] ?? "Step 6 verification rejected";
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } on DioException catch (e, st) {
      String errorServerMsg = "Multipart gateway connection transmission loss";
      if (e.response?.data is Map<String, dynamic>) {
        errorServerMsg = e.response?.data["message"]?.toString() ?? errorServerMsg;
      }

      state = state.copyWith(isLoading: false, errorMessage: errorServerMsg);
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return false;
    } catch (e, st) {
      state = state.copyWith(isLoading: false, errorMessage: "Step 6 unexpected mapping panic");
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return false;
    }
  }

  Future<bool> submitRegistration(DoctorFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info('Executing final registration sequence submission...', tag: LogTags.auth, subTag: _subTag);

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final res = await repository.submitRegistration(data: data);
      state = state.copyWith(isLoading: false);

      final status = res.statusCode ?? 0;
      final success = status >= 200 && status < 300;
      if (success) {
        AppLogger.success('Doctor application final packet registration completed successfully', tag: LogTags.auth, subTag: _subTag);
      } else {
        AppLogger.warning('Final registration deployment bundle dropped by server. Status: $status', tag: LogTags.auth, subTag: _subTag);
      }
      return success;
    } catch (e, st) {
      state = state.copyWith(isLoading: false, errorMessage: "Final submission sequence faulted");
      AppLogger.exception(e, st, tag: LogTags.auth, subTag: _subTag);
      return false;
    }
  }

  void clear() {
    AppLogger.info('Clearing registration error flags locally', tag: LogTags.auth, subTag: _subTag);
    state = state.copyWith(clearError: true, isLoading: false);
  }

  Future<void> logoutRegistration() async {
    try {
      AppLogger.info('Clearing registration temporary state tokens...', tag: LogTags.auth, subTag: _subTag);
      final repository = ref.read(doctorAuthRepositoryProvider);
      await repository.clearAuthSession();
      state = const DoctorRegisterState();
      AppLogger.success('Registration temporary session flushed and state reset', tag: LogTags.auth, subTag: _subTag);
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Fatal failure during registration logout pipeline', tag: LogTags.auth, subTag: _subTag);
    }
  }
}
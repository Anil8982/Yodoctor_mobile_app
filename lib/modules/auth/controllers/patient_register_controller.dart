import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/providers/otp_cooldown_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/utils/app_error_utils.dart';
import 'package:yodoctor/modules/auth/models/otp_response.dart';
import 'package:yodoctor/modules/auth/repositories/patient_auth_repository.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class PatientRegisterState {
  final bool isLoading;
  final bool isSendingEmailOtp;
  final bool isVerifyingEmailOtp;
  final bool isSendingMobileOtp;
  final bool isVerifyingMobileOtp;

  final bool isEmailVerified;
  final bool isMobileVerified;

  final String? emailVerificationId;
  final String? mobileVerificationId;

  final String? verifiedEmail;
  final String? verifiedPhone;

  final String? selectedGender;
  final DateTime? selectedDOB;
  final bool agreedToTerms;
  final String? dobError;
  final String? genderError;
  final String? emailError;
  final String? phoneError;

  PatientRegisterState({
    this.isLoading = false,
    this.isSendingEmailOtp = false,
    this.isVerifyingEmailOtp = false,
    this.isSendingMobileOtp = false,
    this.isVerifyingMobileOtp = false,
    this.isEmailVerified = false,
    this.isMobileVerified = false,
    this.emailVerificationId,
    this.mobileVerificationId,
    this.verifiedEmail,
    this.verifiedPhone,
    this.selectedGender,
    this.selectedDOB,
    this.agreedToTerms = false,
    this.dobError,
    this.genderError,
    this.emailError,
    this.phoneError,
  });

  PatientRegisterState copyWith({
    bool? isLoading,
    bool? isSendingEmailOtp,
    bool? isVerifyingEmailOtp,
    bool? isSendingMobileOtp,
    bool? isVerifyingMobileOtp,
    bool? isEmailVerified,
    bool? isMobileVerified,
    String? emailVerificationId,
    String? mobileVerificationId,
    String? verifiedEmail,
    String? verifiedPhone,
    String? selectedGender,
    DateTime? selectedDOB,
    bool? agreedToTerms,
    String? dobError,
    String? genderError,
    String? emailError,
    String? phoneError,
    bool clearDobError = false,
    bool clearGenderError = false,
    bool clearEmailError = false,
    bool clearPhoneError = false,
    bool clearEmailVerification = false,
    bool clearMobileVerification = false,
  }) {
    return PatientRegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSendingEmailOtp: isSendingEmailOtp ?? this.isSendingEmailOtp,
      isVerifyingEmailOtp: isVerifyingEmailOtp ?? this.isVerifyingEmailOtp,
      isSendingMobileOtp: isSendingMobileOtp ?? this.isSendingMobileOtp,
      isVerifyingMobileOtp: isVerifyingMobileOtp ?? this.isVerifyingMobileOtp,
      isEmailVerified: clearEmailVerification ? false : (isEmailVerified ?? this.isEmailVerified),
      isMobileVerified: clearMobileVerification ? false : (isMobileVerified ?? this.isMobileVerified),
      emailVerificationId: clearEmailVerification ? null : (emailVerificationId ?? this.emailVerificationId),
      mobileVerificationId: clearMobileVerification ? null : (mobileVerificationId ?? this.mobileVerificationId),
      verifiedEmail: clearEmailVerification ? null : (verifiedEmail ?? this.verifiedEmail),
      verifiedPhone: clearMobileVerification ? null : (verifiedPhone ?? this.verifiedPhone),
      selectedGender: selectedGender ?? this.selectedGender,
      selectedDOB: selectedDOB ?? this.selectedDOB,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      dobError: clearDobError ? null : (dobError ?? this.dobError),
      genderError: clearGenderError ? null : (genderError ?? this.genderError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
    );
  }
}

final patientRegisterControllerProvider =
    NotifierProvider<PatientRegisterController, PatientRegisterState>(
      PatientRegisterController.new,
    );

class PatientRegisterController extends Notifier<PatientRegisterState> {
  static const String _subTag = 'PatientRegisterController';

  @override
  PatientRegisterState build() {
    AppLogger.info(
      'PatientRegisterController Initialized',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    return PatientRegisterState();
  }

  void selectGender(String gender) {
    AppLogger.info(
      'Gender selection updated locally to: $gender',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    state = state.copyWith(selectedGender: gender, genderError: null);
  }

  void toggleTerms(bool value) {
    AppLogger.info(
      'Terms & conditions agreement toggle value: $value',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    state = state.copyWith(agreedToTerms: value);
  }

  void selectDateOfBirth(DateTime? date) {
    if (date == null) return;

    AppLogger.info(
      'Date of Birth selected: ${DateFormat('dd MMM yyyy').format(date)}',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    state = state.copyWith(selectedDOB: date, clearDobError: true);
  }

  void onEmailChanged(String currentText) {
    final trimmed = currentText.trim();
    if (state.isEmailVerified && trimmed != state.verifiedEmail) {
      AppLogger.info(
        'Verified email text modified. Resetting email verification state.',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      state = state.copyWith(
        clearEmailVerification: true,
        clearEmailError: true,
      );
    }
  }

  void onPhoneChanged(String currentText) {
    final trimmed = currentText.trim();
    if (state.isMobileVerified && trimmed != state.verifiedPhone) {
      AppLogger.info(
        'Verified mobile number modified. Resetting mobile verification state.',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      state = state.copyWith(
        clearMobileVerification: true,
        clearPhoneError: true,
      );
    }
  }

  // -----------------------------------------------------------------
  // 📱 Mobile OTP Flow
  // -----------------------------------------------------------------

  /// Sends OTP to Mobile Number
  Future<OtpSendResponse> sendMobileOtp(String phone) async {
    if (state.isSendingMobileOtp) {
      return OtpSendResponse(
        success: false,
        message: 'OTP request already in progress.',
      );
    }

    state = state.copyWith(isSendingMobileOtp: true, clearPhoneError: true);
    final repository = ref.read(patientAuthRepositoryProvider);

    try {
      final response = await repository.sendRegistrationMobileOtp(phone: phone);

      if (response.success && response.verificationId != null) {
        state = state.copyWith(
          isSendingMobileOtp: false,
          mobileVerificationId: response.verificationId,
        );
        ref.read(otpCooldownProvider.notifier).startCooldown(response.expiresIn ?? 60);
      } else {
        state = state.copyWith(
          isSendingMobileOtp: false,
          phoneError: response.message,
        );
      }
      return response;
    } catch (e) {
      final msg = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Failed to send OTP to mobile.');
      state = state.copyWith(isSendingMobileOtp: false, phoneError: msg);
      return OtpSendResponse(success: false, message: msg);
    }
  }

  /// Verifies Mobile Number OTP
  Future<dynamic> verifyMobileOtp({
    required String phone,
    required String otp,
  }) async {
    final verificationId = state.mobileVerificationId;
    if (verificationId == null || verificationId.isEmpty) {
      return 'Verification ID missing. Please request a new OTP.';
    }

    if (state.isVerifyingMobileOtp) {
      return 'Verification already in progress.';
    }

    state = state.copyWith(isVerifyingMobileOtp: true, clearPhoneError: true);
    final repository = ref.read(patientAuthRepositoryProvider);

    try {
      final response = await repository.verifyRegistrationMobileOtp(
        phone: phone,
        otp: otp,
        verificationId: verificationId,
      );

      if (response.success && response.verified) {
        state = state.copyWith(
          isVerifyingMobileOtp: false,
          isMobileVerified: true,
          verifiedPhone: phone.trim(),
          mobileVerificationId: response.verificationId ?? verificationId,
        );
        ref.read(otpCooldownProvider.notifier).reset();
        return true;
      } else {
        state = state.copyWith(isVerifyingMobileOtp: false);
        return response.message.isNotEmpty
            ? response.message
            : 'Incorrect OTP. Please check the code and try again.';
      }
    } catch (e) {
      state = state.copyWith(isVerifyingMobileOtp: false);
      return AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Incorrect OTP. Please check the code and try again.');
    }
  }

  // -----------------------------------------------------------------
  // ✉️ Email OTP Flow
  // -----------------------------------------------------------------

  /// Sends OTP to Email Address
  Future<OtpSendResponse> sendEmailOtp(String email) async {
    if (state.isSendingEmailOtp) {
      return OtpSendResponse(
        success: false,
        message: 'OTP request already in progress.',
      );
    }

    state = state.copyWith(isSendingEmailOtp: true, clearEmailError: true);
    final repository = ref.read(patientAuthRepositoryProvider);

    try {
      final response = await repository.sendRegistrationEmailOtp(email: email);

      if (response.success && response.verificationId != null) {
        state = state.copyWith(
          isSendingEmailOtp: false,
          emailVerificationId: response.verificationId,
        );
        ref.read(otpCooldownProvider.notifier).startCooldown(response.expiresIn ?? 60);
      } else {
        state = state.copyWith(
          isSendingEmailOtp: false,
          emailError: response.message,
        );
      }
      return response;
    } catch (e) {
      final msg = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Failed to send OTP to email.');
      state = state.copyWith(isSendingEmailOtp: false, emailError: msg);
      return OtpSendResponse(success: false, message: msg);
    }
  }

  /// Verifies Email OTP
  Future<dynamic> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final verificationId = state.emailVerificationId;
    if (verificationId == null || verificationId.isEmpty) {
      return 'Verification ID missing. Please request a new OTP.';
    }

    if (state.isVerifyingEmailOtp) {
      return 'Verification already in progress.';
    }

    state = state.copyWith(isVerifyingEmailOtp: true, clearEmailError: true);
    final repository = ref.read(patientAuthRepositoryProvider);

    try {
      final response = await repository.verifyRegistrationEmailOtp(
        email: email,
        otp: otp,
        verificationId: verificationId,
      );

      if (response.success && response.verified) {
        state = state.copyWith(
          isVerifyingEmailOtp: false,
          isEmailVerified: true,
          verifiedEmail: email.trim(),
          emailVerificationId: response.verificationId ?? verificationId,
        );
        ref.read(otpCooldownProvider.notifier).reset();
        return true;
      } else {
        state = state.copyWith(isVerifyingEmailOtp: false);
        return response.message.isNotEmpty
            ? response.message
            : 'Incorrect OTP. Please check the code and try again.';
      }
    } catch (e) {
      state = state.copyWith(isVerifyingEmailOtp: false);
      return AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Incorrect OTP. Please check the code and try again.');
    }
  }

  // -----------------------------------------------------------------
  // 📝 Complete Patient Registration
  // -----------------------------------------------------------------

  Future<void> registerPatient({
    required BuildContext context,
    required String fullName,
    required String phone,
    String? email,
    required String password,
    required String confirmPassword,
  }) async {
    final trimmedEmail = email?.trim() ?? '';
    final hasEmail = trimmedEmail.isNotEmpty;

    // 1. Mobile verification check (MANDATORY)
    if (!state.isMobileVerified) {
      AppLogger.warning(
        'Patient registration blocked: Mobile number not verified',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      AppSnackBar.show(
        message: 'Please verify your mobile number before creating your account.',
        type: AppSnackBarType.warning,
      );
      return;
    }

    // 2. Email verification check (MANDATORY ONLY IF EMAIL IS PROVIDED)
    if (hasEmail && !state.isEmailVerified) {
      AppLogger.warning(
        'Patient registration blocked: Email provided but not verified',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      AppSnackBar.show(
        message: 'Please verify your email address before creating your account.',
        type: AppSnackBarType.warning,
      );
      return;
    }

    // 3. Date of birth check
    if (state.selectedDOB == null) {
      AppLogger.warning(
        'Patient registration aborted: Missing selected Date of Birth',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      state = state.copyWith(dobError: 'Please select date of birth');
      return;
    }

    // 4. Gender check
    if (state.selectedGender == null) {
      AppLogger.warning(
        'Patient registration aborted: Missing selected Gender reference',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      state = state.copyWith(genderError: 'Please select gender');
      return;
    }

    // 5. Terms check
    if (!state.agreedToTerms) {
      AppLogger.warning(
        'Patient registration aborted: Terms not agreed',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      AppSnackBar.show(
        message: 'Please agree to Terms & Conditions',
        type: AppSnackBarType.warning,
      );
      return;
    }

    state = state.copyWith(isLoading: true);
    final String formattedDOB = DateFormat(
      'yyyy-MM-dd',
    ).format(state.selectedDOB!);

    final payloadSummary = {
      "fullName": fullName,
      "phone": phone,
      "email": hasEmail ? trimmedEmail : '(Optional - not provided)',
      "gender": state.selectedGender,
      "dob": formattedDOB,
      "isMobileVerified": state.isMobileVerified,
      "isEmailVerified": state.isEmailVerified,
    };

    AppLogger.info(
      'Initiating patient registration pipeline workflow...',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    AppLogger.json(
      payloadSummary,
      tag: LogTags.auth,
      subTag: '$_subTag/RegistrationPayloadSummary',
    );

    try {
      final repository = ref.read(patientAuthRepositoryProvider);
      final result = await repository.signUpPatient(
        fullName: fullName,
        phone: phone,
        email: hasEmail ? trimmedEmail : null,
        password: password,
        confirmPassword: confirmPassword,
        gender: state.selectedGender!,
        dob: formattedDOB,
        emailVerificationId: state.emailVerificationId,
        mobileVerificationId: state.mobileVerificationId,
      );

      if (!context.mounted) return;

      if (result.success) {
        AppLogger.success(
          'Patient account registration dispatched and approved successfully on backend',
          tag: LogTags.auth,
          subTag: _subTag,
        );

        AppSnackBar.show(
          message: result.message.isNotEmpty
              ? result.message
              : 'Account created successfully! Please log in.',
          type: AppSnackBarType.success,
        );
        ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
        context.go(AppRoutes.patientLogin);
      } else {
        AppLogger.warning(
          'Patient registration rejected by backend: ${result.message}',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        AppSnackBar.show(
          message: result.message.isNotEmpty
              ? result.message
              : 'Registration failed. Please try again.',
          type: AppSnackBarType.error,
        );
      }
    } catch (e, st) {
      AppLogger.error(
        'Registration pipeline error',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      if (context.mounted) {
        AppSnackBar.show(
          message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Registration failed. Please try again.'),
          type: AppSnackBarType.error,
        );
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

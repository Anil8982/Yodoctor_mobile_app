import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/repositories/patient_auth_repository.dart';

class PatientRegisterState {
  final bool isLoading;
  final String? selectedGender;
  final DateTime? selectedDOB;
  final bool agreedToTerms;
  final String? dobError;
  final String? genderError;

  PatientRegisterState({
    this.isLoading = false,
    this.selectedGender,
    this.selectedDOB,
    this.agreedToTerms = false,
    this.dobError,
    this.genderError,
  });

  PatientRegisterState copyWith({
    bool? isLoading,
    String? selectedGender,
    DateTime? selectedDOB,
    bool? agreedToTerms,
    String? dobError,
    String? genderError,
    bool clearDobError = false,
    bool clearGenderError = false,
  }) {
    return PatientRegisterState(
      isLoading: isLoading ?? this.isLoading,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedDOB: selectedDOB ?? this.selectedDOB,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      dobError: clearDobError ? null : (dobError ?? this.dobError),
      genderError: clearGenderError ? null : (genderError ?? this.genderError),
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
    AppLogger.info('PatientRegisterController Initialized', tag: LogTags.auth, subTag: _subTag);
    return PatientRegisterState();
  }

  void selectGender(String gender) {
    AppLogger.info('Gender selection updated locally to: $gender', tag: LogTags.auth, subTag: _subTag);
    state = state.copyWith(selectedGender: gender, clearGenderError: true);
  }

  void toggleTerms(bool value) {
    AppLogger.info('Terms & conditions agreement toggle value: $value', tag: LogTags.auth, subTag: _subTag);
    state = state.copyWith(agreedToTerms: value);
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    AppLogger.info('Launching Date of Birth selection calendar UI dialog', tag: LogTags.auth, subTag: _subTag);

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppTheme.secondary),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      AppLogger.success('Date of Birth successfully selected: ${picked.toIso8601String()}', tag: LogTags.auth, subTag: _subTag);
      state = state.copyWith(selectedDOB: picked, clearDobError: true);
    } else {
      AppLogger.info('Date of Birth window dismissed without making selection', tag: LogTags.auth, subTag: _subTag);
    }
  }

  Future<void> registerPatient({
    required BuildContext context,
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (state.selectedDOB == null) {
      AppLogger.warning('Patient registration aborted: Missing selected Date of Birth', tag: LogTags.auth, subTag: _subTag);
      state = state.copyWith(dobError: 'Please select date of birth');
      return;
    }

    if (state.selectedGender == null) {
      AppLogger.warning('Patient registration aborted: Missing selected Gender reference', tag: LogTags.auth, subTag: _subTag);
      state = state.copyWith(genderError: 'Please select gender');
      return;
    }

    if (!state.agreedToTerms) {
      AppLogger.warning('Patient registration aborted: Terms & conditions declaration checkbox unticked', tag: LogTags.auth, subTag: _subTag);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms & Conditions')),
      );
      return;
    }

    state = state.copyWith(isLoading: true);
    final String formattedDOB = DateFormat('yyyy-MM-dd').format(state.selectedDOB!);

    final payloadSummary = {
      "fullName": fullName,
      "phone": phone,
      "email": email,
      "gender": state.selectedGender,
      "dob": formattedDOB,
    };

    AppLogger.info('Initiating patient registration pipeline workflow...', tag: LogTags.auth, subTag: _subTag);
    AppLogger.json(payloadSummary, tag: LogTags.auth, subTag: '$_subTag/RegistrationPayloadSummary');

    try {
      final repository = ref.read(patientAuthRepositoryProvider);
      final result = await repository.signUpPatient(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        gender: state.selectedGender!,
        dob: formattedDOB,
      );

      if (!context.mounted) return;

      if (result.success) {
        AppLogger.success('Patient account registration dispatched and approved successfully on backend', tag: LogTags.auth, subTag: _subTag);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message), backgroundColor: Colors.green),
        );
        ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
        context.go(AppRoutes.patientLogin);
      } else {
        AppLogger.warning('Patient registration sequence explicitly rejected by remote backend: ${result.message}', tag: LogTags.auth, subTag: _subTag);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } catch (e, st) {
      AppLogger.error('Registration pipeline collapse exception encountered during transmission', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
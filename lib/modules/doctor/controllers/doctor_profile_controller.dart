import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';

import '../models/dashboard/doctor_profile_model.dart';
import '../repositories/doctor_profile_repository.dart';

class ProfileFormState {
  final bool isLoading;
  final DoctorProfileModel? profile;
  final String selectedGender;
  final String selectedState;
  final String selectedPracticeType;
  final int avgDuration;
  final List<String> activeDays;
  final Map<String, dynamic> timings;
  final List<Map<String, String>> uploadedDocs;
  final String? errorMessage;
  final bool practiceTypeError;
  final bool availableDaysError;

  ProfileFormState({
    this.isLoading = false,
    this.profile,
    this.selectedGender = '',
    this.selectedState = '',
    this.selectedPracticeType = 'Solo Practice',
    this.avgDuration = 20,
    this.activeDays = const [],
    this.timings = const {},
    this.uploadedDocs = const [],
    this.errorMessage,
    this.practiceTypeError = false,
    this.availableDaysError = false,
  });

  ProfileFormState copyWith({
    bool? isLoading,
    DoctorProfileModel? profile,
    bool clearProfile = false,
    String? selectedGender,
    String? selectedState,
    String? selectedPracticeType,
    int? avgDuration,
    List<String>? activeDays,
    Map<String, dynamic>? timings,
    List<Map<String, String>>? uploadedDocs,
    String? errorMessage,
    bool clearError = false,
    bool? practiceTypeError,
    bool? availableDaysError,
  }) {
    return ProfileFormState(
      isLoading: isLoading ?? this.isLoading,
      profile: clearProfile ? null : (profile ?? this.profile),
      selectedGender: selectedGender ?? this.selectedGender,
      selectedState: selectedState ?? this.selectedState,
      selectedPracticeType: selectedPracticeType ?? this.selectedPracticeType,
      avgDuration: avgDuration ?? this.avgDuration,
      activeDays: activeDays ?? this.activeDays,
      timings: timings ?? this.timings,
      uploadedDocs: uploadedDocs ?? this.uploadedDocs,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      practiceTypeError: practiceTypeError ?? this.practiceTypeError,
      availableDaysError: availableDaysError ?? this.availableDaysError,
    );
  }
}

final doctorProfileProvider =
    NotifierProvider<DoctorProfileNotifier, ProfileFormState>(
      DoctorProfileNotifier.new,
    );

class DoctorProfileNotifier extends Notifier<ProfileFormState> {
  static const String _subTag = 'DoctorProfileNotifier';

  final personalFormKey = GlobalKey<FormState>();
  final professionalFormKey = GlobalKey<FormState>();
  final clinicFormKey = GlobalKey<FormState>();
  final practiceFormKey = GlobalKey<FormState>();
  final consultationFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final aboutController = TextEditingController();
  final qualificationController = TextEditingController();
  final specializationController = TextEditingController();
  final expController = TextEditingController();
  final regNoController = TextEditingController();
  final councilController = TextEditingController();
  final regValidTillController = TextEditingController();
  final clinicNameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final landmarkController = TextEditingController();
  final mapsLinkController = TextEditingController();
  final addressController = TextEditingController();
  final hospitalNameController = TextEditingController();
  final feeController = TextEditingController();

  @override
  ProfileFormState build() {
    AppLogger.info(
      'DoctorProfileNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      mobileController.dispose();
      aboutController.dispose();
      qualificationController.dispose();
      specializationController.dispose();
      expController.dispose();
      regNoController.dispose();
      councilController.dispose();
      regValidTillController.dispose();
      clinicNameController.dispose();
      cityController.dispose();
      stateController.dispose();
      pincodeController.dispose();
      landmarkController.dispose();
      mapsLinkController.dispose();
      addressController.dispose();
      hospitalNameController.dispose();
      feeController.dispose();
    });

    return ProfileFormState();
  }

  Future<bool> loadProfile({bool force = false}) async {
    if (state.isLoading && !force) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info(
      'Loading doctor profile data matrix...',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorProfileRepositoryProvider);
      final response = await repository.getProfile();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        AppLogger.success(
          'Doctor profile data fetched successfully',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        AppLogger.json(
          response.data,
          tag: LogTags.doctor,
          subTag: '$_subTag/ProfileFetchData',
        );

        final profile = DoctorProfileModel.fromJson(response.data["doctor"]);
        initProfile(profile);
        return true;
      } else {
        final msg = response.data["message"] ?? "Failed to fetch profile info";
        state = state.copyWith(isLoading: false, errorMessage: msg);
        AppLogger.warning(
          'Profile fetch failed with status: $statusCode. Message: $msg',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Runtime crash loading profile",
      );
      AppLogger.exception(
        e,
        st,
        message: 'Fatal crash in profile load pipeline',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }

  void initProfile(DoctorProfileModel currentProfile) {
    final formattedRegistrationDate = currentProfile.validTill.isEmpty
        ? ''
        : DateFormat(
            'dd MMM yyyy',
          ).format(DateTime.parse(currentProfile.validTill));
    nameController.text = currentProfile.doctorName;
    emailController.text = currentProfile.email;
    mobileController.text = currentProfile.mobile;
    aboutController.text = currentProfile.bio;
    qualificationController.text = currentProfile.degree;
    specializationController.text = currentProfile.specialization;
    expController.text = currentProfile.experienceYears.toString();
    regNoController.text = currentProfile.licenseNumber;
    councilController.text = currentProfile.stateCouncil;
    regValidTillController.text = formattedRegistrationDate;
    clinicNameController.text = currentProfile.clinicName;
    cityController.text = currentProfile.city;
    stateController.text = currentProfile.state;
    pincodeController.text = currentProfile.pincode;
    landmarkController.text = currentProfile.landmark;
    mapsLinkController.text = currentProfile.mapsLink;
    addressController.text = currentProfile.address;
    hospitalNameController.text = currentProfile.hospitalName ?? '';
    feeController.text = currentProfile.consultationFee.toString();

    state = state.copyWith(
      isLoading: false,
      clearError: true,
      profile: currentProfile,
      selectedGender: currentProfile.gender,
      selectedState: currentProfile.state,
      selectedPracticeType: currentProfile.practiceType,
      avgDuration: currentProfile.consultationDuration,
      activeDays: List.from(currentProfile.availableDays),
    );
  }

  void updateGender(String gender) {
    AppLogger.info(
      'Gender updated to: $gender',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(selectedGender: gender);
  }

  void updateState(String value) {
    stateController.text = value;

    state = state.copyWith(selectedState: value);
  }

  void updatePracticeType(String type) {
    AppLogger.info(
      'Practice type updated to: $type',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(
      selectedPracticeType: type,
      practiceTypeError: false,
    );
  }

  void updateDuration(int value) {
    AppLogger.info(
      'Consultation duration updated to: $value mins',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(avgDuration: value);
  }

  void toggleDay(String day) {
    final days = List<String>.from(state.activeDays);
    if (days.contains(day)) {
      days.remove(day);
    } else {
      days.add(day);
    }
    AppLogger.info(
      'Toggled available day: $day. Active days roster: $days',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(activeDays: days, availableDaysError: false);
  }

  Future<void> pickRegistrationValidTill(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime initialDate =
        DateFormat('dd MMM yyyy').tryParse(regValidTillController.text) ??
        DateTime.now().add(const Duration(days: 365));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final formattedDate = DateFormat('dd MMM yyyy').format(pickedDate);
    regValidTillController.text = formattedDate;
  }

  Future<bool> saveProfileChanges() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final formattedRegistrationDate = regValidTillController.text.isEmpty
        ? null
        : DateFormat('yyyy-MM-dd').format(
            DateFormat('dd MMM yyyy').parse(regValidTillController.text),
          );

    final payload = {
      "doctorName": nameController.text,
      "email": emailController.text,
      "mobile": mobileController.text,
      "gender": state.selectedGender,
      "bio": aboutController.text,
      "degree": qualificationController.text,
      "specialization": specializationController.text,
      "experience_years": int.tryParse(expController.text) ?? 0,
      "licenseNumber": regNoController.text,
      "state_council": councilController.text,
      "valid_till": formattedRegistrationDate,
      "clinic_name": clinicNameController.text,
      "city": cityController.text,
      "state": stateController.text,
      "pincode": pincodeController.text,
      "landmark": landmarkController.text,
      "mapsLink": mapsLinkController.text,
      "address": addressController.text,
      "practice_type": state.selectedPracticeType,
      "hospital_name": hospitalNameController.text,
      "consultationFee": int.tryParse(feeController.text) ?? 0,
      "consultation_duration": state.avgDuration,
      "availableDays": state.activeDays,
    };

    AppLogger.info(
      'Submitting doctor profile revision batch...',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    AppLogger.json(
      payload,
      tag: LogTags.doctor,
      subTag: '$_subTag/UpdatePayload',
    );

    try {
      final repository = ref.read(doctorProfileRepositoryProvider);
      final response = await repository.updateProfile(payload);
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        AppLogger.success(
          'Doctor profile changes saved successfully on backend',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        final syncSuccess = await loadProfile(force: true);
        return syncSuccess;
      } else {
        final msg =
            response.data["message"] ?? "Failed to save profile changes";
        state = state.copyWith(isLoading: false, errorMessage: msg);
        AppLogger.warning(
          'Failed to save profile updates. Backend rejected with status: $statusCode',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Profile mutation failure",
      );
      AppLogger.exception(
        e,
        st,
        message: 'Profile save execution failure',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }

  bool hasUnsavedChanges() {
    final current = state.profile;
    if (current == null) return true;

    final isSame =
        nameController.text == current.doctorName &&
        emailController.text == current.email &&
        mobileController.text == current.mobile &&
        aboutController.text == current.bio &&
        qualificationController.text == current.degree &&
        specializationController.text == current.specialization &&
        (int.tryParse(expController.text) ?? 0) == current.experienceYears &&
        regNoController.text == current.licenseNumber &&
        councilController.text == current.stateCouncil &&
        regValidTillController.text == current.validTill &&
        clinicNameController.text == current.clinicName &&
        cityController.text == current.city &&
        stateController.text == current.state &&
        pincodeController.text == current.pincode &&
        landmarkController.text == current.landmark &&
        mapsLinkController.text == current.mapsLink &&
        addressController.text == current.address &&
        hospitalNameController.text == (current.hospitalName ?? '') &&
        (int.tryParse(feeController.text) ?? 0) == current.consultationFee &&
        state.selectedGender == current.gender &&
        state.selectedPracticeType == current.practiceType &&
        state.avgDuration == current.consultationDuration &&
        // List Elements Equality Check
        state.activeDays.length == current.availableDays.length &&
        state.activeDays.every((day) => current.availableDays.contains(day));

    return !isSame;
  }

  bool validatePracticeType() {
    if (state.selectedPracticeType.isEmpty) {
      state = state.copyWith(practiceTypeError: true);
      return false;
    }
    return true;
  }

  bool validateAvailableDays() {
    if (state.activeDays.isEmpty) {
      state = state.copyWith(availableDaysError: true);
      return false;
    }
    return true;
  }

  Future<bool> validateAllTabs(TabController tabController) async {
    // Personal
    tabController.animateTo(0);
    await Future.delayed(const Duration(milliseconds: 250));

    if (!(personalFormKey.currentState?.validate() ?? false)) {
      return false;
    }

    // Professional
    tabController.animateTo(1);
    await Future.delayed(const Duration(milliseconds: 250));

    if (!(professionalFormKey.currentState?.validate() ?? false)) {
      return false;
    }

    // Clinic
    tabController.animateTo(2);
    await Future.delayed(const Duration(milliseconds: 250));

    if (!(clinicFormKey.currentState?.validate() ?? false)) {
      return false;
    }

    // Practice
    tabController.animateTo(3);
    await Future.delayed(const Duration(milliseconds: 250));

    if (!(practiceFormKey.currentState?.validate() ?? false)) {
      return false;
    }
    if (!validatePracticeType()) {
      return false;
    }

    // Consultation
    tabController.animateTo(4);
    await Future.delayed(const Duration(milliseconds: 250));

    if (!(consultationFormKey.currentState?.validate() ?? false)) {
      return false;
    }
    if (!validateAvailableDays()) {
      return false;
    }

    return true;
  }

  void clearPracticeTypeError() {
    if (state.practiceTypeError) {
      state = state.copyWith(practiceTypeError: false);
    }
  }

  void clearAvailableDaysError() {
    if (state.availableDaysError) {
      state = state.copyWith(availableDaysError: false);
    }
  }
}

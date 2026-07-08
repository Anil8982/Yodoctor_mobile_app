import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/doctor/doctor_profile_model.dart';
import '../../../../services/doctor_profile_service.dart';

// 🎯 State structure for mutable fields only
class ProfileFormState {
  final bool isLoading;
  final DoctorProfileModel? profile;
  final String selectedGender;
  final String selectedPracticeType;
  final int avgDuration;
  final List<String> activeDays;
  final Map<String, dynamic> timings;
  final List<Map<String, String>> uploadedDocs;

  ProfileFormState({
    this.isLoading = false,
    this.profile,
    this.selectedGender = 'Male',
    this.selectedPracticeType = 'Solo Practice',
    this.avgDuration = 20,
    this.activeDays = const [],
    this.timings = const {},
    this.uploadedDocs = const [],
  });

  ProfileFormState copyWith({
    bool? isLoading,
    DoctorProfileModel? profile,
    String? selectedGender,
    String? selectedPracticeType,
    int? avgDuration,
    List<String>? activeDays,
    Map<String, dynamic>? timings,
    List<Map<String, String>>? uploadedDocs,
  }) {
    return ProfileFormState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedPracticeType: selectedPracticeType ?? this.selectedPracticeType,
      avgDuration: avgDuration ?? this.avgDuration,
      activeDays: activeDays ?? this.activeDays,
      timings: timings ?? this.timings,
      uploadedDocs: uploadedDocs ?? this.uploadedDocs,
    );
  }
}

// 🎯 Manual Riverpod Notifier implementation
class DoctorProfileNotifier extends Notifier<ProfileFormState> {
  final DoctorProfileService _service = DoctorProfileService();

  // Form Keys
  final personalFormKey = GlobalKey<FormState>();
  final professionalFormKey = GlobalKey<FormState>();
  final clinicFormKey = GlobalKey<FormState>();
  final practiceFormKey = GlobalKey<FormState>();
  final consultationFormKey = GlobalKey<FormState>();

  // Text Controllers
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
    // Clean-up controllers when this notifier is destroyed/rebuilt
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

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    final response = await _service.getProfile();

    if (response.statusCode != 200) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final profile = DoctorProfileModel.fromJson(response.data["doctor"]);

    initProfile(profile);
  }

  // Initialize form fields with current data payload
  void initProfile(DoctorProfileModel currentProfile) {
    nameController.text = currentProfile.doctorName;
    emailController.text = currentProfile.email;
    mobileController.text = currentProfile.mobile;
    aboutController.text = currentProfile.bio;

    qualificationController.text = currentProfile.degree;
    specializationController.text = currentProfile.specialization;
    expController.text = currentProfile.experienceYears.toString();
    regNoController.text = currentProfile.licenseNumber;
    councilController.text = currentProfile.stateCouncil;
    regValidTillController.text = currentProfile.validTill;
    clinicNameController.text = currentProfile.clinicName;

    clinicNameController.text = currentProfile.clinicName;
    cityController.text = currentProfile.city;
    stateController.text = currentProfile.state;
    pincodeController.text = currentProfile.pincode;
    landmarkController.text = currentProfile.landmark;
    mapsLinkController.text = currentProfile.mapsLink;
    addressController.text = currentProfile.address;
    hospitalNameController.text = currentProfile.hospitalName ?? '';
    feeController.text = currentProfile.consultationFee.toString();

    state = ProfileFormState(
      profile: currentProfile,
      selectedGender: currentProfile.gender,
      selectedPracticeType: currentProfile.practiceType,
      avgDuration: currentProfile.consultationDuration,
      activeDays: List.from(currentProfile.availableDays),
      timings: {},
      uploadedDocs: [],
    );
  }

  void updateGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void updatePracticeType(String type) {
    state = state.copyWith(selectedPracticeType: type);
  }

  void updateDuration(int value) {
    state = state.copyWith(avgDuration: value);
  }

  void toggleDay(String day) {
    final days = List<String>.from(state.activeDays);

    if (days.contains(day)) {
      days.remove(day);
    } else {
      days.add(day);
    }

    state = state.copyWith(activeDays: days);
  }

  // Save updates and return status response
  Future<bool> saveProfileChanges() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _service.updateProfile({
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
        "valid_till": regValidTillController.text,

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
      });

      if (response.statusCode != 200) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      await loadProfile();

      state = state.copyWith(isLoading: false);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}

final doctorProfileProvider =
    NotifierProvider<DoctorProfileNotifier, ProfileFormState>(
      DoctorProfileNotifier.new,
    );

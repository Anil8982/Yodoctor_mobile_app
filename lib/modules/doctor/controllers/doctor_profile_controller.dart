import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/doctor/doctor_dashboard_profile.dart';

// 🎯 State structure for mutable fields only
class ProfileFormState {
  final bool isLoading;
  final DoctorDashboardProfile? profile;
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
    DoctorDashboardProfile? profile,
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

  // Initialize form fields with current data payload
  void initProfile(DoctorDashboardProfile currentProfile) {
    nameController.text = currentProfile.fullName;
    emailController.text = currentProfile.email;
    mobileController.text = currentProfile.mobile;
    aboutController.text = currentProfile.aboutYou;

    qualificationController.text = currentProfile.primaryQualification;
    specializationController.text = currentProfile.specialization;
    expController.text = currentProfile.experienceYears.toString();
    regNoController.text = currentProfile.registrationNumber;
    councilController.text = currentProfile.stateCouncil;
    regValidTillController.text = currentProfile.registrationValidTill;

    clinicNameController.text = currentProfile.clinicName;
    cityController.text = currentProfile.city;
    stateController.text = currentProfile.state;
    pincodeController.text = currentProfile.pincode;
    landmarkController.text = currentProfile.landmark;
    mapsLinkController.text = currentProfile.googleMapsLink;
    addressController.text = currentProfile.fullAddress;
    hospitalNameController.text = currentProfile.affiliatedHospitalName ?? '';
    feeController.text = currentProfile.consultationFee.toString();

    state = ProfileFormState(
      profile: currentProfile,
      selectedGender: currentProfile.gender,
      selectedPracticeType: currentProfile.practiceType,
      avgDuration: currentProfile.avgDurationMinutes,
      activeDays: List.from(currentProfile.availableDays),
      timings: Map.from(currentProfile.shiftTimings),
      uploadedDocs: List.from(currentProfile.documents),
    );
  }

  void updateGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void updatePracticeType(String type) {
    state = state.copyWith(selectedPracticeType: type);
  }

  // Save updates and return status response
  Future<bool> saveProfileChanges() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 800));

    final updatedProfile = DoctorDashboardProfile(
      id: state.profile?.id ?? '',
      fullName: nameController.text,
      email: emailController.text,
      mobile: mobileController.text,
      gender: state.selectedGender,
      aboutYou: aboutController.text,
      profilePictureUrl: state.profile?.profilePictureUrl,
      primaryQualification: qualificationController.text,
      specialization: specializationController.text,
      experienceYears: int.tryParse(expController.text) ?? 0,
      registrationNumber: regNoController.text,
      stateCouncil: councilController.text,
      registrationValidTill: regValidTillController.text,
      clinicName: clinicNameController.text,
      city: cityController.text,
      state: stateController.text,
      pincode: pincodeController.text,
      landmark: landmarkController.text,
      googleMapsLink: mapsLinkController.text,
      fullAddress: addressController.text,
      practiceType: state.selectedPracticeType,
      affiliatedHospitalName: hospitalNameController.text.isEmpty ? null : hospitalNameController.text,
      consultationFee: int.tryParse(feeController.text) ?? 0,
      avgDurationMinutes: state.avgDuration,
      availableDays: state.activeDays,
      shiftTimings: state.timings,
      documents: state.uploadedDocs,
    );

    state = state.copyWith(
      isLoading: false,
      profile: updatedProfile,
    );
    return true;
  }
}

// 🎯 Auto-dispose provider declaration to prevent context overhead
final doctorProfileProvider = NotifierProvider.autoDispose<DoctorProfileNotifier, ProfileFormState>(
  DoctorProfileNotifier.new,
);
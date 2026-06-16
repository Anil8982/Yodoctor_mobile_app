import 'package:flutter/material.dart';
import '../../../../core/models/doctor/doctor_dashboard_profile.dart';

class DoctorProfileController extends ChangeNotifier {
  bool _isLoading = false;
  DoctorDashboardProfile? _profile;

  bool get isLoading => _isLoading;
  DoctorDashboardProfile? get profile => _profile;

  // Global form keys for all 6 tabs validation
  final personalFormKey = GlobalKey<FormState>();
  final professionalFormKey = GlobalKey<FormState>();
  final clinicFormKey = GlobalKey<FormState>();
  final practiceFormKey = GlobalKey<FormState>();
  final consultationFormKey = GlobalKey<FormState>();

  // Tab 1: Personal Info Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final aboutController = TextEditingController();
  String selectedGender = 'Male';

  // Tab 2: Professional Info Controllers
  final qualificationController = TextEditingController();
  final specializationController = TextEditingController();
  final expController = TextEditingController();
  final regNoController = TextEditingController();
  final councilController = TextEditingController();
  final regValidTillController = TextEditingController();

  // Tab 3: Clinic Details Controllers
  final clinicNameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final landmarkController = TextEditingController();
  final mapsLinkController = TextEditingController();
  final addressController = TextEditingController();
  List<String> selectedLanguages = [];

  // Tab 4: Practice Type Controllers
  String selectedPracticeType = 'Solo Practice';
  final hospitalNameController = TextEditingController();

  // Tab 5: Consultation Timings Controllers
  final feeController = TextEditingController();
  int avgDuration = 20;
  List<String> activeDays = [];
  Map<String, dynamic> timings = {};

  // Tab 6: Documents Info
  List<Map<String, String>> uploadedDocs = [];

  // Initialize data from Dashboard Profile Model
  void initProfile(DoctorDashboardProfile currentProfile) {
    _profile = currentProfile;

    // Map Tab 1 Fields
    nameController.text = currentProfile.fullName;
    emailController.text = currentProfile.email;
    mobileController.text = currentProfile.mobile;
    aboutController.text = currentProfile.aboutYou;
    selectedGender = currentProfile.gender;

    // Map Tab 2 Fields
    qualificationController.text = currentProfile.primaryQualification;
    specializationController.text = currentProfile.specialization;
    expController.text = currentProfile.experienceYears.toString();
    regNoController.text = currentProfile.registrationNumber;
    councilController.text = currentProfile.stateCouncil;
    regValidTillController.text = currentProfile.registrationValidTill;

    // Map Tab 3 Fields
    clinicNameController.text = currentProfile.clinicName;
    cityController.text = currentProfile.city;
    stateController.text = currentProfile.state;
    pincodeController.text = currentProfile.pincode;
    landmarkController.text = currentProfile.landmark;
    mapsLinkController.text = currentProfile.googleMapsLink;
    addressController.text = currentProfile.fullAddress;
    // selectedLanguages = List.from(currentProfile.languagesSpoken ?? []);

    // Map Tab 4 Fields
    selectedPracticeType = currentProfile.practiceType;
    hospitalNameController.text = currentProfile.affiliatedHospitalName ?? '';

    // Map Tab 5 Fields
    feeController.text = currentProfile.consultationFee.toString();
    avgDuration = currentProfile.avgDurationMinutes;
    activeDays = List.from(currentProfile.availableDays);
    timings = Map.from(currentProfile.shiftTimings);

    // Map Tab 6 Fields
    uploadedDocs = List.from(currentProfile.documents);
  }

  void updateGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void updatePracticeType(String type) {
    selectedPracticeType = type;
    notifyListeners();
  }

  // Save changes and generate fresh data payload
  Future<bool> saveProfileChanges() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final updatedProfile = DoctorDashboardProfile(
      id: _profile?.id ?? '',
      fullName: nameController.text,
      email: emailController.text,
      mobile: mobileController.text,
      gender: selectedGender,
      aboutYou: aboutController.text,
      profilePictureUrl: _profile?.profilePictureUrl,
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
      practiceType: selectedPracticeType,
      affiliatedHospitalName: hospitalNameController.text.isEmpty ? null : hospitalNameController.text,
      consultationFee: int.tryParse(feeController.text) ?? 0,
      avgDurationMinutes: avgDuration,
      availableDays: activeDays,
      shiftTimings: timings,
      documents: uploadedDocs,
    );

    _profile = updatedProfile;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
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
    super.dispose();
  }
}
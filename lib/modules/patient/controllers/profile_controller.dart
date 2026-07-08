import 'package:flutter/material.dart';

import '../../../services/patient_profile_service.dart';
import '../screens/profile/models/profile_model.dart';
import '../screens/profile/models/patient_model.dart';

class ProfileController extends ChangeNotifier {
  final PatientProfileService _service = PatientProfileService();

  bool _isLoading = false;
  String? _errorMessage;
  PatientModel? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PatientModel? get user => _user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  bool get hasChanges {
    if (_user == null) return false;

    return nameController.text != _user!.fullName ||
        mobileController.text != _user!.phone ||
        dobController.text != _user!.dob ||
        genderController.text != _user!.gender;
  }

  ProfileController() {
    loadProfile();

    nameController.addListener(notifyListeners);
    emailController.addListener(notifyListeners);
    mobileController.addListener(notifyListeners);
    dobController.addListener(notifyListeners);
    genderController.addListener(notifyListeners);
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getProfile();

      if (response.statusCode == 200) {
        final profile = ProfileModel.fromJson(response.data);

        _user = profile.data;

        nameController.text = _user!.fullName;
        emailController.text = _user!.email;
        mobileController.text = _user!.phone;
        dobController.text = _user!.dob;
        genderController.text = _user!.gender;
      } else {
        _errorMessage = response.data["message"];
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.updateProfile(
        fullName: nameController.text.trim(),
        phone: mobileController.text.trim(),
        gender: genderController.text.trim(),
        dob: dobController.text.trim(),
      );

      if (response.statusCode == 200) {
        await loadProfile();
      } else {
        _errorMessage = response.data["message"];
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void discardChanges() {
    loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dobController.dispose();
    genderController.dispose();
    super.dispose();
  }
}

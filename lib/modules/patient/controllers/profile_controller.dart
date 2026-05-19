import 'package:flutter/material.dart';
import '../../../core/utils/dummy_data.dart';

class ProfileController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  PatientUser? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PatientUser? get user => _user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  bool get hasChanges {
    if (_user == null) return false;
    return nameController.text != _user!.name ||
        emailController.text != _user!.email ||
        mobileController.text != _user!.mobileNumber ||
        dobController.text != _user!.dateOfBirth;
  }

  ProfileController() {
    loadProfile();
    nameController.addListener(notifyListeners);
    emailController.addListener(notifyListeners);
    mobileController.addListener(notifyListeners);
    dobController.addListener(notifyListeners);
  }


  void loadProfile() {
    _user = DummyData.currentUser;
    nameController.text = _user?.name ?? '';
    emailController.text = _user?.email ?? '';
    mobileController.text = _user?.mobileNumber ?? '';
    dobController.text = _user?.dateOfBirth ?? '';
    genderController.text = _user?.gender ?? '';
    notifyListeners();
  }

  Future<void> updateProfile() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

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

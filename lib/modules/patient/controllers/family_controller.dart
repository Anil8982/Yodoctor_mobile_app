import 'package:flutter/foundation.dart';

import '../../../services/patient_family_service.dart';
import '../models/family/family_member_model.dart';

class FamilyController extends ChangeNotifier {
  final PatientFamilyService _service = PatientFamilyService();

  bool _isLoading = false;
  String? _errorMessage;

  List<FamilyMemberModel> _members = [];

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<FamilyMemberModel> get members => _members;

  FamilyController() {
    loadFamilyMembers();
  }

  Future<void> loadFamilyMembers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getFamilyMembers();

      if (response.statusCode == 200) {
        final List list = response.data["members"] ?? [];

        _members = list.map((e) => FamilyMemberModel.fromJson(e)).toList();
      } else {
        _errorMessage = response.data["message"];
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMember({
    required String fullName,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String heightCm,
    required String weightKg,
    required String relation,
  }) async {
    final response = await _service.addFamilyMember(
      fullName: fullName,
      gender: gender,
      dob: dob,
      bloodGroup: bloodGroup,
      heightCm: heightCm,
      weightKg: weightKg,
      relation: relation,
    );

    if (response.statusCode == 201) {
      await loadFamilyMembers();
    } else {
      _errorMessage = response.data["message"];
      notifyListeners();
    }
  }

  Future<void> updateMember({
    required int id,
    required String fullName,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String heightCm,
    required String weightKg,
    required String relation,
  }) async {
    final response = await _service.updateFamilyMember(
      id: id,
      fullName: fullName,
      gender: gender,
      dob: dob,
      bloodGroup: bloodGroup,
      heightCm: heightCm,
      weightKg: weightKg,
      relation: relation,
    );

    if (response.statusCode == 200) {
      await loadFamilyMembers();
    } else {
      _errorMessage = response.data["message"];
      notifyListeners();
    }
  }

  Future<void> deleteMember(int id) async {
    final response = await _service.deleteFamilyMember(id);

    if (response.statusCode == 200) {
      await loadFamilyMembers();
    } else {
      _errorMessage = response.data["message"];
      notifyListeners();
    }
  }
}

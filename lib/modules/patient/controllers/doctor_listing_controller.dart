import 'package:flutter/foundation.dart';

import '../../../services/patient_search_service.dart';
import '../models/search/doctor_search_model.dart';

class DoctorListingController extends ChangeNotifier {
  final PatientSearchService _service = PatientSearchService();

  bool _isLoading = false;
  String? _errorMessage;

  final List<DoctorSearchModel> _allDoctors = [];
  final List<DoctorSearchModel> _doctors = [];

  String _selectedSpecialty = "All";
  String _activeQuery = "";

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<DoctorSearchModel> get doctors => _doctors;

  String get selectedSpecialty => _selectedSpecialty;

  String get activeQuery => _activeQuery;

  int get foundCount => _doctors.length;

  List<String> get specialties {
    final values = <String>{"All", ..._allDoctors.map((e) => e.specialty)};

    return values.toList();
  }

  Future<void> loadDoctors({
    String query = "",
    String city = "",
    int page = 1,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _activeQuery = query;

    notifyListeners();

    try {
      final response = await _service.searchDoctors(
        search: query,
        city: city,
        page: page,
      );

      if (response.statusCode == 200) {
        _allDoctors.clear();

        _allDoctors.addAll(
          (response.data["data"]["doctors"] as List).map(
            (e) => DoctorSearchModel.fromJson(e),
          ),
        );

        _applySpecialtyFilter();
      } else {
        _errorMessage = response.data["message"];
        _allDoctors.clear();
        _doctors.clear();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _allDoctors.clear();
      _doctors.clear();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSpecialty(String specialty) {
    if (_selectedSpecialty == specialty) return;

    _selectedSpecialty = specialty;

    _applySpecialtyFilter();

    notifyListeners();
  }

  void _applySpecialtyFilter() {
    if (_selectedSpecialty == "All") {
      _doctors
        ..clear()
        ..addAll(_allDoctors);

      return;
    }

    _doctors
      ..clear()
      ..addAll(_allDoctors.where((e) => e.specialty == _selectedSpecialty));
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../../services/patient_search_service.dart';
import '../models/search/city_model.dart';
import '../models/search/doctor_name_model.dart';
import '../models/search/doctor_search_model.dart';
import '../models/search/specialty_model.dart';

class PatientSearchController extends ChangeNotifier {
  final PatientSearchService _service = PatientSearchService();

  bool _isLoading = false;
  String? _errorMessage;

  final List<SpecialtyModel> _trendingSpecialties = [];
  final List<DoctorSearchModel> _doctorSuggestions = [];
  final List<CityModel> _cities = [];
  final List<DoctorNameModel> _doctorNames = [];

  String _selectedTrending = "";
  String _location = "";
  String _query = "";

  Timer? _debounce;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<String> get trendingSpecialties =>
      _trendingSpecialties.map((e) => e.name).toList();

  List<DoctorSearchModel> get doctorSuggestions => _doctorSuggestions;

  List<CityModel> get cities => _cities;

  String get selectedTrending => _selectedTrending;

  String get location => _location;

  String get query => _query;

  PatientSearchController() {
    loadTrendingSpecialties();
  }

  // -------------------------------
  // Trending Specialties
  // -------------------------------
  Future<void> loadTrendingSpecialties() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getSpecialties();

      if (response.statusCode == 200) {
        _trendingSpecialties.clear();

        _trendingSpecialties.addAll(
          (response.data["data"] as List).map(
            (e) => SpecialtyModel.fromJson(e),
          ),
        );
      } else {
        _errorMessage = response.data["message"];
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // -------------------------------
  // Search Suggestions
  // -------------------------------
  void updateQuery(String value) {
    _query = value;

    _debounce?.cancel();

    if (value.isEmpty) {
      _doctorSuggestions.clear();
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _loadDoctorSuggestions();
    });
  }

  Future<void> _loadDoctorSuggestions() async {
    try {
      final response = await _service.searchDoctors(
        search: _query,
        city: _location,
      );

      if (response.statusCode == 200) {
        _doctorSuggestions.clear();

        _doctorSuggestions.addAll(
          (response.data["data"]["doctors"] as List).map(
            (e) => DoctorSearchModel.fromJson(e),
          ),
        );
      }

      notifyListeners();
    } catch (_) {}
  }

  // -------------------------------
  // Location
  // -------------------------------
  Future<void> updateLocation(String value) async {
    _location = value;
    notifyListeners();

    try {
      final response = await _service.getCities(search: value);

      if (response.statusCode == 200) {
        _cities.clear();

        _cities.addAll(
          (response.data["data"] as List).map((e) => CityModel.fromJson(e)),
        );
      }

      notifyListeners();
    } catch (_) {}
  }

  // -------------------------------
  // Doctor Names
  // -------------------------------
  Future<void> loadDoctorNames() async {
    try {
      final response = await _service.getDoctorNames();

      if (response.statusCode == 200) {
        _doctorNames.clear();

        _doctorNames.addAll(
          (response.data["data"] as List).map(
            (e) => DoctorNameModel.fromJson(e),
          ),
        );
      }
    } catch (_) {}
  }

  // -------------------------------
  // Trending Click
  // -------------------------------
  void selectTrending(String specialty) {
    _selectedTrending = specialty;
    _query = specialty;

    _loadDoctorSuggestions();

    notifyListeners();
  }

  // -------------------------------
  // Clear
  // -------------------------------
  void clearSuggestions() {
    _doctorSuggestions.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

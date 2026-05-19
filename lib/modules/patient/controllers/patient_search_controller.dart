import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/utils/dummy_data.dart';

class PatientSearchController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final List<String> _trendingSpecialties = <String>[];
  List<DoctorProfile> _doctorSuggestions = [];
  String _selectedTrending = '';
  String _location = 'Chhatrapati Sambhajinagar';
  String _query = '';
  Timer? _hideTimer;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get trendingSpecialties => _trendingSpecialties;
  List<DoctorProfile> get doctorSuggestions => _doctorSuggestions;
  String get selectedTrending => _selectedTrending;
  String get location => _location;
  String get query => _query;

  PatientSearchController() {
    loadTrendingSpecialties();
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 7), () {
      _doctorSuggestions = [];
      notifyListeners();
    });
  }

  Future<void> loadTrendingSpecialties() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final List<String> results = await DummyData.getTrendingSpecialties();
      _trendingSpecialties.clear();
      _trendingSpecialties.addAll(results);
    } catch (_) {
      _errorMessage = 'Unable to load specialties. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateQuery(String value) {
    _query = value;
    if (value.isEmpty) {
      _doctorSuggestions = [];
      _hideTimer?.cancel();
      notifyListeners();
      return;
    }

    final input = value.toLowerCase();
    _doctorSuggestions = DummyData.allDoctors.where((doc) {
      return doc.name.toLowerCase().contains(input) ||
          doc.specialty.toLowerCase().contains(input) ||
          doc.hospital.toLowerCase().contains(input);
    }).toList();

    if (_doctorSuggestions.isNotEmpty) {
      _resetHideTimer();
    } else {
      _hideTimer?.cancel();
    }

    notifyListeners();
  }

  void updateLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void selectTrending(String specialty) {
    _selectedTrending = specialty;
    _query = specialty;
    _doctorSuggestions = [];
    _hideTimer?.cancel();
    notifyListeners();
  }

  void clearSuggestions() {
    _doctorSuggestions = [];
    _hideTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }
}
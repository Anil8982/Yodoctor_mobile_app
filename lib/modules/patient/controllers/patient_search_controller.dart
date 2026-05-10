import 'package:flutter/foundation.dart';
import '../../../core/utils/dummy_data.dart';

class PatientSearchController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _trendingSpecialties = <String>[];
  String _selectedTrending = '';
  String _location = 'Bengaluru';
  String _query = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get trendingSpecialties => _trendingSpecialties;
  String get selectedTrending => _selectedTrending;
  String get location => _location;
  String get query => _query;

  PatientSearchController() {
    loadTrendingSpecialties();
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

  void selectTrending(String specialty) {
    _selectedTrending = specialty;
    _query = specialty;
    notifyListeners();
  }

  void updateLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }
}

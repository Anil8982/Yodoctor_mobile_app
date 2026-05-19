import 'package:flutter/foundation.dart';
import '../../../core/utils/dummy_data.dart';

class DoctorListingController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  final List<DoctorProfile> _allDoctors = <DoctorProfile>[];
  final List<DoctorProfile> _doctors = <DoctorProfile>[];

  String _selectedSpecialty = 'All';
  String _activeQuery = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<DoctorProfile> get doctors => _doctors;
  String get selectedSpecialty => _selectedSpecialty;
  String get activeQuery => _activeQuery;

  int get foundCount => _doctors.length;

  List<String> get specialties {
    final Set<String> values = <String>{
      'All',
      ..._allDoctors.map((DoctorProfile item) => item.specialty),
    };
    return values.toList();
  }

  Future<void> loadDoctors({String query = ''}) async {
    _isLoading = true;
    _errorMessage = null;
    _activeQuery = query;
    notifyListeners();

    try {
      final List<DoctorProfile> results = await DummyData.searchDoctors(query: query);
      _allDoctors.clear();
      _allDoctors.addAll(results);
      _applySpecialtyFilter();
    } catch (_) {
      _errorMessage = 'Unable to load doctors. Please try again.';
      _allDoctors.clear();
      _doctors.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSpecialty(String specialty) {
    if (_selectedSpecialty == specialty) return;
    _selectedSpecialty = specialty;
    _applySpecialtyFilter();
    notifyListeners();
  }

  void _applySpecialtyFilter() {
    if (_selectedSpecialty == 'All') {
      _doctors.clear();
      _doctors.addAll(_allDoctors);
      return;
    }

    _doctors.clear();
    _doctors.addAll(
      _allDoctors.where(
        (DoctorProfile item) => item.specialty == _selectedSpecialty,
      ),
    );
  }
}

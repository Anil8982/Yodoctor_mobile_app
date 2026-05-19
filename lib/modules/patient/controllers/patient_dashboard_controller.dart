import 'package:flutter/foundation.dart';
import '../../../core/utils/dummy_data.dart';

class PatientDashboardController extends ChangeNotifier {
  static const List<String> availableFilters = <String>[
    'All',
    'Today',
    'Next 7 Days',
  ];

  bool _isLoading = false;
  String? _errorMessage;
  PatientDashboardData? _dashboardData;
  String _selectedFilter = 'All';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PatientDashboardData? get dashboardData => _dashboardData;
  String get selectedFilter => _selectedFilter;


  PatientDashboardController() {
    loadDashboard();
  }

  Future<void> loadDashboard({String? filter}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (filter != null) {
      _selectedFilter = filter;
    }

    try {
      _dashboardData = await DummyData.getDashboardData(
        filter: _selectedFilter,
      );
    } catch (_) {
      _errorMessage = 'Unable to load dashboard data. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setFilter(String filter) async {
    if (_selectedFilter == filter) return;
    await loadDashboard(filter: filter);
  }
}

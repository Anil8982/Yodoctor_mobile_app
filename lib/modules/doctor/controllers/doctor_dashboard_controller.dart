import 'package:flutter/foundation.dart';
import '../../../core/utils/dummy_data.dart';

class DoctorDashboardController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  DoctorDashboardData? _dashboardData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DoctorDashboardData? get dashboardData => _dashboardData;

  DoctorDashboardController() {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboardData = await DummyData.getDoctorDashboardData();
    } catch (_) {
      _errorMessage = 'Unable to load doctor dashboard. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAvailability(bool available) async {
    if (_dashboardData == null) return;
    
    // Optimistic UI update
    _dashboardData = _dashboardData!.copyWith(isAvailable: available);
    notifyListeners();

    try {
      await DummyData.toggleDoctorAvailability(available);
      // Ensure sync
      _dashboardData = await DummyData.getDoctorDashboardData();
    } catch (_) {
      // Revert if error
      _dashboardData = _doctorDashboardDataRevert(available);
      _errorMessage = 'Failed to update availability status.';
    } finally {
      notifyListeners();
    }
  }

  DoctorDashboardData _doctorDashboardDataRevert(bool attempted) {
    return _dashboardData!.copyWith(isAvailable: !attempted);
  }
}

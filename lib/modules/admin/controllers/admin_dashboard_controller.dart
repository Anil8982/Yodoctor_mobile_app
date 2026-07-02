import 'package:flutter/foundation.dart';
import 'package:yodoctor/core/models/admin_dashboard_data.dart';

import '../../../core/utils/dummy_data.dart';

class AdminDashboardController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  AdminDashboardData? _dashboardData;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  AdminDashboardData? get dashboardData =>
      _dashboardData;

  AdminDashboardController() {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboardData =
          await DummyData.getAdminDashboardData();
    } catch (_) {
      _errorMessage =
          'Unable to load admin dashboard.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboard();
  }
}
import 'package:flutter/foundation.dart';

import '../models/dashboard/dashboard_model.dart';
import '../../../services/patient_dashboard_service.dart';

class PatientDashboardController extends ChangeNotifier {
  static const List<String> availableFilters = ["All", "Today", "Next 7 Days"];

  final PatientDashboardService _service = PatientDashboardService();

  bool _isLoading = false;
  String? _errorMessage;
  DashboardModel? _dashboardData;

  String _selectedFilter = "All";

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  DashboardModel? get dashboardData => _dashboardData;

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
      final response = await _service.getDashboard();
      print("========== DASHBOARD ==========");
      print(response.statusCode);
      print(response.data);

      if (response.statusCode == 200) {
        _dashboardData = DashboardModel.fromJson(response.data);
        print("Patient Name : ${_dashboardData?.patientName}");
        print("Appointments : ${_dashboardData?.appointments.length}");
      } else {
        _errorMessage = response.data["message"] ?? "Unable to load dashboard";
      }
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);

      _errorMessage = "Unable to load dashboard";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> cancelAppointment(int appointmentId) async {
    try {
      final response = await _service.cancelAppointment(appointmentId);

      if (response.statusCode == 200 && response.data["success"] == true) {
        // Dashboard Refresh
        await loadDashboard(filter: _selectedFilter);

        return true;
      }

      _errorMessage =
          response.data["message"] ?? "Unable to cancel appointment";

      notifyListeners();

      return false;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);

      _errorMessage = "Unable to cancel appointment";

      notifyListeners();

      return false;
    }
  }

  Future<void> refreshTokenStatus() async {
    if (_dashboardData?.todayToken == null) return;

    try {
      final response = await _service.getTokenStatus(
        _dashboardData!.todayToken!.appointmentId,
      );

      if (response.statusCode == 200) {
        final token = _dashboardData!.todayToken!;

        _dashboardData = DashboardModel(
          patient: _dashboardData!.patient,
          patientName: _dashboardData!.patientName,
          upcomingCount: _dashboardData!.upcomingCount,
          appointments: _dashboardData!.appointments,
          todayToken: token.copyWith(
            nowServing: response.data["nowServing"],
            patientsAhead: response.data["patientsAhead"],
            estimatedTime:
                response.data["estimatedTime"] ??
                "${response.data["estimatedWaitMinutes"]} mins",
          ),
        );

        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setFilter(String filter) async {
    if (_selectedFilter == filter) return;

    await loadDashboard(filter: filter);
  }
}

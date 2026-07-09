import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/dashboard/dashboard_model.dart';
import '../repositories/patient_dashboard_repository.dart';

final patientDashboardControllerProvider =
ChangeNotifierProvider.autoDispose<PatientDashboardController>(
      (ref) => PatientDashboardController(ref),
);

class PatientDashboardController extends ChangeNotifier {
  PatientDashboardController(this._ref) {
    loadDashboard();
  }

  final Ref _ref;
  static const List<String> availableFilters = ["All", "Today", "Next 7 Days"];
  static const String _subTag = 'PatientDashboardController';

  bool _isLoading = false;
  String? _errorMessage;
  DashboardModel? _dashboardData;
  String _selectedFilter = "All";

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardModel? get dashboardData => _dashboardData;
  String get selectedFilter => _selectedFilter;

  Future<void> loadDashboard({String? filter}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (filter != null) {
      _selectedFilter = filter;
    }

    // 🎯 Fix #2: Simplified production logger string
    AppLogger.info(
      'Loading dashboard',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    try {
      final repository = _ref.read(patientDashboardRepositoryProvider);
      final response = await repository.getDashboard();

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          AppLogger.json(
            response.data as Map<String, dynamic>,
            tag: LogTags.api,
            subTag: _subTag,
          );
        }
        _dashboardData = DashboardModel.fromJson(response.data);
      } else {
        _errorMessage = response.data["message"] ?? "Unable to load dashboard";
        AppLogger.warning(
          'Failed to load dashboard: $_errorMessage',
          tag: LogTags.patient,
          subTag: _subTag,
        );
      }
    } catch (e, stackTrace) {
      _errorMessage = "Unable to load dashboard";
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Failed to load dashboard',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> cancelAppointment(int appointmentId) async {
    AppLogger.info(
      'Cancelling appointment ID: $appointmentId',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    try {
      final repository = _ref.read(patientDashboardRepositoryProvider);
      final response = await repository.cancelAppointment(appointmentId);

      if (response.statusCode == 200 && response.data["success"] == true) {
        AppLogger.success(
          'Appointment cancelled successfully',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        await loadDashboard(filter: _selectedFilter);
        return true;
      }

      _errorMessage = response.data["message"] ?? "Unable to cancel appointment";
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _errorMessage = "Unable to cancel appointment";
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Failed to cancel appointment',
        tag: LogTags.patient,
        subTag: _subTag,
      );
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshTokenStatus() async {
    if (_dashboardData?.todayToken == null) return;

    AppLogger.info(
      'Refreshing token status',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    try {
      final repository = _ref.read(patientDashboardRepositoryProvider);
      final response = await repository.getTokenStatus(
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
            estimatedTime: response.data["estimatedTime"] ?? "${response.data["estimatedWaitMinutes"]} mins",
          ),
        );
        notifyListeners();
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed to refresh token status',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> setFilter(String filter) async {
    if (_selectedFilter == filter) return;
    await loadDashboard(filter: filter);
  }
}
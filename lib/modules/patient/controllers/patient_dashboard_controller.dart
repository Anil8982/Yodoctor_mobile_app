import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
import '../models/dashboard/dashboard_model.dart';
import '../repositories/patient_dashboard_repository.dart';

class PatientDashboardState {
  const PatientDashboardState({
    this.isLoading = false,
    this.isRefreshingToken = false,
    this.errorMessage,
    this.dashboardData,
    this.selectedFilter = "All",
  });

  final bool isLoading;
  final bool isRefreshingToken;
  final String? errorMessage;
  final DashboardModel? dashboardData;
  final String selectedFilter;

  PatientDashboardState copyWith({
    bool? isLoading,
    bool? isRefreshingToken,
    String? errorMessage,
    DashboardModel? dashboardData,
    String? selectedFilter,
    bool clearError = false,
  }) {
    return PatientDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshingToken: isRefreshingToken ?? this.isRefreshingToken,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      dashboardData: dashboardData ?? this.dashboardData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

final patientDashboardControllerProvider =
    NotifierProvider.autoDispose<
      PatientDashboardController,
      PatientDashboardState
    >(PatientDashboardController.new);

class PatientDashboardController extends Notifier<PatientDashboardState> {
  static const List<String> availableFilters = ["All", "Today", "Next 7 Days"];
  static const String _subTag = 'PatientDashboardController';

  PatientDashboardRepository get _repo =>
      ref.read(patientDashboardRepositoryProvider);

  @override
  PatientDashboardState build() {
    Future.microtask(_loadDashboard);
    return const PatientDashboardState();
  }

  Future<void> loadDashboard({String? filter}) =>
      _loadDashboard(filter: filter);

  Future<bool> cancelAppointment(int appointmentId) =>
      _cancelAppointment(appointmentId);

  Future<void> refreshTokenStatus() => _refreshTokenStatus();

  Future<void> setFilter(String filter) async {
    if (state.selectedFilter == filter) return;
    await _loadDashboard(filter: filter);
  }

  Future<void> _loadDashboard({String? filter}) async {
    _setLoading(error: true);

    DebugLog.info('Loading dashboard', tag: LogTags.patient, subTag: _subTag);

    try {
      final response = await _repo.getDashboard();

      if (_isSuccess(response.statusCode)) {
        if (response.data is Map<String, dynamic>) {
          DebugLog.info('Dashboard data received', tag: LogTags.api, subTag: _subTag, json: response.data);
        }
        state = state.copyWith(
          isLoading: false,
          dashboardData: DashboardModel.fromJson(response.data),
          selectedFilter: filter ?? state.selectedFilter,
        );
      } else {
        final msg = response.data["message"] ?? "Unable to load dashboard";
        _handleError(msg, 'Failed to load dashboard');
      }
    } catch (e, st) {
      _handleException(e, st, 'Failed to load dashboard');
    }
  }

  Future<bool> _cancelAppointment(int appointmentId) async {
    DebugLog.info(
      'Cancelling $appointmentId',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    try {
      final response = await _repo.cancelAppointment(appointmentId);

      if (_isSuccess(response.statusCode) && response.data["success"] == true) {
        DebugLog.success('Cancelled', tag: LogTags.patient, subTag: _subTag);
        await _loadDashboard(filter: state.selectedFilter);
        return true;
      }

      final msg = response.data["message"] ?? "Unable to cancel appointment";
      state = state.copyWith(errorMessage: msg);
      return false;
    } catch (e, st) {
      _handleException(
        e,
        st,
        'Failed to cancel appointment',
        userErrorMessage: 'Unable to cancel appointment',
      );
      return false;
    }
  }

  Future<void> _refreshTokenStatus() async {
    final token = state.dashboardData?.todayToken;
    if (token == null || state.isRefreshingToken) return;

    state = state.copyWith(isRefreshingToken: true);

    DebugLog.info('Refreshing token', tag: LogTags.patient, subTag: _subTag);

    try {
      final response = await _repo.getTokenStatus(token.appointmentId);

      if (_isSuccess(response.statusCode)) {
        final updatedDashboard = DashboardModel(
          patient: state.dashboardData!.patient,
          patientName: state.dashboardData!.patientName,
          upcomingCount: state.dashboardData!.upcomingCount,
          appointments: state.dashboardData!.appointments,
          todayToken: token.copyWith(
            nowServing: response.data["nowServing"],
            patientsAhead: response.data["patientsAhead"],
            estimatedTime:
                response.data["estimatedTime"] ??
                "${response.data["estimatedWaitMinutes"]} mins",
          ),
        );
        state = state.copyWith(dashboardData: updatedDashboard);
      }
    } catch (e, st) {
      DebugLog.error(
        'Failed to refresh token status',
        error: e,
        stackTrace: st,
        tag: LogTags.patient,
        subTag: _subTag,
      );
    } finally {
      state = state.copyWith(isRefreshingToken: false);
    }
  }

  void _setLoading({bool error = false}) {
    state = state.copyWith(isLoading: true, clearError: error);
  }

  void _handleError(String message, String logMessage) {
    DebugLog.warning(
      '$logMessage: $message',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    state = state.copyWith(isLoading: false, errorMessage: message);
  }

  void _handleException(
    Object e,
    StackTrace st,
    String logMessage, {
    String? userErrorMessage,
  }) {
    DebugLog.error(
      logMessage,
      error: e,
      stackTrace: st,
      tag: LogTags.patient,
      subTag: _subTag,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: userErrorMessage ?? "Unable to load dashboard",
    );
  }

  bool _isSuccess(int? code) => code != null && code >= 200 && code < 300;
}

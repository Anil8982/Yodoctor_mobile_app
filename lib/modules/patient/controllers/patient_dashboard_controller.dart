import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
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
NotifierProvider.autoDispose<PatientDashboardController, PatientDashboardState>(
  PatientDashboardController.new,
);

class PatientDashboardController extends Notifier<PatientDashboardState> {
  static const List<String> availableFilters = ["All", "Today", "Next 7 Days"];
  static const String _subTag = 'PatientDashboardController';

  @override
  PatientDashboardState build() {
    Future.microtask(() => loadDashboard());
    return const PatientDashboardState();
  }

  Future<void> loadDashboard({String? filter}) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      selectedFilter: filter ?? state.selectedFilter,
    );

    AppLogger.info(
      'Loading dashboard',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(patientDashboardRepositoryProvider);
      final response = await repository.getDashboard();

      final statusCode = response.statusCode;

      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        if (response.data is Map<String, dynamic>) {
          AppLogger.json(
            response.data as Map<String, dynamic>,
            tag: LogTags.api,
            subTag: _subTag,
          );
        }
        final dashboardData = DashboardModel.fromJson(response.data);
        state = state.copyWith(
          isLoading: false,
          dashboardData: dashboardData,
        );
      } else {
        final errorMsg = response.data["message"] ?? "Unable to load dashboard";
        AppLogger.warning(
          'Failed to load dashboard: $errorMsg',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMsg,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Failed to load dashboard',
        tag: LogTags.patient,
        subTag: _subTag,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Unable to load dashboard",
      );
    }
  }

  Future<bool> cancelAppointment(int appointmentId) async {
    AppLogger.info(
      'Cancelling appointment ID: $appointmentId',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(patientDashboardRepositoryProvider);
      final response = await repository.cancelAppointment(appointmentId);

      final statusCode = response.statusCode;

      if (statusCode != null && statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        AppLogger.success(
          'Appointment cancelled successfully',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        await loadDashboard(filter: state.selectedFilter);
        return true;
      }

      final errorMsg = response.data["message"] ?? "Unable to cancel appointment";
      state = state.copyWith(errorMessage: errorMsg);
      return false;
    } catch (e, stackTrace) {
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Failed to cancel appointment',
        tag: LogTags.patient,
        subTag: _subTag,
      );
      state = state.copyWith(errorMessage: "Unable to cancel appointment");
      return false;
    }
  }

  Future<void> refreshTokenStatus() async {
    if (state.dashboardData?.todayToken == null) return;
    if (state.isRefreshingToken) return;

    state = state.copyWith(isRefreshingToken: true);

    AppLogger.info(
      'Refreshing token status',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(patientDashboardRepositoryProvider);
      final response = await repository.getTokenStatus(
        state.dashboardData!.todayToken!.appointmentId,
      );

      final statusCode = response.statusCode;

      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        final token = state.dashboardData!.todayToken!;
        final updatedDashboard = DashboardModel(
          patient: state.dashboardData!.patient,
          patientName: state.dashboardData!.patientName,
          upcomingCount: state.dashboardData!.upcomingCount,
          appointments: state.dashboardData!.appointments,
          todayToken: token.copyWith(
            nowServing: response.data["nowServing"],
            patientsAhead: response.data["patientsAhead"],
            estimatedTime: response.data["estimatedTime"] ?? "${response.data["estimatedWaitMinutes"]} mins",
          ),
        );
        state = state.copyWith(dashboardData: updatedDashboard);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed to refresh token status',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    } finally {
      state = state.copyWith(isRefreshingToken: false);
    }
  }

  Future<void> setFilter(String filter) async {
    if (state.selectedFilter == filter) return;
    await loadDashboard(filter: filter);
  }
}
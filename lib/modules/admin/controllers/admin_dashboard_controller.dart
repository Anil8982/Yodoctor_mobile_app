import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/admin/admin_dashboard_data.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';

class AdminDashboardState {
  final AdminDashboardData? rawData;
  final DateTime fromDate;
  final DateTime toDate;
  final List<PatientAppointment> filteredAppointments;
  final bool filterApplied;

  AdminDashboardState({
    this.rawData,
    required this.fromDate,
    required this.toDate,
    required this.filteredAppointments,
    required this.filterApplied,
  });

  AdminDashboardState copyWith({
    AdminDashboardData? rawData,
    DateTime? fromDate,
    DateTime? toDate,
    List<PatientAppointment>? filteredAppointments,
    bool? filterApplied,
  }) {
    return AdminDashboardState(
      rawData: rawData ?? this.rawData,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      filterApplied: filterApplied ?? this.filterApplied,
    );
  }
}

class AdminDashboardNotifier extends AsyncNotifier<AdminDashboardState> {
  @override
  Future<AdminDashboardState> build() async {
    final data = await DummyData.getAdminDashboardData();
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    return AdminDashboardState(
      rawData: data,
      fromDate: firstDayOfMonth,
      toDate: now,
      filteredAppointments: [],
      filterApplied: false,
    );
  }

  void updateDates({DateTime? from, DateTime? to}) {
    final previousState = state;
    if (!previousState.hasValue) return;

    state = AsyncValue.data(previousState.value!.copyWith(
      fromDate: from ?? previousState.value!.fromDate,
      toDate: to ?? previousState.value!.toDate,
      filterApplied: false,
      filteredAppointments: [],
    ));
  }

  void applyDateFilter() {
    final previousState = state;
    if (!previousState.hasValue || previousState.value!.rawData == null) return;

    final current = previousState.value!;
    final allAppointments = current.rawData!.appointments;
    final start = DateTime(current.fromDate.year, current.fromDate.month, current.fromDate.day);
    final end = DateTime(current.toDate.year, current.toDate.month, current.toDate.day, 23, 59, 59);

    final filtered = allAppointments.where((appointment) {
      final date = appointment.dateTime;
      return !date.isBefore(start) && !date.isAfter(end);
    }).toList();

    state = AsyncValue.data(current.copyWith(
      filteredAppointments: filtered,
      filterApplied: true,
    ));
  }

  void resetAnalytics() {
    final previousState = state;
    if (!previousState.hasValue) return;

    final now = DateTime.now();
    state = AsyncValue.data(previousState.value!.copyWith(
      fromDate: DateTime(now.year, now.month, 1),
      toDate: now,
      filterApplied: false,
      filteredAppointments: [],
    ));
  }

  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final data = await DummyData.getAdminDashboardData();
      final now = DateTime.now();
      return AdminDashboardState(
        rawData: data,
        fromDate: DateTime(now.year, now.month, 1),
        toDate: now,
        filteredAppointments: [],
        filterApplied: false,
      );
    });
  }
}

final adminDashboardProvider = AsyncNotifierProvider.autoDispose<AdminDashboardNotifier, AdminDashboardState>(
  AdminDashboardNotifier.new,
);
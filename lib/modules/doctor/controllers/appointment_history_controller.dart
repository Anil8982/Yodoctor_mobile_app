import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/appointment_history_item.dart';
import '../../../services/appointment_service.dart';

enum DoctorAppointmentFilter { today, lastSevenDays, all }

class AppointmentHistoryState {
  final bool isLoading;
  final List<AppointmentHistoryItem> allAppointments;
  final DoctorAppointmentFilter selectedFilter;
  final String searchQuery;

  const AppointmentHistoryState({
    this.isLoading = false,
    this.allAppointments = const [],
    this.selectedFilter = DoctorAppointmentFilter.all,
    this.searchQuery = '',
  });

  AppointmentHistoryState copyWith({
    bool? isLoading,
    List<AppointmentHistoryItem>? allAppointments,
    DoctorAppointmentFilter? selectedFilter,
    String? searchQuery,
  }) {
    return AppointmentHistoryState(
      isLoading: isLoading ?? this.isLoading,
      allAppointments: allAppointments ?? this.allAppointments,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AppointmentHistoryNotifier extends Notifier<AppointmentHistoryState> {
  final AppointmentService _service = AppointmentService();

  @override
  AppointmentHistoryState build() {
    return const AppointmentHistoryState();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true);

    try {
      String? filter;

      switch (state.selectedFilter) {
        case DoctorAppointmentFilter.today:
          filter = "today";
          break;

        case DoctorAppointmentFilter.lastSevenDays:
          filter = "last7";
          break;

        case DoctorAppointmentFilter.all:
          filter = null;
          break;
      }

      final response = await _service.getHistory(filter: filter);

      final List data = response.data["appointments"];

      final appointments = data.map((e) {
        final patient =
            e["patientName"] ??
            e["familyMemberName"] ??
            e["walk_in_patient_name"] ??
            "Unknown";

        return AppointmentHistoryItem(
          id: e["id"].toString(),
          doctorName: "",
          specialty: "",
          patientLabel: patient,
          date: DateTime.parse(e["appointment_date"]),
          shift: e["appointment_slot"] ?? "",
          tokenNumber: e["token_number"] ?? "",
          status: e["status"] ?? "",
        );
      }).toList();

      state = state.copyWith(isLoading: false, allAppointments: appointments);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setFilter(DoctorAppointmentFilter filter) async {
    state = state.copyWith(selectedFilter: filter);

    await loadHistory();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  List<AppointmentHistoryItem> getFilteredHistory() {
    final query = state.searchQuery.toLowerCase();

    return state.allAppointments.where((item) {
      return query.isEmpty ||
          item.patientLabel.toLowerCase().contains(query) ||
          item.tokenNumber.toLowerCase().contains(query) ||
          item.status.toLowerCase().contains(query);
    }).toList();
  }
}

final appointmentHistoryProvider =
    NotifierProvider<AppointmentHistoryNotifier, AppointmentHistoryState>(
      AppointmentHistoryNotifier.new,
    );

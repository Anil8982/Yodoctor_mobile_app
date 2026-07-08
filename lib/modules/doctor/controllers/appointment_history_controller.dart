import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../../core/utils/dummy_data.dart';

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
    AppLogger.info('Initializing appointment history matrix with dummy records', tag: LogTags.doctor, subTag: _subTag);
    return AppointmentHistoryState(
      allAppointments: List.from(DummyData.appointmentHistory),
    );
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

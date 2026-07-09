import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../../core/models/appointment_history_item.dart';
import '../repositories/doctor_appointment_repository.dart';

enum DoctorAppointmentFilter { today, lastSevenDays, all }

class AppointmentHistoryState {
  final bool isLoading;
  final List<AppointmentHistoryItem> allAppointments;
  final DoctorAppointmentFilter selectedFilter;
  final String searchQuery;
  final String? errorMessage;

  const AppointmentHistoryState({
    this.isLoading = false,
    this.allAppointments = const [],
    this.selectedFilter = DoctorAppointmentFilter.all,
    this.searchQuery = '',
    this.errorMessage,
  });

  AppointmentHistoryState copyWith({
    bool? isLoading,
    List<AppointmentHistoryItem>? allAppointments,
    DoctorAppointmentFilter? selectedFilter,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppointmentHistoryState(
      isLoading: isLoading ?? this.isLoading,
      allAppointments: allAppointments ?? this.allAppointments,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final appointmentHistoryProvider =
NotifierProvider<AppointmentHistoryNotifier, AppointmentHistoryState>(
  AppointmentHistoryNotifier.new,
);

class AppointmentHistoryNotifier extends Notifier<AppointmentHistoryState> {
  static const String _subTag = 'AppointmentHistoryNotifier';

  @override
  AppointmentHistoryState build() {
    AppLogger.info('AppointmentHistoryNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    return const AppointmentHistoryState();
  }

  Future<void> loadHistory() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);

    AppLogger.info('Fetching doctor appointment history for filter: ${state.selectedFilter.name}', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);

      String? filterQuery;
      if (state.selectedFilter == DoctorAppointmentFilter.today) filterQuery = 'today';
      if (state.selectedFilter == DoctorAppointmentFilter.lastSevenDays) filterQuery = '7days';

      final response = await repository.getHistory(filter: filterQuery);
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final rawList = response.data["appointments"] as List? ?? [];
        final parsedList = rawList.map((e) => AppointmentHistoryItem.fromJson(e)).toList();

        AppLogger.success('Doctor appointment history fetched successfully. Count: ${parsedList.length}', tag: LogTags.doctor, subTag: _subTag);
        AppLogger.json(response.data, tag: LogTags.doctor, subTag: '$_subTag/HistoryData');

        state = state.copyWith(allAppointments: parsedList, isLoading: false);
      } else {
        final msg = response.data["message"] ?? "Failed to load appointment history";
        state = state.copyWith(errorMessage: msg, isLoading: false);
        AppLogger.warning('Failed to fetch appointment history: $msg', tag: LogTags.doctor, subTag: _subTag);
      }
    } catch (e, st) {
      state = state.copyWith(errorMessage: "Failed to load appointment history", isLoading: false);
      AppLogger.exception(e, st, message: 'Appointment history request crash', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  Future<void> setFilter(DoctorAppointmentFilter filter) async {
    AppLogger.info('Changing filter to: ${filter.name}', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(selectedFilter: filter);
    await loadHistory();
  }

  void setSearchQuery(String query) {
    AppLogger.info('Updating search query: $query', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(searchQuery: query);
  }

  List<AppointmentHistoryItem> getFilteredHistory() {
    final query = state.searchQuery.toLowerCase().trim();
    if (query.isEmpty) return state.allAppointments;

    final filtered = state.allAppointments.where((item) {
      return item.patientLabel.toLowerCase().contains(query) ||
          item.tokenNumber.toLowerCase().contains(query) ||
          item.status.toLowerCase().contains(query);
    }).toList();

    AppLogger.info('Filtered appointment list local lookup count: ${filtered.length}', tag: LogTags.doctor, subTag: _subTag);
    return filtered;
  }
}
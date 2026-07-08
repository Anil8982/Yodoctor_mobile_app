import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../../core/utils/dummy_data.dart';

enum DoctorAppointmentFilter { today, lastSevenDays, all }

class AppointmentHistoryState {
  final List<AppointmentHistoryItem> allAppointments;
  final DoctorAppointmentFilter selectedFilter;
  final String searchQuery;

  AppointmentHistoryState({
    required this.allAppointments,
    this.selectedFilter = DoctorAppointmentFilter.all,
    this.searchQuery = '',
  });

  AppointmentHistoryState copyWith({
    List<AppointmentHistoryItem>? allAppointments,
    DoctorAppointmentFilter? selectedFilter,
    String? searchQuery,
  }) {
    return AppointmentHistoryState(
      allAppointments: allAppointments ?? this.allAppointments,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AppointmentHistoryNotifier extends Notifier<AppointmentHistoryState> {
  // Single source of truth for the subTag in this doctor panel domain
  static const String _subTag = 'AppointmentHistoryNotifier';

  @override
  AppointmentHistoryState build() {
    AppLogger.info('Initializing appointment history matrix with dummy records', tag: LogTags.doctor, subTag: _subTag);
    return AppointmentHistoryState(
      allAppointments: List.from(DummyData.appointmentHistory),
    );
  }

  void setFilter(DoctorAppointmentFilter filter) {
    AppLogger.debug('Filter scope updated to: ${filter.name}', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(selectedFilter: filter);
  }

  void setSearchQuery(String query) {
    AppLogger.debug('Executing patient search parameters query: "$query"', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(searchQuery: query);
  }

  List<AppointmentHistoryItem> getTodayLiveQueue() {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    return state.allAppointments.where((appointment) {
      final appDateStr = DateFormat('yyyy-MM-dd').format(appointment.date);
      return appDateStr == todayStr;
    }).toList();
  }

  List<AppointmentHistoryItem> getFilteredHistory() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final query = state.searchQuery.trim().toLowerCase();

    return state.allAppointments.where((appointment) {
      final appointmentDay = DateTime(
        appointment.date.year,
        appointment.date.month,
        appointment.date.day,
      );

      final matchesDate = switch (state.selectedFilter) {
        DoctorAppointmentFilter.today => appointmentDay == today,
        DoctorAppointmentFilter.lastSevenDays =>
        !appointmentDay.isBefore(today.subtract(const Duration(days: 7))) && !appointmentDay.isAfter(today),
        DoctorAppointmentFilter.all => true,
      };

      final matchesSearch = query.isEmpty ||
          appointment.patientLabel.toLowerCase().contains(query) ||
          appointment.tokenNumber.toLowerCase().contains(query) ||
          appointment.status.toLowerCase().contains(query);

      return matchesDate && matchesSearch;
    }).toList();
  }

  void completePatient(String tokenNumber) {
    AppLogger.success('Patient status updated to COMPLETED. Token: $tokenNumber', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(
      allAppointments: [
        for (final app in state.allAppointments)
          if (app.tokenNumber == tokenNumber) _updateStatus(app, 'COMPLETED') else app
      ],
    );
  }

  void skipPatient(String tokenNumber) {
    AppLogger.warning('Patient token: $tokenNumber has been marked as SKIPPED', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(
      allAppointments: [
        for (final app in state.allAppointments)
          if (app.tokenNumber == tokenNumber) _updateStatus(app, 'SKIPPED') else app
      ],
    );
  }

  void cancelPatient(String tokenNumber) {
    AppLogger.warning('Appointment token: $tokenNumber has been officially CANCELLED', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(
      allAppointments: [
        for (final app in state.allAppointments)
          if (app.tokenNumber == tokenNumber) _updateStatus(app, 'CANCELLED') else app
      ],
    );
  }

  AppointmentHistoryItem _updateStatus(AppointmentHistoryItem item, String newStatus) {
    return AppointmentHistoryItem(
      id: item.id,
      doctorName: item.doctorName,
      specialty: item.specialty,
      patientLabel: item.patientLabel,
      date: item.date,
      shift: item.shift,
      status: newStatus,
      tokenNumber: item.tokenNumber,
    );
  }
}

final appointmentHistoryProvider = NotifierProvider<AppointmentHistoryNotifier, AppointmentHistoryState>(
  AppointmentHistoryNotifier.new,
);
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../core/models/doctor/incoming_appointment_model.dart';
import '../repositories/doctor_appointment_repository.dart';

class IncomingAppointmentState {
  final bool loading;
  final List<IncomingAppointmentModel> appointments;
  final String? errorMessage;

  const IncomingAppointmentState({
    this.loading = false,
    this.appointments = const [],
    this.errorMessage,
  });

  IncomingAppointmentState copyWith({
    bool? loading,
    List<IncomingAppointmentModel>? appointments,
    String? errorMessage,
    bool clearError = false,
  }) {
    return IncomingAppointmentState(
      loading: loading ?? this.loading,
      appointments: appointments ?? this.appointments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final incomingAppointmentProvider =
NotifierProvider<IncomingAppointmentNotifier, IncomingAppointmentState>(
  IncomingAppointmentNotifier.new,
);

class IncomingAppointmentNotifier extends Notifier<IncomingAppointmentState> {
  static const String _subTag = 'IncomingAppointmentNotifier';

  @override
  IncomingAppointmentState build() {
    AppLogger.info('IncomingAppointmentNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    Future.microtask(loadAppointments);
    return const IncomingAppointmentState();
  }

  Future<void> loadAppointments() async {
    if (state.loading) return;
    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info('Fetching live incoming appointment streams...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.getIncomingAppointments();
      final statusCode = res.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final rawList = res.data["appointments"] as List? ?? [];
        final list = rawList.map((e) => IncomingAppointmentModel.fromJson(e)).toList();

        AppLogger.success('Incoming appointments synchronized successfully. Count: ${list.length}', tag: LogTags.doctor, subTag: _subTag);
        AppLogger.json(res.data, tag: LogTags.doctor, subTag: '$_subTag/AppointmentsData');

        state = state.copyWith(loading: false, appointments: list);
      } else {
        final msg = res.data["message"] ?? "Failed to extract requests feed";
        AppLogger.warning('Failed to load incoming appointments: $msg', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false, errorMessage: msg);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load requests");
      AppLogger.exception(e, st, message: 'Incoming processing stream exception', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  Future<bool> accept(String id) async {
    AppLogger.info('Accepting appointment ID: $id', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.respondAppointment(id, "ACCEPT");

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        AppLogger.success('Appointment ID: $id accepted successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadAppointments();
        return true;
      }
      AppLogger.warning('Failed to accept appointment ID: $id. Status: ${res.statusCode}', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Accept request exception', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<bool> reject(String id) async {
    AppLogger.info('Rejecting appointment ID: $id', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.respondAppointment(id, "REJECT");

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        AppLogger.success('Appointment ID: $id rejected successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadAppointments();
        return true;
      }
      AppLogger.warning('Failed to reject appointment ID: $id. Status: ${res.statusCode}', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Reject request exception', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<bool> autoAcceptAll() async {
    AppLogger.info('Triggering auto-accept for all incoming appointments', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.autoAcceptAllAppointments();

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        AppLogger.success('All incoming appointments auto-accepted successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadAppointments();
        return true;
      }
      AppLogger.warning('Auto-accept all operation failed on backend. Status: ${res.statusCode}', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Auto accept request exception', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }
}
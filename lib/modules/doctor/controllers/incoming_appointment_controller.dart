import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
import '../../patient/models/appointment/incoming_appointment_model.dart';
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
    DebugLog.info('IncomingAppointmentNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    Future.microtask(loadAppointments);
    return const IncomingAppointmentState();
  }

  Future<void> loadAppointments() async {
    if (state.loading) return;
    state = state.copyWith(loading: true, clearError: true);
    DebugLog.info('Fetching live incoming appointment streams...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.getIncomingAppointments();
      final statusCode = res.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final rawList = res.data["appointments"] as List? ?? [];
        final list = rawList.map((e) => IncomingAppointmentModel.fromJson(e)).toList();

        DebugLog.success('Incoming appointments synchronized successfully. Count: ${list.length}', tag: LogTags.doctor, subTag: _subTag, json: res.data);


        state = state.copyWith(loading: false, appointments: list);
      } else {
        final msg = res.data["message"] ?? "Failed to extract requests feed";
        DebugLog.warning('Failed to load incoming appointments: $msg', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false, errorMessage: msg);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load requests");
      DebugLog.error('Incoming processing stream exception', error: e, stackTrace: st, tag: LogTags.doctor, subTag: _subTag);
    }
  }

  Future<bool> accept(String id) async {
    DebugLog.info('Accepting appointment ID: $id', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.respondAppointment(id, "ACCEPT");

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        DebugLog.success('Appointment ID: $id accepted successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadAppointments();
        return true;
      }
      DebugLog.warning('Failed to accept appointment ID: $id. Status: ${res.statusCode}', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      DebugLog.error('Accept request exception', error: e, stackTrace: st, tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<bool> reject(String id) async {
    DebugLog.info('Rejecting appointment ID: $id', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.respondAppointment(id, "REJECT");

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        DebugLog.success('Appointment ID: $id rejected successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadAppointments();
        return true;
      }
      DebugLog.warning('Failed to reject appointment ID: $id. Status: ${res.statusCode}', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      DebugLog.error('Reject request exception', error: e, stackTrace: st, tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<bool> autoAcceptAll() async {
    DebugLog.info('Triggering auto-accept for all incoming appointments', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.autoAcceptAllAppointments();

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        DebugLog.success('All incoming appointments auto-accepted successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadAppointments();
        return true;
      }
      DebugLog.warning('Auto-accept all operation failed on backend. Status: ${res.statusCode}', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      DebugLog.error('Auto accept request exception', error: e, stackTrace: st, tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }
}
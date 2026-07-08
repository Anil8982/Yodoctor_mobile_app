import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/appointment_service.dart';
import '../../../core/models/doctor/incoming_appointment_model.dart';

class IncomingAppointmentState {
  final bool loading;
  final List<IncomingAppointmentModel> appointments;

  const IncomingAppointmentState({
    this.loading = false,
    this.appointments = const [],
  });

  IncomingAppointmentState copyWith({
    bool? loading,
    List<IncomingAppointmentModel>? appointments,
  }) {
    return IncomingAppointmentState(
      loading: loading ?? this.loading,
      appointments: appointments ?? this.appointments,
    );
  }
}

class IncomingAppointmentNotifier extends Notifier<IncomingAppointmentState> {
  final AppointmentService _service = AppointmentService();

  @override
  IncomingAppointmentState build() {
    Future.microtask(loadAppointments);

    return const IncomingAppointmentState();
  }

  Future<void> loadAppointments() async {
    state = state.copyWith(loading: true);

    try {
      final res = await _service.getIncomingAppointments();

      final appointments = (res.data["appointments"] as List)
          .map((e) => IncomingAppointmentModel.fromJson(e))
          .toList();

      state = state.copyWith(loading: false, appointments: appointments);
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> accept(String id) async {
    await _service.respondAppointment(id, "ACCEPT");

    await loadAppointments();
  }

  Future<void> reject(String id) async {
    await _service.respondAppointment(id, "REJECT");

    await loadAppointments();
  }

  Future<void> autoAcceptAll() async {
    await _service.autoAcceptAllAppointments();

    await loadAppointments();
  }
}

final incomingAppointmentProvider =
    NotifierProvider<IncomingAppointmentNotifier, IncomingAppointmentState>(
      IncomingAppointmentNotifier.new,
    );

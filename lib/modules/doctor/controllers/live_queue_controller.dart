import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/doctor/prescription_model.dart';
import '../../../services/appointment_service.dart';
import '../../../core/models/doctor/live_queue_model.dart';

class LiveQueueState {
  final bool loading;
  final List<LiveQueueItem> queue;
  final LiveQueueItem? current;
  final LiveQueueItem? next;

  const LiveQueueState({
    this.loading = false,
    this.queue = const [],
    this.current,
    this.next,
  });

  LiveQueueState copyWith({
    bool? loading,
    List<LiveQueueItem>? queue,
    LiveQueueItem? current,
    LiveQueueItem? next,
  }) {
    return LiveQueueState(
      loading: loading ?? this.loading,
      queue: queue ?? this.queue,
      current: current ?? this.current,
      next: next ?? this.next,
    );
  }
}

class LiveQueueNotifier extends Notifier<LiveQueueState> {
  final AppointmentService _service = AppointmentService();

  @override
  LiveQueueState build() {
    Future.microtask(() => loadQueue("MORNING"));
    return const LiveQueueState();
  }

  Future<void> loadQueue(String slot) async {
    state = state.copyWith(loading: true);

    try {
      final queueRes = await _service.getTodayQueue(slot: slot);
      final currentRes = await _service.getCurrentPatient(slot: slot);
      final nextRes = await _service.getNextPatient(slot: slot);

      final queue = (queueRes.data["queue"] as List)
          .map((e) => LiveQueueItem.fromJson(e))
          .toList();

      LiveQueueItem? current;
      LiveQueueItem? next;

      if (currentRes.data["active"] == true) {
        current = LiveQueueItem.fromJson(currentRes.data["appointment"]);
      }

      if (nextRes.statusCode == 200 && nextRes.data["appointment"] != null) {
        next = LiveQueueItem.fromJson(nextRes.data["appointment"]);
      }

      state = state.copyWith(
        loading: false,
        queue: queue,
        current: current,
        next: next,
      );
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> complete(String id, String slot) async {
    await _service.completeAppointment(id);
    await loadQueue(slot);
  }

  Future<void> recall(String id, String slot) async {
    await _service.recallPatient(id);
    await loadQueue(slot);
  }

  Future<void> noShow(String slot) async {
    await _service.noShow(slot);
    await loadQueue(slot);
  }

  Future<void> skip(String id, String slot) async {
    await _service.skipAppointment(id);
    await loadQueue(slot);
  }

  Future<void> start(String id, String slot) async {
    await _service.startAppointment(appointmentId: id, slot: slot);

    await loadQueue(slot);
  }

  Future<void> nextToken(String slot) async {
    await _service.callNextToken(slot: slot);
    await loadQueue(slot);
  }

  Future<PrescriptionModel?> getPrescription(String appointmentId) async {
    final res = await _service.getPrescription(appointmentId);

    if (res.statusCode == 200) {
      return PrescriptionModel.fromJson(res.data);
    }

    return null;
  }

  Future<void> savePrescription({
    required String appointmentId,
    required String medicines,
    required String instructions,
  }) async {
    await _service.addPrescription(
      appointmentId: appointmentId,
      medicines: medicines,
      instructions: instructions,
    );
  }
}

final liveQueueProvider = NotifierProvider<LiveQueueNotifier, LiveQueueState>(
  LiveQueueNotifier.new,
);

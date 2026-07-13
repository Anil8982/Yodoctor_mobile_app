import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../core/models/doctor/prescription_model.dart';
import '../../../core/models/doctor/live_queue_model.dart';
import '../repositories/doctor_appointment_repository.dart';

class LiveQueueState {
  final bool loading;
  final List<LiveQueueItem> queue;
  final LiveQueueItem? current;
  final LiveQueueItem? next;
  final String? errorMessage;

  const LiveQueueState({
    this.loading = false,
    this.queue = const [],
    this.current,
    this.next,
    this.errorMessage,
  });

  LiveQueueState copyWith({
    bool? loading,
    List<LiveQueueItem>? queue,
    LiveQueueItem? current,
    bool clearCurrent = false,
    LiveQueueItem? next,
    bool clearNext = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LiveQueueState(
      loading: loading ?? this.loading,
      queue: queue ?? this.queue,
      current: clearCurrent ? null : (current ?? this.current),
      next: clearNext ? null : (next ?? this.next),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final liveQueueProvider = NotifierProvider<LiveQueueNotifier, LiveQueueState>(
  LiveQueueNotifier.new,
);

class LiveQueueNotifier extends Notifier<LiveQueueState> {
  static const String _subTag = 'LiveQueueNotifier';

  @override
  LiveQueueState build() {
    AppLogger.info(
      'LiveQueueNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    Future.microtask(() => loadQueue("MORNING"));
    return const LiveQueueState();
  }

  Future<void> loadQueue(String slot) async {
    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info(
      'Initializing live queue stream pipeline for slot: $slot',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);

      final results = await Future.wait([
        repository.getTodayQueue(slot: slot),
        repository.getCurrentPatient(slot: slot),
        repository.getNextPatient(slot: slot),
      ]);

      final queueRes = results[0];
      final currentRes = results[1];
      final nextRes = results[2];

      if ((queueRes.statusCode ?? 0) >= 200 &&
          (queueRes.statusCode ?? 0) < 300) {
        final rawList = queueRes.data["queue"] as List? ?? [];
        final queue = rawList.map((e) => LiveQueueItem.fromJson(e)).toList();

        LiveQueueItem? current;
        LiveQueueItem? next;

        if (currentRes.data?["active"] == true &&
            currentRes.data?["appointment"] != null) {
          current = LiveQueueItem.fromJson(currentRes.data["appointment"]);
        }

        if (nextRes.statusCode == 200 && nextRes.data?["appointment"] != null) {
          next = LiveQueueItem.fromJson(nextRes.data["appointment"]);
        }

        AppLogger.success(
          'Live queue pipeline synchronised flawlessly. Queue Count: ${queue.length}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        AppLogger.json(
          {
            "queue_count": queue.length,
            "current_patient": currentRes.data,
            "next_patient": nextRes.data,
          },
          tag: LogTags.doctor,
          subTag: '$_subTag/QueueSyncMatrix',
        );

        state = state.copyWith(
          loading: false,
          queue: queue,
          current: current,
          clearCurrent: current == null,
          next: next,
          clearNext: next == null,
        );
      } else {
        AppLogger.warning(
          'Failed to read live queue bounds. Status: ${queueRes.statusCode}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(
          loading: false,
          errorMessage: "Failed to read live queue bounds",
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        loading: false,
        errorMessage: "Runtime synchronization pipeline crash",
      );
      AppLogger.exception(
        e,
        st,
        message: 'Fatal exception within queue loader thread',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<void> complete(String id, String slot) async {
    AppLogger.info(
      'Completing appointment ID: $id',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.completeAppointment(id);
      AppLogger.success(
        'Appointment ID: $id marked completed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      await loadQueue(slot);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Complete transaction crashed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<void> recall(String id, String slot) async {
    AppLogger.info(
      'Recalling patient for appointment ID: $id',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.recallPatient(id);
      AppLogger.success(
        'Patient recall broadcasted successfully for ID: $id',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      await loadQueue(slot);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Recall execution crashed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<void> noShow(String slot) async {
    AppLogger.info(
      'Triggering no-show status updates for current token slot: $slot',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.noShow(slot);
      AppLogger.success(
        'No-show state updated on gateway branch',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      await loadQueue(slot);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'No show event crash',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<void> skip(String id, String slot) async {
    AppLogger.info(
      'Skipping appointment ID: $id',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.skipAppointment(id);
      AppLogger.success(
        'Appointment ID: $id skipped successfully',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      await loadQueue(slot);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Skip tracking faulted',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<void> start(String id, String slot) async {
    AppLogger.info(
      'Starting consultation for appointment ID: $id, Slot: $slot',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.startAppointment(appointmentId: id, slot: slot);
      AppLogger.success(
        'Consultation started successfully for ID: $id',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      await loadQueue(slot);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Start tracking faulted',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<void> nextToken(String slot) async {
    AppLogger.info(
      'Calling next token sequentially for slot: $slot',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      await repository.callNextToken(slot: slot);
      AppLogger.success(
        'Next token triggered over transmission wire',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      await loadQueue(slot);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Next token trigger failure',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<PrescriptionModel?> getPrescription(String appointmentId) async {
    AppLogger.info(
      'Fetching prescription records for ID: $appointmentId',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.getPrescription(appointmentId);
      if (res.statusCode == 200 && res.data != null) {
        AppLogger.success(
          'Prescription retrieved on context channel',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        AppLogger.json(
          res.data,
          tag: LogTags.doctor,
          subTag: '$_subTag/PrescriptionData',
        );
        return PrescriptionModel.fromJson(res.data);
      }
      AppLogger.warning(
        'Prescription response matrix empty or non-200. Status: ${res.statusCode}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return null;
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Fetch prescription data fault',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return null;
    }
  }

  Future<bool> savePrescription({
    required String appointmentId,
    required String medicines,
    required String instructions,
  }) async {
    final payload = {
      "appointmentId": appointmentId,
      "medicines": medicines,
      "instructions": instructions,
    };

    AppLogger.info(
      'Saving prescription parameters for transaction: $appointmentId',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    AppLogger.json(
      payload,
      tag: LogTags.doctor,
      subTag: '$_subTag/PrescriptionPayload',
    );

    try {
      final repository = ref.read(doctorAppointmentRepositoryProvider);
      final res = await repository.addPrescription(
        appointmentId: appointmentId,
        medicines: medicines,
        instructions: instructions,
      );
      final success =
          (res.statusCode ?? 0) >= 200 && (res.statusCode ?? 0) < 300;
      if (success) {
        AppLogger.success(
          'Prescription committed to centralized data node',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      } else {
        AppLogger.warning(
          'Prescription save denied by remote branch. Status: ${res.statusCode}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      }
      return success;
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Save prescription transmission error',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }
}

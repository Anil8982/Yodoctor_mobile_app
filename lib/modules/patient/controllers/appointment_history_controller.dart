import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/history/appointment_history_model.dart';
import '../repositories/patient_appointment_history_repository.dart';

class AppointmentHistoryState {
  final List<AppointmentHistoryModel> appointments;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? nextCursor;
  final Map<int, int> ratings;
  final Map<int, String> feedbacks;

  AppointmentHistoryState({
    this.appointments = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.nextCursor,
    this.ratings = const {},
    this.feedbacks = const {},
  });

  bool get hasMore => nextCursor != null;

  AppointmentHistoryState copyWith({
    List<AppointmentHistoryModel>? appointments,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    String? nextCursor,
    bool clearCursor = false,
    Map<int, int>? ratings,
    Map<int, String>? feedbacks,
  }) {
    return AppointmentHistoryState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      ratings: ratings ?? this.ratings,
      feedbacks: feedbacks ?? this.feedbacks,
    );
  }
}

final appointmentHistoryControllerProvider =
NotifierProvider<AppointmentHistoryController, AppointmentHistoryState>(
  AppointmentHistoryController.new,
);

class AppointmentHistoryController extends Notifier<AppointmentHistoryState> {
  static const String _subTag = 'AppointmentHistoryController';

  @override
  AppointmentHistoryState build() {
    Future.microtask(loadHistory);
    return AppointmentHistoryState();
  }

  int ratingFor(int appointmentId) => state.ratings[appointmentId] ?? 0;
  String feedbackFor(int appointmentId) => state.feedbacks[appointmentId] ?? "";

  Future<void> loadHistory() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);

    AppLogger.info('Loading appointment history...', tag: LogTags.patient, subTag: _subTag);

    try {
      final repository = ref.read(patientAppointmentHistoryRepositoryProvider);
      final response = await repository.getAppointmentHistory();

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;
        final rawList = data["data"] as List? ?? [];
        final list = rawList.map((e) => AppointmentHistoryModel.fromJson(e)).toList();

        AppLogger.success('Appointment history loaded successfully. Count: ${list.length}', tag: LogTags.patient, subTag: _subTag);

        state = state.copyWith(
          appointments: list,
          nextCursor: data["nextCursor"],
          isLoading: false,
        );
      } else {
        final msg = response.data["message"] ?? "Failed to load history";
        state = state.copyWith(errorMessage: msg, isLoading: false);
        AppLogger.warning('Failed to load appointment history: $msg', tag: LogTags.patient, subTag: _subTag);
      }
    } catch (e, st) {
      state = state.copyWith(errorMessage: "Failed to load history", isLoading: false);
      AppLogger.exception(e, st, message: 'Failed to load history', tag: LogTags.patient, subTag: _subTag);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);

    AppLogger.info('Loading more history with cursor: ${state.nextCursor}', tag: LogTags.patient, subTag: _subTag);

    try {
      final repository = ref.read(patientAppointmentHistoryRepositoryProvider);
      final response = await repository.getAppointmentHistory(cursor: state.nextCursor);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;
        final rawList = data["data"] as List? ?? [];
        final more = rawList.map((e) => AppointmentHistoryModel.fromJson(e)).toList();

        AppLogger.success('More history loaded successfully. Count: ${more.length}', tag: LogTags.patient, subTag: _subTag);

        state = state.copyWith(
          appointments: [...state.appointments, ...more],
          nextCursor: data["nextCursor"],
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(isLoadingMore: false);
        AppLogger.warning('Failed to load more history: ${response.statusCode}', tag: LogTags.patient, subTag: _subTag);
      }
    } catch (e, st) {
      state = state.copyWith(isLoadingMore: false);
      AppLogger.exception(e, st, message: 'Failed to load more history', tag: LogTags.patient, subTag: _subTag);
    }
  }

  Future<void> refresh() async {
    AppLogger.info('Refreshing appointment history...', tag: LogTags.patient, subTag: _subTag);
    state = state.copyWith(appointments: const [], clearCursor: true);
    await loadHistory();
  }

  Future<void> submitRating({
    required int appointmentId,
    required int rating,
    required String feedback,
  }) async {
    final payload = {
      "appointmentId": appointmentId,
      "rating": rating,
      "comment": feedback,
    };

    AppLogger.info('Submitting rating for appointment ID: $appointmentId', tag: LogTags.patient, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.patient, subTag: '$_subTag/ReviewPayload');

    try {
      final repository = ref.read(patientAppointmentHistoryRepositoryProvider);
      final response = await repository.submitDoctorReview(
        appointmentId: appointmentId,
        rating: rating,
        comment: feedback,
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        AppLogger.success('Review submitted successfully for appointment ID: $appointmentId', tag: LogTags.patient, subTag: _subTag);

        final updatedRatings = Map<int, int>.from(state.ratings)..[appointmentId] = rating;
        final updatedFeedbacks = Map<int, String>.from(state.feedbacks)..[appointmentId] = feedback.trim();

        state = state.copyWith(ratings: updatedRatings, feedbacks: updatedFeedbacks);
      } else {
        final errorMsg = response.data["message"] ?? "Failed to submit review";
        AppLogger.warning('Review submission rejected by backend: $errorMsg', tag: LogTags.patient, subTag: _subTag);
        throw Exception(errorMsg);
      }
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Review submission execution faulted', tag: LogTags.patient, subTag: _subTag);
      throw Exception("Failed to submit review");
    }
  }

  Future<Map<String, dynamic>> getPrescription(int appointmentId) async {
    AppLogger.info('Fetching prescription for appointment ID: $appointmentId', tag: LogTags.patient, subTag: _subTag);

    try {
      final repository = ref.read(patientAppointmentHistoryRepositoryProvider);
      final response = await repository.getPrescription(appointmentId);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        AppLogger.success('Prescription data retrieved successfully', tag: LogTags.patient, subTag: _subTag);
        AppLogger.json(response.data, tag: LogTags.patient, subTag: '$_subTag/PrescriptionResponse');
        return Map<String, dynamic>.from(response.data);
      }

      AppLogger.warning('Prescription not found. StatusCode: ${response.statusCode}', tag: LogTags.patient, subTag: _subTag);
      throw Exception(response.data["message"] ?? "Prescription not found");
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Prescription extraction failed', tag: LogTags.patient, subTag: _subTag);
      throw Exception("Prescription not found");
    }
  }
}
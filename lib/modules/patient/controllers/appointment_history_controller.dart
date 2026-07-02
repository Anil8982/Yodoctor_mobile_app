import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/dummy_data.dart';

// 🎯 Unified immutable state structure holding both data items and sync updates
class AppointmentHistoryState {
  final List<AppointmentHistoryItem> appointments;
  final Map<String, int> ratings;
  final Map<String, String> feedbacks;

  AppointmentHistoryState({
    this.appointments = const [],
    this.ratings = const {},
    this.feedbacks = const {},
  });

  AppointmentHistoryState copyWith({
    List<AppointmentHistoryItem>? appointments,
    Map<String, int>? ratings,
    Map<String, String>? feedbacks,
  }) {
    return AppointmentHistoryState(
      appointments: appointments ?? this.appointments,
      ratings: ratings ?? this.ratings,
      feedbacks: feedbacks ?? this.feedbacks,
    );
  }
}

// 🎯 FIX: Extended manual AsyncNotifier base class to resolve inheritance bounds
class AppointmentHistoryNotifier extends AsyncNotifier<AppointmentHistoryState> {

  @override
  Future<AppointmentHistoryState> build() async {
    // Triggers initial data fetch session on build setup
    final data = await DummyData.getAppointmentHistory();
    return AppointmentHistoryState(appointments: data);
  }

  // Pull-to-refresh or explicit data reload channel
  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final data = await DummyData.getAppointmentHistory();
      return AppointmentHistoryState(
        appointments: data,
        ratings: state.value?.ratings ?? const {},
        feedbacks: state.value?.feedbacks ?? const {},
      );
    });
  }

  int ratingFor(String appointmentId) => state.value?.ratings[appointmentId] ?? 0;

  String feedbackFor(String appointmentId) => state.value?.feedbacks[appointmentId] ?? '';

  // Process synchronous update blocks cleanly without manual notifier triggers
  Future<void> submitRating({
    required String appointmentId,
    required int rating,
    required String feedback,
  }) async {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedRatings = Map<String, int>.from(currentState.ratings)..[appointmentId] = rating;
    final updatedFeedbacks = Map<String, String>.from(currentState.feedbacks)..[appointmentId] = feedback.trim();

    // Assignment triggers state mutation stream cleanly to consumers
    state = AsyncValue.data(currentState.copyWith(
      ratings: updatedRatings,
      feedbacks: updatedFeedbacks,
    ));
  }
}

// 🎯 FIX: Provider registration utilizing autoDispose modifier to safely track lifecycle
final appointmentHistoryProvider = AsyncNotifierProvider.autoDispose<AppointmentHistoryNotifier, AppointmentHistoryState>(
  AppointmentHistoryNotifier.new,
);
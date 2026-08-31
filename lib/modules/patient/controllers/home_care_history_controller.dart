import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';

import 'package:yodoctor/modules/patient/models/home_care/home_care_history_model.dart';
import 'package:yodoctor/modules/patient/repositories/patient_homecare_repository.dart';

final homeCareHistoryProvider =
NotifierProvider<HomeCareHistoryNotifier, HomeCareHistoryState>(
  HomeCareHistoryNotifier.new,
);

class HomeCareHistoryState {
  final List<HomeCareBookingModel> bookings;
  final HomeCareBookingModel? selectedBooking;
  final bool isLoading;
  final bool isDetailsLoading;
  final bool isCancelling;
  final bool isRefreshing;
  final String selectedFilter;
  final String? errorMessage;

  const HomeCareHistoryState({
    this.bookings = const [],
    this.selectedBooking,
    this.isLoading = false,
    this.isDetailsLoading = false,
    this.isCancelling = false,
    this.isRefreshing = false,
    this.selectedFilter = 'ALL',
    this.errorMessage,
  });

  HomeCareHistoryState copyWith({
    List<HomeCareBookingModel>? bookings,
    HomeCareBookingModel? selectedBooking,
    bool clearSelectedBooking = false,
    bool? isLoading,
    bool? isDetailsLoading,
    bool? isCancelling,
    bool? isRefreshing,
    String? selectedFilter,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeCareHistoryState(
      bookings: bookings ?? this.bookings,
      selectedBooking: clearSelectedBooking
          ? null
          : (selectedBooking ?? this.selectedBooking),
      isLoading: isLoading ?? this.isLoading,
      isDetailsLoading: isDetailsLoading ?? this.isDetailsLoading,
      isCancelling: isCancelling ?? this.isCancelling,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class HomeCareHistoryNotifier extends Notifier<HomeCareHistoryState> {
  late final PatientHomeCareRepository _repository;

  @override
  HomeCareHistoryState build() {
    _repository = ref.read(patientHomeCareRepositoryProvider);
    return const HomeCareHistoryState();
  }

  List<HomeCareBookingModel> get filteredBookings {
    if (state.selectedFilter == 'ALL') {
      return state.bookings;
    }

    return state.bookings
        .where(
          (booking) =>
      booking.status.toUpperCase() ==
          state.selectedFilter.toUpperCase(),
    )
        .toList();
  }

  Future<void> fetchHistory({bool isRefresh = false}) async {
    if (isRefresh) {
      if (state.isRefreshing) return;
      state = state.copyWith(isRefreshing: true, clearError: true);
    } else {
      if (state.isLoading) return;
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final response = await _repository.getBookings();

      if (response.data is Map<String, dynamic>) {
        final historyResponse = HomeCareHistoryResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        state = state.copyWith(
          bookings: historyResponse.data,
          isLoading: false,
          isRefreshing: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: 'Unexpected response format received from server.',
        );
      }
    } on DioException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch home care history',
        error: e,
        stackTrace: stackTrace,
        tag: LogTags.patient,
      );
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: e.response?.data?['message']?.toString() ??
            e.message ??
            'Failed to fetch home care history. Please try again.',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching home care history',
        error: e,
        stackTrace: stackTrace,
        tag: LogTags.patient,
      );
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> fetchBookingDetails(int bookingId) async {
    if (state.isDetailsLoading) return;

    state = state.copyWith(isDetailsLoading: true, clearError: true);

    try {
      final response = await _repository.getBookingDetails(bookingId);

      if (response.data is Map<String, dynamic>) {
        final detailsResponse = HomeCareBookingDetailsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        state = state.copyWith(
          selectedBooking: detailsResponse.data,
          isDetailsLoading: false,
        );
      } else {
        state = state.copyWith(
          isDetailsLoading: false,
          errorMessage: 'Unexpected response format received from server.',
        );
      }
    } on DioException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch home care booking details for id: $bookingId',
        error: e,
        stackTrace: stackTrace,
        tag: LogTags.patient,
      );
      state = state.copyWith(
        isDetailsLoading: false,
        errorMessage: e.response?.data?['message']?.toString() ??
            e.message ??
            'Failed to fetch booking details. Please try again.',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching booking details for id: $bookingId',
        error: e,
        stackTrace: stackTrace,
        tag: LogTags.patient,
      );
      state = state.copyWith(
        isDetailsLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<bool> cancelBooking(int bookingId) async {
    if (state.isCancelling) return false;

    state = state.copyWith(
      isCancelling: true,
      clearError: true,
    );

    try {
      final response = await _repository.cancelBooking(bookingId);
      final responseData = response.data;

      final isSuccess =
          responseData is Map<String, dynamic> &&
              responseData['success'] == true;

      if (!isSuccess) {
        final message = responseData is Map<String, dynamic>
            ? responseData['message']?.toString()
            : null;

        state = state.copyWith(
          isCancelling: false,
          errorMessage: message ?? 'Failed to cancel the booking.',
        );

        return false;
      }

      await fetchHistory(isRefresh: true);

      HomeCareBookingModel? updatedBooking;
      for (final booking in state.bookings) {
        if (booking.id == bookingId) {
          updatedBooking = booking;
          break;
        }
      }

      state = state.copyWith(
        selectedBooking: updatedBooking,
        isCancelling: false,
      );

      return true;
    } on DioException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to cancel home care booking for id: $bookingId',
        error: e,
        stackTrace: stackTrace,
        tag: LogTags.patient,
      );

      state = state.copyWith(
        isCancelling: false,
        errorMessage: e.response?.data?['message']?.toString() ??
            e.message ??
            'Failed to cancel booking. Please try again.',
      );

      return false;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error cancelling booking for id: $bookingId',
        error: e,
        stackTrace: stackTrace,
        tag: LogTags.patient,
      );

      state = state.copyWith(
        isCancelling: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );

      return false;
    }
  }

  void setFilter(String filter) {
    if (state.selectedFilter != filter) {
      state = state.copyWith(selectedFilter: filter);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearSelectedBooking() {
    state = state.copyWith(clearSelectedBooking: true);
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/search/doctor_search_model.dart';
import '../models/search/search_params.dart';
import '../repositories/patient_search_repository.dart';

class DoctorListingState {
  final bool isLoading;
  final String? error;
  final List<DoctorSearchModel> doctors;
  final int page;
  final bool hasMore;
  final String currentSearch;
  final String currentCity;

  DoctorListingState({
    this.isLoading = false,
    this.error,
    this.doctors = const [],
    this.page = 1,
    this.hasMore = true,
    this.currentSearch = "",
    this.currentCity = "",
  });

  DoctorListingState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<DoctorSearchModel>? doctors,
    int? page,
    bool? hasMore,
    String? currentSearch,
    String? currentCity,
  }) {
    return DoctorListingState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      doctors: doctors ?? this.doctors,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      currentSearch: currentSearch ?? this.currentSearch,
      currentCity: currentCity ?? this.currentCity,
    );
  }
}

final doctorListingControllerProvider =
NotifierProvider<DoctorListingController, DoctorListingState>(
  DoctorListingController.new,
);

class DoctorListingController extends Notifier<DoctorListingState> {
  static const String _subTag = 'DoctorListingController';

  @override
  DoctorListingState build() {
    return DoctorListingState();
  }

  /// Execute search with params
  Future<void> searchDoctors(SearchParams params) async {
    state = DoctorListingState(
      currentSearch: params.search,
      currentCity: params.city,
    );
    await _loadDoctors(page: 1);
  }

  /// Clear all filters - Show all doctors
  Future<void> clearAllFilters() async {
    // Reset to empty search and city
    state = DoctorListingState(
      currentSearch: "",
      currentCity: "",
    );
    await _loadDoctors(page: 1);
  }

  /// Load more for infinite scroll
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    await _loadDoctors(page: state.page + 1);
  }

  /// Refresh current search
  Future<void> refresh() async {
    await _loadDoctors(page: 1);
  }

  /// Retry on error
  Future<void> retry() async {
    await _loadDoctors(page: state.page);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Reset state
  void reset() {
    state = DoctorListingState();
  }

  Future<void> _loadDoctors({required int page}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.searchDoctors(
        search: state.currentSearch,
        city: state.currentCity,
        page: page,
        limit: 20,
      );

      if (response.statusCode == 200) {
        final rawList = response.data["data"]["doctors"] as List;
        final doctors = rawList
            .map((e) => DoctorSearchModel.fromJson(e))
            .toList();

        final totalCount = response.data["data"]["count"] as int? ?? 0;
        final hasMore = (page * 20) < totalCount;

        state = state.copyWith(
          doctors: page == 1 ? doctors : [...state.doctors, ...doctors],
          page: page,
          hasMore: hasMore,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.data["message"] ?? "Failed to load doctors",
          isLoading: false,
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        error: "Failed to load doctors",
        isLoading: false,
      );
      AppLogger.exception(
        e,
        st,
        message: 'Load doctors failed',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }
}
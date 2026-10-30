import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
import '../models/review/doctor_review_model.dart';
import '../repositories/doctor_review_repository.dart';

class DoctorReviewState {
  final bool loading;
  final List<DoctorReviewModel> reviews;
  final double avgRating;
  final int totalReviews;
  final bool hasMore;
  final int page;
  final String? errorMessage;

  const DoctorReviewState({
    this.loading = false,
    this.reviews = const [],
    this.avgRating = 0,
    this.totalReviews = 0,
    this.hasMore = false,
    this.page = 1,
    this.errorMessage,
  });

  DoctorReviewState copyWith({
    bool? loading,
    List<DoctorReviewModel>? reviews,
    double? avgRating,
    int? totalReviews,
    bool? hasMore,
    int? page,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorReviewState(
      loading: loading ?? this.loading,
      reviews: reviews ?? this.reviews,
      avgRating: avgRating ?? this.avgRating,
      totalReviews: totalReviews ?? this.totalReviews,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final doctorReviewProvider =
NotifierProvider<DoctorReviewNotifier, DoctorReviewState>(
  DoctorReviewNotifier.new,
);

class DoctorReviewNotifier extends Notifier<DoctorReviewState> {
  static const String _subTag = 'DoctorReviewNotifier';

  final Set<int> _loadingPages = {};

  @override
  DoctorReviewState build() {
    DebugLog.info('DoctorReviewNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    Future.microtask(() => loadReviews(page: 1));
    return const DoctorReviewState();
  }

  Future<void> loadReviews({int page = 1}) async {
    if (_loadingPages.contains(page)) return;
    _loadingPages.add(page);

    state = state.copyWith(loading: true, clearError: true);
    DebugLog.info('Fetching doctor reviews feed stream. Page: $page', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorReviewRepositoryProvider);
      final response = await repository.getReviews(page: page);
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final rawList = response.data["reviews"] as List? ?? [];
        final newReviews = rawList.map((e) => DoctorReviewModel.fromJson(e)).toList();
        final updatedReviews = page == 1 ? newReviews : [...state.reviews, ...newReviews];

        DebugLog.success(
          'Reviews page $page compiled safely. Current list size: ${updatedReviews.length}',
          tag: LogTags.doctor,
          subTag: _subTag,
          json: response.data,
        );

        state = state.copyWith(
          loading: false,
          reviews: updatedReviews,
          avgRating: double.tryParse(response.data["avgRating"].toString()) ?? 0,
          totalReviews: response.data["totalReviews"] ?? 0,
          hasMore: response.data["hasMore"] ?? false,
          page: page,
        );
      } else {
        final msg = response.data["message"] ?? "Failed to load patient feedback";
        state = state.copyWith(loading: false, errorMessage: msg);
        DebugLog.warning('Reviews point dropped execution block safely. Status: $statusCode, Message: $msg', tag: LogTags.doctor, subTag: _subTag);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to read reviews feed");
      DebugLog.error(
        'Reviews pipeline thread exception crash',
        tag: LogTags.doctor,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
    } finally {
      _loadingPages.remove(page);
    }
  }

  Future<void> loadNextPage() async {
    if (state.hasMore && !state.loading) {
      DebugLog.info('Requesting next page pointer row: ${state.page + 1}', tag: LogTags.doctor, subTag: _subTag);
      await loadReviews(page: state.page + 1);
    }
  }
}
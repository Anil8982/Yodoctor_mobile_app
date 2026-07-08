import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/doctor/doctor_review_model.dart';
import '../../../services/doctor_review_service.dart';

class DoctorReviewState {
  final bool loading;
  final List<DoctorReviewModel> reviews;
  final double avgRating;
  final int totalReviews;
  final bool hasMore;
  final int page;

  const DoctorReviewState({
    this.loading = false,
    this.reviews = const [],
    this.avgRating = 0,
    this.totalReviews = 0,
    this.hasMore = false,
    this.page = 1,
  });

  DoctorReviewState copyWith({
    bool? loading,
    List<DoctorReviewModel>? reviews,
    double? avgRating,
    int? totalReviews,
    bool? hasMore,
    int? page,
  }) {
    return DoctorReviewState(
      loading: loading ?? this.loading,
      reviews: reviews ?? this.reviews,
      avgRating: avgRating ?? this.avgRating,
      totalReviews: totalReviews ?? this.totalReviews,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class DoctorReviewNotifier extends Notifier<DoctorReviewState> {
  final _service = DoctorReviewService();

  @override
  DoctorReviewState build() {
    Future.microtask(loadReviews);
    return const DoctorReviewState();
  }

  Future<void> loadReviews({int page = 1}) async {
    state = state.copyWith(loading: true);

    final response = await _service.getReviews(page: page);

    final reviews = (response.data["reviews"] as List)
        .map((e) => DoctorReviewModel.fromJson(e))
        .toList();

    state = state.copyWith(
      loading: false,
      reviews: reviews,
      avgRating: double.tryParse(response.data["avgRating"].toString()) ?? 0,
      totalReviews: response.data["totalReviews"] ?? 0,
      hasMore: response.data["hasMore"] ?? false,
      page: page,
    );
  }
}

final doctorReviewProvider =
    NotifierProvider<DoctorReviewNotifier, DoctorReviewState>(
      DoctorReviewNotifier.new,
    );

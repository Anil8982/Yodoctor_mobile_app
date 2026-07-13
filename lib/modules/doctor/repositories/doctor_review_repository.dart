import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final doctorReviewRepositoryProvider = Provider<DoctorReviewRepository>((ref) {
  return DoctorReviewRepository(ref.read(dioProvider));
});

class DoctorReviewRepository {
  DoctorReviewRepository(this._dio);
  final Dio _dio;

  Future<Response> getReviews({int page = 1}) {
    return _dio.get(
      ApiConstants.doctorReviews,
      queryParameters: {"page": page},
    );
  }
}
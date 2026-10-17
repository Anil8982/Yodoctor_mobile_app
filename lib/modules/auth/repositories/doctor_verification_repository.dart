import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final doctorVerificationRepositoryProvider = Provider<DoctorVerificationRepository>((ref) {
  return DoctorVerificationRepository(ref.read(dioProvider));
});

class DoctorVerificationRepository {
  DoctorVerificationRepository(this._dio);
  final Dio _dio;

  /// Fetches the current verification status of the doctor
  Future<Response> getVerificationStatus() {
    return _dio.get(ApiConstants.doctorVerificationStatus);
  }
}
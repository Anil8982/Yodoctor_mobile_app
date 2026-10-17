import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final doctorProfileRepositoryProvider = Provider<DoctorProfileRepository>((ref) {
  return DoctorProfileRepository(ref.read(dioProvider));
});

class DoctorProfileRepository {
  DoctorProfileRepository(this._dio);
  final Dio _dio;

  Future<Response> getProfile() {
    return _dio.get(ApiConstants.getDoctorProfile);
  }

  Future<Response> updateProfile(Map<String, dynamic> data) {
    return _dio.put(ApiConstants.updateDoctorProfile, data: data);
  }
}
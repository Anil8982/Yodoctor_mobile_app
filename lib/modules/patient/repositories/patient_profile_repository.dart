import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final patientProfileRepositoryProvider = Provider<PatientProfileRepository>((ref) {
  return PatientProfileRepository(ref.read(dioProvider));
});

class PatientProfileRepository {
  PatientProfileRepository(this._dio);
  final Dio _dio;

  Future<Response> getProfile() {
    return _dio.get(ApiConstants.getProfile);
  }

  Future<Response> updateProfile({
    required String fullName,
    required String phone,
    required String gender,
    required String dob,
  }) {
    return _dio.put(
      ApiConstants.updateProfile,
      data: {
        "fullName": fullName,
        "phone": phone,
        "gender": gender,
        "dob": dob,
      },
    );
  }
}
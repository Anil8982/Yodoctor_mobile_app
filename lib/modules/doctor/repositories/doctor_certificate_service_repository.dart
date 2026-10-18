import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final doctorCertificateServiceRepositoryProvider =
Provider<DoctorCertificateServiceRepository>((ref) {
  final dio = ref.read(dioProvider);
  return DoctorCertificateServiceRepository(dio);
});

class DoctorCertificateServiceRepository {
  final Dio _dio;

  DoctorCertificateServiceRepository(this._dio);

  Future<Response> getCertificateService() {
    return _dio.get(
      ApiConstants.certificateService,
    );
  }

  Future<Response> saveCertificateService({
    required bool enabled,
    required double fee,
    String? instructions,
  }) {
    return _dio.post(
      ApiConstants.saveCertificateService,
      data: {
        'enabled': enabled,
        'fee': fee,
        'instructions': instructions,
      },
    );
  }

  Future<Response> toggleCertificateService({
    required bool enabled,
  }) {
    return _dio.patch(
      ApiConstants.certificateServiceToggle,
      data: {
        'enabled': enabled,
      },
    );
  }
}
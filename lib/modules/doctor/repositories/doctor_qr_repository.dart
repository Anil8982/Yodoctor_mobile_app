import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final doctorQrRepositoryProvider = Provider<DoctorQrRepository>((ref) {
  return DoctorQrRepository(ref.read(dioProvider));
});

class DoctorQrRepository {
  DoctorQrRepository(this._dio);
  final Dio _dio;

  Future<Response> getMyQr() {
    return _dio.get(ApiConstants.getDoctorQr);
  }

  Future<Response> downloadQr({
    required String doctorName,
    required String specialization,
    required String qrValue,
  }) {
    return _dio.post(
      ApiConstants.downloadDoctorQr,
      data: {
        "doctorName": doctorName,
        "specialization": specialization,
        "qrValue": qrValue,
      },
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
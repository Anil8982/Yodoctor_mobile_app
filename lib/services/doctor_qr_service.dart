import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class DoctorQrService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("doctor_token");
  }

  Future<Response> getMyQr() async {
    final token = await _token();

    return ApiService.dio.get(
      "/doctor/my-qr",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> downloadQr({
    required String doctorName,
    required String specialization,
    required String qrValue,
  }) async {
    final token = await _token();

    return ApiService.dio.post(
      "/download-qr",
      data: {
        "doctorName": doctorName,
        "specialization": specialization,
        "qrValue": qrValue,
      },
      options: Options(
        headers: {"Authorization": "Bearer $token"},
        responseType: ResponseType.bytes,
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class ManualBookingService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("doctor_token");
  }

  Future<Response> bookPatient({
    required String patientName,
    required String patientMobile,
    required int patientAge,
    required String slot,
    String appointmentType = "CLINIC",
  }) async {
    final token = await _token();

    return ApiService.dio.post(
      "/doctor/manualbooking",
      data: {
        "appointmentType": appointmentType,
        "slot": slot,
        "patientName": patientName,
        "patientMobile": patientMobile,
        "patientAge": patientAge,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

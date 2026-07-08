import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class PatientAppointmentHistoryService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<Response> getAppointmentHistory({
    String? cursor,
    int limit = 10,
  }) async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/visit/appointments/history",
      queryParameters: {"limit": limit, if (cursor != null) "cursor": cursor},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // ⭐ Submit Review
  Future<Response> submitDoctorReview({
    required int appointmentId,
    required int rating,
    required String comment,
  }) async {
    final token = await _token();

    return ApiService.dio.post(
      "/patient/doctor-feedback",
      data: {
        "appointmentId": appointmentId,
        "rating": rating,
        "comment": comment,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // 💊 Prescription
  Future<Response> getPrescription(int appointmentId) async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/appointments/$appointmentId/prescription",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

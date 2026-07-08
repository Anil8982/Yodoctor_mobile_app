import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/patient/models/appointment/book_appointment_request.dart';
import 'api_service.dart';

class PatientAppointmentService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<Response> bookAppointment(BookAppointmentRequest request) async {
    final token = await _token();

    return ApiService.dio.post(
      "/patient/visit/appointments",
      data: request.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

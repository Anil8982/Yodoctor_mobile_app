import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class PatientDashboardService {
  Future<Response> getDashboard() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await ApiService.dio.get(
      "/patient/dashboard",

      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> cancelAppointment(int appointmentId) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await ApiService.dio.put(
      "/patient/visit/appointments/$appointmentId/cancel",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getTokenStatus(int appointmentId) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return await ApiService.dio.get(
      "/patient/visit/token-status/$appointmentId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

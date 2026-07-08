import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class DoctorDashboardService {
  Future<Response> getDashboard() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_token");

    return ApiService.dio.get(
      "/doctor/dashboard",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> updateAvailability(bool isAvailable) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_token");

    return ApiService.dio.put(
      "/doctor/availability",
      data: {"isAvailable": isAvailable},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

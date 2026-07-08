import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class DoctorProfileService {
  Future<Response> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_token");

    return ApiService.dio.get(
      "/doctor/profile",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_token");

    return ApiService.dio.put(
      "/doctor/profile",
      data: data,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

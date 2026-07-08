import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class PatientProfileService {
  Future<Response> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return ApiService.dio.get(
      "/patient/getprofile",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> updateProfile({
    required String fullName,
    required String phone,
    required String gender,
    required String dob,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return ApiService.dio.put(
      "/patient/updateProfile",
      data: {
        "fullName": fullName,
        "phone": phone,
        "gender": gender,
        "dob": dob,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

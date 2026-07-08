import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class PatientSearchService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // -------------------------------
  // Search Doctors
  // -------------------------------
  Future<Response> searchDoctors({
    String search = "",
    String city = "",
    int page = 1,
    int limit = 10,
  }) async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/visit/doctors",
      queryParameters: {
        "search": search,
        "city": city,
        "page": page,
        "limit": limit,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // -------------------------------
  // Doctor Name Suggestions
  // -------------------------------
  Future<Response> getDoctorNames() async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/doctorname",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // -------------------------------
  // Cities
  // -------------------------------
  Future<Response> getCities({String search = ""}) async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/cities",
      queryParameters: {"search": search},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // -------------------------------
  // Specializations
  // -------------------------------
  Future<Response> getSpecialties() async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/diseases",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // -------------------------------
  // Clinic Names
  // -------------------------------
  Future<Response> getClinicNames() async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/clinicname",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getPlaceNames() async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/clinicname",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getDoctorById(int doctorId) async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/visit/doctors/$doctorId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

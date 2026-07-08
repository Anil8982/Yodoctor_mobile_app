import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class PatientLabService {
  Future<Response> getCategories() {
    return ApiService.dio.get("/lab/categories");
  }

  Future<Response> getTests({String? search, int? category, String? tier}) {
    return ApiService.dio.get(
      "/patient/lab/tests",
      queryParameters: {
        if (search != null) "search": search,
        if (category != null) "category": category,
        if (tier != null) "tier": tier,
      },
    );
  }

  Future<Response> getPopularTests() {
    return ApiService.dio.get("/patient/lab/tests/popular");
  }

  Future<Response> getPackages() {
    return ApiService.dio.get("/patient/lab/packages");
  }

  Future<Response> getTestDetails(int id) {
    return ApiService.dio.get("/patient/lab/tests/$id");
  }

  Future<Response> createBooking(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("patient_token");

    return ApiService.dio.post(
      "/patient/lab-bookings",
      data: data,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

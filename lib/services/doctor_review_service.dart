import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class DoctorReviewService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("doctor_token");
  }

  Future<Response> getReviews({int page = 1}) async {
    final token = await _token();

    return ApiService.dio.get(
      "/doctor/reviews",
      queryParameters: {"page": page},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

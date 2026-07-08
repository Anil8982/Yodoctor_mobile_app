import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class PatientHomeCareService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("patient_token");
  }

  // Create Booking
  Future<Response> createBooking(Map<String, dynamic> data) async {
    final token = await _token();

    return ApiService.dio.post(
      "/patient/bookhomecare",
      data: data,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // My Bookings
  Future<Response> getBookings() async {
    final token = await _token();

    return ApiService.dio.get(
      "/patient/getbookhomecare",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

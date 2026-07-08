import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class DoctorCertificateService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("doctor_token");
  }

  Future<Response> getRequests() async {
    final token = await _token();

    return ApiService.dio.get(
      "/certificate/requests",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getIssuedCertificates() async {
    final token = await _token();

    return ApiService.dio.get(
      "/certificate/issued",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> approve({
    required int id,
    required String doctorNotes,
    required String fitnessStatus,
    required int validity,
  }) async {
    final token = await _token();

    return ApiService.dio.put(
      "/certificate/approve/$id",
      data: {
        "doctor_notes": doctorNotes,
        "fitness_status": fitnessStatus,
        "validity": validity,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> reject(int id) async {
    final token = await _token();

    return ApiService.dio.put(
      "/certificate/reject/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getRequestDetails(int id) async {
    final token = await _token();

    return ApiService.dio.get(
      "/certificate/requests/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getDocuments(int id) async {
    final token = await _token();

    return ApiService.dio.get(
      "/certificate/documents/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

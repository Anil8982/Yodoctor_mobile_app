import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AppointmentService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("doctor_token");
  }

  Future<Response> getHistory({String? filter, int page = 1}) async {
    final token = await _token();

    return ApiService.dio.get(
      "/doctor/appointments/history",
      queryParameters: {if (filter != null) "filter": filter, "page": page},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getTodayQueue({required String slot}) async {
    final token = await _token();

    return ApiService.dio.get(
      "/doctor/appointments/today-queue",
      queryParameters: {"slot": slot},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getCurrentPatient({required String slot}) async {
    final token = await _token();

    return ApiService.dio.get(
      "/doctor/appointments/current-token",
      queryParameters: {"slot": slot},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getNextPatient({required String slot}) async {
    final token = await _token();

    return ApiService.dio.get(
      "/doctor/appointments/next",
      queryParameters: {"slot": slot},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> startAppointment({
    required String appointmentId,
    required String slot,
  }) async {
    final token = await _token();

    return ApiService.dio.put(
      "/doctor/appointments/$appointmentId/start",
      data: {"slot": slot},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> skipAppointment(String appointmentId) async {
    final token = await _token();

    return ApiService.dio.put(
      "/doctor/appointments/$appointmentId/skip",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> callNextToken({required String slot}) async {
    final token = await _token();

    return ApiService.dio.post(
      "/doctor/appointments/next-token",
      data: {"slot": slot},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> addPrescription({
    required String appointmentId,
    required String medicines,
    required String instructions,
  }) async {
    final token = await _token();

    return ApiService.dio.post(
      "/doctor/appointments/$appointmentId/prescription",
      data: {"medicines": medicines, "instructions": instructions},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getPrescription(String appointmentId) async {
    final token = await _token();

    return ApiService.dio.get(
      "/doctor/prescription/$appointmentId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> completeAppointment(String appointmentId) async {
    final token = await _token();

    return ApiService.dio.post(
      "/doctor/appointments/$appointmentId/summary",
      data: {"diagnosis": "", "notes": ""},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> noShow(String slot) async {
    final token = await _token();

    return ApiService.dio.put(
      "/doctor/appointments/noShow",
      data: {"slot": slot},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> recallPatient(String appointmentId) async {
    final token = await _token();

    return ApiService.dio.put(
      "/doctor/appointments/recall/$appointmentId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getIncomingAppointments() async {
    final token = await _token();

    return ApiService.dio.get(
      "/doctor/appointments/incoming",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> respondAppointment(String id, String action) async {
    final token = await _token();

    return ApiService.dio.put(
      "/doctor/respond-appointment/$id",
      data: {"action": action},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> autoAcceptAllAppointments() async {
    final token = await _token();

    return ApiService.dio.put(
      "/doctor/appointments/auto-accept",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

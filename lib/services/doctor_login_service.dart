import 'package:dio/dio.dart';

import 'api_service.dart';

class DoctorLoginService {
  Future<Response> login({
    required String identifier,
    required String password,
  }) {
    return ApiService.dio.post(
      "/auth/login",
      data: {
        "identifier": identifier,
        "password": password,
        "portal": "DOCTOR",
      },
    );
  }
}

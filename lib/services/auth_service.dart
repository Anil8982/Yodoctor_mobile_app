import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  Future<Response> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dob,
  }) async {
    return ApiService.dio.post(
      "/patient/register",
      data: {
        "fullName": fullName,
        "phone": phone,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "gender": gender,
        "dob": dob,
      },
    );
  }

  Future<Response> login({
    required String identifier,
    required String password,
  }) async {
    return await ApiService.dio.post(
      "/auth/login",
      data: {"identifier": identifier, "password": password, "portal": "USER"},
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/doctor_login_service.dart';

class DoctorLoginController extends ChangeNotifier {
  final DoctorLoginService _service = DoctorLoginService();

  bool isLoading = false;
  String? error;

  Future<Map<String, dynamic>?> login({
    required String identifier,
    required String password,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.login(
        identifier: identifier,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();

      final data = response.data;

      final token = data["data"]?["token"];

      if (token != null) {
        await prefs.setString("doctor_token", token);
      }

      isLoading = false;
      notifyListeners();

      return {
        "redirect": data["redirect"],
        "status": data["status"],
        "nextStep": data["nextStep"],
        "message": data["message"],
      };
    } on DioException catch (e) {
      error = e.response?.data["message"] ?? "Login Failed";

      isLoading = false;
      notifyListeners();

      return null;
    } catch (e) {
      error = e.toString();

      isLoading = false;
      notifyListeners();

      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("doctor_token");

    error = null;
    notifyListeners();
  }
}

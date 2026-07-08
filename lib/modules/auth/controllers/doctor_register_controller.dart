import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/doctor_register_service.dart';
import '../models/doctor_register_model.dart';

class DoctorRegisterController extends ChangeNotifier {
  final DoctorRegisterService _service = DoctorRegisterService();

  bool isLoading = false;
  String? error;
  String? token;

  Future<bool> registerStep1(DoctorFormData data) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.registerStep1(
        fullName: data.fullName,
        email: data.email,
        mobile: data.mobile,
        gender: data.gender,
        languages: data.languages,
        bio: data.bio,
        password: data.password,
        confirmPassword: data.confirmPassword,
      );

      final prefs = await SharedPreferences.getInstance();

      token = response.data["token"];

      if (token != null) {
        await prefs.setString("doctor_register_token", token!);
      }

      isLoading = false;
      notifyListeners();

      return true;
    } on DioException catch (e) {
      if (e.response?.data is Map) {
        final map = e.response!.data;

        if (map["message"] != null) {
          error = map["message"];
        } else if (map["errors"] != null) {
          error = (map["errors"] as Map).values.first.toString();
        } else {
          error = "Something went wrong";
        }
      } else {
        error = "Something went wrong";
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();

    return false;
  }

  Future<bool> registerStep2(DoctorFormData data) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.registerStep2(
        qualification: data.qualification,
        specialization: data.specialization,
        experience: data.experience,
        regNumber: data.regNumber,
        stateCouncil: data.stateCouncil,
        validTill: data.validTill,
      );

      print("STEP 2 RESPONSE");
      print(response.data);

      return true;
    } on DioException catch (e) {
      if (e.response?.data["errors"] != null) {
        error = e.response!.data["errors"].toString();
      } else {
        error = e.response?.data["message"] ?? "Step 2 Failed";
      }

      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerStep3(DoctorFormData data) async {
    try {
      isLoading = true;
      error = null;

      notifyListeners();

      final response = await _service.registerStep3(data: data);

      print("STEP 3");
      print(response.data);

      return true;
    } on DioException catch (e) {
      error = e.response?.data["message"] ?? "Step 3 Failed";
      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveStep4(DoctorFormData data) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.registerStep4(data: data);

      isLoading = false;
      notifyListeners();

      return response.statusCode == 200;
    } on DioException catch (e) {
      error = e.response?.data["message"] ?? "Step 4 Failed";

      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> saveStep5(DoctorFormData data) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.registerStep5(data: data);

      isLoading = false;
      notifyListeners();

      return response.statusCode == 200;
    } on DioException catch (e) {
      error = e.response?.data["message"] ?? "Step 5 Failed";

      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> saveStep6(DoctorFormData data) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.registerStep6(data: data);

      isLoading = false;
      notifyListeners();

      return response.statusCode == 200;
    } on DioException catch (e) {
      error = e.response?.data["message"] ?? "Step 6 Failed";

      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> submitRegistration(DoctorFormData data) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.submitRegistration(data: data);

      isLoading = false;
      notifyListeners();

      return response.statusCode == 200;
    } on DioException catch (e) {
      error = e.response?.data["message"] ?? "Registration Failed";

      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  void clear() {
    error = null;
    isLoading = false;
    notifyListeners();
  }

  Future<void> logoutRegistration() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("doctor_register_token");

    clear();
  }
}

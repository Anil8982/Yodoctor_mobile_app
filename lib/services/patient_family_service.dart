import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class PatientFamilyService {
  Future<Response> getFamilyMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final res = await ApiService.dio.get(
      "/patient/getfamily",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    print("FAMILY STATUS = ${res.statusCode}");
    print("FAMILY DATA = ${res.data}");

    return res;
  }

  Future<Response> addFamilyMember({
    required String fullName,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String heightCm,
    required String weightKg,
    required String relation,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return ApiService.dio.post(
      "/patient/addfamily",
      data: {
        "fullName": fullName,
        "gender": gender,
        "dob": dob,
        "bloodGroup": bloodGroup,
        "heightCm": heightCm,
        "weightKg": weightKg,
        "relation": relation,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> updateFamilyMember({
    required int id,
    required String fullName,
    required String gender,
    required String dob,
    required String bloodGroup,
    required String heightCm,
    required String weightKg,
    required String relation,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return ApiService.dio.put(
      "/patient/updatefamily/$id",
      data: {
        "fullName": fullName,
        "gender": gender,
        "dob": dob,
        "bloodGroup": bloodGroup,
        "heightCm": heightCm,
        "weightKg": weightKg,
        "relation": relation,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> deleteFamilyMember(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return ApiService.dio.delete(
      "/patient/deletefamily/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

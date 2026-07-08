import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';
import '../modules/auth/models/doctor_register_model.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class DoctorRegisterService {
  Future<Response> registerStep1({
    required String fullName,
    required String email,
    required String mobile,
    required String gender,
    required List<String> languages,
    required String bio,
    required String password,
    required String confirmPassword,
  }) {
    return ApiService.dio.post(
      "/doctor/register",
      data: {
        "fullName": fullName,
        "email": email,
        "mobile": mobile,
        "gender": gender,
        "languages": languages,
        "bio": bio,
        "password": password,
        "confirmPassword": confirmPassword,
      },
    );
  }

  Future<Response> registerStep2({
    required String qualification,
    required String specialization,
    required String experience,
    required String regNumber,
    required String stateCouncil,
    required DateTime? validTill,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_register_token");

    return ApiService.dio.patch(
      "/doctor/registration/step-2",
      data: {
        "qualification": qualification,
        "specialization": specialization,
        "experience": experience,
        "regNumber": regNumber,
        "stateCouncil": stateCouncil,
        "validTill": validTill == null
            ? null
            : DateFormat("yyyy-MM-dd").format(validTill),
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> registerStep3({required DoctorFormData data}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_register_token");

    return ApiService.dio.patch(
      "/doctor/registration/step-3",
      options: Options(headers: {"Authorization": "Bearer $token"}),
      data: {
        "clinic": [
          {
            "clinicName": data.clinicName,
            "address": data.address,
            "city": data.city,
            "state": data.state,
            "pincode": data.pincode,
            "landmark": data.landmark,
            "mapsLink": data.mapsLink,
            "languages": data.languages,
          },
        ],
      },
    );
  }

  Future<Response> registerStep4({required DoctorFormData data}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_register_token");

    return ApiService.dio.patch(
      "/doctor/registration/step-4",
      data: {
        "practiceType": data.practiceType,
        "hospitalName": data.hospitalName,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> registerStep5({required DoctorFormData data}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_register_token");

    return ApiService.dio.patch(
      "/doctor/registration/step-5",
      data: {
        "fee": data.fee,
        "duration": data.duration,
        "selectedDays": data.selectedDays,
        "morningEnabled": data.morningEnabled,
        "morningStart": data.morningStart.split(":").first,
        "morningEnd": data.morningEnd.split(":").first,
        "eveningEnabled": data.eveningEnabled,
        "eveningStart": data.eveningStart.isEmpty
            ? null
            : data.eveningStart.split(":").first,
        "eveningEnd": data.eveningEnd.isEmpty
            ? null
            : data.eveningEnd.split(":").first,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> registerStep6({required DoctorFormData data}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_register_token");

    final formData = FormData.fromMap({
      "profile": await MultipartFile.fromFile(
        data.profileFile!.path,
        filename: basename(data.profileFile!.path),
      ),

      "certificate": await MultipartFile.fromFile(
        data.certificateFile!.path,
        filename: basename(data.certificateFile!.path),
      ),

      "idProof": await MultipartFile.fromFile(
        data.idProofFile!.path,
        filename: basename(data.idProofFile!.path),
      ),

      if (data.clinicProofFile != null)
        "clinicProof": await MultipartFile.fromFile(
          data.clinicProofFile!.path,
          filename: basename(data.clinicProofFile!.path),
        ),
    });

    return ApiService.dio.patch(
      "/doctor/registration/step-6",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }

  Future<Response> submitRegistration({required DoctorFormData data}) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("doctor_register_token");

    return ApiService.dio.patch(
      "/doctor/registration/submit",
      data: {
        "accurate": data.declAccurate,
        "display": data.declDisplay,
        "privacy": data.declPrivacy,
        "terms": data.declTerms,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}

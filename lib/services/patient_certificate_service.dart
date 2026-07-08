import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class PatientCertificateService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<Response> createRequest(Map<String, dynamic> data) async {
    final token = await _token();

    return ApiService.dio.post(
      "/certificate/create",
      data: data,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> uploadDocuments({
    required int requestId,
    String? profilePhoto,
    String? idProof,
    String? medicalReports,
    String? prescription,
  }) async {
    final token = await _token();

    final formData = FormData.fromMap({
      "request_id": requestId,

      if (profilePhoto != null)
        "profilePhoto": await MultipartFile.fromFile(profilePhoto),

      if (idProof != null) "idProof": await MultipartFile.fromFile(idProof),

      if (medicalReports != null)
        "medicalReports": await MultipartFile.fromFile(medicalReports),

      if (prescription != null)
        "prescription": await MultipartFile.fromFile(prescription),
    });

    return ApiService.dio.post(
      "/certificate/upload",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }

  Future<Response> getMyRequests() async {
    final token = await _token();

    return ApiService.dio.get(
      "/certificate/my-requests",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getRequestDetail(int id) async {
    final token = await _token();

    return ApiService.dio.get(
      "/certificate/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> downloadCertificate(int id) async {
    final token = await _token();

    return ApiService.dio.get(
      "/certificate/download/$id",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
        responseType: ResponseType.bytes,
      ),
    );
  }

  Future<Response> getDoctors() async {
    return ApiService.dio.get("/doctor/alldoctors");
  }
}

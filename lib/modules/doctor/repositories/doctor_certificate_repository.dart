import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final doctorCertificateRepositoryProvider = Provider<DoctorCertificateRepository>((ref) {
  return DoctorCertificateRepository(ref.read(dioProvider));
});

class DoctorCertificateRepository {
  DoctorCertificateRepository(this._dio);
  final Dio _dio;

  Future<Response> getRequests() {
    return _dio.get(ApiConstants.certificateRequests);
  }

  Future<Response> getIssuedCertificates() {
    return _dio.get(ApiConstants.issuedCertificates);
  }

  Future<Response> approve({
    required int id,
    required String doctorNotes,
    required String fitnessStatus,
    required int validity,
  }) {
    return _dio.put(
      '${ApiConstants.approveCertificate}/$id',
      data: {
        "doctor_notes": doctorNotes,
        "fitness_status": fitnessStatus,
        "validity": validity,
      },
    );
  }

  Future<Response> reject(int id) {
    return _dio.put('${ApiConstants.rejectCertificate}/$id');
  }

  Future<Response> getRequestDetails(int id) {
    return _dio.get('${ApiConstants.certificateRequests}/$id');
  }

  Future<Response> getDocuments(int id) {
    return _dio.get('${ApiConstants.certificateDocuments}/$id');
  }

  Future<Response> downloadDocument(String fileUrl) {
    return _dio.get(
      fileUrl,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
  }
}
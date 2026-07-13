import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final patientAppointmentHistoryRepositoryProvider = Provider<PatientAppointmentHistoryRepository>((ref) {
  return PatientAppointmentHistoryRepository(ref.read(dioProvider));
});

class PatientAppointmentHistoryRepository {
  PatientAppointmentHistoryRepository(this._dio);
  final Dio _dio;

  Future<Response> getAppointmentHistory({String? cursor, int limit = 10}) {
    return _dio.get(
      ApiConstants.appointmentHistory,
      queryParameters: {
        "limit": limit,
        "cursor": ?cursor,
      },
    );
  }

  Future<Response> submitDoctorReview({
    required int appointmentId,
    required int rating,
    required String comment,
  }) {
    return _dio.post(
      ApiConstants.submitDoctorReview,
      data: {
        "appointmentId": appointmentId,
        "rating": rating,
        "comment": comment,
      },
    );
  }

  Future<Response> getPrescription(int appointmentId) {
    return _dio.get('${ApiConstants.getPrescription}/$appointmentId/prescription');
  }
}
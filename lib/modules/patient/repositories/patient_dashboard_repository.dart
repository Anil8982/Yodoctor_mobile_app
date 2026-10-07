import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final patientDashboardRepositoryProvider = Provider<PatientDashboardRepository>((ref) {
  return PatientDashboardRepository(ref.read(dioProvider));
});

class PatientDashboardRepository {
  PatientDashboardRepository(this._dio);
  final Dio _dio;

  Future<Response> getDashboard() {
    return _dio.get(ApiConstants.patientDashboard);
  }

  Future<Response> cancelAppointment(int appointmentId) {
    return _dio.put('${ApiConstants.cancelAppointment}/$appointmentId/cancel');
  }

  Future<Response> getTokenStatus(int appointmentId) {
    return _dio.get('${ApiConstants.tokenStatus}/$appointmentId');
  }
}
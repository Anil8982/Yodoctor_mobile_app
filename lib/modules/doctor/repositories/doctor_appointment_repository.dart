import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final doctorAppointmentRepositoryProvider = Provider<DoctorAppointmentRepository>((ref) {
  return DoctorAppointmentRepository(ref.read(dioProvider));
});

class DoctorAppointmentRepository {
  DoctorAppointmentRepository(this._dio);
  final Dio _dio;

  Future<Response> getHistory({String? filter, int page = 1}) {
    return _dio.get(
      ApiConstants.doctorHistory,
      queryParameters: {
        "filter": ?filter,
        "page": page,
      },
    );
  }

  Future<Response> getTodayQueue({required String slot}) {
    return _dio.get(ApiConstants.todayQueue, queryParameters: {"slot": slot});
  }

  Future<Response> getCurrentPatient({required String slot}) {
    return _dio.get(ApiConstants.currentToken, queryParameters: {"slot": slot});
  }

  Future<Response> getNextPatient({required String slot}) {
    return _dio.get(ApiConstants.nextPatient, queryParameters: {"slot": slot});
  }

  Future<Response> startAppointment({required String appointmentId, required String slot}) {
    return _dio.put('${ApiConstants.startAppointment}/$appointmentId/start', data: {"slot": slot});
  }

  Future<Response> skipAppointment(String appointmentId) {
    return _dio.put('${ApiConstants.skipAppointment}/$appointmentId/skip');
  }

  Future<Response> callNextToken({required String slot}) {
    return _dio.post(ApiConstants.nextToken, data: {"slot": slot});
  }

  Future<Response> addPrescription({
    required String appointmentId,
    required String medicines,
    required String instructions,
  }) {
    return _dio.post('${ApiConstants.addPrescription}/$appointmentId/prescription', data: {
      "medicines": medicines,
      "instructions": instructions,
    });
  }

  Future<Response> getPrescription(String appointmentId) {
    return _dio.get('${ApiConstants.getPrescriptionDoctor}/$appointmentId');
  }

  Future<Response> completeAppointment(String appointmentId) {
    return _dio.post('${ApiConstants.completeAppointment}/$appointmentId/summary', data: {
      "diagnosis": "",
      "notes": "",
    });
  }

  Future<Response> noShow(String slot) {
    return _dio.put(ApiConstants.noShow, data: {"slot": slot});
  }

  Future<Response> recallPatient(String appointmentId) {
    return _dio.put('${ApiConstants.recallPatient}/$appointmentId');
  }

  Future<Response> getIncomingAppointments() {
    return _dio.get(ApiConstants.incomingAppointments);
  }

  Future<Response> respondAppointment(String id, String action) {
    return _dio.put('${ApiConstants.respondAppointment}/$id', data: {"action": action});
  }

  Future<Response> autoAcceptAllAppointments() {
    return _dio.put(ApiConstants.autoAccept);
  }
}
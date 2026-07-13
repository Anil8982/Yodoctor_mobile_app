import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import '../models/appointment/book_appointment_request.dart';

// Reactive Provider with constructor dependency injection via ref.read
final patientAppointmentRepositoryProvider = Provider<PatientAppointmentRepository>((ref) {
  return PatientAppointmentRepository(ref.read(dioProvider));
});

class PatientAppointmentRepository {
  PatientAppointmentRepository(this._dio);

  final Dio _dio;

  /// Sends the appointment request to the backend using active interceptors pipeline
  Future<Response> bookAppointment(BookAppointmentRequest request) {
    return _dio.post(
      ApiConstants.bookAppointment,
      data: request.toJson(),
    );
  }
}
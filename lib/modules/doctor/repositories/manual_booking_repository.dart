import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final manualBookingRepositoryProvider = Provider<ManualBookingRepository>((ref) {
  return ManualBookingRepository(ref.read(dioProvider));
});

class ManualBookingRepository {
  ManualBookingRepository(this._dio);
  final Dio _dio;

  Future<Response> bookPatient({
    required String patientName,
    required String patientMobile,
    required int patientAge,
    required String slot,
    String appointmentType = "CLINIC",
  }) {
    return _dio.post(
      ApiConstants.manualBooking,
      data: {
        "appointmentType": appointmentType,
        "slot": slot,
        "patientName": patientName,
        "patientMobile": patientMobile,
        "patientAge": patientAge,
      },
    );
  }
}
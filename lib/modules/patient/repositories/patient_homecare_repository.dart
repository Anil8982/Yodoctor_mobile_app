import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final patientHomeCareRepositoryProvider = Provider<PatientHomeCareRepository>((ref) {
  return PatientHomeCareRepository(ref.read(dioProvider));
});

class PatientHomeCareRepository {
  PatientHomeCareRepository(this._dio);

  final Dio _dio;

  Future<Response> createBooking(Map<String, dynamic> data) {
    return _dio.post(
      ApiConstants.bookHomeCare,
      data: data,
    );
  }

  Future<Response> getBookings() {
    return _dio.get(
      ApiConstants.getHomeCareBookings,
    );
  }
}
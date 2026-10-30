import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final doctorDashboardRepositoryProvider = Provider<DoctorDashboardRepository>((ref) {
  return DoctorDashboardRepository(ref.read(dioProvider));
});

class DoctorDashboardRepository {
  DoctorDashboardRepository(this._dio);
  final Dio _dio;

  Future<Response> getDashboard() {
    return _dio.get(ApiConstants.doctorDashboard);
  }

  Future<Response> updateAvailability(bool isAvailable) {
    return _dio.put(
      ApiConstants.doctorAvailability,
      data: {"isAvailable": isAvailable},
    );
  }
}
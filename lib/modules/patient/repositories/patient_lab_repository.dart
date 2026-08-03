import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final patientLabRepositoryProvider = Provider<PatientLabRepository>((ref) {
  return PatientLabRepository(ref.read(dioProvider));
});

class PatientLabRepository {
  PatientLabRepository(this._dio);
  final Dio _dio;

  Future<Response> getCategories() {
    return _dio.get(ApiConstants.labCategories);
  }

  Future<Response> getTests({String? search, int? category, String? tier}) {
    return _dio.get(
      ApiConstants.labTests,
      queryParameters: {
        "search": ?search,
        "category": ?category,
        "tier": ?tier,
      },
    );
  }

  Future<Response> getPopularTests() {
    return _dio.get(ApiConstants.popularLabTests);
  }

  Future<Response> getPackages() {
    return _dio.get(ApiConstants.labPackages);
  }

  Future<Response> getTestDetails(int id) {
    return _dio.get('${ApiConstants.labTests}/$id');
  }

  Future<Response> createBooking(Map<String, dynamic> data) {
    return _dio.post(ApiConstants.labBookings, data: data);
  }

  Future<Response> createLabPaymentOrder(int bookingId) {
    return _dio.post(
      ApiConstants.createLabPaymentOrder,
      data: {"booking_id": bookingId},
    );
  }

  Future<Response> verifyLabPayment(Map<String, dynamic> body) {
    return _dio.post(
      ApiConstants.verifyLabPayment,
      data: body,
    );
  }
}
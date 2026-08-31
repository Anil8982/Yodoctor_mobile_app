import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final patientSearchRepositoryProvider = Provider<PatientSearchRepository>((ref) {
  return PatientSearchRepository(ref.read(dioProvider));
});

class PatientSearchRepository {
  PatientSearchRepository(this._dio);
  final Dio _dio;

  Future<Response> searchDoctors({
    String search = "",
    String city = "",
    int page = 1,
    int limit = 10,
  }) {
    return _dio.get(
      ApiConstants.searchDoctors,
      queryParameters: {
        "search": search,
        "city": city,
        "page": page,
        "limit": limit,
      },
    );
  }

  Future<Response> getDoctorNames() {
    return _dio.get(ApiConstants.doctorNames);
  }

  Future<Response> getCities({String search = ""}) {
    return _dio.get(
      ApiConstants.cities,
      queryParameters: {"search": search},
    );
  }

  Future<Response> getSpecialties() {
    return _dio.get(ApiConstants.diseases);
  }

  Future<Response> getClinicNames() {
    return _dio.get(ApiConstants.clinicNames);
  }

  Future<Response> getPlaceNames() {
    return _dio.get(ApiConstants.clinicNames);
  }

  Future<Response> getDoctorById(int doctorId) {
    return _dio.get('${ApiConstants.doctorById}/$doctorId');
  }
}
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final patientFamilyRepositoryProvider = Provider<PatientFamilyRepository>((ref) {
  return PatientFamilyRepository(ref.read(dioProvider));
});

class PatientFamilyRepository {
  PatientFamilyRepository(this._dio);
  final Dio _dio;

  Future<Response> getFamilyMembers() {
    return _dio.get(ApiConstants.getFamily);
  }

  Future<Response> addFamilyMember(Map<String, dynamic> data) {
    return _dio.post(ApiConstants.addFamily, data: data);
  }

  Future<Response> updateFamilyMember(int id, Map<String, dynamic> data) {
    return _dio.put('${ApiConstants.updateFamily}/$id', data: data);
  }

  Future<Response> deleteFamilyMember(int id) {
    return _dio.delete('${ApiConstants.deleteFamily}/$id');
  }
}
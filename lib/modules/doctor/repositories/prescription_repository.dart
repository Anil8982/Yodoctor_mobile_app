
import 'package:debug_bubble/debug_bubble.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import 'package:yodoctor/modules/doctor/models/appointment/prescription_model.dart';


final prescriptionRepositoryProvider =
Provider<PrescriptionRepository>((ref) {
  return PrescriptionRepository(ref.read(dioProvider));
});

class PrescriptionRepository {
  PrescriptionRepository(this._dio);

  final Dio _dio;

  /// API 1: POST Add Prescription
  Future<Response> addPrescription({
    required String appointmentId,
    required PrescriptionModel prescription,
  }) async {
    return _dio.post(
      ApiConstants.addPrescription(appointmentId),
      data: {
        'symptoms': prescription.symptoms,
        'diagnosis': prescription.diagnosis,
        'medicines': prescription.medicines
            .map((medicine) => medicine.toJson())
            .toList(),
        'tests': prescription.tests,
        'advice': prescription.advice,
        if (prescription.followUpAfter != null &&
            prescription.followUpAfter!.trim().isNotEmpty)
          'follow_up_after': prescription.followUpAfter!.trim(),
        if (prescription.followUpDate != null &&
            prescription.followUpDate!.trim().isNotEmpty)
          'follow_up_date': prescription.followUpDate!.trim(),
        if (prescription.followUpNotes != null &&
            prescription.followUpNotes!.trim().isNotEmpty)
          'follow_up_notes': prescription.followUpNotes!.trim(),
      },
    );
  }

  /// API 2: GET Prescription JSON
  Future<PrescriptionModel> getPrescription(
      String appointmentId,
      ) async {
    final response = await _dio.get(
      ApiConstants.getPrescriptionDoctor(appointmentId),
    );

    final data = Map<String, dynamic>.from(
      response.data as Map,
    );

    return PrescriptionModel.fromJson(data);
  }

  /// API 2: Download generated PDF or original uploaded file
  Future<List<int>> downloadPrescription({
    required String appointmentId,
    required String format,
  }) async {
    if (format != 'pdf' && format != 'original') {
      throw ArgumentError(
        'format must be either pdf or original',
      );
    }

    final response = await _dio.get<List<int>>(
      ApiConstants.getPrescriptionDoctor(appointmentId),
      queryParameters: {'format': format},
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    final bytes = response.data;

    if (bytes == null || bytes.isEmpty) {
      DebugLog.warning('Prescription file is empty.', tag: 'Doctor Prescription Repository');
      throw Exception('Prescription file is empty.');
    }

    return bytes;
  }

  /// API 3: POST Upload Prescription
  Future<Response> uploadPrescription({
    required String appointmentId,
    required String filePath,
  }) async {
    final fileName = filePath.split(RegExp(r'[/\\]')).last;

    final formData = FormData.fromMap({
      'prescription': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    return _dio.post(
      ApiConstants.uploadPrescription(appointmentId),
      data: formData,
    );
  }
}

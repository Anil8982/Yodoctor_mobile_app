import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final patientCertificateRepositoryProvider =
    Provider<PatientCertificateRepository>((ref) {
      return PatientCertificateRepository(ref.read(dioProvider));
    });

class PatientCertificateRepository {
  PatientCertificateRepository(this._dio);

  final Dio _dio;

  static const String _subTag = 'PatientCertificate';

  Future<Response> createRequest(Map<String, dynamic> data) async {
    AppLogger.info(
      'Creating certificate request',
      tag: LogTags.api,
      subTag: _subTag,
    );
    AppLogger.json(data, tag: LogTags.api, subTag: _subTag);

    try {
      final response = await _dio.post(
        ApiConstants.createCertificate,
        data: data,
      );
      AppLogger.success(
        'Certificate request created successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to create certificate request',
        tag: LogTags.api,
        subTag: _subTag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<Response> uploadDocuments({
    required int requestId,
    String? profilePhoto,
    String? idProof,
    String? medicalReports,
    String? prescription,
  }) async {
    AppLogger.info(
      'Uploading documents for request ID: $requestId',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final formData = FormData.fromMap({
        'request_id': requestId,
        if (profilePhoto != null)
          'profilePhoto': await MultipartFile.fromFile(profilePhoto),
        if (idProof != null) 'idProof': await MultipartFile.fromFile(idProof),
        if (medicalReports != null)
          'medicalReports': await MultipartFile.fromFile(medicalReports),
        if (prescription != null)
          'prescription': await MultipartFile.fromFile(prescription),
      });

      final response = await _dio.post(
        ApiConstants.uploadCertificateDocuments,
        data: formData,
      );
      AppLogger.success(
        'Documents uploaded successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to upload documents',
        tag: LogTags.api,
        subTag: _subTag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<Response> getMyRequests() async {
    AppLogger.info(
      'Fetching my certificate requests',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final response = await _dio.get(ApiConstants.myCertificates);
      AppLogger.success(
        'Fetched certificate requests successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to fetch certificate requests',
        tag: LogTags.api,
        subTag: _subTag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<Response> getRequestDetail(int id) async {
    AppLogger.info(
      'Fetching request detail for ID: $id',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final response = await _dio.get('${ApiConstants.certificateDetail}/$id');
      AppLogger.success(
        'Fetched request details successfully for ID: $id',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to fetch request detail for ID: $id',
        tag: LogTags.api,
        subTag: _subTag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<Response> downloadCertificate(int id) async {
    AppLogger.info(
      'Downloading certificate for ID: $id',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final response = await _dio.get(
        '${ApiConstants.downloadCertificate}/$id',
        options: Options(responseType: ResponseType.bytes),
      );
      AppLogger.success(
        'Certificate downloaded successfully for ID: $id',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to download certificate for ID: $id',
        tag: LogTags.api,
        subTag: _subTag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<Response> getDoctors() async {
    AppLogger.info(
      'Fetching certificate doctors',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final response = await _dio.get(ApiConstants.certificateDoctors);

      AppLogger.success(
        'Fetched certificate doctors successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );

      return response;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to fetch certificate doctors',
        tag: LogTags.api,
        subTag: _subTag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  // --- Certificate Payment ---

  Future<Response> createPaymentOrder(Map<String, dynamic> data) async {
    AppLogger.info(
      'Creating certificate payment order',
      tag: LogTags.api,
      subTag: _subTag,
    );
    AppLogger.json(data, tag: LogTags.api, subTag: _subTag);

    try {
      final response = await _dio.post(
        ApiConstants.createCertificatePaymentOrder,
        data: data,
      );
      AppLogger.success(
        'Certificate payment order created successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );
      AppLogger.json(response.data, tag: LogTags.api, subTag: _subTag);
      return response;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to create certificate payment order',
        tag: LogTags.api,
        subTag: _subTag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<Response> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    AppLogger.info(
      'Verifying certificate payment',
      tag: LogTags.api,
      subTag: _subTag,
    );

    final data = {
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
    };

    AppLogger.json(data, tag: LogTags.api, subTag: _subTag);

    try {
      final response = await _dio.post(
        ApiConstants.verifyCertificatePayment,
        data: data,
      );
      AppLogger.success(
        'Certificate payment verified successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );
      AppLogger.json(response.data, tag: LogTags.api, subTag: _subTag);
      return response;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to verify certificate payment',
        tag: LogTags.api,
        subTag: _subTag,
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}

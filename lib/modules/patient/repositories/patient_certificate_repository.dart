import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
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
    DebugLog.info(
      'Creating certificate request',
      tag: LogTags.api,
      subTag: _subTag,
      json: data,
    );

    try {
      final response = await _dio.post(
        ApiConstants.createCertificate,
        data: data,
      );
      DebugLog.success(
        'Certificate request created successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      DebugLog.error(
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
    DebugLog.info(
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
      DebugLog.success(
        'Documents uploaded successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      DebugLog.error(
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
    DebugLog.info(
      'Fetching my certificate requests',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final response = await _dio.get(ApiConstants.myCertificates);
      DebugLog.success(
        'Fetched certificate requests successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      DebugLog.error(
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
    DebugLog.info(
      'Fetching request detail for ID: $id',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final response = await _dio.get('${ApiConstants.certificateDetail}/$id');
      DebugLog.success(
        'Fetched request details successfully for ID: $id',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      DebugLog.error(
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
    DebugLog.info(
      'Downloading certificate for ID: $id',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final response = await _dio.get(
        '${ApiConstants.downloadCertificate}/$id',
        options: Options(responseType: ResponseType.bytes),
      );
      DebugLog.success(
        'Certificate downloaded successfully for ID: $id',
        tag: LogTags.api,
        subTag: _subTag,
      );
      return response;
    } catch (e, stack) {
      DebugLog.error(
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
    DebugLog.info(
      'Fetching certificate doctors',
      tag: LogTags.api,
      subTag: _subTag,
    );

    try {
      final response = await _dio.get(ApiConstants.certificateDoctors);

      DebugLog.success(
        'Fetched certificate doctors successfully',
        tag: LogTags.api,
        subTag: _subTag,
      );

      return response;
    } catch (e, stack) {
      DebugLog.error(
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
    DebugLog.info(
      'Creating certificate payment order',
      tag: LogTags.api,
      subTag: _subTag,
      json: data,
    );

    try {
      final response = await _dio.post(
        ApiConstants.createCertificatePaymentOrder,
        data: data,
      );
      DebugLog.success(
        'Certificate payment order created successfully',
        tag: LogTags.api,
        subTag: _subTag,
        json: response.data,
      );
      return response;
    } catch (e, stack) {
      DebugLog.error(
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
    final data = {
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
    };

    DebugLog.info(
      'Verifying certificate payment',
      tag: LogTags.api,
      subTag: _subTag,
      json: data,
    );

    try {
      final response = await _dio.post(
        ApiConstants.verifyCertificatePayment,
        data: data,
      );
      DebugLog.success(
        'Certificate payment verified successfully',
        tag: LogTags.api,
        subTag: _subTag,
        json: response.data,
      );
      return response;
    } catch (e, stack) {
      DebugLog.error(
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

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.read(dioProvider));
});

class PaymentRepository {
  PaymentRepository(this._dio);
  final Dio _dio;
  static const String _subTag = 'PaymentRepository';

  Future<Response> createPaymentOrder({
    required double amount,
    String currency = "INR",
  }) {
    AppLogger.info('Creating payment order', tag: LogTags.payment, subTag: _subTag);
    return _dio.post(ApiConstants.createPaymentOrder, data: {
      "amount": amount,
      "currency": currency,
    });
  }

  Future<Response> verifyPayment(Map<String, dynamic> body) {
    AppLogger.info('Verifying payment', tag: LogTags.payment, subTag: _subTag);
    return _dio.post(ApiConstants.verifyPayment, data: body);
  }

  Future<Response> getInvoiceById(String invoiceId) {
    AppLogger.info('Fetching invoice: $invoiceId', tag: LogTags.payment, subTag: _subTag);
    return _dio.get('${ApiConstants.invoiceDetail}/$invoiceId');
  }

  Future<Response> downloadInvoice(String invoiceId) {
    AppLogger.info('Downloading invoice: $invoiceId', tag: LogTags.payment, subTag: _subTag);
    return _dio.get(
      '${ApiConstants.invoiceDetail}/$invoiceId/download',
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
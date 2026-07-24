import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.read(dioProvider));
});

class SubscriptionRepository {
  SubscriptionRepository(this._dio);
  final Dio _dio;
  static const String _subTag = 'SubscriptionRepository';

  Future<Response> getActiveSubscription() async {
    AppLogger.info('Fetching active subscription status from server', tag: LogTags.doctor, subTag: _subTag);
    try {
      return await _dio.get(ApiConstants.activeSubscription);
    } catch (e, st) {
      AppLogger.error('Failed to fetch active subscription', tag: LogTags.doctor, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> getBillingHistory() {
    return _dio.get(ApiConstants.billingHistory);
  }

  Future<Response> getPlans() {
    return _dio.get(ApiConstants.subscriptionPlans);
  }

  Future<Response> createSubscription({
    required String planId,
    String billing = "monthly",
    bool isUpgrade = true,
  }) {
    return _dio.post(
      ApiConstants.createSubscription,
      data: {"planId": planId, "billing": billing, "isUpgrade": isUpgrade},
    );
  }

  Future<Response> verifySubscription(Map<String, dynamic> body) {
    return _dio.post(ApiConstants.verifySubscription, data: body);
  }
}
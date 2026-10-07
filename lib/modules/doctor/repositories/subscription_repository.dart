// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:yodoctor/core/constants/api_constants.dart';
// import 'package:yodoctor/core/constants/log_tags.dart';
// import 'package:yodoctor/core/debug/app_logger.dart';
// import 'package:yodoctor/core/network/dio_provider.dart';
//
// final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
//   return SubscriptionRepository(ref.read(dioProvider));
// });
//
// class SubscriptionRepository {
//   SubscriptionRepository(this._dio);
//   final Dio _dio;
//   static const String _subTag = 'SubscriptionRepository';
//
//   Future<Response> getActiveSubscription() async {
//     AppLogger.info('Fetching active subscription status from server', tag: LogTags.doctor, subTag: _subTag);
//     try {
//       return await _dio.get(ApiConstants.activeSubscription);
//     } catch (e, st) {
//       AppLogger.error('Failed to fetch active subscription', tag: LogTags.doctor, subTag: _subTag, error: e, stackTrace: st);
//       rethrow;
//     }
//   }
//
//   // Updated with optional page and limit parameters with backward compatibility
//   Future<Response> getBillingHistory({int page = 1, int limit = 20}) {
//     return _dio.get(
//       ApiConstants.billingHistory,
//       queryParameters: {"page": page, "limit": limit},
//     );
//   }
//
//   Future<Response> getPlans() {
//     return _dio.get(ApiConstants.subscriptionPlans);
//   }
//
//   Future<Response> getPlanById(String planId) {
//     return _dio.get('${ApiConstants.planById}/$planId');
//   }
//
//   Future<Response> createSubscription({
//     required String planId,
//     String billing = "monthly",
//     bool isUpgrade = true,
//   }) {
//     return _dio.post(
//       ApiConstants.createSubscription,
//       data: {"planId": planId, "billing": billing, "isUpgrade": isUpgrade},
//     );
//   }
//
//   Future<Response> verifySubscription(Map<String, dynamic> body) {
//     return _dio.post(ApiConstants.verifySubscription, data: body);
//   }
//
//   Future<Response> getAllSubscriptions() {
//     return _dio.get(ApiConstants.allSubscriptions);
//   }
//
//   Future<Response> getSubscriptionById(String id) {
//     return _dio.get('${ApiConstants.subscriptionById}/$id');
//   }
//
//   Future<Response> cancelSubscription({
//     required String id,
//     bool cancelAtPeriodEnd = true,
//   }) {
//     return _dio.post(
//       '${ApiConstants.cancelSubscription}/$id/cancel',
//       data: {"cancel_at_period_end": cancelAtPeriodEnd},
//     );
//   }
//
//   Future<Response> upgradeSubscriptionPlan({
//     required String id,
//     required String newPlanId,
//   }) {
//     return _dio.post(
//       '${ApiConstants.upgradeSubscription}/$id/upgrade',
//       data: {"newPlanId": newPlanId},
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final subscriptionRepositoryProvider =
Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.read(dioProvider));
});

class SubscriptionRepository {
  SubscriptionRepository(this._dio);

  final Dio _dio;

  static const String _subTag = 'SubscriptionRepository';

  // ACTIVE SUBSCRIPTION
  Future<Response> getActiveSubscription() async {
    AppLogger.info(
      'Fetching active subscription status from server',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      return await _dio.get(
        ApiConstants.activeSubscription,
      );
    } catch (e, st) {
      AppLogger.error(
        'Failed to fetch active subscription',
        tag: LogTags.doctor,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  // BILLING HISTORY
  Future<Response> getBillingHistory({
    int page = 1,
    int limit = 20,
  }) {
    return _dio.get(
      ApiConstants.billingHistory,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
  }

  // PLANS

  /// Fetch all subscription plans.
  ///
  /// GET /razorpay/plans
  Future<Response> getPlans() {
    return _dio.get(
      ApiConstants.subscriptionPlans,
    );
  }

  /// Fetch a single plan.
  ///
  /// GET /razorpay/plans/:planId
  Future<Response> getPlanById(String planId) {
    return _dio.get(
      '${ApiConstants.planById}/$planId',
    );
  }

  // FIRST OFFER / ₹1 TRIAL
  /// Create the ₹1 first-offer order.
  ///
  /// This is ONLY for the first-time trial plan.
  ///
  /// POST /razorpay/first-offer/order
  Future<Response> createFirstOfferOrder({
    required String planId,
    String billing = 'monthly',
  }) {
    return _dio.post(
      ApiConstants.firstOfferOrder,
      data: {
        'planId': planId,
        'billing': billing,
      },
    );
  }

  /// Verify the ₹1 first-offer payment.
  ///
  /// POST /razorpay/first-offer/verify
  Future<Response> verifyFirstOffer({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) {
    return _dio.post(
      ApiConstants.firstOfferVerify,
      data: {
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
      },
    );
  }

  // CREATE SUBSCRIPTION / UPGRADE
  /// Create a normal subscription.
  ///
  /// The same API is also used for upgrading
  /// an existing subscription.
  ///
  /// POST /razorpay/subscriptions/create
  Future<Response> createSubscription({
    required String planId,
    String billing = 'monthly',
  }) {
    return _dio.post(
      ApiConstants.createSubscription,
      data: {
        'planId': planId,
        'billing': billing,
      },
    );
  }

  // VERIFY SUBSCRIPTION
  /// Verify normal subscription payment.
  ///
  /// POST /razorpay/subscriptions/verify
  Future<Response> verifySubscription({
    required String razorpayPaymentId,
    required String razorpaySubscriptionId,
    required String razorpaySignature,
    required String localSubscriptionId,
  }) {
    return _dio.post(
      ApiConstants.verifySubscription,
      data: {
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_subscription_id': razorpaySubscriptionId,
        'razorpay_signature': razorpaySignature,
        'local_subscription_id': localSubscriptionId,
      },
    );
  }

  // ALL SUBSCRIPTIONS
  Future<Response> getAllSubscriptions() {
    return _dio.get(
      ApiConstants.allSubscriptions,
    );
  }

  // SUBSCRIPTION BY ID
  Future<Response> getSubscriptionById(String id) {
    return _dio.get(
      '${ApiConstants.subscriptionById}/$id',
    );
  }

  // CANCEL SUBSCRIPTION
  Future<Response> cancelSubscription({
    required String id,
    bool cancelAtPeriodEnd = true,
  }) {
    return _dio.post(
      '${ApiConstants.cancelSubscription}/$id/cancel',
      data: {
        'cancel_at_period_end': cancelAtPeriodEnd,
      },
    );
  }
}
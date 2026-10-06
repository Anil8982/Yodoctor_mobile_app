// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:yodoctor/core/constants/log_tags.dart';
// import 'package:yodoctor/core/debug/app_logger.dart';
// import 'package:yodoctor/modules/doctor/controllers/subscription_status_controller.dart';
// import 'package:yodoctor/modules/payment/controllers/razorpay_controller.dart';
// import 'package:yodoctor/modules/doctor/models/subscription/available_plan_model.dart';
// import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';
// import 'package:yodoctor/modules/payment/providers.dart';
// import '../repositories/subscription_repository.dart';
//
// enum PaymentFlowState { idle, processing, success, failed }
//
// class DoctorSubscriptionState {
//   final bool isLoading;
//   final SubscriptionPlan? currentPlan;
//   final List<BillingInvoice> billingHistory;
//   final List<AvailablePlan> allPlans;
//   final bool showPlans;
//   final bool isYearly;
//   final AvailablePlan? selectedNewPlan;
//   final String? errorMessage;
//   final bool isInitialized;
//   final int currentPage;
//   final bool hasMoreBilling;
//   final bool isLoadingMore;
//   final PaymentFlowState paymentFlow;
//   final String? paymentId;
//   final String? planName;
//
//   const DoctorSubscriptionState({
//     this.isLoading = false,
//     this.currentPlan,
//     this.billingHistory = const [],
//     this.allPlans = const [],
//     this.showPlans = false,
//     this.isYearly = false,
//     this.selectedNewPlan,
//     this.errorMessage,
//     this.isInitialized = false,
//     this.currentPage = 1,
//     this.hasMoreBilling = true,
//     this.isLoadingMore = false,
//     this.paymentFlow = PaymentFlowState.idle,
//     this.paymentId,
//     this.planName,
//   });
//
//   DoctorSubscriptionState copyWith({
//     bool? isLoading,
//     SubscriptionPlan? currentPlan,
//     bool clearCurrentPlan = false,
//     List<BillingInvoice>? billingHistory,
//     List<AvailablePlan>? allPlans,
//     bool? showPlans,
//     bool? isYearly,
//     AvailablePlan? selectedNewPlan,
//     bool clearSelectedPlan = false,
//     String? errorMessage,
//     bool clearError = false,
//     bool? isInitialized,
//     int? currentPage,
//     bool? hasMoreBilling,
//     bool? isLoadingMore,
//     PaymentFlowState? paymentFlow,
//     String? paymentId,
//     String? planName,
//   }) {
//     return DoctorSubscriptionState(
//       isLoading: isLoading ?? this.isLoading,
//       currentPlan: clearCurrentPlan ? null : (currentPlan ?? this.currentPlan),
//       billingHistory: billingHistory ?? this.billingHistory,
//       allPlans: allPlans ?? this.allPlans,
//       showPlans: showPlans ?? this.showPlans,
//       isYearly: isYearly ?? this.isYearly,
//       selectedNewPlan: clearSelectedPlan
//           ? null
//           : (selectedNewPlan ?? this.selectedNewPlan),
//       errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
//       isInitialized: isInitialized ?? this.isInitialized,
//       currentPage: currentPage ?? this.currentPage,
//       hasMoreBilling: hasMoreBilling ?? this.hasMoreBilling,
//       isLoadingMore: isLoadingMore ?? this.isLoadingMore,
//       paymentFlow: paymentFlow ?? this.paymentFlow,
//       paymentId: paymentId ?? this.paymentId,
//       planName: planName ?? this.planName,
//     );
//   }
// }
//
// final doctorSubscriptionProvider =
// NotifierProvider<DoctorSubscriptionNotifier, DoctorSubscriptionState>(
//   DoctorSubscriptionNotifier.new,
// );
//
// class DoctorSubscriptionNotifier extends Notifier<DoctorSubscriptionState> {
//   static const String _subTag = 'DoctorSubscriptionNotifier';
//
//   String? _pendingLocalSubscriptionId;
//   String? _pendingRazorpaySubscriptionId;
//   StreamSubscription<RazorpayEvent>? _razorpaySubscription;
//
//   @override
//   DoctorSubscriptionState build() {
//     AppLogger.info(
//       'DoctorSubscriptionNotifier Initialized',
//       tag: LogTags.doctor,
//       subTag: _subTag,
//     );
//
//     _listenToRazorpayEvents();
//
//     ref.onDispose(() {
//       _razorpaySubscription?.cancel();
//     });
//
//     return const DoctorSubscriptionState(isLoading: false);
//   }
//
//   void _listenToRazorpayEvents() {
//     final razorpayController = ref.read(razorpayControllerProvider);
//
//     _razorpaySubscription = razorpayController.events.listen(
//           (event) {
//         switch (event) {
//           case RazorpaySuccess(:final paymentId, :final signature):
//             _handlePaymentSuccess(paymentId, signature);
//
//           case RazorpayFailure(:final message):
//             _handlePaymentFailure(message, cancelled: false);
//
//           case RazorpayCancelled():
//             _handlePaymentFailure('Payment cancelled', cancelled: true);
//
//           case RazorpayExternalWallet():
//             _clearPendingPaymentData();
//         }
//       },
//       onError: (error) {
//         AppLogger.error(
//           'Razorpay event stream error: $error',
//           tag: LogTags.doctor,
//           subTag: _subTag,
//         );
//       },
//     );
//   }
//
//   // ============ Subscription Data Loading ============
//
//   Future<void> loadPlans() async {
//     if (state.allPlans.isNotEmpty) return;
//
//     state = state.copyWith(isLoading: true, clearError: true);
//
//     try {
//       final repository = ref.read(subscriptionRepositoryProvider);
//       final plansRes = await repository.getPlans();
//
//       if ((plansRes.statusCode ?? 0) >= 200 &&
//           (plansRes.statusCode ?? 0) < 300) {
//         final allPlans = (plansRes.data?["data"]?["plans"] as List? ?? [])
//             .map((e) => AvailablePlan.fromJson(Map<String, dynamic>.from(e)))
//             .toList();
//
//         state = state.copyWith(
//           isLoading: false,
//           allPlans: allPlans,
//           clearError: true,
//         );
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: "Failed to load plans",
//         );
//       }
//     } catch (e, st) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: 'Network error loading plans.',
//       );
//       AppLogger.exception(
//         e,
//         st,
//         message: 'Load plans failed',
//         tag: LogTags.doctor,
//         subTag: _subTag,
//       );
//     }
//   }
//
//   Future<void> loadSubscriptionDetails() async {
//     AppLogger.info(
//       'Loading subscription details',
//       tag: LogTags.doctor,
//       subTag: _subTag,
//     );
//     state = state.copyWith(isLoading: true, clearError: true, currentPage: 1);
//
//     try {
//       if (!ref.read(subscriptionStatusProvider).isResolved) {
//         AppLogger.info(
//           'Waiting for subscription status to resolve...',
//           tag: LogTags.doctor,
//           subTag: _subTag,
//         );
//         await ref.read(subscriptionStatusProvider.notifier).checkActiveSubscription();
//       }
//
//       final subStatus = ref.read(subscriptionStatusProvider);
//
//       if (!subStatus.hasSubscription) {
//         AppLogger.info(
//           'No active subscription (from cache), skipping duplicate API call',
//           tag: LogTags.doctor,
//           subTag: _subTag,
//         );
//         state = state.copyWith(
//           isLoading: false,
//           currentPlan: null,
//           clearCurrentPlan: true,
//           showPlans: true,
//           isInitialized: true,
//           clearError: true,
//         );
//         return;
//       }
//
//       final repository = ref.read(subscriptionRepositoryProvider);
//
//       // Fetch active subscription details
//       final subRes = await repository.getActiveSubscription();
//       final statusCode = subRes.statusCode ?? 0;
//
//       // Fetch billing history
//       final historyRes = await repository.getBillingHistory(page: 1, limit: 20);
//
//       if (statusCode >= 200 && statusCode < 300) {
//         SubscriptionPlan? currentPlan;
//         final rawSubscription =
//             subRes.data?["subscription"] ?? subRes.data?["data"]?["subscription"];
//         if (rawSubscription is Map && rawSubscription.isNotEmpty) {
//           currentPlan = SubscriptionPlan.fromJson(
//             Map<String, dynamic>.from(rawSubscription),
//           );
//         }
//
//         final billingHistory =
//         (historyRes.data?["data"]?["invoices"] as List? ?? [])
//             .map((e) => BillingInvoice.fromJson(Map<String, dynamic>.from(e)))
//             .toList();
//
//         final totalPages = _parseTotalPages(
//           historyRes.data?["data"]?["totalPages"],
//         );
//
//         final bool hasNoActivePlan = currentPlan == null || !currentPlan.isActive;
//
//         state = state.copyWith(
//           isLoading: false,
//           currentPlan: currentPlan,
//           clearCurrentPlan: currentPlan == null,
//           billingHistory: billingHistory,
//           showPlans: hasNoActivePlan,
//           isInitialized: true,
//           clearError: true,
//           currentPage: 1,
//           hasMoreBilling: 1 < totalPages,
//         );
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: "Failed to load subscription data",
//           isInitialized: true,
//         );
//       }
//     } catch (e, st) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: "Network error. Pull to retry.",
//         isInitialized: true,
//       );
//       AppLogger.exception(
//         e, st,
//         message: 'Subscription load failed',
//         tag: LogTags.doctor,
//         subTag: _subTag,
//       );
//     }
//   }
//
//   int _parseTotalPages(dynamic value) {
//     if (value is int) return value;
//     return int.tryParse(value.toString()) ?? 1;
//   }
//
//   Future<void> loadMoreBillingHistory() async {
//     if (state.isLoadingMore || !state.hasMoreBilling) return;
//     state = state.copyWith(isLoadingMore: true);
//
//     try {
//       final nextPage = state.currentPage + 1;
//       final repository = ref.read(subscriptionRepositoryProvider);
//       final historyRes = await repository.getBillingHistory(
//         page: nextPage,
//         limit: 20,
//       );
//
//       if ((historyRes.statusCode ?? 0) >= 200 &&
//           (historyRes.statusCode ?? 0) < 300) {
//         final moreHistory =
//         (historyRes.data?["data"]?["invoices"] as List? ?? [])
//             .map(
//               (e) => BillingInvoice.fromJson(Map<String, dynamic>.from(e)),
//         )
//             .toList();
//         final totalPages = _parseTotalPages(
//           historyRes.data?["data"]?["totalPages"],
//         );
//
//         state = state.copyWith(
//           billingHistory: [...state.billingHistory, ...moreHistory],
//           currentPage: nextPage,
//           hasMoreBilling: nextPage < totalPages,
//           isLoadingMore: false,
//         );
//       } else {
//         state = state.copyWith(isLoadingMore: false);
//       }
//     } catch (e) {
//       state = state.copyWith(isLoadingMore: false);
//       AppLogger.error(
//         'Failed to load more billing history: $e',
//         tag: LogTags.doctor,
//         subTag: _subTag,
//       );
//     }
//   }
//
//   // ============ Plan Selection ============
//
//   void toggleDuration(bool isYearly) =>
//       state = state.copyWith(isYearly: isYearly, clearSelectedPlan: true);
//
//   void selectNewPlan(AvailablePlan plan) =>
//       state = state.copyWith(selectedNewPlan: plan);
//
//   void showUpgradePlans() => state = state.copyWith(showPlans: true);
//
//   List<AvailablePlan> getAvailablePlans() {
//     final targetCycle = state.isYearly ? "yearly" : "monthly";
//     return state.allPlans.where((p) {
//       if (p.category.isNotEmpty) return p.category.toLowerCase() == targetCycle;
//       final d = p.durationText.toLowerCase(), t = p.title.toLowerCase();
//       return targetCycle == "yearly"
//           ? d.contains("year") || d.contains("yr") || t.contains("year")
//           : d.contains("month") ||
//           d.contains("mo") ||
//           d.contains("trial") ||
//           t.contains("month") ||
//           t.contains("trial");
//     }).toList();
//   }
//
//   Future<void> refreshData() async => await loadSubscriptionDetails();
//
//   // ============ Plan Upgrade/Purchase Flow ============
//
//   Future<bool> upgradePlan() async {
//     if (state.selectedNewPlan == null || state.isLoading) return false;
//
//     if (state.currentPlan != null &&
//         state.currentPlan!.planId == state.selectedNewPlan!.id) {
//       state = state.copyWith(
//         errorMessage: "You are already subscribed to this plan.",
//       );
//       return false;
//     }
//
//     final hasActiveSub =
//         state.currentPlan != null && state.currentPlan!.isActive;
//
//     return hasActiveSub
//         ? await _upgradeExistingSubscription()
//         : await _createNewSubscriptionFlow();
//   }
//
//   Future<bool> cancelSubscription() async {
//     if (state.currentPlan == null || !state.currentPlan!.isActive) return false;
//
//     state = state.copyWith(isLoading: true, clearError: true);
//
//     try {
//       final repository = ref.read(subscriptionRepositoryProvider);
//       final response = await repository.cancelSubscription(
//         id: state.currentPlan!.id,
//       );
//
//       if ((response.statusCode ?? 0) >= 200 &&
//           (response.statusCode ?? 0) < 300) {
//         await loadSubscriptionDetails();
//         state = state.copyWith(isLoading: false, showPlans: true);
//         return true;
//       }
//
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: response.data?["message"] ?? "Cancellation failed",
//       );
//       return false;
//     } catch (e, st) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: 'Failed to cancel subscription.',
//       );
//       AppLogger.exception(
//         e,
//         st,
//         message: 'Cancel failed',
//         tag: LogTags.doctor,
//         subTag: _subTag,
//       );
//       return false;
//     }
//   }
//
//   Future<bool> _upgradeExistingSubscription() async {
//     state = state.copyWith(isLoading: true, clearError: true);
//
//     try {
//       final repository = ref.read(subscriptionRepositoryProvider);
//       final response = await repository.upgradeSubscriptionPlan(
//         id: state.currentPlan!.id,
//         newPlanId: state.selectedNewPlan!.id,
//       );
//
//       if ((response.statusCode ?? 0) >= 200 &&
//           (response.statusCode ?? 0) < 300) {
//         await loadSubscriptionDetails();
//         return true;
//       }
//
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: response.data?["message"] ?? "Upgrade failed",
//       );
//       return false;
//     } catch (e, st) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: 'Upgrade request failed.',
//       );
//       AppLogger.exception(
//         e,
//         st,
//         message: 'Upgrade failed',
//         tag: LogTags.doctor,
//         subTag: _subTag,
//       );
//       return false;
//     }
//   }
//
//   Future<bool> _createNewSubscriptionFlow() async {
//     state = state.copyWith(isLoading: true, clearError: true);
//
//     try {
//       final repository = ref.read(subscriptionRepositoryProvider);
//
//       final response = await repository.createSubscription(
//         planId: state.selectedNewPlan!.id,
//         billing: state.isYearly ? "yearly" : "monthly",
//
//         // New subscription flow must NOT be treated as an upgrade.
//         // Upgrade requests are handled separately by _upgradeExistingSubscription().
//         isUpgrade: false,
//       );
//
//       if ((response.statusCode ?? 0) >= 200 &&
//           (response.statusCode ?? 0) < 300) {
//         final data = response.data?["data"] ?? {};
//         final subId = data["subscription_id"] as String?;
//         final key = data["razorpay_key"] as String?;
//
//         if (subId != null && key != null) {
//           _pendingLocalSubscriptionId =
//           data["local_subscription_id"] as String?;
//           _pendingRazorpaySubscriptionId = subId;
//
//           final razorpayController = ref.read(razorpayControllerProvider);
//
//           razorpayController.openSubscriptionCheckout(
//             key: key,
//             subscriptionId: subId,
//             planName: state.selectedNewPlan?.title ?? 'Subscription Plan',
//             prefill: Map<String, String>.from(
//               data["prefill"] as Map<String, dynamic>? ?? {},
//             ),
//           );
//
//           return true;
//         }
//
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: "Invalid checkout configuration.",
//         );
//         return false;
//       }
//
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage:
//         response.data?["message"] ?? "Subscription creation failed",
//       );
//       return false;
//     } catch (e, st) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: 'Payment initialization failed.',
//       );
//
//       AppLogger.exception(
//         e,
//         st,
//         message: 'Subscription creation failed',
//         tag: LogTags.doctor,
//         subTag: _subTag,
//       );
//
//       return false;
//     }
//   }
//
//   // ============ Payment Result Handlers ============
//
//   Future<void> _handlePaymentSuccess(
//       String? paymentId,
//       String? signature,
//       ) async {
//     AppLogger.success(
//       'Processing payment success: $paymentId',
//       tag: LogTags.doctor,
//       subTag: _subTag,
//     );
//
//     state = state.copyWith(paymentFlow: PaymentFlowState.processing);
//
//     try {
//       final repository = ref.read(subscriptionRepositoryProvider);
//
//       final verifyRes = await repository.verifySubscription({
//         ?paymentId: "razorpay_payment_id",
//         ?_pendingRazorpaySubscriptionId: "razorpay_subscription_id",
//         ?signature: "razorpay_signature",
//         ?_pendingLocalSubscriptionId: "local_subscription_id",
//       });
//
//       _clearPendingPaymentData();
//
//       if ((verifyRes.statusCode ?? 0) >= 200 && (verifyRes.statusCode ?? 0) < 300) {
//         AppLogger.success(
//           'Subscription verified and activated',
//           tag: LogTags.doctor,
//           subTag: _subTag,
//         );
//
//         await loadSubscriptionDetails();
//
//         state = state.copyWith(
//           isLoading: false,
//           showPlans: false,
//           clearSelectedPlan: true,
//           clearError: true,
//           paymentFlow: PaymentFlowState.success,
//           paymentId: paymentId,
//           planName: state.selectedNewPlan?.title,
//         );
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: verifyRes.data?["message"] ?? "Verification failed",
//           paymentFlow: PaymentFlowState.failed,
//           paymentId: null,
//           planName: null,
//         );
//       }
//     } catch (e, st) {
//       _clearPendingPaymentData();
//
//       AppLogger.exception(
//         e,
//         st,
//         message: 'Verification error',
//         tag: LogTags.doctor,
//         subTag: _subTag,
//       );
//
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: 'Payment verification failed.',
//         paymentFlow: PaymentFlowState.failed,
//         paymentId: null,
//         planName: null,
//       );
//     }
//   }
//
//   void _handlePaymentFailure(String message, {required bool cancelled}) {
//     _clearPendingPaymentData();
//
//     state = state.copyWith(
//       isLoading: false,
//       errorMessage: cancelled
//           ? 'Payment cancelled'
//           : 'Payment failed: $message',
//       paymentFlow: PaymentFlowState.failed,
//       paymentId: null,
//       planName: null,
//     );
//   }
//
//   void _clearPendingPaymentData() {
//     _pendingLocalSubscriptionId = null;
//     _pendingRazorpaySubscriptionId = null;
//   }
// }

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/doctor/controllers/subscription_status_controller.dart';
import 'package:yodoctor/modules/payment/controllers/razorpay_controller.dart';
import 'package:yodoctor/modules/doctor/models/subscription/available_plan_model.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';
import 'package:yodoctor/modules/payment/providers.dart';
import '../repositories/subscription_repository.dart';

enum PaymentFlowState { idle, processing, success, failed }

class DoctorSubscriptionState {
  final bool isLoading;
  final SubscriptionPlan? currentPlan;
  final List<BillingInvoice> billingHistory;
  final List<AvailablePlan> allPlans;
  final bool showPlans;
  final bool isYearly;
  final AvailablePlan? selectedNewPlan;
  final String? errorMessage;
  final bool isInitialized;
  final int currentPage;
  final bool hasMoreBilling;
  final bool isLoadingMore;
  final PaymentFlowState paymentFlow;
  final String? paymentId;
  final String? planName;

  const DoctorSubscriptionState({
    this.isLoading = false,
    this.currentPlan,
    this.billingHistory = const [],
    this.allPlans = const [],
    this.showPlans = false,
    this.isYearly = false,
    this.selectedNewPlan,
    this.errorMessage,
    this.isInitialized = false,
    this.currentPage = 1,
    this.hasMoreBilling = true,
    this.isLoadingMore = false,
    this.paymentFlow = PaymentFlowState.idle,
    this.paymentId,
    this.planName,
  });

  DoctorSubscriptionState copyWith({
    bool? isLoading,
    SubscriptionPlan? currentPlan,
    bool clearCurrentPlan = false,
    List<BillingInvoice>? billingHistory,
    List<AvailablePlan>? allPlans,
    bool? showPlans,
    bool? isYearly,
    AvailablePlan? selectedNewPlan,
    bool clearSelectedPlan = false,
    String? errorMessage,
    bool clearError = false,
    bool? isInitialized,
    int? currentPage,
    bool? hasMoreBilling,
    bool? isLoadingMore,
    PaymentFlowState? paymentFlow,
    String? paymentId,
    String? planName,
  }) {
    return DoctorSubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      currentPlan: clearCurrentPlan ? null : (currentPlan ?? this.currentPlan),
      billingHistory: billingHistory ?? this.billingHistory,
      allPlans: allPlans ?? this.allPlans,
      showPlans: showPlans ?? this.showPlans,
      isYearly: isYearly ?? this.isYearly,
      selectedNewPlan: clearSelectedPlan
          ? null
          : (selectedNewPlan ?? this.selectedNewPlan),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isInitialized: isInitialized ?? this.isInitialized,
      currentPage: currentPage ?? this.currentPage,
      hasMoreBilling: hasMoreBilling ?? this.hasMoreBilling,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      paymentFlow: paymentFlow ?? this.paymentFlow,
      paymentId: paymentId ?? this.paymentId,
      planName: planName ?? this.planName,
    );
  }
}

final doctorSubscriptionProvider =
NotifierProvider<DoctorSubscriptionNotifier, DoctorSubscriptionState>(
  DoctorSubscriptionNotifier.new,
);

class DoctorSubscriptionNotifier extends Notifier<DoctorSubscriptionState> {
  static const String _subTag = 'DoctorSubscriptionNotifier';

  // -------- Pending payment context (set during checkout creation) --------
  // Used for normal subscription verification.
  String? _pendingLocalSubscriptionId;
  String? _pendingRazorpaySubscriptionId;

  // Used for the ₹1 first-offer / trial verification.
  String? _pendingRazorpayOrderId;
  bool _isFirstOfferFlow = false;

  // -------- Concurrency guards --------
  bool _isCreatingSubscription = false;
  bool _isVerifyingPayment = false;

  // -------- Duplicate callback guard --------
  String? _lastVerifiedPaymentId;

  StreamSubscription<RazorpayEvent>? _razorpaySubscription;

  @override
  DoctorSubscriptionState build() {
    AppLogger.info(
      'DoctorSubscriptionNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    _listenToRazorpayEvents();

    ref.onDispose(() {
      _razorpaySubscription?.cancel();
    });

    return const DoctorSubscriptionState(isLoading: false);
  }

  void _listenToRazorpayEvents() {
    final razorpayController = ref.read(razorpayControllerProvider);

    _razorpaySubscription = razorpayController.events.listen(
          (event) {
        switch (event) {
          case RazorpaySuccess(:final paymentId, :final signature):
            _handlePaymentSuccess(paymentId, signature);

          case RazorpayFailure(:final message):
            _handlePaymentFailure(message, cancelled: false);

          case RazorpayCancelled():
            _handlePaymentFailure('Payment cancelled', cancelled: true);

          case RazorpayExternalWallet():
            _clearPendingPaymentData();
        }
      },
      onError: (error) {
        AppLogger.error(
          'Razorpay event stream error: $error',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      },
    );
  }

  // ============ Subscription Data Loading ============

  Future<void> loadPlans() async {
    if (state.allPlans.isNotEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final plansRes = await repository.getPlans();

      if ((plansRes.statusCode ?? 0) >= 200 &&
          (plansRes.statusCode ?? 0) < 300) {
        final allPlans = (plansRes.data?["data"]?["plans"] as List? ?? [])
            .map((e) => AvailablePlan.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        state = state.copyWith(
          isLoading: false,
          allPlans: allPlans,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Failed to load plans",
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error loading plans.',
      );
      AppLogger.exception(
        e,
        st,
        message: 'Load plans failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<void> loadSubscriptionDetails() async {
    AppLogger.info(
      'Loading subscription details',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(isLoading: true, clearError: true, currentPage: 1);

    try {
      if (!ref.read(subscriptionStatusProvider).isResolved) {
        AppLogger.info(
          'Waiting for subscription status to resolve...',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        await ref
            .read(subscriptionStatusProvider.notifier)
            .checkActiveSubscription();
      }

      final subStatus = ref.read(subscriptionStatusProvider);

      if (!subStatus.hasSubscription) {
        AppLogger.info(
          'No active subscription (from cache), skipping duplicate API call',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(
          isLoading: false,
          currentPlan: null,
          clearCurrentPlan: true,
          showPlans: true,
          isInitialized: true,
          clearError: true,
        );
        return;
      }

      final repository = ref.read(subscriptionRepositoryProvider);

      // Fetch active subscription details
      final subRes = await repository.getActiveSubscription();
      final statusCode = subRes.statusCode ?? 0;

      // Fetch billing history
      final historyRes =
      await repository.getBillingHistory(page: 1, limit: 20);

      if (statusCode >= 200 && statusCode < 300) {
        SubscriptionPlan? currentPlan;
        final rawSubscription =
            subRes.data?["subscription"] ?? subRes.data?["data"]?["subscription"];
        if (rawSubscription is Map && rawSubscription.isNotEmpty) {
          currentPlan = SubscriptionPlan.fromJson(
            Map<String, dynamic>.from(rawSubscription),
          );
        }

        final billingHistory =
        (historyRes.data?["data"]?["invoices"] as List? ?? [])
            .map((e) => BillingInvoice.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        final totalPages = _parseTotalPages(
          historyRes.data?["data"]?["totalPages"],
        );

        final bool hasNoActivePlan =
            currentPlan == null || !currentPlan.isActive;

        state = state.copyWith(
          isLoading: false,
          currentPlan: currentPlan,
          clearCurrentPlan: currentPlan == null,
          billingHistory: billingHistory,
          showPlans: hasNoActivePlan,
          isInitialized: true,
          clearError: true,
          currentPage: 1,
          hasMoreBilling: 1 < totalPages,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Failed to load subscription data",
          isInitialized: true,
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Network error. Pull to retry.",
        isInitialized: true,
      );
      AppLogger.exception(
        e, st,
        message: 'Subscription load failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  int _parseTotalPages(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 1;
  }

  Future<void> loadMoreBillingHistory() async {
    if (state.isLoadingMore || !state.hasMoreBilling) return;
    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final repository = ref.read(subscriptionRepositoryProvider);
      final historyRes = await repository.getBillingHistory(
        page: nextPage,
        limit: 20,
      );

      if ((historyRes.statusCode ?? 0) >= 200 &&
          (historyRes.statusCode ?? 0) < 300) {
        final moreHistory =
        (historyRes.data?["data"]?["invoices"] as List? ?? [])
            .map(
              (e) => BillingInvoice.fromJson(Map<String, dynamic>.from(e)),
        )
            .toList();
        final totalPages = _parseTotalPages(
          historyRes.data?["data"]?["totalPages"],
        );

        state = state.copyWith(
          billingHistory: [...state.billingHistory, ...moreHistory],
          currentPage: nextPage,
          hasMoreBilling: nextPage < totalPages,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(isLoadingMore: false);
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
      AppLogger.error(
        'Failed to load more billing history: $e',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  // ============ Plan Selection ============

  void toggleDuration(bool isYearly) =>
      state = state.copyWith(isYearly: isYearly, clearSelectedPlan: true);

  void selectNewPlan(AvailablePlan plan) =>
      state = state.copyWith(selectedNewPlan: plan);

  void showUpgradePlans() => state = state.copyWith(showPlans: true);

  /// Returns true if the given plan represents the ₹1 first-offer / trial flow.
  ///
  /// The new plans distinguish Trial using `category == 'trial'`.
  bool _isTrialPlan(AvailablePlan plan) {
    return plan.category.toLowerCase() == 'trial';
  }

  List<AvailablePlan> getAvailablePlans() {
    // Trial plans live under the "trial" category; paid plans under
    // "subscription" (with a monthly / yearly cycle, if provided).
    final targetCycle = state.isYearly ? "yearly" : "monthly";
    return state.allPlans.where((p) {
      final category = p.category.toLowerCase();

      // Always surface trial plans (₹1 first offer) regardless of cycle.
      if (category == 'trial') return true;

      if (p.category.isNotEmpty) {
        return category == targetCycle;
      }

      final d = p.durationText.toLowerCase(), t = p.title.toLowerCase();
      return targetCycle == "yearly"
          ? d.contains("year") || d.contains("yr") || t.contains("year")
          : d.contains("month") ||
          d.contains("mo") ||
          d.contains("trial") ||
          t.contains("month") ||
          t.contains("trial");
    }).toList();
  }

  Future<void> refreshData() async => await loadSubscriptionDetails();

  // ============ Plan Upgrade/Purchase Flow ============

  /// Entry point for the UI. Handles both new subscriptions and upgrades.
  ///
  /// - Trial plan  → ₹1 first-offer flow (`createFirstOfferOrder`).
  /// - Paid plan   → normal subscription flow (`createSubscription`).
  ///
  /// The backend decides whether a `createSubscription` call is treated as a
  /// new subscription or an upgrade, so no `isUpgrade` flag is sent.
  Future<bool> upgradePlan() async {
    if (state.selectedNewPlan == null || state.isLoading) return false;

    // Guard against double-taps creating duplicate Razorpay orders.
    if (_isCreatingSubscription) return false;

    if (state.currentPlan != null &&
        state.currentPlan!.planId == state.selectedNewPlan!.id &&
        !_isTrialPlan(state.selectedNewPlan!)) {
      state = state.copyWith(
        errorMessage: "You are already subscribed to this plan.",
      );
      return false;
    }

    return _isTrialPlan(state.selectedNewPlan!)
        ? await _createFirstOfferFlow()
        : await _createNewSubscriptionFlow();
  }

  Future<bool> cancelSubscription() async {
    if (state.currentPlan == null || !state.currentPlan!.isActive) return false;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final response = await repository.cancelSubscription(
        id: state.currentPlan!.id,
      );

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        await loadSubscriptionDetails();
        state = state.copyWith(isLoading: false, showPlans: true);
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: response.data?["message"] ?? "Cancellation failed",
      );
      return false;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to cancel subscription.',
      );
      AppLogger.exception(
        e,
        st,
        message: 'Cancel failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }

  // ---- Normal (paid) subscription flow ----

  Future<bool> _createNewSubscriptionFlow() async {
    if (_isCreatingSubscription) return false;
    _isCreatingSubscription = true;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);

      final response = await repository.createSubscription(
        planId: state.selectedNewPlan!.id,
        billing: state.isYearly ? "yearly" : "monthly",
      );

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        final data = response.data?["data"] ?? {};
        final subId = data["subscription_id"] as String?;
        final key = data["razorpay_key"] as String?;

        if (subId != null && key != null) {
          _isFirstOfferFlow = false;
          _pendingLocalSubscriptionId =
          data["local_subscription_id"] as String?;
          _pendingRazorpaySubscriptionId = subId;
          _pendingRazorpayOrderId = null;

          final razorpayController = ref.read(razorpayControllerProvider);

          razorpayController.openSubscriptionCheckout(
            key: key,
            subscriptionId: subId,
            planName: state.selectedNewPlan?.title ?? 'Subscription Plan',
            prefill: Map<String, String>.from(
              data["prefill"] as Map<String, dynamic>? ?? {},
            ),
          );

          return true;
        }

        state = state.copyWith(
          isLoading: false,
          errorMessage: "Invalid checkout configuration.",
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage:
        _extractMessage(response.data) ?? "Subscription creation failed",
      );
      return false;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );

      AppLogger.exception(
        e,
        st,
        message: 'Subscription creation failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      return false;
    } finally {
      _isCreatingSubscription = false;
    }
  }

  // ---- ₹1 First-offer / trial flow ----

  Future<bool> _createFirstOfferFlow() async {
    if (_isCreatingSubscription) return false;
    _isCreatingSubscription = true;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);

      final response = await repository.createFirstOfferOrder(
        planId: state.selectedNewPlan!.id,
        billing: state.isYearly ? "yearly" : "monthly",
      );

      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        final data = response.data?["data"] ?? {};
        final orderId = data["order_id"] as String? ??
            data["razorpay_order_id"] as String?;
        final key = data["razorpay_key"] as String?;

        if (orderId != null && key != null) {
          _isFirstOfferFlow = true;
          _pendingRazorpayOrderId = orderId;
          _pendingLocalSubscriptionId = null;
          _pendingRazorpaySubscriptionId = null;

          final razorpayController = ref.read(razorpayControllerProvider);

          razorpayController.openOrderCheckout(
            key: key,
            orderId: orderId,
            amount: 1.0, // ₹1 first-offer trial
            description: state.selectedNewPlan?.title ?? 'First Offer',
            prefill: Map<String, String>.from(
              data["prefill"] as Map<String, dynamic>? ?? {},
            ),
          );

          return true;
        }

        state = state.copyWith(
          isLoading: false,
          errorMessage: "Invalid checkout configuration.",
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage:
        _extractMessage(response.data) ?? "Trial order creation failed",
      );
      return false;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );

      AppLogger.exception(
        e,
        st,
        message: 'First-offer order creation failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      return false;
    } finally {
      _isCreatingSubscription = false;
    }
  }

  // ============ Payment Result Handlers ============

  Future<void> _handlePaymentSuccess(
      String? paymentId,
      String? signature,
      ) async {
    // Prevent duplicate verification from double callbacks.
    if (_isVerifyingPayment) {
      AppLogger.info(
        'Ignoring duplicate Razorpay success callback',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return;
    }

    if (paymentId != null && _lastVerifiedPaymentId == paymentId) {
      AppLogger.info(
        'Skipping already-verified payment $paymentId',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return;
    }

    _isVerifyingPayment = true;
    state = state.copyWith(paymentFlow: PaymentFlowState.processing);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);

      if (_isFirstOfferFlow) {
        await _verifyFirstOffer(repository, paymentId, signature);
      } else {
        await _verifySubscription(repository, paymentId, signature);
      }
    } catch (e, st) {
      _clearPendingPaymentData();

      AppLogger.exception(
        e,
        st,
        message: 'Verification error',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Payment verification failed. Please contact support.',
        paymentFlow: PaymentFlowState.failed,
        paymentId: null,
        planName: null,
      );
    } finally {
      _isVerifyingPayment = false;
    }
  }

  /// Verifies a paid subscription payment and then refreshes state.
  Future<void> _verifySubscription(
      SubscriptionRepository repository,
      String? paymentId,
      String? signature,
      ) async {
    final razorpaySubscriptionId = _pendingRazorpaySubscriptionId;
    final localSubscriptionId = _pendingLocalSubscriptionId;

    if (paymentId == null ||
        paymentId.isEmpty ||
        razorpaySubscriptionId == null ||
        razorpaySubscriptionId.isEmpty ||
        localSubscriptionId == null ||
        localSubscriptionId.isEmpty ||
        signature == null ||
        signature.isEmpty) {
      AppLogger.error(
        'Missing subscription verification data: '
            'paymentId=$paymentId, subId=$razorpaySubscriptionId, '
            'localSubId=$localSubscriptionId, '
            'signature=${signature != null}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      _clearPendingPaymentData();
      state = state.copyWith(
        isLoading: false,
        errorMessage:
        'Payment could not be verified. Please contact support.',
        paymentFlow: PaymentFlowState.failed,
        paymentId: null,
        planName: null,
      );
      return;
    }

    final verifyRes = await repository.verifySubscription(
      razorpayPaymentId: paymentId,
      razorpaySubscriptionId: razorpaySubscriptionId,
      razorpaySignature: signature,
      localSubscriptionId: localSubscriptionId,
    );

    _clearPendingPaymentData();

    if ((verifyRes.statusCode ?? 0) >= 200 &&
        (verifyRes.statusCode ?? 0) < 300) {
      _lastVerifiedPaymentId = paymentId;
      await _onVerificationSuccess(paymentId);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
        _extractMessage(verifyRes.data) ?? "Verification failed",
        paymentFlow: PaymentFlowState.failed,
        paymentId: null,
        planName: null,
      );
    }
  }

  /// Verifies a ₹1 first-offer payment and then refreshes state.
  Future<void> _verifyFirstOffer(
      SubscriptionRepository repository,
      String? paymentId,
      String? signature,
      ) async {
    final orderId = _pendingRazorpayOrderId;

    // Validate required data BEFORE calling the API.
    if (paymentId == null ||
        paymentId.isEmpty ||
        orderId == null ||
        orderId.isEmpty ||
        signature == null ||
        signature.isEmpty) {
      AppLogger.error(
        'Missing first-offer verification data: '
            'paymentId=$paymentId, orderId=$orderId, '
            'signature=${signature != null}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      _clearPendingPaymentData();
      state = state.copyWith(
        isLoading: false,
        errorMessage:
        'Payment could not be verified. Please contact support.',
        paymentFlow: PaymentFlowState.failed,
        paymentId: null,
        planName: null,
      );
      return;
    }

    final verifyRes = await repository.verifyFirstOffer(
      razorpayOrderId: orderId,
      razorpayPaymentId: paymentId,
      razorpaySignature: signature,
    );

    _clearPendingPaymentData();

    if ((verifyRes.statusCode ?? 0) >= 200 &&
        (verifyRes.statusCode ?? 0) < 300) {
      _lastVerifiedPaymentId = paymentId;
      await _onVerificationSuccess(paymentId);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
        _extractMessage(verifyRes.data) ?? "Verification failed",
        paymentFlow: PaymentFlowState.failed,
        paymentId: null,
        planName: null,
      );
    }
  }

  /// Shared post-verification step.
  ///
  /// IMPORTANT: verification already succeeded. If refreshing subscription
  /// details fails, we must NOT mark the payment as failed.
  Future<void> _onVerificationSuccess(String paymentId) async {
    final verifiedPlanName = state.selectedNewPlan?.title;

    AppLogger.success(
      'Payment verified successfully: $paymentId',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    // Mark success immediately so the UI never shows failed after a
    // successful verification, even if the refresh below fails.
    state = state.copyWith(
      isLoading: false,
      showPlans: false,
      clearSelectedPlan: true,
      clearError: true,
      paymentFlow: PaymentFlowState.success,
      paymentId: paymentId,
      planName: verifiedPlanName,
    );

    // Refresh current subscription. Failure here must not flip payment state.
    try {
      await loadSubscriptionDetails();
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Post-verification subscription refresh failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  void _handlePaymentFailure(String message, {required bool cancelled}) {
    _clearPendingPaymentData();

    state = state.copyWith(
      isLoading: false,
      errorMessage: cancelled
          ? 'Payment cancelled'
          : 'Payment failed: $message',
      paymentFlow: PaymentFlowState.failed,
      paymentId: null,
      planName: null,
    );
  }

  void _clearPendingPaymentData() {
    _pendingLocalSubscriptionId = null;
    _pendingRazorpaySubscriptionId = null;
    _pendingRazorpayOrderId = null;
    _isFirstOfferFlow = false;
  }

  // ============ Error helpers ============

  /// Extract a user-facing message from an API response body.
  String? _extractMessage(dynamic data) {
    if (data is Map) {
      final msg = data['message'] ?? data['error'];
      if (msg is String && msg.trim().isNotEmpty) return msg;
    }
    return null;
  }

  /// Convert low-level exceptions into user-friendly messages.
  String _friendlyError(Object e) {
    if (e is DioException) {
      // Let the central Dio interceptor handle auth/logout. We only
      // translate to user-friendly text here — no logout from controller.
      final status = e.response?.statusCode;
      switch (status) {
        case 400:
          return 'Invalid request. Please check your plan selection.';
        case 401:
          return 'Your session has expired. Please sign in again.';
        case 403:
          return 'You do not have permission to perform this action.';
        case 404:
          return 'Requested resource was not found.';
        case 409:
          return 'This subscription already exists.';
        case 422:
          return _extractMessage(e.response?.data) ??
              'Some information is invalid. Please review and try again.';
        case 429:
          return 'Too many attempts. Please try again in a moment.';
        case 500:
        case 502:
        case 503:
        case 504:
          return 'Server is temporarily unavailable. Please try again.';
      }

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.transformTimeout:
          return 'Connection timed out. Please check your network.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please try again.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.badResponse:
          return _extractMessage(e.response?.data) ??
              'Unexpected server response.';
        case DioExceptionType.unknown:
          return 'Something went wrong. Please try again.';
        case DioExceptionType.badCertificate:
          return 'Secure connection failed. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/doctor/models/subscription/available_plan_model.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';
import '../repositories/subscription_repository.dart';

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
    );
  }
}

final doctorSubscriptionProvider =
    NotifierProvider<DoctorSubscriptionNotifier, DoctorSubscriptionState>(
      DoctorSubscriptionNotifier.new,
    );

class DoctorSubscriptionNotifier extends Notifier<DoctorSubscriptionState> {
  static const String _subTag = 'DoctorSubscriptionNotifier';

  late final Razorpay _razorpay;
  bool _isCheckoutOpen = false;
  String? _localSubscriptionId;
  String? _razorpaySubscriptionId;

  @override
  DoctorSubscriptionState build() {
    AppLogger.info(
      'DoctorSubscriptionNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    ref.onDispose(() {
      _razorpay.clear();
    });

    Future.microtask(() => _loadInitialData());
    return const DoctorSubscriptionState(isLoading: true);
  }

  // Defensive initial load with error handling
  Future<void> _loadInitialData() async {
    try {
      await loadSubscriptionDetails();
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Initial load failed',
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
      final repository = ref.read(subscriptionRepositoryProvider);

      final subRes = await repository.getActiveSubscription();
      await Future.delayed(const Duration(milliseconds: 250));

      final historyRes = await repository.getBillingHistory(page: 1, limit: 20);
      await Future.delayed(const Duration(milliseconds: 250));

      final plansRes = await repository.getPlans();

      final subStatus = subRes.statusCode ?? 0;
      final historyStatus = historyRes.statusCode ?? 0;
      final plansStatus = plansRes.statusCode ?? 0;

      if (subStatus >= 200 &&
          subStatus < 300 &&
          historyStatus >= 200 &&
          historyStatus < 300 &&
          plansStatus >= 200 &&
          plansStatus < 300) {
        SubscriptionPlan? currentPlan;
        final rawSubscription =
            subRes.data?["subscription"] ??
            subRes.data?["data"]?["subscription"];
        if (rawSubscription is Map && rawSubscription.isNotEmpty) {
          currentPlan = SubscriptionPlan.fromJson(
            Map<String, dynamic>.from(rawSubscription),
          );
        }

        final billingHistory =
            (historyRes.data?["data"]?["invoices"] as List? ?? [])
                .map(
                  (e) => BillingInvoice.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList();

        final allPlans = (plansRes.data?["data"]?["plans"] as List? ?? [])
            .map((e) => AvailablePlan.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        final bool hasNoActivePlan =
            currentPlan == null || !currentPlan.isActive;
        final totalPages = _parseTotalPages(
          historyRes.data?["data"]?["totalPages"],
        );

        AppLogger.success(
          'Subscription data loaded. Plans: ${allPlans.length}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );

        state = state.copyWith(
          isLoading: false,
          currentPlan: currentPlan,
          clearCurrentPlan: currentPlan == null,
          billingHistory: billingHistory,
          allPlans: allPlans,
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
        e,
        st,
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

  void toggleDuration(bool isYearly) =>
      state = state.copyWith(isYearly: isYearly, clearSelectedPlan: true);
  void selectNewPlan(AvailablePlan plan) =>
      state = state.copyWith(selectedNewPlan: plan);
  void showUpgradePlans() => state = state.copyWith(showPlans: true);

  List<AvailablePlan> getAvailablePlans() {
    final targetCycle = state.isYearly ? "yearly" : "monthly";
    return state.allPlans.where((p) {
      if (p.category.isNotEmpty) return p.category.toLowerCase() == targetCycle;
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

  Future<bool> upgradePlan() async {
    if (state.selectedNewPlan == null || state.isLoading) return false;
    final hasActiveSub =
        state.currentPlan != null && state.currentPlan!.isActive;
    return hasActiveSub
        ? await _upgradeExistingSubscription()
        : await _createNewSubscriptionFlow();
  }

  Future<bool> _upgradeExistingSubscription() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final response = await repository.upgradeSubscriptionPlan(
        id: state.currentPlan!.id,
        newPlanId: state.selectedNewPlan!.id,
      );
      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        await loadSubscriptionDetails();
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: response.data?["message"] ?? "Upgrade failed",
      );
      return false;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Upgrade request failed.',
      );
      AppLogger.exception(
        e,
        st,
        message: 'Upgrade failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }

  Future<bool> _createNewSubscriptionFlow() async {
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
          _localSubscriptionId = data["local_subscription_id"] as String?;

          _razorpaySubscriptionId = subId;

          _openCheckout(
            razorpayKey: key,
            subscriptionId: subId,
            prefill: data["prefill"] as Map<String, dynamic>? ?? {},
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
            response.data?["message"] ?? "Subscription creation failed",
      );
      return false;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Payment initialization failed.',
      );
      AppLogger.exception(
        e,
        st,
        message: 'Subscription creation failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }

  void _openCheckout({
    required String razorpayKey,
    required String subscriptionId,
    required Map<String, dynamic> prefill,
  }) {
    if (_isCheckoutOpen) return;
    _isCheckoutOpen = true;

    if (_localSubscriptionId == null) {
      AppLogger.warning(
        'localSubscriptionId is null during checkout',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }

    try {
      _razorpay.open({
        'key': razorpayKey,
        'subscription_id': subscriptionId,
        'name': 'YoDoctor',
        'description': state.selectedNewPlan?.title ?? 'Subscription Plan',
        'retry': {'enabled': true, 'max_count': 1},
        'prefill': {
          'contact': prefill['contact'] ?? '',
          'email': prefill['email'] ?? '',
          'name': prefill['name'] ?? '',
        },
        'send_sms_hash': true,
      });
    } catch (e, st) {
      _isCheckoutOpen = false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to open payment gateway.',
      );
      AppLogger.exception(
        e,
        st,
        message: 'Checkout open error',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _isCheckoutOpen = false;
    AppLogger.success(
      'Payment Success: ${response.paymentId}',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final verifyRes = await repository.verifySubscription({
        if (response.paymentId != null)
          "razorpay_payment_id": response.paymentId,
        if (_razorpaySubscriptionId != null)
          "razorpay_subscription_id": _razorpaySubscriptionId,
        if (response.signature != null)
          "razorpay_signature": response.signature,
        if (_localSubscriptionId != null)
          "local_subscription_id": _localSubscriptionId,
      });

      if ((verifyRes.statusCode ?? 0) >= 200 &&
          (verifyRes.statusCode ?? 0) < 300) {
        AppLogger.success(
          'Subscription verified and activated',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        _localSubscriptionId = null;
        _razorpaySubscriptionId = null;

        await loadSubscriptionDetails();
        state = state.copyWith(
          isLoading: false,
          showPlans: false,
          clearSelectedPlan: true,
          clearError: true,
        );
      } else {
        AppLogger.warning(
          'Verification failed: ${verifyRes.data?["message"]}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        _localSubscriptionId = null;
        _razorpaySubscriptionId = null;
        state = state.copyWith(
          isLoading: false,
          errorMessage: verifyRes.data?["message"] ?? "Verification failed",
        );
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Verification error',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      _localSubscriptionId = null;
      _razorpaySubscriptionId = null;

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Payment verification failed.',
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _isCheckoutOpen = false;
    _localSubscriptionId = null;
    _razorpaySubscriptionId = null;

    state = state.copyWith(isLoading: false);
    final msg = response.message ?? 'Payment failed';
    AppLogger.error(
      'Payment Failed - Code: ${response.code}, Message: $msg, Error: ${response.error}',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(
      errorMessage: response.code == Razorpay.PAYMENT_CANCELLED
          ? 'Payment cancelled'
          : 'Payment failed: $msg',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _isCheckoutOpen = false;
    _localSubscriptionId = null;
    _razorpaySubscriptionId = null;

    state = state.copyWith(isLoading: false);
    AppLogger.info(
      'External Wallet: ${response.walletName}',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
  }

  // ─── DEBUG: Test All Endpoints ────────────────────────────
  Future<Map<String, dynamic>> debugTestAllEndpoints() async {
    final results = <String, dynamic>{};
    final repository = ref.read(subscriptionRepositoryProvider);

    AppLogger.info(
      '🔍 DEBUG: Testing all endpoints...',
      tag: LogTags.doctor,
      subTag: '$_subTag/DEBUG',
    );

    // 1. Get Plans
    try {
      final plansRes = await repository.getPlans();
      results['getPlans'] = {
        'status': plansRes.statusCode,
        'success': plansRes.statusCode == 200,
      };
      AppLogger.success(
        '✅ getPlans: ${plansRes.statusCode}',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    } catch (e) {
      results['getPlans'] = {'error': e.toString()};
      AppLogger.error('❌ getPlans: $e', tag: LogTags.doctor, subTag: 'DEBUG');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // 2. Get Plan by ID
    try {
      final planRes = await repository.getPlanById('plan_trial');
      results['getPlanById'] = {
        'status': planRes.statusCode,
        'success': planRes.statusCode == 200,
      };
      AppLogger.success(
        '✅ getPlanById: ${planRes.statusCode}',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    } catch (e) {
      results['getPlanById'] = {'error': e.toString()};
      AppLogger.error(
        '❌ getPlanById: $e',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // 3. Get Active Subscription
    try {
      final activeRes = await repository.getActiveSubscription();
      results['getActiveSubscription'] = {
        'status': activeRes.statusCode,
        'success': activeRes.statusCode == 200,
      };
      AppLogger.success(
        '✅ getActiveSubscription: ${activeRes.statusCode}',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    } catch (e) {
      results['getActiveSubscription'] = {'error': e.toString()};
      AppLogger.error(
        '❌ getActiveSubscription: $e',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // 4. Get Billing History
    try {
      final billingRes = await repository.getBillingHistory(page: 1, limit: 5);
      results['getBillingHistory'] = {
        'status': billingRes.statusCode,
        'success': billingRes.statusCode == 200,
      };
      AppLogger.success(
        '✅ getBillingHistory: ${billingRes.statusCode}',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    } catch (e) {
      results['getBillingHistory'] = {'error': e.toString()};
      AppLogger.error(
        '❌ getBillingHistory: $e',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // 5. Get All Subscriptions
    try {
      final allSubRes = await repository.getAllSubscriptions();
      results['getAllSubscriptions'] = {
        'status': allSubRes.statusCode,
        'success': allSubRes.statusCode == 200,
      };
      AppLogger.success(
        '✅ getAllSubscriptions: ${allSubRes.statusCode}',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    } catch (e) {
      results['getAllSubscriptions'] = {'error': e.toString()};
      AppLogger.error(
        '❌ getAllSubscriptions: $e',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // 6. Create Payment Order
    try {
      final payRes = await repository.createPaymentOrder(amount: 1);
      results['createPaymentOrder'] = {
        'status': payRes.statusCode,
        'success': payRes.statusCode == 200 || payRes.statusCode == 201,
      };
      AppLogger.success(
        '✅ createPaymentOrder: ${payRes.statusCode}',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    } catch (e) {
      results['createPaymentOrder'] = {'error': e.toString()};
      AppLogger.error(
        '❌ createPaymentOrder: $e',
        tag: LogTags.doctor,
        subTag: 'DEBUG',
      );
    }

    final passed = results.values.where((r) => r['success'] == true).length;
    AppLogger.info(
      '🔍 DEBUG SUMMARY: $passed/${results.length} endpoints passed',
      tag: LogTags.doctor,
      subTag: 'DEBUG',
    );
    AppLogger.json(results, tag: LogTags.doctor, subTag: 'DEBUG/RESULTS');

    return results;
  }
}

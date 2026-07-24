import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  const DoctorSubscriptionState({
    this.isLoading = false,
    this.currentPlan,
    this.billingHistory = const [],
    this.allPlans = const [],
    this.showPlans = false,
    this.isYearly = false,
    this.selectedNewPlan,
    this.errorMessage,
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
  }) {
    return DoctorSubscriptionState(
      // 🎯 FIXED: Replaced 'loading' typo with the correct 'isLoading' parameter parameter
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
    );
  }
}

// 🎯 NotifierProvider Configuration
final doctorSubscriptionProvider =
    NotifierProvider<DoctorSubscriptionNotifier, DoctorSubscriptionState>(
      DoctorSubscriptionNotifier.new,
    );

class DoctorSubscriptionNotifier extends Notifier<DoctorSubscriptionState> {
  static const String _subTag = 'DoctorSubscriptionNotifier';

  @override
  DoctorSubscriptionState build() {
    AppLogger.info(
      'DoctorSubscriptionNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    Future.microtask(() => loadSubscriptionDetails());
    return const DoctorSubscriptionState(isLoading: true);
  }

  Future<void> loadSubscriptionDetails() async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info(
      'Loading subscription details sequentially to prevent rate limits',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(subscriptionRepositoryProvider);

      // 1. Fetch active subscription sequentially
      final subRes = await repository.getActiveSubscription();
      final subStatus = subRes.statusCode ?? 0;

      // 2. Fetch billing history
      final historyRes = await repository.getBillingHistory();
      final historyStatus = historyRes.statusCode ?? 0;

      // 3. Fetch available plans
      final plansRes = await repository.getPlans();
      final plansStatus = plansRes.statusCode ?? 0;

      if (subStatus >= 200 &&
          subStatus < 300 &&
          historyStatus >= 200 &&
          historyStatus < 300 &&
          plansStatus >= 200 &&
          plansStatus < 300) {

        SubscriptionPlan? currentPlan;
        final rawSubscription = subRes.data?["subscription"] ?? subRes.data?["data"]?["subscription"];

        if (rawSubscription is Map && rawSubscription.isNotEmpty) {
          currentPlan = SubscriptionPlan.fromJson(
            Map<String, dynamic>.from(rawSubscription),
          );
        }

        // Safe parsing for invoices/history
        final rawHistoryData = historyRes.data?["data"]?["invoices"] ?? historyRes.data?["history"] ?? [];
        final billingHistory = (rawHistoryData as List? ?? [])
            .map((e) => BillingInvoice.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        // Safe parsing for available plans
        final rawPlansData = plansRes.data?["data"]?["plans"] ?? plansRes.data?["plans"] ?? [];
        final allPlans = (rawPlansData as List? ?? [])
            .map((e) => AvailablePlan.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        final bool hasNoActivePlan =
            currentPlan == null || !currentPlan.isActive;

        AppLogger.success(
          'Subscription data profile synchronized flawlessly. Plans count: ${allPlans.length}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        AppLogger.json(
          {
            "has_active_plan": currentPlan != null,
            "history_count": billingHistory.length,
            "available_plans_count": allPlans.length,
          },
          tag: LogTags.doctor,
          subTag: '$_subTag/SubscriptionSyncMatrix',
        );

        state = state.copyWith(
          isLoading: false,
          currentPlan: currentPlan,
          clearCurrentPlan: currentPlan == null,
          billingHistory: billingHistory,
          allPlans: allPlans,
          showPlans: hasNoActivePlan,
        );
      } else {
        AppLogger.warning(
          'Subscription sync dropped by gateway nodes. Status Sub: $subStatus, Hist: $historyStatus, Plans: $plansStatus',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Failed to read remote billing configurations",
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to compile subscription parameters",
      );
      AppLogger.exception(
        e,
        st,
        message: 'Fatal exception within billing loader workspace stream',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }
  void toggleDuration(bool isYearly) {
    AppLogger.info(
      'Toggling duration filter boundary. IsYearly: $isYearly',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(isYearly: isYearly, clearSelectedPlan: true);
  }

  void selectNewPlan(AvailablePlan plan) {
    AppLogger.info(
      'Selecting active upgraded tier intent path. Plan ID: ${plan.id}',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(selectedNewPlan: plan);
  }

  void showUpgradePlans() {
    state = state.copyWith(showPlans: true);
  }

  List<AvailablePlan> getAvailablePlans() {
    final targetCycle = state.isYearly ? "yearly" : "monthly";
    return state.allPlans.where((p) {
      // 1. Direct category match from backend (Best & primary approach)
      if (p.category.isNotEmpty) {
        return p.category.toLowerCase() == targetCycle;
      }

      // 2. Fallback text search if category is empty
      final cleanDuration = p.durationText.toLowerCase();
      final cleanTitle = p.title.toLowerCase();
      final cleanSlug = p.slug.toLowerCase();

      if (targetCycle == "yearly") {
        return cleanDuration.contains("year") ||
            cleanDuration.contains("yr") ||
            cleanTitle.contains("year");
      } else {
        return cleanDuration.contains("month") ||
            cleanDuration.contains("mo") ||
            cleanDuration.contains("trial") ||
            cleanTitle.contains("month") ||
            cleanTitle.contains("trial") ||
            cleanSlug.contains("trial");
      }
    }).toList();
  }

  Future<bool> upgradePlan() async {
    if (state.selectedNewPlan == null) return false;

    final payload = {
      "planId": state.selectedNewPlan!.id,
      "billing": state.isYearly ? "yearly" : "monthly",
    };

    AppLogger.info(
      'Initializing checkout transmission chain for Plan ID: ${state.selectedNewPlan!.id}',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    AppLogger.json(
      payload,
      tag: LogTags.doctor,
      subTag: '$_subTag/OrderCreationPayload',
    );

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final response = await repository.createSubscription(
        planId: state.selectedNewPlan!.id,
        billing: state.isYearly ? "yearly" : "monthly",
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        AppLogger.success(
          'Order transaction generated successfully on core system node',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(isLoading: false);
        await loadSubscriptionDetails();
        return true;
      } else {
        final msg =
            response.data?["message"] ??
            "Payment execution denied by server gate";
        AppLogger.warning(
          'Order registration rejected by edge interface. Status: $statusCode',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Payment initialization failed.',
      );
      AppLogger.exception(
        e,
        st,
        message: 'Order pipeline transmission failure over wire',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }
}

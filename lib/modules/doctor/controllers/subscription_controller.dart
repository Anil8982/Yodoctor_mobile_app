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
  final bool isInitialized;

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
  }) {
    return DoctorSubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      currentPlan: clearCurrentPlan ? null : (currentPlan ?? this.currentPlan),
      billingHistory: billingHistory ?? this.billingHistory,
      allPlans: allPlans ?? this.allPlans,
      showPlans: showPlans ?? this.showPlans,
      isYearly: isYearly ?? this.isYearly,
      selectedNewPlan: clearSelectedPlan ? null : (selectedNewPlan ?? this.selectedNewPlan),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

final doctorSubscriptionProvider =
NotifierProvider<DoctorSubscriptionNotifier, DoctorSubscriptionState>(
  DoctorSubscriptionNotifier.new,
);

class DoctorSubscriptionNotifier extends Notifier<DoctorSubscriptionState> {
  static const String _subTag = 'DoctorSubscriptionNotifier';

  @override
  DoctorSubscriptionState build() {
    AppLogger.info('DoctorSubscriptionNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);

    // ✅ Use Future.microtask - DON'T call async method directly in build
    Future.microtask(() => _loadInitialData());

    return const DoctorSubscriptionState(isLoading: true);
  }

  Future<void> _loadInitialData() async {
    await loadSubscriptionDetails();
  }

  Future<void> loadSubscriptionDetails() async {
    AppLogger.info('Loading subscription details', tag: LogTags.doctor, subTag: _subTag);

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);

      final subRes = await repository.getActiveSubscription();
      await Future.delayed(const Duration(milliseconds: 250));

      final historyRes = await repository.getBillingHistory();
      await Future.delayed(const Duration(milliseconds: 250));

      final plansRes = await repository.getPlans();

      final subStatus = subRes.statusCode ?? 0;
      final historyStatus = historyRes.statusCode ?? 0;
      final plansStatus = plansRes.statusCode ?? 0;

      if (subStatus >= 200 && subStatus < 300 && historyStatus >= 200 && historyStatus < 300 && plansStatus >= 200 && plansStatus < 300) {
        SubscriptionPlan? currentPlan;
        final rawSubscription = subRes.data?["subscription"] ?? subRes.data?["data"]?["subscription"];

        if (rawSubscription is Map && rawSubscription.isNotEmpty) {
          currentPlan = SubscriptionPlan.fromJson(Map<String, dynamic>.from(rawSubscription));
        }

        final rawHistoryData = historyRes.data?["data"]?["invoices"] ?? historyRes.data?["history"] ?? [];
        final billingHistory = (rawHistoryData as List? ?? [])
            .map((e) => BillingInvoice.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        final rawPlansData = plansRes.data?["data"]?["plans"] ?? plansRes.data?["plans"] ?? [];
        final allPlans = (rawPlansData as List? ?? [])
            .map((e) => AvailablePlan.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        final bool hasNoActivePlan = currentPlan == null || !currentPlan.isActive;

        AppLogger.success('Subscription data loaded. Plans: ${allPlans.length}', tag: LogTags.doctor, subTag: _subTag);

        state = state.copyWith(
          isLoading: false,
          currentPlan: currentPlan,
          clearCurrentPlan: currentPlan == null,
          billingHistory: billingHistory,
          allPlans: allPlans,
          showPlans: hasNoActivePlan,
          isInitialized: true,
          clearError: true,
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
      AppLogger.exception(e, st, message: 'Subscription load failed', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  void toggleDuration(bool isYearly) {
    state = state.copyWith(isYearly: isYearly, clearSelectedPlan: true);
  }

  void selectNewPlan(AvailablePlan plan) {
    state = state.copyWith(selectedNewPlan: plan);
  }

  void showUpgradePlans() {
    state = state.copyWith(showPlans: true);
  }

  List<AvailablePlan> getAvailablePlans() {
    final targetCycle = state.isYearly ? "yearly" : "monthly";
    return state.allPlans.where((p) {
      if (p.category.isNotEmpty) return p.category.toLowerCase() == targetCycle;
      final cleanDuration = p.durationText.toLowerCase();
      final cleanTitle = p.title.toLowerCase();
      if (targetCycle == "yearly") {
        return cleanDuration.contains("year") || cleanDuration.contains("yr") || cleanTitle.contains("year");
      } else {
        return cleanDuration.contains("month") || cleanDuration.contains("mo") || cleanDuration.contains("trial") || cleanTitle.contains("month") || cleanTitle.contains("trial");
      }
    }).toList();
  }

  Future<bool> upgradePlan() async {
    if (state.selectedNewPlan == null) return false;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final response = await repository.createSubscription(
        planId: state.selectedNewPlan!.id,
        billing: state.isYearly ? "yearly" : "monthly",
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        await loadSubscriptionDetails();
        return true;
      } else {
        final msg = response.data?["message"] ?? "Payment failed";
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(isLoading: false, errorMessage: 'Payment initialization failed.');
      AppLogger.exception(e, st, message: 'Upgrade failed', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }
}
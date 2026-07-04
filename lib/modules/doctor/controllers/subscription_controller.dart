import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/doctor/subscription_model.dart';
import 'package:yodoctor/core/models/doctor/available_plan_model.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';

class DoctorSubscriptionNotifier extends Notifier<DoctorSubscriptionState> {
  @override
  DoctorSubscriptionState build() {
    Future.microtask(() => loadSubscriptionDetails());
    return DoctorSubscriptionState(isLoading: true);
  }

  Future<void> loadSubscriptionDetails() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final mockPlan = SubscriptionPlan(
        title: '3 Month Plan',
        type: 'monthly',
        nextBillingDate: DateTime(2026, 9, 15),
        isActive: true,
        upcomingPlan: UpcomingPlan(
          title: '6 Month Plan',
          startDate: DateTime(2026, 9, 15),
        ),
      );

      final mockHistory = [
        BillingInvoice(
          invoiceId: 'INV-1781529675742',
          date: DateTime(2026, 6, 15),
          planTitle: '6 Month Plan',
          amount: 2397.00,
          status: 'paid',
        ),
        BillingInvoice(
          invoiceId: 'INV-1781529022486',
          date: DateTime(2026, 6, 15),
          planTitle: '3 Month Plan',
          amount: 1199.00,
          status: 'paid',
        ),
      ];

      final bool hasNoActivePlan = !mockPlan.isActive;

      state = DoctorSubscriptionState(
        isLoading: false,
        currentPlan: mockPlan,
        billingHistory: mockHistory,
        showPlans: hasNoActivePlan,
        isYearly: false,
        selectedNewPlan: null,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load subscription status.',
      );
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
    return state.isYearly ? DummyData.yearlyAvailablePlans : DummyData.monthlyAvailablePlans;
  }

  Future<void> upgradePlan() async {
    if (state.selectedNewPlan == null) return;
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      await loadSubscriptionDetails();
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Payment initialization failed.',
      );
    }
  }
}

final doctorSubscriptionProvider = NotifierProvider.autoDispose<
    DoctorSubscriptionNotifier, DoctorSubscriptionState>(
  DoctorSubscriptionNotifier.new,
);
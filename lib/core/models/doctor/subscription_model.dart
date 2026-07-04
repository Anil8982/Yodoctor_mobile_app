
import 'available_plan_model.dart';

class SubscriptionPlan {
  final String title;
  final String type; // monthly, yearly, etc.
  final DateTime nextBillingDate;
  final bool isActive;
  final UpcomingPlan? upcomingPlan;

  SubscriptionPlan({
    required this.title,
    required this.type,
    required this.nextBillingDate,
    this.isActive = false,
    this.upcomingPlan,
  });
}

class UpcomingPlan {
  final String title;
  final DateTime startDate;

  UpcomingPlan({required this.title, required this.startDate});
}

class BillingInvoice {
  final String invoiceId;
  final DateTime date;
  final String planTitle;
  final double amount;
  final String status; // paid, pending, failed

  BillingInvoice({
    required this.invoiceId,
    required this.date,
    required this.planTitle,
    required this.amount,
    required this.status,
  });
}

class DoctorSubscriptionState {
  final bool isLoading;
  final SubscriptionPlan? currentPlan;
  final List<BillingInvoice> billingHistory;
  final String? errorMessage;

  final bool isYearly;
  final AvailablePlan? selectedNewPlan;
  final bool showPlans;

  DoctorSubscriptionState({
    this.isLoading = false,
    this.currentPlan,
    this.billingHistory = const [],
    this.errorMessage,
    this.isYearly = false,
    this.selectedNewPlan,
    this.showPlans = false,
  });

  DoctorSubscriptionState copyWith({
    bool? isLoading,
    SubscriptionPlan? currentPlan,
    List<BillingInvoice>? billingHistory,
    String? errorMessage,
    bool? isYearly,
    AvailablePlan? selectedNewPlan,
    bool? showPlans,
    bool clearSelectedPlan = false,
  }) {
    return DoctorSubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      currentPlan: currentPlan ?? this.currentPlan,
      billingHistory: billingHistory ?? this.billingHistory,
      errorMessage: errorMessage ?? this.errorMessage,
      isYearly: isYearly ?? this.isYearly,
      selectedNewPlan: clearSelectedPlan ? null : (selectedNewPlan ?? this.selectedNewPlan),
      showPlans: showPlans ?? this.showPlans,
    );
  }
}
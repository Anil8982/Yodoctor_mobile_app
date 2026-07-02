
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

// Immutable Riverpod State
class DoctorSubscriptionState {
  final bool isLoading;
  final SubscriptionPlan? currentPlan;
  final List<BillingInvoice> billingHistory;
  final String? errorMessage;

  DoctorSubscriptionState({
    this.isLoading = false,
    this.currentPlan,
    this.billingHistory = const [],
    this.errorMessage,
  });

  DoctorSubscriptionState copyWith({
    bool? isLoading,
    SubscriptionPlan? currentPlan,
    List<BillingInvoice>? billingHistory,
    String? errorMessage,
  }) {
    return DoctorSubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      currentPlan: currentPlan ?? this.currentPlan,
      billingHistory: billingHistory ?? this.billingHistory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
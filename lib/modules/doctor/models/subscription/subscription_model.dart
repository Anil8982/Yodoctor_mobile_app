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

  // 🎯 FIXED: Factory initialization mapping for remote backend responses cleanly
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      title: json['title'] ?? '',
      type: json['type'] ?? 'monthly',
      nextBillingDate: json['nextBillingDate'] != null
          ? DateTime.parse(json['nextBillingDate'])
          : DateTime.now(),
      isActive: json['isActive'] ?? false,
      upcomingPlan: json['upcomingPlan'] != null
          ? UpcomingPlan.fromJson(Map<String, dynamic>.from(json['upcomingPlan']))
          : null,
    );
  }
}

class UpcomingPlan {
  final String title;
  final DateTime startDate;

  UpcomingPlan({required this.title, required this.startDate});

  factory UpcomingPlan.fromJson(Map<String, dynamic> json) {
    return UpcomingPlan(
      title: json['title'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
    );
  }
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

  factory BillingInvoice.fromJson(Map<String, dynamic> json) {
    return BillingInvoice(
      invoiceId: json['invoiceId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      planTitle: json['planTitle'] ?? '',
      // 🎯 FIXED ERROR 31: Type shield compilation guard converting safely from int/string to double
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status'] ?? 'unpaid',
    );
  }
}

class DoctorSubscriptionState {
  final bool isLoading;
  final SubscriptionPlan? currentPlan;
  final List<BillingInvoice> billingHistory;
  final List<AvailablePlan> allPlans; // 🎯 FIXED: Added missing remote plans aggregate matrix
  final String? errorMessage;
  final bool isYearly;
  final AvailablePlan? selectedNewPlan;
  final bool showPlans;

  const DoctorSubscriptionState({
    this.isLoading = false,
    this.currentPlan,
    this.billingHistory = const [],
    this.allPlans = const [], // 🎯 FIXED
    this.errorMessage,
    this.isYearly = false,
    this.selectedNewPlan,
    this.showPlans = false,
  });

  DoctorSubscriptionState copyWith({
    bool? isLoading,
    SubscriptionPlan? currentPlan,
    bool clearCurrentPlan = false, // 🎯 FIXED: Support null reset tracking natively
    List<BillingInvoice>? billingHistory,
    List<AvailablePlan>? allPlans, // 🎯 FIXED
    bool? showPlans,
    bool? isYearly,
    AvailablePlan? selectedNewPlan,
    bool clearSelectedPlan = false,
    String? errorMessage,
    bool clearError = false, // 🎯 FIXED: Standard clear error standard boundary
  }) {
    return DoctorSubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      currentPlan: clearCurrentPlan ? null : (currentPlan ?? this.currentPlan),
      billingHistory: billingHistory ?? this.billingHistory,
      allPlans: allPlans ?? this.allPlans, // 🎯 FIXED
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isYearly: isYearly ?? this.isYearly,
      selectedNewPlan: clearSelectedPlan ? null : (selectedNewPlan ?? this.selectedNewPlan),
      showPlans: showPlans ?? this.showPlans,
    );
  }
}
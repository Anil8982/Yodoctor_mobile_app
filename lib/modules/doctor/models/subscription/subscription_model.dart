class SubscriptionPlan {
  final String id;
  final String planId;
  final String title;
  final String type;
  final String status;
  final DateTime nextBillingDate;
  final bool isActive;
  final UpcomingPlan? upcomingPlan;
  final double amount;
  final double? baseAmount;
  final double? gstAmount;
  final String currency;
  final String? rzpSubscriptionId;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final String? lastPaymentId;
  final String? upgradeStatus;
  final DateTime? scheduledActivationDate;

  SubscriptionPlan({
    required this.id,
    required this.planId,
    required this.title,
    required this.type,
    required this.status,
    required this.nextBillingDate,
    this.isActive = false,
    this.upcomingPlan,
    this.amount = 0,
    this.baseAmount,
    this.gstAmount,
    this.currency = 'INR',
    this.rzpSubscriptionId,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.lastPaymentId,
    this.upgradeStatus,
    this.scheduledActivationDate,
  });

  bool get isPending => status.toLowerCase() == 'pending';

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    final statusVal = json['status'] ?? 'inactive';
    final upgradeStatus = json['upgrade_status'];
    final isUpgradeScheduled = upgradeStatus == 'scheduled' || json['scheduled_plan_name'] != null;

    UpcomingPlan? upcoming;
    if (json['upcomingPlan'] != null) {
      upcoming = UpcomingPlan.fromJson(json['upcomingPlan']);
    } else if (isUpgradeScheduled) {
      final title = json['scheduled_plan_name'] ?? json['scheduled_plan_id'] ?? 'Upcoming Plan';
      DateTime? startDate;
      if (json['scheduled_activation_date'] != null) {
        startDate = DateTime.tryParse(json['scheduled_activation_date']);
      } else if (json['current_period_end'] != null) {
        startDate = DateTime.tryParse(json['current_period_end']);
      }
      upcoming = UpcomingPlan(
        title: title.toString(),
        startDate: startDate ?? DateTime.now(),
      );
    }

    return SubscriptionPlan(
      id: json['id'] ?? '',
      planId: json['plan_id'] ?? '',
      title: json['plan_name'] ?? json['title'] ?? '',
      type: json['billing_cycle'] ?? json['type'] ?? 'monthly',
      status: statusVal,
      nextBillingDate: json['next_billing_date'] != null
          ? (DateTime.tryParse(json['next_billing_date']) ?? DateTime.now())
          : (json['current_period_end'] != null
              ? (DateTime.tryParse(json['current_period_end']) ?? DateTime.now())
              : DateTime.now()),
      isActive: statusVal.toLowerCase() == 'active',
      upcomingPlan: upcoming,
      amount: double.tryParse((json['total_amount'] ?? json['amount'] ?? 0).toString()) ?? 0.0,
      baseAmount: json['base_amount'] != null ? double.tryParse(json['base_amount'].toString()) : null,
      gstAmount: json['gst_amount'] != null ? double.tryParse(json['gst_amount'].toString()) : null,
      currency: json['currency'] ?? 'INR',
      rzpSubscriptionId: json['rzp_subscription_id'],
      currentPeriodStart: json['current_period_start'] != null ? DateTime.tryParse(json['current_period_start']) : null,
      currentPeriodEnd: json['current_period_end'] != null ? DateTime.tryParse(json['current_period_end']) : null,
      lastPaymentId: json['last_payment_id'],
      upgradeStatus: upgradeStatus,
      scheduledActivationDate: json['scheduled_activation_date'] != null ? DateTime.tryParse(json['scheduled_activation_date']) : null,
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
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
    );
  }
}

class BillingInvoice {
  final String invoiceId;
  final DateTime date;
  final String planTitle;
  final double amount;
  final String status;

  BillingInvoice({
    required this.invoiceId,
    required this.date,
    required this.planTitle,
    required this.amount,
    required this.status,
  });

  factory BillingInvoice.fromJson(Map<String, dynamic> json) {
    return BillingInvoice(
      invoiceId: json['id'] ?? json['invoiceId'] ?? '',
      date: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'])
          : (json['date'] != null ? DateTime.parse(json['date']) : DateTime.now()),
      planTitle: json['plan_name'] ?? json['planTitle'] ?? '',
      amount: double.tryParse((json['amount'] ?? 0).toString()) ?? 0.0,
      status: json['status'] ?? 'unpaid',
    );
  }
}
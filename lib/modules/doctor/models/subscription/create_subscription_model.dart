class CreateSubscriptionResponse {
  final String subscriptionId;
  final String localSubscriptionId;
  final String razorpayKey;
  final PlanSummary plan;
  final PrefillData prefill;

  CreateSubscriptionResponse({
    required this.subscriptionId, required this.localSubscriptionId,
    required this.razorpayKey, required this.plan, required this.prefill,
  });

  factory CreateSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionResponse(
      subscriptionId: json['subscription_id'] ?? '',
      localSubscriptionId: json['local_subscription_id'] ?? '',
      razorpayKey: json['razorpay_key'] ?? '',
      plan: PlanSummary.fromJson(json['plan'] ?? {}),
      prefill: PrefillData.fromJson(json['prefill'] ?? {}),
    );
  }
}

class PlanSummary {
  final String id, name, currency, billing;
  final double amount;

  PlanSummary({required this.id, required this.name, required this.amount, required this.currency, required this.billing});

  factory PlanSummary.fromJson(Map<String, dynamic> json) {
    return PlanSummary(
      id: json['id'] ?? '', name: json['name'] ?? '',
      amount: double.tryParse((json['amount'] ?? 0).toString()) ?? 0.0,
      currency: json['currency'] ?? 'INR', billing: json['billing'] ?? 'monthly',
    );
  }
}

class PrefillData {
  final String name, email, contact;
  PrefillData({required this.name, required this.email, required this.contact});

  factory PrefillData.fromJson(Map<String, dynamic> json) {
    return PrefillData(
      name: json['name'] ?? '', email: json['email'] ?? '', contact: json['contact'] ?? '',
    );
  }
}
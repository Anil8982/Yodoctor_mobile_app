import 'subscription_model.dart';

class SubscriptionVerifyResponse {
  final SubscriptionPlan? subscription;
  final String? invoiceId;
  final String? paymentId;

  SubscriptionVerifyResponse({this.subscription, this.invoiceId, this.paymentId});

  factory SubscriptionVerifyResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionVerifyResponse(
      subscription: json['subscription'] != null ? SubscriptionPlan.fromJson(json['subscription']) : null,
      invoiceId: json['invoice_id'],
      paymentId: json['payment_id'],
    );
  }
}
import '../../doctor/models/subscription/create_subscription_model.dart';

class PaymentOrderModel {
  final String orderId, currency, razorpayKey;
  final double amount;
  final PrefillData? prefill;

  PaymentOrderModel({required this.orderId, required this.amount, required this.currency, required this.razorpayKey, this.prefill});

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) {
    return PaymentOrderModel(
      orderId: json['order_id'] ?? '',
      amount: double.tryParse((json['amount'] ?? 0).toString()) ?? 0.0,
      currency: json['currency'] ?? 'INR',
      razorpayKey: json['razorpay_key'] ?? '',
      prefill: json['prefill'] != null ? PrefillData.fromJson(json['prefill']) : null,
    );
  }
}
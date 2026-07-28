// lib/modules/payment/services/razorpay_service.dart
import 'package:razorpay_flutter/razorpay_flutter.dart';

enum RazorpayPaymentType { subscription, order }

class RazorpayOptions {
  final String key;
  final String? subscriptionId;
  final String? orderId;
  final String name;
  final String description;
  final Map<String, String> prefill;
  final RazorpayPaymentType paymentType;

  RazorpayOptions({
    required this.key,
    this.subscriptionId,
    this.orderId,
    required this.name,
    required this.description,
    this.prefill = const {},
    required this.paymentType,
  });
}
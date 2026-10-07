// lib/modules/payment/providers.dart (New file)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/payment/controllers/razorpay_controller.dart';

final razorpayControllerProvider = Provider<RazorpayController>((ref) {
  final controller = RazorpayController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
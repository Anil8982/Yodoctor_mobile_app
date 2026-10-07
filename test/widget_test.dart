import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yodoctor/modules/payment/screens/payment_success_screen.dart';

void main() {
  testWidgets('Payment Success Screen Preview', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PaymentSuccessScreen(
            paymentId: 'pay_RzP8QwX123456',
            planName: 'Premium Monthly',
            nextRoute: '/doctor/dashboard',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  });
}
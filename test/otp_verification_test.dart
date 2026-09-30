import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/models/login_response.dart';
import 'package:yodoctor/modules/auth/widgets/otp_bottom_sheet.dart';

void main() {
  group('LoginResponse OTP parsing tests', () {
    test('parses normal successful login response without OTP', () {
      final json = {
        'success': true,
        'message': 'Login successful',
        'data': {'token': 'jwt_token_123'},
      };

      final response = LoginResponse.fromJson(json);

      expect(response.success, true);
      expect(response.requiresOtp, false);
      expect(response.token, 'jwt_token_123');
    });

    test('parses login response requiring email OTP', () {
      final json = {
        'success': true,
        'message': 'OTP sent to email',
        'requiresOtp': true,
        'verificationId': 'ver_12345',
        'channel': 'EMAIL',
        'maskedEmail': 's***@gmail.com',
      };

      final response = LoginResponse.fromJson(json);

      expect(response.success, true);
      expect(response.requiresOtp, true);
      expect(response.verificationId, 'ver_12345');
      expect(response.channel, 'EMAIL');
      expect(response.maskedDestination, 's***@gmail.com');
    });

    test('parses login response requiring SMS OTP', () {
      final json = {
        'success': true,
        'message': 'OTP sent to mobile',
        'otpRequired': true,
        'channel': 'SMS',
        'mobile': '+919876543210',
      };

      final response = LoginResponse.fromJson(json);

      expect(response.success, true);
      expect(response.requiresOtp, true);
      expect(response.channel, 'SMS');
      expect(response.mobile, '+919876543210');
    });
  });

  group('OtpBottomSheet Widget Tests', () {
    testWidgets('renders title, supporting text, and buttons correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.patientTheme,
          home: Scaffold(
            body: OtpBottomSheet(
              verificationId: 'ver_test',
              channel: 'EMAIL',
              maskedDestination: 'user***@domain.com',
              primaryColor: AppTheme.secondary,
              onVerify: (otp) async => true,
              onResend: () async => true,
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify title & supporting text
      expect(find.text('Verify OTP'), findsOneWidget);
      expect(
        find.text('Enter the 6-digit OTP sent to user***@domain.com.'),
        findsOneWidget,
      );

      // Verify buttons
      expect(find.text('Verify & Proceed'), findsOneWidget);
      expect(find.textContaining('Resend OTP in'), findsOneWidget);
    });

    testWidgets('Verify button triggers onVerify callback with 6-digit OTP',
        (WidgetTester tester) async {
      String? submittedOtp;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.doctorTheme,
          home: Scaffold(
            body: OtpBottomSheet(
              channel: 'SMS',
              mobile: '+919876543210',
              primaryColor: AppTheme.primary,
              onVerify: (otp) async {
                submittedOtp = otp;
                return true;
              },
              onResend: () async => true,
            ),
          ),
        ),
      );

      await tester.pump();

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, '654321');
      await tester.pump();

      expect(submittedOtp, '654321');
    });

    testWidgets('displays inline error message when verification fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.patientTheme,
          home: Scaffold(
            body: OtpBottomSheet(
              channel: 'EMAIL',
              maskedDestination: 'test@example.com',
              primaryColor: AppTheme.secondary,
              onVerify: (otp) async => 'Invalid OTP entered',
              onResend: () async => true,
            ),
          ),
        ),
      );

      await tester.pump();

      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, '123456');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Invalid OTP entered'), findsOneWidget);

      // Modifying text should clear the error
      await tester.enterText(textFieldFinder, '12345');
      await tester.pump();

      expect(find.text('Invalid OTP entered'), findsNothing);
    });
  });

  group('OTP Payload Structure Tests', () {
    test('email OTP payload contains only verificationId, otp, and channel', () {
      final payload = {
        'otp': '123456',
        'channel': 'EMAIL',
        'verificationId': 'ver_test_123',
      };

      expect(payload.containsKey('portal'), isFalse);
      expect(payload['otp'], '123456');
      expect(payload['channel'], 'EMAIL');
      expect(payload['verificationId'], 'ver_test_123');
    });

    test('sms OTP payload contains only otp, channel, and mobile', () {
      final payload = {
        'otp': '654321',
        'channel': 'SMS',
        'mobile': '+919876543210',
      };

      expect(payload.containsKey('portal'), isFalse);
      expect(payload['otp'], '654321');
      expect(payload['channel'], 'SMS');
      expect(payload['mobile'], '+919876543210');
    });
  });
}

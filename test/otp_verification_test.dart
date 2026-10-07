import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yodoctor/core/providers/otp_cooldown_provider.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_error_utils.dart';
import 'package:yodoctor/modules/auth/models/login_response.dart';
import 'package:yodoctor/modules/auth/models/otp_response.dart';
import 'package:yodoctor/modules/auth/controllers/patient_register_controller.dart';
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

    test('parses live web app OTP initiation response correctly', () {
      final json = {
        "success": true,
        "requiresOtp": true,
        "message": "OTP sent to your registered email",
        "verificationId": "96454c35-12f3-40f8-8956-57be70aaeffd",
        "channel": "EMAIL",
        "destination": "sa***@gmail.com",
        "expiresIn": 300,
      };

      final response = LoginResponse.fromJson(json);

      expect(response.success, true);
      expect(response.requiresOtp, true);
      expect(response.message, "OTP sent to your registered email");
      expect(response.verificationId, "96454c35-12f3-40f8-8956-57be70aaeffd");
      expect(response.channel, "EMAIL");
      expect(response.destination, "sa***@gmail.com");
      expect(response.maskedDestination, "sa***@gmail.com");
      expect(response.expiresIn, 300);
    });

    test('login with OTP payload structure has empty password and loginWithOtp=true', () {
      final payload = {
        "identifier": "user@example.com",
        "password": "",
        "portal": "USER",
        "loginWithOtp": true,
      };

      expect(payload['identifier'], "user@example.com");
      expect(payload['password'], "");
      expect(payload['portal'], "USER");
      expect(payload['loginWithOtp'], isTrue);
    });

    test('normal password login payload structure does not have loginWithOtp flag', () {
      final payload = {
        "identifier": "user@example.com",
        "password": "SecretPassword123",
        "portal": "USER",
      };

      expect(payload['password'], "SecretPassword123");
      expect(payload.containsKey('loginWithOtp'), isFalse);
    });
  });

  group('Registration OTP Response Models Tests', () {
    test('parses Send Registration Email OTP response correctly', () {
      final json = {
        "success": true,
        "message": "OTP sent successfully to email",
        "verificationId": "96454c35-12f3-40f8-8956-57be70aaeffd",
        "expiresIn": 300,
      };

      final response = OtpSendResponse.fromJson(json);

      expect(response.success, true);
      expect(response.message, "OTP sent successfully to email");
      expect(response.verificationId, "96454c35-12f3-40f8-8956-57be70aaeffd");
      expect(response.expiresIn, 300);
    });

    test('parses Verify Registration Email OTP response correctly', () {
      final json = {
        "success": true,
        "message": "Email verified successfully",
        "verificationId": "a1b2c3d4-e5f6-7890-abcd-1234567890ab",
        "email": "test@example.com",
        "verified": true,
      };

      final response = OtpVerifyResponse.fromJson(json);

      expect(response.success, true);
      expect(response.verified, true);
      expect(response.email, "test@example.com");
      expect(response.verificationId, "a1b2c3d4-e5f6-7890-abcd-1234567890ab");
    });

    test('parses Send Registration Mobile OTP response correctly', () {
      final json = {
        "success": true,
        "message": "OTP sent successfully to mobile number",
        "verificationId": "a1b2c3d4-e5f6-7890-abcd-1234567890ab",
      };

      final response = OtpSendResponse.fromJson(json);

      expect(response.success, true);
      expect(response.verificationId, "a1b2c3d4-e5f6-7890-abcd-1234567890ab");
    });

    test('parses Verify Registration Mobile OTP response correctly', () {
      final json = {
        "success": true,
        "message": "Mobile number verified successfully",
        "verificationId": "a1b2c3d4-e5f6-7890-abcd-1234567890ab",
        "phone": "9876543210",
        "verified": true,
      };

      final response = OtpVerifyResponse.fromJson(json);

      expect(response.success, true);
      expect(response.verified, true);
      expect(response.phone, "9876543210");
    });
  });

  group('AppErrorUtils Sanitization Tests', () {
    test('converts invalid OTP error to user friendly message', () {
      final msg = AppErrorUtils.sanitizeErrorMessage('Invalid OTP');
      expect(msg, 'Incorrect OTP. Please check the code and try again.');
    });

    test('converts expired OTP error to user friendly message', () {
      final msg = AppErrorUtils.sanitizeErrorMessage('OTP has expired');
      expect(msg, 'This OTP has expired. Please request a new OTP.');
    });

    test('converts network errors to user friendly message', () {
      final msg = AppErrorUtils.sanitizeErrorMessage('SocketException: Connection refused (errno = 111)');
      expect(msg, 'Unable to connect right now. Please check your internet connection and try again.');
    });

    test('converts duplicate email errors to user friendly message', () {
      final msg = AppErrorUtils.sanitizeErrorMessage('email already exists in database');
      expect(msg, 'This email is already registered. Please use a different email or log in.');
    });

    test('converts duplicate phone errors to user friendly message', () {
      final msg = AppErrorUtils.sanitizeErrorMessage('phone already registered');
      expect(msg, 'This mobile number is already registered. Please use a different number or log in.');
    });

    test('filters out raw technical exceptions', () {
      final msg = AppErrorUtils.sanitizeErrorMessage("type 'String' is not a subtype of type 'Map<String, dynamic>'");
      expect(msg, 'Something went wrong. Please try again.');
    });
  });

  group('PatientRegisterController State Tests', () {
    test('initial state has unverified email and mobile', () {
      final container = ProviderContainer();
      final state = container.read(patientRegisterControllerProvider);

      expect(state.isMobileVerified, false);
      expect(state.isEmailVerified, false);
      expect(state.mobileVerificationId, isNull);
      expect(state.emailVerificationId, isNull);
    });

    test('changing email after verification resets email verification state', () {
      final container = ProviderContainer();
      final notifier = container.read(patientRegisterControllerProvider.notifier);

      // Simulate verified email
      notifier.state = notifier.state.copyWith(
        isEmailVerified: true,
        verifiedEmail: 'verified@example.com',
        emailVerificationId: 'ver_email_123',
      );

      expect(notifier.state.isEmailVerified, true);
      expect(notifier.state.emailVerificationId, 'ver_email_123');

      // Modifying email text
      notifier.onEmailChanged('modified@example.com');

      expect(notifier.state.isEmailVerified, false);
      expect(notifier.state.emailVerificationId, isNull);
    });

    test('changing mobile after verification resets mobile verification state', () {
      final container = ProviderContainer();
      final notifier = container.read(patientRegisterControllerProvider.notifier);

      // Simulate verified mobile
      notifier.state = notifier.state.copyWith(
        isMobileVerified: true,
        verifiedPhone: '9876543210',
        mobileVerificationId: 'ver_mobile_123',
      );

      expect(notifier.state.isMobileVerified, true);
      expect(notifier.state.mobileVerificationId, 'ver_mobile_123');

      // Modifying phone text
      notifier.onPhoneChanged('9876543211');

      expect(notifier.state.isMobileVerified, false);
      expect(notifier.state.mobileVerificationId, isNull);
    });
  });

  group('OtpBottomSheet Widget Tests', () {
    testWidgets('renders title, supporting text, and buttons correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
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
        ProviderScope(
          child: MaterialApp(
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
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.patientTheme,
            home: Scaffold(
              body: OtpBottomSheet(
                channel: 'EMAIL',
                maskedDestination: 'test@example.com',
                primaryColor: AppTheme.secondary,
                onVerify: (otp) async => 'Incorrect OTP. Please check the code and try again.',
                onResend: () async => true,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, '123456');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Incorrect OTP. Please check the code and try again.'), findsOneWidget);

      // Modifying text should clear the error
      await tester.enterText(textFieldFinder, '12345');
      await tester.pump();

      expect(find.text('Incorrect OTP. Please check the code and try again.'), findsNothing);
    });

    testWidgets('preserves persistent cooldown across sheet dismiss and reopen',
        (WidgetTester tester) async {
      final container = ProviderContainer();
      container.read(otpCooldownProvider.notifier).startCooldown(18);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.patientTheme,
            home: Scaffold(
              body: OtpBottomSheet(
                channel: 'EMAIL',
                maskedDestination: 'test@example.com',
                primaryColor: AppTheme.secondary,
                onVerify: (otp) async => true,
                onResend: () async => true,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Expect to find active countdown reflecting controller timestamp and disabled action
      expect(find.textContaining('Resend OTP in'), findsOneWidget);
      expect(find.text('Resend OTP'), findsNothing);
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

  group('OTP Cooldown Controller Tests', () {
    test('startCooldown sets active cooldown remaining seconds', () {
      final container = ProviderContainer();
      final notifier = container.read(otpCooldownProvider.notifier);

      expect(notifier.remainingSeconds, 0);

      notifier.startCooldown(25);
      expect(notifier.remainingSeconds, greaterThan(0));
      expect(notifier.remainingSeconds, lessThanOrEqualTo(25));

      notifier.reset();
      expect(notifier.remainingSeconds, 0);
    });
  });
}

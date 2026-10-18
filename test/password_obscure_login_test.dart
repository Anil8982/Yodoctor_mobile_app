import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yodoctor/modules/auth/screens/unified_login_screen.dart';
import 'package:yodoctor/modules/auth/widgets/yo_login_text_field.dart';

void main() {
  group('YoLoginTextField and UnifiedLoginScreen Password Obscure Tests', () {
    testWidgets(
      'YoLoginTextField toggles obscure state and respects external obscureText',
      (tester) async {
        bool obscure = true;
        final controller = TextEditingController(text: 'secret123');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return YoLoginTextField(
                    color: Colors.blue,
                    hint: 'Password',
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    controller: controller,
                    obscureText: obscure,
                    onObscureToggle: (val) {
                      setState(() {
                        obscure = val;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );

        // Initially obscured
        TextField textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

        // Tap eye icon to make password visible
        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pumpAndSettle();

        textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isFalse);
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

        // External state hides it
        obscure = true;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return YoLoginTextField(
                    color: Colors.blue,
                    hint: 'Password',
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    controller: controller,
                    obscureText: obscure,
                    onObscureToggle: (val) {
                      setState(() {
                        obscure = val;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'Clicking login button hides visible password in UnifiedLoginScreen',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: UnifiedLoginScreen(role: UserRole.patient),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find password text field (the second TextField)
        final textFieldFinders = find.byType(TextField);
        expect(textFieldFinders, findsNWidgets(2));

        // Enter password
        final passwordFieldFinder = textFieldFinders.at(1);
        await tester.enterText(passwordFieldFinder, 'pass123');
        await tester.pumpAndSettle();

        // Verify initially obscured
        TextField passwordField = tester.widget(passwordFieldFinder);
        expect(passwordField.obscureText, isTrue);

        // Tap eye icon to un-obscure (show password)
        final eyeIconFinder = find.byIcon(Icons.visibility_outlined);
        expect(eyeIconFinder, findsOneWidget);
        await tester.tap(eyeIconFinder);
        await tester.pumpAndSettle();

        // Now password should be visible (obscureText is false)
        passwordField = tester.widget(passwordFieldFinder);
        expect(passwordField.obscureText, isFalse);
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

        // Now click on the Login button (FilledButton)
        final loginButtonFinder = find.widgetWithText(FilledButton, 'Login');
        expect(loginButtonFinder, findsOneWidget);
        await tester.tap(loginButtonFinder);
        await tester.pumpAndSettle();

        // Password MUST be hidden again (obscureText is true)
        passwordField = tester.widget(passwordFieldFinder);
        expect(passwordField.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      },
    );
  });
}

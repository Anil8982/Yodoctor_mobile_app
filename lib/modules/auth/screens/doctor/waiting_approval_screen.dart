import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: AppTheme.yoBlue.withOpacity(0.1),
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 60,
                    color: AppTheme.yoBlue,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Registration Submitted",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Your registration has been submitted successfully.\n\nOur admin team will verify your documents.\n\nYou will be able to login after approval.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),

                const SizedBox(height: 40),

                FilledButton(
                  onPressed: () {
                    context.go(AppRoutes.doctorLogin);
                  },
                  child: const Text("Back to Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

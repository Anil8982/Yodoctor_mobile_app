import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../../core/routes/app_routes.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    AppLogger.info('Rendering WaitingApprovalScreen', tag: LogTags.ui, subTag: 'WaitingApprovalScreen');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 48,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Registration Submitted",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Your registration has been submitted successfully.\n\nOur admin team will verify your documents.\n\nYou will be able to login after approval.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      AppLogger.info('Navigating back to doctor login from approval screen', tag: LogTags.ui, subTag: 'WaitingApprovalScreen');
                      context.go(AppRoutes.doctorLogin);
                    },
                    child: const Text("Back to Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
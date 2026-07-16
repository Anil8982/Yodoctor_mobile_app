import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_login_controller.dart';

class WaitingApprovalScreen extends ConsumerWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 1. Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pending_actions_rounded, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text("Approval Pending", style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),

              // 2. Main Card Content
              Image.asset(AppAssets.logo(context)),
              const Spacer(),

              Card(
                elevation: 0,
                color: colorScheme.tertiaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.secondaryContainer,
                        child: Icon(Icons.hourglass_top_rounded, size: 48, color: colorScheme.onSecondaryContainer),
                      ),
                      const SizedBox(height: 16),
                      Chip(label: Text("Under Review", style: TextStyle(color: colorScheme.onTertiary)), backgroundColor: colorScheme.onTertiaryContainer.transparency(.9)),
                      const SizedBox(height: 24),
                      Text("Your registration is under review", style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Text("Our admin team is carefully reviewing your submitted documents and credentials. You will be notified once a decision is made.",
                          textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 32),

                      // 3. Progress Section
                      _buildProgressSteps(colorScheme),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // 4. Bottom Actions
              OutlinedButton.icon(
                onPressed: () => ref.read(doctorLoginControllerProvider.notifier).logout(),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.support_agent),
                label: const Text("Contact Support"),
                style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSteps(ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            _stepIcon(colorScheme, true, null), // 1. Submitted
            Expanded(child: Container(height: 3, color: colorScheme.primary)),
            _stepIcon(colorScheme, true, null), // 2. Under Review
            Expanded(child: Container(height: 3, color: colorScheme.outlineVariant)),
            _stepIcon(colorScheme, false, "3"),  // 3. Decision
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Submitted", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            Expanded(child: Text("Under Review", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
            Text("Decision", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _stepIcon(ColorScheme colorScheme, bool completed, String? stepNumber) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? colorScheme.primary : colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: completed
            ? Icon(Icons.check, size: 18, color: colorScheme.onPrimary)
            : Text(stepNumber ?? "", style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant)),
      ),
    );
  }
}
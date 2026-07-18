import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_login_controller.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_status_controller.dart';

class VerificationStatusScreen extends ConsumerWidget {
  const VerificationStatusScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(doctorStatusProvider);
    final notifier = ref.read(doctorStatusProvider.notifier);

    if (state.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () => notifier.checkStatus(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(notifier.statusIcon, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            notifier.statusTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Image.asset(
                          AppAssets.logo(context),
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 10,
                          shadowColor: colorScheme.primary,
                          color: colorScheme.tertiaryContainer,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 280),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor:
                                      colorScheme.secondaryContainer,
                                  child: Icon(
                                    notifier.statusIcon,
                                    size: 48,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Chip(
                                  label: Text(
                                    notifier.statusTitle,
                                    style: TextStyle(
                                      color: colorScheme.onTertiary,
                                    ),
                                  ),
                                  backgroundColor: colorScheme
                                      .onTertiaryContainer
                                      .transparency(.9),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  notifier.statusTitle,
                                  style: theme.textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  notifier.description,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                if (state.status == 'PENDING') ...[
                                  const SizedBox(height: 32),
                                  _buildProgressSteps(colorScheme),
                                ] else ...[
                                  const SizedBox(height: 24),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () => ref
                            .read(doctorLoginControllerProvider.notifier)
                            .logout(),
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.support_agent),
                        label: const Text("Contact Support"),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSteps(ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            _stepIcon(colorScheme, true, null),
            Expanded(child: Container(height: 3, color: colorScheme.primary)),
            _stepIcon(colorScheme, true, null),
            Expanded(
              child: Container(height: 3, color: colorScheme.outlineVariant),
            ),
            _stepIcon(colorScheme, false, "3"),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Submitted",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                "Under Review",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              "Decision",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stepIcon(
    ColorScheme colorScheme,
    bool completed,
    String? stepNumber,
  ) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: completed
            ? Icon(Icons.check, size: 18, color: colorScheme.onPrimary)
            : Text(
                stepNumber ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }
}

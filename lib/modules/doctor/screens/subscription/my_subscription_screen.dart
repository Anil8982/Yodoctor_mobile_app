import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_login_controller.dart';
import 'package:yodoctor/modules/widgets/logout_dialog.dart';
import '../../controllers/subscription_controller.dart';
import 'widgets/available_plans_section.dart';
import 'widgets/main_plan_card.dart';
import 'widgets/billing_history_section.dart';

class MySubscriptionScreen extends ConsumerWidget {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorSubscriptionProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final bool hasActivePlan =
        state.currentPlan != null && state.currentPlan!.isActive;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'My Subscription',
        ),
        // 🎯 Added Logout action button in AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, color: colorScheme.error),
            tooltip: 'Logout',
            onPressed: () async {
              // Confirm before logging out
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => LogoutDialog(role: AppRole.doctor,)
              );

              if (shouldLogout == true) {
                // Trigger logout from DoctorLoginController
                await ref.read(doctorLoginControllerProvider.notifier).logout();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.isLoading && state.currentPlan == null
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null && state.currentPlan == null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  ref.read(doctorSubscriptionProvider.notifier).loadSubscriptionDetails();
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          await ref.read(doctorSubscriptionProvider.notifier).loadSubscriptionDetails();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.isLoading && state.currentPlan != null) ...[
                    LinearProgressIndicator(color: colorScheme.primary),
                    const SizedBox(height: 16),
                  ],
                  if (hasActivePlan) ...[
                    MainPlanCard(plan: state.currentPlan!),
                    const SizedBox(height: 32),
                  ],
                  _buildUpgradeButton(context, ref),
                  const SizedBox(height: 32),
                  BillingHistorySection(history: state.billingHistory),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeButton(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            builder: (context) => const AvailablePlansSection(),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.upgrade_rounded, size: 20),
        label: const Text(
          'Upgrade plan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
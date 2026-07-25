import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/doctor/screens/subscription/widgets/my_subscription_shimmer.dart';
import '../../controllers/subscription_controller.dart';
import 'widgets/available_plans_section.dart';
import 'widgets/billing_history_section.dart';
import 'widgets/subscription_plan_card.dart';

class MySubscriptionScreen extends ConsumerWidget {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorSubscriptionProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final bool hasActivePlan = state.currentPlan != null && state.currentPlan!.isActive;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Subscription'),
        centerTitle: false,
      ),
      body: state.errorMessage != null && !state.isInitialized
          ? _buildErrorView(context, ref, state.errorMessage!, colorScheme, theme)
          : state.isLoading && !state.isInitialized
          ? const MySubscriptionShimmer()
          : RefreshIndicator(
        onRefresh: () async {
          await ref.read(doctorSubscriptionProvider.notifier).loadSubscriptionDetails();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.isLoading) ...[
                    LinearProgressIndicator(color: colorScheme.primary, minHeight: 3),
                    const SizedBox(height: 24),
                  ],
                  SubscriptionPlanCard(
                    plan: hasActivePlan ? state.currentPlan : null,
                    onUpgradePressed: () => _showPlansSheet(context),
                  ),
                  const SizedBox(height: 32),
                  if (hasActivePlan) ...[
                    _buildQuickStats(context, state, colorScheme, theme),
                    const SizedBox(height: 32),
                  ],
                  _buildChangePlanButton(context, colorScheme),
                  const SizedBox(height: 20),
                  if (state.billingHistory.isNotEmpty)
                    BillingHistorySection(history: state.billingHistory)
                  else
                    _buildEmptyHistory(theme, colorScheme),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(
      BuildContext context,
      DoctorSubscriptionState state,
      ColorScheme colorScheme,
      ThemeData theme,
      ) {
    final plan = state.currentPlan!;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.calendar_today_rounded,
            label: 'Billing Cycle',
            value: plan.type.toUpperCase(),
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.update_rounded,
            label: 'Next Billing',
            value: _formatDate(plan.nextBillingDate),
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.verified_rounded,
            label: 'Status',
            value: plan.isActive ? 'Active' : 'Inactive',
            valueColor: plan.isActive ? Colors.green : Colors.red,
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.transparency(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildChangePlanButton(BuildContext context, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showPlansSheet(context),
        icon: const Icon(Icons.swap_horiz_rounded, size: 20),
        label: const Text('Change Plan'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.transparency(0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildEmptyHistory(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.transparency(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_rounded, size: 48, color: colorScheme.onSurfaceVariant.transparency(0.5)),
          const SizedBox(height: 12),
          Text('No billing history yet', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(
            'Your payment history will appear here',
            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant.transparency(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(
      BuildContext context,
      WidgetRef ref,
      String errorMessage,
      ColorScheme colorScheme,
      ThemeData theme,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.transparency(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi_off_rounded, size: 48, color: colorScheme.error),
            ),
            const SizedBox(height: 24),
            Text('Connection Error', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 8),
            Text(errorMessage, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.read(doctorSubscriptionProvider.notifier).loadSubscriptionDetails(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlansSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => const AvailablePlansSection(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}


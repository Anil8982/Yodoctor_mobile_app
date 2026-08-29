import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/modules/doctor/controllers/subscription_status_controller.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/logout_dialog.dart';
import '../../controllers/subscription_controller.dart';
import 'widgets/available_plans_section.dart';
import 'widgets/billing_history_section.dart';
import 'widgets/subscription_plan_card.dart';
import 'widgets/subscription_verification_shimmer.dart';

class SubscriptionVerificationPage extends ConsumerWidget {
  const SubscriptionVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorSubscriptionProvider);
    final subStatus = ref.watch(subscriptionStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final bool hasActivePlan =
        state.currentPlan != null && state.currentPlan!.isActive;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: 'Activate Your Account',
        showBackButton: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () async {
                LogoutDialog.show(context, ref, role: AppRole.doctor);
              },
              icon: Icon(
                Icons.logout_rounded,
                size: 18,
                color: colorScheme.error,
              ),
              label: Text(
                'Logout',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body:
          state.errorMessage != null &&
              !state.isInitialized &&
              state.allPlans.isEmpty
          ? _buildErrorState(
              context,
              ref,
              state.errorMessage!,
              colorScheme,
              theme,
            )
          : state.isLoading && !state.isInitialized
          ? const SubscriptionVerificationShimmer()
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(subscriptionStatusProvider.notifier)
                    .checkActiveSubscription();
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
                        _buildVerificationBanner(subStatus, colorScheme, theme),
                        if (state.isLoading) ...[
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            color: colorScheme.primary,
                            minHeight: 3,
                          ),
                        ],
                        const SizedBox(height: 24),
                        _buildHeaderSection(theme, colorScheme),
                        const SizedBox(height: 24),
                        SubscriptionPlanCard(
                          plan: hasActivePlan ? state.currentPlan : null,
                          onUpgradePressed: () =>
                              _showPlansBottomSheet(context, ref),
                        ),
                        const SizedBox(height: 24),
                        _buildFeaturesSection(theme, colorScheme),
                        const SizedBox(height: 24),
                        _buildInlinePlansSection(
                          context,
                          ref,
                          state,
                          theme,
                          colorScheme,
                        ),
                        const SizedBox(height: 24),
                        _buildRefreshButton(context, ref, colorScheme),
                        const SizedBox(height: 24),
                        if (state.isInitialized &&
                            state.billingHistory.isNotEmpty) ...[
                          const Divider(),
                          const SizedBox(height: 16),
                          BillingHistorySection(history: state.billingHistory),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildVerificationBanner(
    SubscriptionStatusState subStatus,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Card(
      color: subStatus.isLoading
          ? colorScheme.primaryContainer
          : subStatus.hasSubscription
          ? colorScheme.tertiaryContainer
          : colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              subStatus.isLoading
                  ? Icons.hourglass_top_rounded
                  : subStatus.hasSubscription
                  ? Icons.check_circle_rounded
                  : Icons.warning_rounded,
              color: subStatus.isLoading
                  ? colorScheme.onPrimaryContainer
                  : subStatus.hasSubscription
                  ? colorScheme.onTertiaryContainer
                  : colorScheme.onErrorContainer,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subStatus.isLoading
                        ? 'Verifying subscription...'
                        : subStatus.hasSubscription
                        ? 'Subscription Active!'
                        : 'No Active Subscription',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: subStatus.isLoading
                          ? colorScheme.onPrimaryContainer
                          : subStatus.hasSubscription
                          ? colorScheme.onTertiaryContainer
                          : colorScheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subStatus.isLoading
                        ? 'Please wait while we check your subscription status'
                        : subStatus.hasSubscription
                        ? 'Redirecting to dashboard...'
                        : 'Choose a plan below to activate your account',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: subStatus.isLoading
                          ? colorScheme.onPrimaryContainer.transparency(0.8)
                          : subStatus.hasSubscription
                          ? colorScheme.onTertiaryContainer.transparency(0.8)
                          : colorScheme.onErrorContainer.transparency(0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (subStatus.isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a subscription plan that works best for your practice. '
          'All plans include access to patient management, appointments, and certificates.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(ThemeData theme, ColorScheme colorScheme) {
    final features = [
      {
        'icon': Icons.calendar_month_rounded,
        'title': 'Appointment Management',
        'desc': 'Manage patient appointments efficiently',
      },
      {
        'icon': Icons.description_rounded,
        'title': 'Digital Certificates',
        'desc': 'Issue medical certificates instantly',
      },
      {
        'icon': Icons.qr_code_scanner_rounded,
        'title': 'QR Check-in',
        'desc': 'Quick patient check-in with QR codes',
      },
      {
        'icon': Icons.people_rounded,
        'title': 'Patient History',
        'desc': 'Access complete patient medical history',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Included Features',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Card(
              color: colorScheme.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feature['title'] as String,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feature['desc'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInlinePlansSection(
    BuildContext context,
    WidgetRef ref,
    DoctorSubscriptionState state,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (state.allPlans.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Plans',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showPlansBottomSheet(context, ref),
              icon: const Icon(Icons.open_in_full_rounded, size: 16),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: state.allPlans.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final plan = state.allPlans[index];
              final isSelected = state.selectedNewPlan?.id == plan.id;

              return SizedBox(
                width: 200,
                child: Card(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan.durationText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${plan.currentPrice.toStringAsFixed(0)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              ref
                                  .read(doctorSubscriptionProvider.notifier)
                                  .selectNewPlan(plan);
                              _showPlansBottomSheet(context, ref);
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              backgroundColor: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.primaryContainer,
                              foregroundColor: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onPrimaryContainer,
                            ),
                            child: Text(isSelected ? 'Selected' : 'Choose'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          await ref
              .read(subscriptionStatusProvider.notifier)
              .checkActiveSubscription();
        },
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: const Text('Check Status Again'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          foregroundColor: colorScheme.onSurface,
        ),
      ),
    );
  }

  void _showPlansBottomSheet(BuildContext context, WidgetRef ref) async {
    await ref.read(doctorSubscriptionProvider.notifier).loadPlans();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const AvailablePlansSection(),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    String errorMessage,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => ref
                  .read(subscriptionStatusProvider.notifier)
                  .checkActiveSubscription(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }
}

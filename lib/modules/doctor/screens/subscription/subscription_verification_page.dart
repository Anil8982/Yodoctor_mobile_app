import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_status_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/subscription_status_controller.dart';
import 'package:yodoctor/modules/doctor/models/subscription/available_plan_model.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import 'package:yodoctor/modules/widgets/logout_dialog.dart';
import '../../controllers/subscription_controller.dart';
import '../../models/subscription/subscription_model.dart';
import 'widgets/available_plans_section.dart';
import 'widgets/billing_history_section.dart';
import 'widgets/subscription_plan_card.dart';
import 'widgets/subscription_verification_shimmer.dart';

class SubscriptionVerificationPage extends ConsumerStatefulWidget {
  const SubscriptionVerificationPage({super.key});

  @override
  ConsumerState<SubscriptionVerificationPage> createState() =>
      _SubscriptionVerificationPageState();
}

class _SubscriptionVerificationPageState
    extends ConsumerState<SubscriptionVerificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionStatusProvider.notifier).checkActiveSubscription();
      ref.read(doctorSubscriptionProvider.notifier).loadSubscriptionDetails();
      ref.read(doctorSubscriptionProvider.notifier).loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorSubscriptionProvider);
    final subStatus = ref.watch(subscriptionStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final SubscriptionPlan? effectivePlan =
        state.currentPlan ?? subStatus.subscriptionPlan;
    final bool hasActivePlan =
        effectivePlan != null && effectivePlan.isActive;

    ref.listen(doctorSubscriptionProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage &&
          next.errorMessage!.isNotEmpty) {
        AppSnackBar.show(
          message: next.errorMessage!,
          type: AppSnackBarType.error,
        );
      }

      if (previous?.paymentFlow != next.paymentFlow) {
        switch (next.paymentFlow) {
          case PaymentFlowState.processing:
            context.push(AppRoutes.paymentProcessing);
            break;

          case PaymentFlowState.success:
            final docStatus = ref.read(doctorStatusProvider).status ??
                ref.read(storageProvider).getStatus();
            final isApproved = docStatus == 'APPROVED';
            final nextRoute = isApproved
                ? AppRoutes.doctorDashboard
                : AppRoutes.waitingApproval;

            context.go(
              AppRoutes.paymentSuccess,
              extra: {
                "paymentId": next.paymentId ?? '',
                "planName": next.planName ?? next.currentPlan?.title,
                "nextRoute": nextRoute,
              },
            );
            break;

          case PaymentFlowState.failed:
          case PaymentFlowState.idle:
            break;
        }
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                await Future.wait([
                  ref
                      .read(subscriptionStatusProvider.notifier)
                      .checkActiveSubscription(),
                  ref
                      .read(doctorSubscriptionProvider.notifier)
                      .loadSubscriptionDetails(),
                  ref
                      .read(doctorSubscriptionProvider.notifier)
                      .loadPlans(),
                ]);
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
                        _buildVerificationBanner(
                          subStatus,
                          state,
                          colorScheme,
                          theme,
                        ),
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
                          plan: hasActivePlan
                              ? effectivePlan
                              : (effectivePlan?.isPending == true
                                  ? effectivePlan
                                  : null),
                          onUpgradePressed: () async {
                            if (effectivePlan?.isPending == true) {
                              if (state.allPlans.isEmpty) {
                                await ref
                                    .read(doctorSubscriptionProvider.notifier)
                                    .loadPlans();
                              }
                              final currentPlans = ref.read(doctorSubscriptionProvider).allPlans;
                              var matching = currentPlans
                                  .where((p) => p.id == effectivePlan?.planId)
                                  .firstOrNull;
                              matching ??= currentPlans
                                  .where((p) =>
                                      p.slug == effectivePlan?.planId ||
                                      (effectivePlan != null &&
                                          effectivePlan.title.toLowerCase().contains(p.title.toLowerCase())))
                                  .firstOrNull;
                              if (matching == null && effectivePlan != null) {
                                matching = AvailablePlan(
                                  id: effectivePlan.planId.isNotEmpty ? effectivePlan.planId : 'plan_3_month',
                                  title: effectivePlan.title.isNotEmpty ? effectivePlan.title : '3 Month Plan',
                                  name: effectivePlan.title.isNotEmpty ? effectivePlan.title : '3 Month Plan',
                                  slug: effectivePlan.planId.isNotEmpty ? effectivePlan.planId : '3-month',
                                  description: 'Full Premium Access',
                                  icon: '💳',
                                  category: 'subscription',
                                  months: 3,
                                  originalPrice: effectivePlan.amount,
                                  currentPrice: effectivePlan.amount,
                                  totalPrice: effectivePlan.amount,
                                  monthlyPrice: effectivePlan.amount,
                                  currency: effectivePlan.currency,
                                  freeText: '',
                                  subtitle: '',
                                  durationText: effectivePlan.type,
                                  buttonText: 'Complete Payment',
                                  discountPercentage: '',
                                  gradient: '',
                                  circleColor: '',
                                  recommended: false,
                                  isBestValue: false,
                                  features: const [],
                                );
                              }
                              if (matching != null) {
                                ref
                                    .read(doctorSubscriptionProvider.notifier)
                                    .selectNewPlan(matching);
                                final success = await ref
                                    .read(doctorSubscriptionProvider.notifier)
                                    .upgradePlan();
                                if (success) return;
                              }
                            }
                            if (!context.mounted) return;
                            _showPlansBottomSheet(context, ref);
                          },
                          onChangePlanPressed: () {
                            _showPlansBottomSheet(context, ref);
                          },
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
    DoctorSubscriptionState state,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final effectivePlan = state.currentPlan ?? subStatus.subscriptionPlan;
    final isPending = subStatus.isPaymentPending ||
        (effectivePlan != null && effectivePlan.isPending);
    final isActive = subStatus.hasActiveSubscription ||
        (effectivePlan != null && effectivePlan.isActive);

    final Color cardColor = subStatus.isLoading
        ? colorScheme.primaryContainer
        : isPending
        ? const Color(0xFFFFF3E0)
        : isActive
        ? colorScheme.tertiaryContainer
        : colorScheme.errorContainer;

    final IconData icon = subStatus.isLoading
        ? Icons.hourglass_top_rounded
        : isPending
        ? Icons.pending_actions_rounded
        : isActive
        ? Icons.check_circle_rounded
        : Icons.warning_rounded;

    final Color iconColor = subStatus.isLoading
        ? colorScheme.onPrimaryContainer
        : isPending
        ? const Color(0xFFE65100)
        : isActive
        ? colorScheme.onTertiaryContainer
        : colorScheme.onErrorContainer;

    final String title = subStatus.isLoading
        ? 'Verifying subscription...'
        : isPending
        ? 'Payment Pending'
        : isActive
        ? 'Subscription Active!'
        : 'No Active Subscription';

    final String subtitle = subStatus.isLoading
        ? 'Please wait while we check your subscription status'
        : isPending
        ? (effectivePlan != null && effectivePlan.title.isNotEmpty
            ? 'Your payment for ${effectivePlan.title} is incomplete. Complete payment now to activate your account.'
            : 'Your payment is incomplete. Please complete payment to submit your application for review.')
        : isActive
        ? 'Your subscription is active and verified.'
        : 'Choose a plan below to activate your account';

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: iconColor.transparency(0.85),
                      fontWeight: FontWeight.w500,
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
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: state.allPlans.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final plan = state.allPlans[index];
              final isSelected = state.selectedNewPlan?.id == plan.id;
              final showGst = plan.hasGst;
              final totalPayable = plan.totalWithTax;

              return SizedBox(
                width: 210,
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
                          showGst
                              ? '₹${totalPayable.toStringAsFixed(2)}'
                              : '₹${plan.currentPrice.toStringAsFixed(0)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        if (showGst)
                          Text(
                            '(Base ₹${plan.currentPrice.toInt()} + 18% GST)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 10,
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
                            child: Text(
                              isSelected
                                  ? (showGst
                                      ? 'Selected (₹${totalPayable.toStringAsFixed(0)})'
                                      : 'Selected')
                                  : 'Choose',
                            ),
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
          await Future.wait([
            ref
                .read(subscriptionStatusProvider.notifier)
                .checkActiveSubscription(),
            ref
                .read(doctorSubscriptionProvider.notifier)
                .loadSubscriptionDetails(),
            ref
                .read(doctorSubscriptionProvider.notifier)
                .loadPlans(),
          ]);
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

import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/doctor/models/subscription/available_plan_model.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../controllers/subscription_controller.dart';
import 'subscription_pricing_card.dart';

class AvailablePlansSection extends ConsumerWidget {
  const AvailablePlansSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorSubscriptionProvider);
    final notifier = ref.read(doctorSubscriptionProvider.notifier);
    final availablePlans = notifier.getAvailablePlans();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final plan = state.selectedNewPlan;

    if (state.allPlans.isEmpty && !state.isLoading) {
      Future.microtask(
        () => ref.read(doctorSubscriptionProvider.notifier).loadPlans(),
      );
    }

    ref.listen(doctorSubscriptionProvider, (previous, next) {
      if (next.errorMessage != null) {
        AppSnackBar.show(
          message: next.errorMessage!,
          type: AppSnackBarType.error,
        );
      }
    });

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.transparency(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Scaffold(
              backgroundColor: AppTheme.transparent,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'HEALTHCARE PLANS',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Choose Your Plan',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Flexible pricing for healthcare providers of every size. No hidden fees.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.transparency(
                          0.4,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildToggleItem(
                            context,
                            ref,
                            title: 'Monthly',
                            isTargetYearly: false,
                            currentSelection: state.isYearly,
                          ),
                          _buildToggleItem(
                            context,
                            ref,
                            title: 'Yearly',
                            isTargetYearly: true,
                            currentSelection: state.isYearly,
                            hasBadge: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isMobile = constraints.maxWidth < 600;
                        if (isMobile) {
                          return Column(
                            children: availablePlans
                                .map(
                                  (p) => SubscriptionPricingCard(
                                    plan: p,
                                    isSelected: plan?.id == p.id,
                                  ),
                                )
                                .toList(),
                          );
                        }
                        return IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: availablePlans
                                .map(
                                  (p) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: SubscriptionPricingCard(
                                        plan: p,
                                        isSelected: plan?.id == p.id,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              bottomNavigationBar: plan != null
                  ? _buildStickyBottomBar(context, ref, plan)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required bool isTargetYearly,
    required bool currentSelection,
    bool hasBadge = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = currentSelection == isTargetYearly;

    return InkWell(
      onTap: () => ref
          .read(doctorSubscriptionProvider.notifier)
          .toggleDuration(isTargetYearly),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primaryContainer : AppTheme.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            if (hasBadge) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SAVE 20%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar(
    BuildContext context,
    WidgetRef ref,
    AvailablePlan plan,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.transparency(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${plan.currentPrice.toInt()}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showSummaryBottomSheet(context, ref, plan),
                    child: Text(
                      'View Details',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(doctorSubscriptionProvider.notifier).upgradePlan();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSummaryBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AvailablePlan plan,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.transparency(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.transparency(
                              0.5,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            plan.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                plan.subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (plan.recommended)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.amber.transparency(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'BEST VALUE',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.amber.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Price Hero
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primaryContainer.transparency(0.3),
                            colorScheme.primaryContainer.transparency(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.primary.transparency(0.15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Amount',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '₹',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                              Text(
                                '${plan.currentPrice.toInt()}',
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.primary,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                          if (plan.originalPrice > plan.currentPrice) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₹${plan.originalPrice.toInt()}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: colorScheme.onSurfaceVariant
                                        .transparency(0.5),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.green.transparency(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Save ${((1 - plan.currentPrice / plan.originalPrice) * 100).toInt()}%',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppTheme.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (plan.monthlyPrice > 0 && plan.months > 1) ...[
                            const SizedBox(height: 6),
                            Text(
                              '₹${plan.monthlyPrice.toInt()}/month for ${plan.months.toInt()} months',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Price Breakdown
                    Text(
                      'Price Breakdown',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBreakdownTile(
                      context,
                      icon: Icons.card_membership_rounded,
                      label: 'Plan',
                      value: plan.title,
                    ),
                    _buildBreakdownTile(
                      context,
                      icon: Icons.sync_rounded,
                      label: 'Billing Cycle',
                      value: plan.durationText,
                    ),
                    _buildBreakdownTile(
                      context,
                      icon: Icons.local_offer_rounded,
                      label: 'Original Price',
                      value: '₹${plan.originalPrice.toInt()}',
                    ),
                    if (plan.discountPercentage.isNotEmpty)
                      _buildBreakdownTile(
                        context,
                        icon: Icons.discount_rounded,
                        label: 'Discount',
                        value: plan.discountPercentage,
                        valueColor: AppTheme.green,
                      ),
                    _buildBreakdownTile(
                      context,
                      icon: Icons.tag_rounded,
                      label: 'You Pay',
                      value: '₹${plan.currentPrice.toInt()}',
                      isHighlighted: true,
                    ),

                    const SizedBox(height: 24),

                    // Features
                    if (plan.features.isNotEmpty) ...[
                      Text(
                        'Everything You Get',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...plan.features.map((feature) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: feature.included
                                      ? AppTheme.green.transparency(0.1)
                                      : colorScheme.onSurfaceVariant
                                            .transparency(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  feature.included
                                      ? Icons.check_rounded
                                      : Icons.close_rounded,
                                  size: 16,
                                  color: feature.included
                                      ? AppTheme.green
                                      : colorScheme.onSurfaceVariant
                                            .transparency(0.4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature.text,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: feature.included
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurfaceVariant
                                              .transparency(0.5),
                                    decoration: feature.included
                                        ? null
                                        : TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 24),

                    // Description
                    if (plan.description.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.white.transparency(0.03)
                              : AppTheme.black.transparency(0.02),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                plan.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // CTA
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ref
                              .read(doctorSubscriptionProvider.notifier)
                              .upgradePlan();
                        },
                        icon: const Icon(Icons.lock_rounded, size: 18),
                        label: Text(
                          'Pay ₹${plan.currentPrice.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            size: 14,
                            color: colorScheme.onSurfaceVariant.transparency(
                              0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Secure payment · Cancel anytime',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.transparency(
                                0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isHighlighted = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isHighlighted
            ? colorScheme.primaryContainer.transparency(0.3)
            : colorScheme.surfaceContainerLow.transparency(0.5),
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(color: colorScheme.primary.transparency(0.2))
            : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isHighlighted
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.transparency(0.6),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
              color:
                  valueColor ??
                  (isHighlighted ? colorScheme.primary : colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

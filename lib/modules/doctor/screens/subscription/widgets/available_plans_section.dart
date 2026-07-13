import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/doctor/available_plan_model.dart';
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
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        color: colorScheme.surfaceContainerHighest.transparency(0.4),
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
                                .map((p) => SubscriptionPricingCard(
                              plan: p,
                              isSelected: plan?.id == p.id,
                            ))
                                .toList(),
                          );
                        }
                        return IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: availablePlans
                                .map((p) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: SubscriptionPricingCard(
                                  plan: p,
                                  isSelected: plan?.id == p.id,
                                ),
                              ),
                            ))
                                .toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              bottomNavigationBar: plan != null ? _buildStickyBottomBar(context, ref, plan) : null,
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
          color: isActive ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
              ),
            ),
            if (hasBadge) ...[
              const SizedBox(width: 6),
              const Badge(
                label: Text('SAVE 20%'),
                backgroundColor: Colors.amber,
                textColor: Colors.black,
                largeSize: 16,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar(BuildContext context, WidgetRef ref, AvailablePlan plan) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        boxShadow: [
          BoxShadow(
            color: Colors.black.transparency(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
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
                    onTap: () => _showSummaryBottomSheet(context, plan),
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
                    // 🎯 FIXED ASYNC GAP BUG: Flush current modal context layout boundaries instantly before upgrading plans triggers
                    Navigator.pop(context);
                    ref.read(doctorSubscriptionProvider.notifier).upgradePlan();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSummaryBottomSheet(BuildContext context, AvailablePlan plan) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.transparency(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Price Breakup',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(context, 'Subscription', plan.title),
            const SizedBox(height: 12),
            _buildSummaryRow(context, 'Original Price', '₹${plan.originalPrice.toInt()}'),
            const SizedBox(height: 12),
            _buildSummaryRow(context, 'Discount', plan.discountPercentage, textColor: Colors.green),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payable',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${plan.currentPrice.toInt()}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {Color? textColor}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: textColor ?? theme.colorScheme.onSurface)),
      ],
    );
  }
}
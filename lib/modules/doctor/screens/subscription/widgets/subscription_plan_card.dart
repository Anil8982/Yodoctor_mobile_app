import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan? plan; // Nullable to handle inactive state
  final VoidCallback? onUpgradePressed; // Required when plan is inactive
  final VoidCallback? onChangePlanPressed; // For pending payment: switch plan

  const SubscriptionPlanCard({
    super.key,
    this.plan,
    this.onUpgradePressed,
    this.onChangePlanPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final bool hasActivePlan = plan != null && plan!.isActive;
    final bool isPaymentPending = plan != null && plan!.isPending;

    // Dynamic colors & content based on active/pending/inactive state
    final List<Color> gradientColors = hasActivePlan
        ? [
            colorScheme.primary,
            colorScheme.secondary,
          ] // Active Primary/Secondary
        : isPaymentPending
        ? [
            const Color(0xFFE65100),
            const Color(0xFFF57C00),
          ] // Amber/Orange for Payment Pending
        : [
            AppTheme.warning(context),
            AppTheme.warning(context).pastel(0.8),
          ]; // Inactive Warning

    final shadowColor = hasActivePlan
        ? colorScheme.primary
        : isPaymentPending
        ? const Color(0xFFE65100)
        : AppTheme.warning(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor.transparency(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: AppTheme.white.transparency(0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: hasActivePlan
                  ? _buildActiveContent(context, textTheme, plan!)
                  : isPaymentPending
                  ? _buildPendingPaymentContent(
                      context,
                      textTheme,
                      plan!,
                      onUpgradePressed,
                      onChangePlanPressed,
                    )
                  : _buildInactiveContent(context, textTheme, onUpgradePressed),
            ),
          ],
        ),
      ),
    );
  }

  // 1. ACTIVE PLAN CONTENT
  Widget _buildActiveContent(
    BuildContext context,
    TextTheme textTheme,
    SubscriptionPlan plan,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CURRENT PLAN',
              style: textTheme.labelMedium?.copyWith(
                color: AppTheme.white.transparency(0.65),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.white.transparency(0.18),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppTheme.white.transparency(0.25),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: AppTheme.success(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Active',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          plan.title,
          style: textTheme.headlineLarge?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          plan.type.toUpperCase(),
          style: textTheme.labelMedium?.copyWith(
            color: AppTheme.white.transparency(0.75),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: AppTheme.white.transparency(0.8),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Next Billing: ${DateFormat('dd MMM yyyy').format(plan.nextBillingDate)}',
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (plan.upcomingPlan != null) ...[
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.white.transparency(0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.white.transparency(0.12),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: AppTheme.white.transparency(0.7),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'UPCOMING PLAN',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppTheme.white.transparency(0.7),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  plan.upcomingPlan!.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Starts automatically on ${DateFormat('dd MMM yyyy').format(plan.upcomingPlan!.startDate)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppTheme.white.transparency(0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // 2. PENDING PAYMENT CONTENT
  Widget _buildPendingPaymentContent(
    BuildContext context,
    TextTheme textTheme,
    SubscriptionPlan plan,
    VoidCallback? onUpgradePressed,
    VoidCallback? onChangePlanPressed,
  ) {
    final bool hasTaxBreakdown = plan.baseAmount != null && plan.gstAmount != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'PAYMENT PENDING',
                style: textTheme.labelMedium?.copyWith(
                  color: AppTheme.white.transparency(0.85),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.white.transparency(0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppTheme.white.transparency(0.35),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pending_actions_rounded,
                    size: 14,
                    color: AppTheme.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pending',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          plan.title.isNotEmpty ? plan.title : 'Selected Plan',
          style: textTheme.headlineLarge?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        if (plan.amount > 0) ...[
          const SizedBox(height: 6),
          Text(
            hasTaxBreakdown
                ? '₹${plan.amount.toStringAsFixed(2)} • ${plan.type.toUpperCase()}'
                : '₹${plan.amount.toStringAsFixed(0)} • ${plan.type.toUpperCase()}',
            style: textTheme.titleMedium?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (hasTaxBreakdown) ...[
            const SizedBox(height: 2),
            Text(
              '(Base: ₹${plan.baseAmount!.toStringAsFixed(2)} + 18% GST: ₹${plan.gstAmount!.toStringAsFixed(2)})',
              style: textTheme.bodySmall?.copyWith(
                color: AppTheme.white.transparency(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
        const SizedBox(height: 10),
        Text(
          'Your subscription payment was not completed. Complete payment now to activate your account and start admin review.',
          style: textTheme.bodyMedium?.copyWith(
            color: AppTheme.white.transparency(0.9),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: onUpgradePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.white,
                foregroundColor: const Color(0xFFE65100),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              icon: const Icon(Icons.payment_rounded, size: 20),
              label: Text(
                plan.amount > 0
                    ? 'Complete Payment (₹${plan.amount.toStringAsFixed(2)})'
                    : 'Complete Payment Now',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            if (onChangePlanPressed != null)
              OutlinedButton.icon(
                onPressed: onChangePlanPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.white,
                  side: BorderSide(
                    color: AppTheme.white.transparency(0.55),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                label: const Text(
                  'Choose Another Plan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // 3. INACTIVE PLAN CONTENT
  Widget _buildInactiveContent(
    BuildContext context,
    TextTheme textTheme,
    VoidCallback? onUpgradePressed,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'SUBSCRIPTION STATUS',
                style: textTheme.labelMedium?.copyWith(
                  color: AppTheme.white.transparency(0.75),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.white.transparency(0.18),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppTheme.white.transparency(0.25),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: AppTheme.error(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Inactive',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'No Active Plan',
          style: textTheme.headlineLarge?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Unlock full access to patient records, appointments, and telemedicine features by activating a plan.',
          style: textTheme.bodyMedium?.copyWith(
            color: AppTheme.white.transparency(0.85),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onUpgradePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.white,
              foregroundColor: AppTheme.warning(context),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            icon: const Icon(Icons.bolt_rounded, size: 20),
            label: const Text(
              'Explore Plans & Activate',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

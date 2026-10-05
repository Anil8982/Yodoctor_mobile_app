import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan? plan; // Nullable to handle inactive state
  final VoidCallback? onUpgradePressed; // Required when plan is inactive

  const SubscriptionPlanCard({super.key, this.plan, this.onUpgradePressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final bool hasActivePlan = plan != null && plan!.isActive;

    // Dynamic colors & content based on active/inactive state
    final List<Color> gradientColors = hasActivePlan
        ? [
            colorScheme.primary,
            colorScheme.secondary,
          ] // Active Primary/Secondary
        : [
            AppTheme.warning(context),
            AppTheme.warning(context).pastel(0.8),
          ]; // Inactive Warning

    final shadowColor = hasActivePlan
        ? colorScheme.primary
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

  // 2. INACTIVE PLAN CONTENT
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

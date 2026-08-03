import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan? plan; // Nullable to handle inactive state
  final VoidCallback? onUpgradePressed; // Required when plan is inactive

  const SubscriptionPlanCard({super.key, this.plan, this.onUpgradePressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool hasActivePlan = plan != null && plan!.isActive;

    // Dynamic colors & content based on active/inactive state
    final List<Color> gradientColors = hasActivePlan
        ? [
            const Color(0xFF1A52CD),
            const Color(0xFF0EA791),
          ] // Active Blue/Green
        : [
            const Color(0xFFE65100),
            const Color(0xFFF57C00),
          ]; // Inactive Amber/Orange

    final shadowColor = hasActivePlan
        ? const Color(0xFF1A52CD)
        : const Color(0xFFF57C00);

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
                backgroundColor: Colors.white.transparency(0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: hasActivePlan
                  ? _buildActiveContent(textTheme, plan!)
                  : _buildInactiveContent(textTheme, onUpgradePressed),
            ),
          ],
        ),
      ),
    );
  }

  // 1. ACTIVE PLAN CONTENT
  Widget _buildActiveContent(TextTheme textTheme, SubscriptionPlan plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CURRENT PLAN',
              style: textTheme.labelMedium?.copyWith(
                color: Colors.white.transparency(0.65),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.transparency(0.18),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.transparency(0.25),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: Color(0xFF39FF14),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Active',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
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
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          plan.type.toUpperCase(),
          style: textTheme.labelMedium?.copyWith(
            color: Colors.white.transparency(0.75),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: Colors.white.transparency(0.8),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Next Billing: ${DateFormat('dd MMM yyyy').format(plan.nextBillingDate)}',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
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
              color: Colors.white.transparency(0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.transparency(0.12),
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
                      color: Colors.white.transparency(0.7),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'UPCOMING PLAN',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white.transparency(0.7),
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
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Starts automatically on ${DateFormat('dd MMM yyyy').format(plan.upcomingPlan!.startDate)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.transparency(0.75),
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
                  color: Colors.white.transparency(0.75),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.transparency(0.18),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.transparency(0.25),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: Color(0xFFFF5252), // Red dot for inactive
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Inactive',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
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
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Unlock full access to patient records, appointments, and telemedicine features by activating a plan.',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.transparency(0.85),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onUpgradePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFE65100),
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

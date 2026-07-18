import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:yodoctor/modules/doctor/models/subscription/available_plan_model.dart';
import '../../../controllers/subscription_controller.dart';

class SubscriptionPricingCard extends ConsumerWidget {
  final AvailablePlan plan;
  final bool isSelected;

  const SubscriptionPricingCard({
    super.key,
    required this.plan,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final isFree = plan.currentPrice == 0;

    const cleanPremiumColor = Color(0xFF123BB5);
    final activeColor = isDarkMode
        ? cleanPremiumColor.darkModeVariant()
        : cleanPremiumColor;
    final headerTextColor = activeColor.contrastColor;

    final cardBg = isSelected
        ? (isDarkMode ? const Color(0xFF141927) : activeColor.pastel(0.97))
        : colorScheme.surfaceContainerLow;

    final String rawDiscountText = plan.discountPercentage;

    String? displayDiscountText;

    if (isFree) {
      displayDiscountText = 'FREE';
    } else if (rawDiscountText.trim().isNotEmpty) {
      final cleanText = rawDiscountText.trim().toLowerCase();
      if (cleanText == '0' || cleanText == '0%' || cleanText == '0% off') {
        displayDiscountText = 'FREE';
      } else {
        displayDiscountText = rawDiscountText.toUpperCase();
      }
    }

    final headerBadgeBg = isSelected
        ? headerTextColor.transparency(0.15)
        : (isDarkMode
              ? activeColor.transparency(0.2)
              : activeColor.pastel(0.90));

    final headerBadgeTextColor = isSelected
        ? headerTextColor
        : (isDarkMode ? activeColor.lighten(0.2) : activeColor);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected
              ? activeColor
              : colorScheme.outlineVariant.transparency(0.3),
          width: 2.0,
        ),
        boxShadow: isSelected
            ? [
                Colors.black.shadow(
                  opacity: isDarkMode ? 0.2 : 0.04,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: () =>
            ref.read(doctorSubscriptionProvider.notifier).selectNewPlan(plan),
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              color: isSelected
                  ? activeColor
                  : (isDarkMode
                        ? colorScheme.surfaceContainerHighest.darken(0.1)
                        : colorScheme.surfaceContainerHighest.lighten(0.04)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            plan.title,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                              color: isSelected
                                  ? headerTextColor
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),

                        if (displayDiscountText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: headerBadgeBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              displayDiscountText,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: headerBadgeTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: headerTextColor,
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? activeColor
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${plan.currentPrice.toInt()}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            '/ ${plan.durationText}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Text(
                    plan.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 46,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => ref
                          .read(doctorSubscriptionProvider.notifier)
                          .selectNewPlan(plan),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected
                            ? activeColor
                            : Colors.transparent,
                        foregroundColor: isSelected
                            ? headerTextColor
                            : activeColor,
                        side: BorderSide(color: activeColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isFree
                            ? 'Start Free Trial'
                            : (isSelected ? 'Selected' : 'Choose Plan'),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

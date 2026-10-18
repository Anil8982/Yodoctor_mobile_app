import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
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
    final isTrial = plan.category.toLowerCase() == 'trial' ||
        plan.durationText.toLowerCase().contains('trial') ||
        plan.title.toLowerCase().contains('trial');

    final showGst = !isFree && !isTrial;

    final activeColor = colorScheme.primary;
    final headerTextColor = colorScheme.onPrimary;

    final cardBg = isSelected
        ? (isDarkMode
        ? colorScheme.surfaceContainerHigh
        : activeColor.pastel(0.97))
        : colorScheme.surfaceContainer;

    // Single unified promo tag to avoid duplicate badges
    String? promoBadgeText;
    if (isFree || isTrial) {
      promoBadgeText = plan.freeText.isNotEmpty
          ? plan.freeText.toUpperCase()
          : (isTrial ? 'TRIAL' : 'FREE');
    } else if (plan.discountPercentage.trim().isNotEmpty) {
      final clean = plan.discountPercentage.trim().toUpperCase();
      if (clean != '0' && clean != '0%' && clean != '0% OFF') {
        promoBadgeText = clean;
      }
    }

    final headerBadgeBg = isSelected
        ? headerTextColor.transparency(0.18)
        : (isDarkMode
        ? activeColor.transparency(0.25)
        : activeColor.pastel(0.88));

    final headerBadgeTextColor = isSelected
        ? headerTextColor
        : (isDarkMode ? activeColor.lighten(0.3) : activeColor);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSelected
              ? activeColor
              : colorScheme.outlineVariant.transparency(0.35),
          width: 2.0,
        ),
        boxShadow: isSelected
            ? [
          activeColor.shadow(
            opacity: isDarkMode ? 0.28 : 0.12,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ]
            : [
          AppTheme.black.shadow(
            opacity: isDarkMode ? 0.15 : 0.03,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () =>
            ref.read(doctorSubscriptionProvider.notifier).selectNewPlan(plan),
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(
              theme,
              colorScheme,
              isDarkMode,
              isSelected,
              activeColor,
              headerTextColor,
              headerBadgeBg,
              headerBadgeTextColor,
              promoBadgeText,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceSection(
                    theme,
                    colorScheme,
                    isSelected,
                    activeColor,
                    isFree,
                    showGst,
                  ),
                  if (plan.originalPrice > plan.currentPrice) ...[
                    const SizedBox(height: 6),
                    _buildOriginalPrice(theme, colorScheme),
                  ],
                  if (plan.monthlyPrice > 0 && plan.months > 1) ...[
                    const SizedBox(height: 4),
                    _buildMonthlyBreakdown(theme, colorScheme),
                  ],
                  if (plan.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      plan.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.transparency(0.9),
                        height: 1.4,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Single unified clean divider
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isSelected
                        ? activeColor.transparency(0.15)
                        : colorScheme.outlineVariant.transparency(0.2),
                  ),
                  const SizedBox(height: 16),

                  if (plan.features.isNotEmpty) ...[
                    _buildFeaturesList(
                      theme,
                      colorScheme,
                      isSelected,
                      activeColor,
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildCTAButton(
                    theme,
                    ref,
                    isSelected,
                    activeColor,
                    headerTextColor,
                    isFree,
                    isTrial,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      ThemeData theme,
      ColorScheme colorScheme,
      bool isDarkMode,
      bool isSelected,
      Color activeColor,
      Color headerTextColor,
      Color headerBadgeBg,
      Color headerBadgeTextColor,
      String? promoBadgeText,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      color: isSelected
          ? activeColor
          : (isDarkMode
          ? colorScheme.surfaceContainerHighest.darken(0.12)
          : colorScheme.surfaceContainerHighest.lighten(0.02)),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                if (plan.icon.isNotEmpty)
                  Text(plan.icon, style: const TextStyle(fontSize: 18)),
                Text(
                  plan.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: isSelected ? headerTextColor : colorScheme.onSurface,
                  ),
                ),
                if (promoBadgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: headerBadgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      promoBadgeText,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: headerBadgeTextColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                if (plan.recommended && !isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.amber.transparency(0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.amber.transparency(0.4),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      'BEST VALUE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDarkMode
                            ? AppTheme.amber.shade300
                            : AppTheme.amber.shade800,
                        fontWeight: FontWeight.w800,
                        fontSize: 9.5,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSelected
                ? Icon(
              Icons.check_circle_rounded,
              key: const ValueKey('selected'),
              size: 22,
              color: headerTextColor,
            )
                : Icon(
              Icons.radio_button_unchecked_rounded,
              key: const ValueKey('unselected'),
              size: 20,
              color: colorScheme.onSurfaceVariant.transparency(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(
      ThemeData theme,
      ColorScheme colorScheme,
      bool isSelected,
      Color activeColor,
      bool isFree,
      bool showGst,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Currency symbol
        Text(
          '₹',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: isSelected ? activeColor : colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 2),

        // Main price
        Text(
          isFree ? '0' : '${plan.currentPrice.toInt()}',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            letterSpacing: -0.8,
            height: 1.0,
          ),
        ),
        const SizedBox(width: 5),

        // Duration text
        Text(
          '/ ${plan.durationText}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.transparency(0.8),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),

        // Perfectly aligned inline + GST pill
        if (showGst) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor.transparency(0.12)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '+ GST',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected ? activeColor : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                fontSize: 9.5,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOriginalPrice(ThemeData theme, ColorScheme colorScheme) {
    final num savingsPercent = plan.originalPrice > 0
        ? ((1 - (plan.currentPrice / plan.originalPrice)) * 100).round()
        : 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '₹${plan.originalPrice.toInt()}',
          style: theme.textTheme.bodySmall?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: colorScheme.onSurfaceVariant.transparency(0.55),
            fontSize: 12.5,
            height: 1.2,
          ),
        ),
        const SizedBox(width: 8),
        if (savingsPercent > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.green.transparency(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Save $savingsPercent%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.green,
                fontWeight: FontWeight.w800,
                fontSize: 10,
                letterSpacing: 0.2,
                height: 1.1,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMonthlyBreakdown(ThemeData theme, ColorScheme colorScheme) {
    return Text(
      '₹${plan.monthlyPrice.toInt()}/mo for ${plan.months.toInt()} months',
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant.transparency(0.7),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFeaturesList(
      ThemeData theme,
      ColorScheme colorScheme,
      bool isSelected,
      Color activeColor,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s included',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            fontSize: 12.5,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 12),
        ...plan.features.map((feature) {
          final isIncluded = feature.included;
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    isIncluded
                        ? Icons.check_circle_rounded
                        : Icons.remove_circle_outline_rounded,
                    size: 16,
                    color: isIncluded
                        ? (isSelected ? activeColor : AppTheme.green)
                        : colorScheme.onSurfaceVariant.transparency(0.35),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    feature.text,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isIncluded
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant.transparency(0.45),
                      height: 1.35,
                      fontSize: 13,
                      decoration:
                      isIncluded ? null : TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCTAButton(
      ThemeData theme,
      WidgetRef ref,
      bool isSelected,
      Color activeColor,
      Color headerTextColor,
      bool isFree,
      bool isTrial,
      ) {
    final buttonText = plan.buttonText.isNotEmpty
        ? plan.buttonText
        : (isFree || isTrial)
        ? 'Start Trial'
        : (isSelected ? 'Selected Plan' : 'Choose Plan');

    return SizedBox(
      height: 44,
      width: double.infinity,
      child: isSelected
          ? ElevatedButton.icon(
        onPressed: () => ref
            .read(doctorSubscriptionProvider.notifier)
            .selectNewPlan(plan),
        icon: Icon(Icons.check_rounded, size: 18, color: headerTextColor),
        label: Text(
          buttonText,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: headerTextColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: activeColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      )
          : OutlinedButton(
        onPressed: () => ref
            .read(doctorSubscriptionProvider.notifier)
            .selectNewPlan(plan),
        style: OutlinedButton.styleFrom(
          foregroundColor: activeColor,
          side: BorderSide(
            color: activeColor.transparency(0.65),
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonText,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: activeColor,
          ),
        ),
      ),
    );
  }
}
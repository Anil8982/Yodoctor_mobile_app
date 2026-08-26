import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/models/lab/lab_test_model.dart';

class LabPackageCard extends StatelessWidget {
  final LabPackage package;
  final bool isInCart;
  final VoidCallback onAddToCart;
  final VoidCallback? onViewDetails;

  const LabPackageCard({
    super.key,
    required this.package,
    required this.isInCart,
    required this.onAddToCart,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 195,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 95,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.science_rounded,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    package.categoryId == 'fullbody' ? 'Package' : 'Essential',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.success(context),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '${package.discountPercentage}% OFF',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSuccess(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Text(
                            package.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${package.parametersCount} Params • ${package.reportDuration}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (package.homeSampleAvailable) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 11,
                          color: AppTheme.success(context),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Home Sample Collection',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              color: AppTheme.success(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${package.currentPrice.toInt()}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₹${package.originalPrice.toInt()}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: OutlinedButton(
                            onPressed: onViewDetails,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'View',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: OutlinedButton(
                            onPressed: onAddToCart,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isInCart
                                  ? colorScheme.primary
                                  : Colors.transparent,
                              side: BorderSide(color: colorScheme.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              isInCart ? 'Added' : '+ Add',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isInCart
                                    ? colorScheme.onPrimary
                                    : colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
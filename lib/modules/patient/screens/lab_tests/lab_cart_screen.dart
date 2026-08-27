import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/controllers/lab_test_controller.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';

class LabCartScreen extends ConsumerWidget {
  const LabCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final labState = ref.watch(labProvider);

    final cartItems = labState.cart;

    final double totalMRP = cartItems.fold(
      0,
      (sum, item) => sum + item.originalPrice,
    );
    final double totalPayable = cartItems.fold(
      0,
      (sum, item) => sum + item.currentPrice,
    );
    final double totalSavings = totalMRP - totalPayable;
    final int averageDiscount = totalMRP > 0
        ? ((totalSavings / totalMRP) * 100).round()
        : 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        title: 'My Cart',
        actions: [
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: colorScheme.onPrimary,
                child: Text(
                  '${cartItems.length}',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: cartItems.isEmpty
            ? _buildEmptyCart(context)
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.05,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.science_rounded,
                                      color: colorScheme.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          '${item.parametersCount} Parameters Included',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: colorScheme.outline,
                                                fontSize: 11,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${item.currentPrice.toInt()}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: colorScheme.primary,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '₹${item.originalPrice.toInt()}',
                                              style: TextStyle(
                                                color: colorScheme.outline,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      color: colorScheme.error,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(labProvider.notifier)
                                          .toggleCartItem(item);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                                style: BorderStyle.solid,
                              ),
                              color: colorScheme.primary.withValues(
                                alpha: 0.02,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Add More Tests',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price Summary',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSummaryRow(
                                context,
                                'Total MRP',
                                '₹${totalMRP.toInt()}',
                                isBold: false,
                              ),
                              const SizedBox(height: 10),
                              _buildSummaryRow(
                                context,
                                'You Save',
                                '- ₹${totalSavings.toInt()}',
                                isBold: false,
                                textColor: AppTheme.green,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.green.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.green.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_offer_outlined,
                                      color: AppTheme.green,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Great deal! You\'re saving $averageDiscount% on this order.',
                                        style: TextStyle(
                                          color: AppTheme.green,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.4,
                                ),
                                height: 1,
                              ),
                              const SizedBox(height: 16),
                              _buildSummaryRow(
                                context,
                                'Total Payable',
                                '₹${totalPayable.toInt()}',
                                isBold: true,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Payable',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                            Text(
                              '₹${totalPayable.toInt()}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push(AppRoutes.labSlotBooking);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Proceed to Book Slot',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded, size: 16),
                                ],
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

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    required bool isBold,
    double fontSize = 14,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isBold ? null : theme.colorScheme.onSurfaceVariant,
            fontWeight: isBold ? FontWeight.bold : null,
            fontSize: fontSize,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
            fontSize: fontSize,
            color: textColor ?? (isBold ? theme.colorScheme.primary : null),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you haven\'t added any lab tests yet. Explore our packages to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.outline,
                fontSize: 14,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text(
                  'Add Tests & Packages',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';

class BillingHistorySection extends StatelessWidget {
  final List<BillingInvoice> history;

  const BillingHistorySection({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 🎯 Sort by date (newest first)
    final sortedHistory = List<BillingInvoice>.from(history)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 28, 10, 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📋 Header with count badge
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                size: 22,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Billing History',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
              if (sortedHistory.isNotEmpty) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${sortedHistory.length}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // 📭 Empty State
          if (sortedHistory.isEmpty)
            _buildEmptyState(context)
          else
            // 📋 Invoice List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedHistory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final invoice = sortedHistory[index];
                return _buildModernInvoiceCard(context, invoice);
              },
            ),
        ],
      ),
    );
  }

  // 📭 Empty State
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 40,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No billing history yet',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your payment invoices will appear here once you subscribe to a plan',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInvoiceCard(BuildContext context, BillingInvoice invoice) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Material(
      color: AppTheme.transparent,
      child: InkWell(
        onTap: () {
          // 🎯 Future: Navigate to invoice detail
          // context.push('${AppRoutes.invoiceDetail}/${invoice.invoiceId}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildInvoiceIcon(context),
                        const SizedBox(width: 14),
                        Expanded(child: _buildInvoiceDetails(context, invoice)),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(height: 1, thickness: 0.5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusChip(status: invoice.status.toUpperCase()),
                        _buildAmountText(context, invoice.amount),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    _buildInvoiceIcon(context),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 4,
                      child: _buildInvoiceDetails(context, invoice),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: StatusChip(status: invoice.status.toUpperCase()),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildAmountText(context, invoice.amount),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInvoiceIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.receipt_long_rounded,
        color: colorScheme.primary,
        size: 24,
      ),
    );
  }

  Widget _buildInvoiceDetails(BuildContext context, BillingInvoice invoice) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          invoice.invoiceId,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Column(
          children: [
            // Plan title with icon
            Row(
              children: [
                Icon(
                  Icons.card_membership_rounded,
                  size: 14,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  invoice.planTitle,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd MMM yyyy').format(invoice.date),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountText(BuildContext context, double amount) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      '₹${NumberFormat('#,##,##0').format(amount)}',
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w900,
        color: colorScheme.onSurface,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';

class BillingHistorySection extends StatelessWidget {
  final List<BillingInvoice> history;

  const BillingHistorySection({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
          Text(
            'Billing History',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          history.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'No billing history available',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
              : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final invoice = history[index];
              return _buildModernInvoiceCard(context, invoice);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernInvoiceCard(BuildContext context, BillingInvoice invoice) {
    final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
    final isPaid = invoice.status.toLowerCase() == 'paid';
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
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
              _buildStatusBadge(context, isPaid, invoice.status),
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
              child: _buildStatusBadge(context, isPaid, invoice.status),
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
        Row(
          children: [
            Text(
              invoice.planTitle,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(radius: 2, backgroundColor: Colors.grey),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd MMM yyyy').format(invoice.date),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isPaid, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final badgeColor = isPaid ? Colors.green : colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: badgeColor),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
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
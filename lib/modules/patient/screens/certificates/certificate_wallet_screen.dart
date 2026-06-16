import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/models/medical_certificate.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/certificate_request.dart';
import '../../widgets/custom_sliver_app_bar.dart';
import '../../widgets/patient_drawer.dart';
import 'widgets/certificate_header.dart';
import 'widgets/certificate_preview_dialog.dart';

class CertificateWalletScreen extends StatefulWidget {
  const CertificateWalletScreen({super.key});

  @override
  State<CertificateWalletScreen> createState() => _CertificateWalletScreenState();
}

class _CertificateWalletScreenState extends State<CertificateWalletScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Consumer<CertificateController>(
      builder: (context, controller, child) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: const PatientDrawer(user: DummyData.currentUser),
          backgroundColor: theme.scaffoldBackgroundColor,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                CustomSliverAppBar(
                  expandedHeight: 220,
                  scaffoldKey: _scaffoldKey,
                  background: CertificateHeader(
                    certificateCount: controller.certificates.length,
                    selectedFilter: controller.selectedFilter,
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                Container(
                  color: colorScheme.surface,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          return TextField(
                            controller: _searchController,
                            onChanged: controller.setSearchQuery,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Search by type or doctor...',
                              prefixIcon: const Icon(Icons.search_rounded, size: 22),
                              suffixIcon: value.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 20),
                                      onPressed: () {
                                        _searchController.clear();
                                        controller.setSearchQuery('');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.35),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: ['All', 'Pending', 'Approved', 'Rejected'].map((filter) {
                            final isSelected = controller.selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (_) => controller.setFilter(filter),
                                selectedColor: colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                showCheckmark: false,
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.certificates.isEmpty
                      ? _buildEmptyState(context, controller.selectedFilter)
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
                          itemCount: controller.certificates.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final cert = controller.certificates[index];
                            return _buildCertificateCard(context, cert);
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              controller.initFormWithDefaults(DummyData.currentUser);
              context.push(AppRoutes.applyCertificate);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Apply Certificate'),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        );
      },
    );
  }

  Widget _buildCertificateCard(BuildContext context, MedicalCertificate cert) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateStr = DateFormat('dd MMM yyyy').format(cert.requestDate);

    IconData getIcon() {
      switch (cert.type.toLowerCase()) {
        case 'medical fitness':
          return Icons.fitness_center_rounded;
        case 'vaccination':
          return Icons.vaccines_rounded;
        case 'disability':
          return Icons.accessible_rounded;
        case 'second opinion':
          return Icons.rate_review_rounded;
        default:
          return Icons.article_rounded;
      }
    }

    Color getStatusColor() {
      switch (cert.status.toUpperCase()) {
        case 'APPROVED':
          return colorScheme.primary;
        case 'PENDING':
          return Colors.orange;
        case 'REJECTED':
          return colorScheme.error;
        default:
          return colorScheme.outline;
      }
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(getIcon(), color: colorScheme.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cert.type,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Patient: ${cert.patientName}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: getStatusColor().withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    cert.status,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            Row(
              children: [
                Icon(Icons.person_pin_rounded, color: colorScheme.onSurfaceVariant, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Assigned to: ',
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                Text(
                  cert.doctor.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  dateStr,
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (cert.status.toUpperCase() == 'APPROVED') ...[
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => CertificatePreviewDialog(certificate: cert),
                    );
                  },
                  icon: const Icon(Icons.verified_rounded, size: 16),
                  label: const Text('View & Download Certificate'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
            ] else if (cert.status.toUpperCase() == 'REJECTED') ...[
              const SizedBox(height: 4),
              Text(
                'Note: Request was declined by doctor due to insufficient medical evidence.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String filter) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: Icon(Icons.card_membership_rounded, size: 36, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Text(
            'No Certificates Found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No certificate match the "$filter" filter.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

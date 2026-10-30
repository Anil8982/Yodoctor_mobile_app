import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/certificate_request.dart';
import '../../widgets/patient_app_bar.dart';
import '../../widgets/patient_bottom_nav.dart';
import '../../../patient/models/certificate/patient_certificate_request_model.dart';
import 'package:yodoctor/l10n/app_localizations.dart';

class CertificateWalletScreen extends ConsumerStatefulWidget {
  const CertificateWalletScreen({super.key});

  @override
  ConsumerState<CertificateWalletScreen> createState() =>
      _CertificateWalletScreenState();
}

class _CertificateWalletScreenState
    extends ConsumerState<CertificateWalletScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _getLocalizedFilter(String filter, AppLocalizations l10n) {
    switch (filter.toLowerCase()) {
      case 'pending':
        return l10n.filterPending;
      case 'approved':
        return l10n.filterApproved;
      case 'rejected':
        return l10n.filterRejected;
      case 'all':
      default:
        return l10n.filterAll;
    }
  }

  String _getLocalizedCertType(String type, AppLocalizations l10n) {
    switch (type.toLowerCase()) {
      case 'medical fitness':
        return l10n.certMedicalFitness;
      case 'vaccination':
        return l10n.certVaccination;
      case 'disability':
        return l10n.certDisability;
      case 'second opinion':
        return l10n.certSecondOpinion;
      case 'discharge summary':
        return l10n.certDischargeSummary;
      default:
        return type;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(certificateProvider.notifier).loadMyRequests();
    });
  }

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
    final l10n = AppLocalizations.of(context)!;

    final formState = ref.watch(certificateProvider);
    final notifier = ref.read(certificateProvider.notifier);

    final filteredCertificates = notifier.getFilteredCertificates();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PatientAppBar(
        titleText: l10n.certificateWallet,
        subtitleText: 'Verified Medical Documents',
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: theme.scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (context, value, child) {
                        return TextField(
                          controller: _searchController,
                          onChanged: notifier.setSearchQuery,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: l10n.searchByTypeOrDoctor,
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 22,
                            ),
                            suffixIcon: value.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      notifier.setSearchQuery('');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor:
                                theme.colorScheme.surfaceContainer,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant
                                    .transparency(0.35),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
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
                        children:
                            [
                              'All',
                              'Pending',
                              'Approved',
                              'Rejected',
                            ].map((filter) {
                              final isSelected =
                                  formState.selectedFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                ),
                                child: FilterChip(
                                  label: Text(
                                    _getLocalizedFilter(filter, l10n),
                                  ),
                                  selected: isSelected,
                                  onSelected: (_) =>
                                      notifier.setFilter(filter),
                                  selectedColor:
                                      colorScheme.primaryContainer,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  showCheckmark: false,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredCertificates.isEmpty
                    ? _buildEmptyState(context, formState.selectedFilter)
                    : RefreshIndicator(
                        onRefresh: notifier.loadMyRequests,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            12,
                            horizontalPadding,
                            PatientBottomNav.floatingNavPadding(context),
                          ),
                          itemCount: filteredCertificates.length,
                          itemBuilder: (context, index) {
                            final cert = filteredCertificates[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildCertificateCard(context, cert),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: PatientBottomNav.totalBarHeight(context) + 12,
            child: FloatingActionButton.extended(
              heroTag: 'apply_certificate',
              onPressed: () {
                context.push(AppRoutes.doctorSelection);
              },
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.applyCertificate),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(
    BuildContext context,
    PatientCertificateRequestModel cert,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final dateStr = DateFormat('dd MMM yyyy').format(cert.createdAt);

    IconData getIcon() {
      switch (cert.certificateType.toLowerCase()) {
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
          return AppTheme.success(context);
        case 'PENDING':
          return AppTheme.warning(context);
        case 'REJECTED':
          return AppTheme.error(context);
        default:
          return colorScheme.outline;
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        await ref
            .read(certificateProvider.notifier)
            .loadCertificateDetail(cert.id);

        if (context.mounted) {
          context.push(
            AppRoutes.patientCertificateDetail,
            extra: cert.id,
          );
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant.transparency(0.4)),
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
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      getIcon(),
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getLocalizedCertType(cert.certificateType, l10n),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(
                    status: cert.status,
                    customColor: getStatusColor(),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 0.5),
              Row(
                children: [
                  Icon(
                    Icons.person_pin_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.assignedTo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      cert.doctorName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    dateStr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (cert.status.toUpperCase() == 'APPROVED') ...[
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(certificateProvider.notifier)
                          .downloadCertificate(cert.id);
                    },
                    icon: const Icon(Icons.verified_rounded, size: 16),
                    label: Text(l10n.viewAndDownloadCertificate),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
              ] else if (cert.status.toUpperCase() == 'REJECTED') ...[
                const SizedBox(height: 4),
                Text(
                  l10n.requestDeclinedNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String filter) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.card_membership_rounded,
              size: 36,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noCertificatesFound,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.noCertificatesMatchFilter(_getLocalizedFilter(filter, l10n)),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

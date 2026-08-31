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
import '../../widgets/custom_sliver_app_bar.dart';
import 'widgets/certificate_header.dart';
import '../../../patient/models/certificate/patient_certificate_request_model.dart';

class CertificateWalletScreen extends ConsumerStatefulWidget {
  const CertificateWalletScreen({super.key});

  @override
  ConsumerState<CertificateWalletScreen> createState() =>
      _CertificateWalletScreenState();
}

class _CertificateWalletScreenState
    extends ConsumerState<CertificateWalletScreen> {
  final TextEditingController _searchController = TextEditingController();

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

    final formState = ref.watch(certificateProvider);
    final notifier = ref.read(certificateProvider.notifier);

    final filteredCertificates = notifier.getFilteredCertificates();

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          NestedScrollView(
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CustomSliverAppBar(
                  titleText: 'Certificate Wallet',
                  expandedHeight: 220,
                  background: CertificateHeader(
                    certificateCount: filteredCertificates.length,
                    selectedFilter: formState.selectedFilter,
                  ),
                ),
                SliverAppBar(
                  leading: const SizedBox.shrink(),
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: colorScheme.surface,
                  pinned: false,
                  floating: true,
                  snap: true,
                  scrolledUnderElevation: 0,
                  elevation: 0,
                  toolbarHeight: 120,
                  titleSpacing: 0,
                  title: Container(
                    color: colorScheme.surface,
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                                hintText: 'Search by type or doctor...',
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
                                fillColor: theme.colorScheme.surfaceContainerLow,
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
                            children: ['All', 'Pending', 'Approved', 'Rejected']
                                .map((filter) {
                              final isSelected =
                                  formState.selectedFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(filter),
                                  selected: isSelected,
                                  onSelected: (_) => notifier.setFilter(filter),
                                  selectedColor: colorScheme.primaryContainer,
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
                ),
              ];
            },
            body: filteredCertificates.isEmpty
                ? _buildEmptyState(context, formState.selectedFilter)
                : RefreshIndicator(
              onRefresh: notifier.loadMyRequests,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      12,
                      horizontalPadding,
                      110,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final cert = filteredCertificates[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildCertificateCard(context, cert),
                        );
                      }, childCount: filteredCertificates.length),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 25,
            child: FloatingActionButton.extended(
              heroTag: 'apply_certificate',
              onPressed: () {
                context.push(AppRoutes.doctorSelection);
              },
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Apply Certificate'),
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
          return colorScheme.primary;
        case 'PENDING':
          return AppTheme.orange;
        case 'REJECTED':
          return colorScheme.error;
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
          context.push(AppRoutes.patientCertificateDetail);
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
                          cert.certificateType,
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
                    'Assigned to: ',
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
                    label: const Text('View & Download Certificate'),
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
            child: Icon(
              Icons.card_membership_rounded,
              size: 36,
              color: colorScheme.onSurfaceVariant,
            ),
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
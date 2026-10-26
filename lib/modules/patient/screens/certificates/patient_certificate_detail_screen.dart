import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';

import '../../controllers/certificate_request.dart';
import '../../../patient/models/certificate/patient_certificate_detail_model.dart';
import '../../../patient/models/certificate/patient_certificate_timeline_model.dart';

class PatientCertificateDetailScreen extends ConsumerStatefulWidget {
  final int certificateId;

  const PatientCertificateDetailScreen({
    super.key,
    required this.certificateId,
  });

  @override
  ConsumerState<PatientCertificateDetailScreen> createState() =>
      _PatientCertificateDetailScreenState();
}

class _PatientCertificateDetailScreenState
    extends ConsumerState<PatientCertificateDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref
            .read(certificateProvider.notifier)
            .loadCertificateDetail(widget.certificateId);
      }
    });
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return AppTheme.success(context);
      case 'PENDING':
        return AppTheme.warning(context);
      case 'REJECTED':
        return AppTheme.error(context);
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  IconData _getCertificateIcon(String type) {
    switch (type.toLowerCase()) {
      case 'medical fitness':
        return Icons.fitness_center_rounded;
      case 'vaccination':
        return Icons.vaccines_rounded;
      case 'disability':
        return Icons.accessible_rounded;
      case 'second opinion':
        return Icons.rate_review_rounded;
      default:
        return Icons.verified_user_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(certificateProvider);

    final cert = state.selectedCertificate;

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppHeader(title: l10n.certificateDetails),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (cert == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppHeader(title: l10n.certificateDetails),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 54,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.certificateNotFound,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () {
                  ref
                      .read(certificateProvider.notifier)
                      .loadCertificateDetail(widget.certificateId);
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(title: l10n.certificateDetails),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _buildOverviewCard(context, cert, l10n),
            const SizedBox(height: 20),
            _buildTimelineSection(context, state.timeline, l10n),
            const SizedBox(height: 20),
            _buildDetailsCard(context, cert, l10n),
            const SizedBox(height: 20),
            _buildClinicalNotesCard(context, cert, l10n),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // 1. Overview Header Card Function
  Widget _buildOverviewCard(
      BuildContext context,
      PatientCertificateDetailModel cert,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isApproved = cert.status.toUpperCase() == 'APPROVED';
    final isRejected = cert.status.toUpperCase() == 'REJECTED';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.4),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Certificate Type Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.transparency(0.4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.primary.transparency(0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getCertificateIcon(cert.certificateType),
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // 2. Certificate Type (API Data)
                Expanded(
                  child: Text(
                    cert.certificateType,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Status Chip (API Data)
                StatusChip(
                  status: cert.status,
                  customColor: _getStatusColor(context, cert.status),
                ),
              ],
            ),

            if (isApproved) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: FilledButton.icon(
                  onPressed: () {
                    ref
                        .read(certificateProvider.notifier)
                        .downloadCertificate(cert.id);
                  },
                  icon: const Icon(Icons.download_rounded, size: 20),
                  label: Text(
                    l10n.viewAndDownloadCertificate,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ] else if (isRejected) ...[
              const SizedBox(height: 14),
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
    );
  }


  // 2. Timeline Section Function
  Widget _buildTimelineSection(
      BuildContext context,
      List<PatientCertificateTimelineModel> timeline,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final completedCount =
        timeline.where((e) => e.state.toLowerCase() == 'done').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.timelineLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              '$completedCount/${timeline.length} Steps Completed',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: colorScheme.outlineVariant.transparency(0.35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: timeline.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'No timeline events available',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
                : Column(
              children: List.generate(timeline.length, (index) {
                final item = timeline[index];
                final isLast = index == timeline.length - 1;
                return _buildTimelineStep(
                  context: context,
                  item: item,
                  isLast: isLast,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // 2.1 Individual Timeline Step Function
  Widget _buildTimelineStep({
    required BuildContext context,
    required PatientCertificateTimelineModel item,
    required bool isLast,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final stateKey = item.state.toLowerCase();
    final bool isDone =
        stateKey == 'done' || stateKey == 'completed' || stateKey == 'approved';
    final bool isInProgress = stateKey == 'in_progress' ||
        stateKey == 'pending' ||
        stateKey == 'processing';
    final bool isRejected =
        stateKey == 'rejected' || stateKey == 'failed' || stateKey == 'declined';

    final Color activeNodeColor = isDone
        ? colorScheme.primary
        : isRejected
        ? colorScheme.error
        : isInProgress
        ? colorScheme.tertiary
        : colorScheme.surfaceContainerHighest;

    final Color onNodeColor = isDone
        ? colorScheme.onPrimary
        : isRejected
        ? colorScheme.onError
        : isInProgress
        ? colorScheme.onTertiary
        : colorScheme.onSurfaceVariant;

    final Color badgeContainerColor = isDone
        ? colorScheme.primaryContainer
        : isRejected
        ? colorScheme.errorContainer
        : isInProgress
        ? colorScheme.tertiaryContainer
        : colorScheme.surfaceContainerHighest;

    final Color onBadgeColor = isDone
        ? colorScheme.onPrimaryContainer
        : isRejected
        ? colorScheme.onErrorContainer
        : isInProgress
        ? colorScheme.onTertiaryContainer
        : colorScheme.onSurfaceVariant;

    final String dateFormatted =
    DateFormat('dd MMM yyyy, hh:mm a').format(item.createdAt);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeNodeColor,
                    border: Border.all(
                      color: isInProgress
                          ? colorScheme.tertiary.withValues(alpha: 0.35)
                          : Colors.transparent,
                      width: isInProgress ? 3 : 0,
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.check_rounded, size: 15, color: onNodeColor)
                        : isRejected
                        ? Icon(Icons.close_rounded,
                        size: 15, color: onNodeColor)
                        : Container(
                      width: isInProgress ? 7 : 6,
                      height: isInProgress ? 7 : 6,
                      decoration: BoxDecoration(
                        color: onNodeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isDone
                            ? colorScheme.primary.withValues(alpha: 0.35)
                            : colorScheme.outlineVariant.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 2 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: isDone || isInProgress
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isDone || isInProgress
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: badgeContainerColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.state.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: onBadgeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item.note != null && item.note!.trim().isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      item.note!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatted,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11,
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

  // 3. Consultation / Basic Details Card Function
  Widget _buildDetailsCard(
      BuildContext context,
      PatientCertificateDetailModel cert,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.certificateLabel,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: colorScheme.outlineVariant.transparency(0.35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  icon: Icons.badge_outlined,
                  label: l10n.patientInfoLabel,
                  value: cert.fullName,
                ),
                const Divider(height: 18, thickness: 0.5),
                _buildInfoRow(
                  context,
                  icon: Icons.medical_services_outlined,
                  label: l10n.doctorLabel,
                  value: cert.doctorName,
                ),
                const Divider(height: 18, thickness: 0.5),
                _buildInfoRow(
                  context,
                  icon: Icons.track_changes_rounded,
                  label: l10n.purposeLabel,
                  value: cert.purpose,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 4. Clinical Observations & Notes Card Function
  Widget _buildClinicalNotesCard(
      BuildContext context,
      PatientCertificateDetailModel cert,
      AppLocalizations l10n,
      ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.transparency(0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            _buildInfoRow(
              context,
              icon: Icons.health_and_safety_outlined,
              label: l10n.knownMedicalConditions,
              value: cert.medicalConditions.isEmpty
                  ? 'None'
                  : cert.medicalConditions,
            ),
            const Divider(height: 18, thickness: 0.5),
            _buildInfoRow(
              context,
              icon: Icons.medication_outlined,
              label: l10n.medicinesLabel,
              value: cert.medications.isEmpty ? 'None' : cert.medications,
            ),
            if (cert.notes.isNotEmpty) ...[
              const Divider(height: 18, thickness: 0.5),
              _buildInfoRow(
                context,
                icon: Icons.speaker_notes_outlined,
                label: l10n.notesLabel,
                value: cert.notes,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 5. Info Row Helper Function
  Widget _buildInfoRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
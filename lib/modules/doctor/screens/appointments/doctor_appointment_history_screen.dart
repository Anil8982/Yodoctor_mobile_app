import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/doctor/models/appointment/appointment_history_item.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../widgets/doctor_drawer.dart';
import '../../widgets/doctor_sliver_app_bar.dart';

import '../../controllers/appointment_history_controller.dart';
import 'widgets/history_toolbar.dart';
import 'widgets/appointment_history_table.dart';
import 'widgets/mobile_appointment_list.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';

class DoctorAppointmentHistoryScreen extends ConsumerStatefulWidget {
  const DoctorAppointmentHistoryScreen({super.key});

  @override
  ConsumerState<DoctorAppointmentHistoryScreen> createState() =>
      _DoctorAppointmentHistoryScreenState();
}

class _DoctorAppointmentHistoryScreenState
    extends ConsumerState<DoctorAppointmentHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentHistoryProvider.notifier).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double horizontalPadding = Responsive.horizontalPadding(context);
    final profileState = ref.watch(doctorProfileProvider);
    final historyState = ref.watch(appointmentHistoryProvider);
    final historyNotifier = ref.read(appointmentHistoryProvider.notifier);
    final filteredAppointments = historyNotifier.getFilteredHistory();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.surfaceContainer,
      extendBodyBehindAppBar: true,

      drawer: DoctorDrawer(doctor: profileState.profile),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            DoctorSliverAppBar(
              expandedHeight: 140.0,

              background: FlexibleSpaceBar(
                title: Text(
                  'Appointment History',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                titlePadding: EdgeInsets.only(
                  left: horizontalPadding + 4,
                  bottom: AppSpacing.lg,
                ),
                centerTitle: false,
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      AppSpacing.xl,
                      horizontalPadding,
                      AppSpacing.xxxl,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HistoryToolbar(
                            selectedFilter: historyState.selectedFilter,
                            searchController: _searchController,
                            onFilterChanged: (filter) {
                              historyNotifier.setFilter(filter);
                            },
                            onSearchChanged: historyNotifier.setSearchQuery,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (filteredAppointments.isEmpty)
                            const _EmptyHistory()
                          else if (Responsive.isMobile(context))
                            MobileAppointmentList(
                              appointments: filteredAppointments,
                              onPrescriptionTap: _openPrescription,
                              patientIdentityBuilder: _buildPatientIdentity,
                              statusChipBuilder: _buildStatusChip,
                              tokenChipBuilder: _buildTokenChip,
                              infoChipBuilder: _buildInfoChip,
                            )
                          else
                            AppointmentHistoryTable(
                              appointments: filteredAppointments,
                              onPrescriptionTap: _openPrescription,
                              patientNameParser: _patientName,
                              patientIdentityBuilder: _buildPatientIdentity,
                              tokenChipBuilder: _buildTokenChip,
                              statusChipBuilder: _buildStatusChip,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientIdentity(AppointmentHistoryItem appointment) {
    final colorScheme = Theme.of(context).colorScheme;

    // Safely resolve patient name
    final parsedName = _patientName(appointment.patientLabel);
    final displayName = parsedName.isNotEmpty ? parsedName : 'Unknown Patient';

    // Safe initial - prevents RangeError on empty string
    final initial = displayName.isNotEmpty
        ? displayName.substring(0, 1).toUpperCase()
        : '?';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            initial,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              appointment.shift,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTokenChip(String token) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.16)),
      ),
      child: Text(
        token,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusUpper = status.toUpperCase();
    final completed = statusUpper == 'COMPLETED';
    final cancelled = statusUpper == 'CANCELLED';

    final foreground = completed
        ? colorScheme.secondary
        : cancelled
        ? colorScheme.error
        : Colors.orange;

    final background = completed
        ? colorScheme.secondaryContainer
        : cancelled
        ? colorScheme.errorContainer
        : Colors.orange.transparency(0.15);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: foreground.withValues(alpha: 0.2)),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.xxs),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  // void _openPrescription(AppointmentHistoryItem appointment) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     showDragHandle: true,
  //     builder: (context) {
  //       final theme = Theme.of(context);
  //       final colorScheme = theme.colorScheme;
  //
  //       return Padding(
  //         padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(Icons.receipt_long_rounded, size: 44, color: colorScheme.primary),
  //             const SizedBox(height: AppSpacing.md),
  //             Text(
  //               'Prescription',
  //               style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
  //             ),
  //             const SizedBox(height: AppSpacing.xs),
  //             Text(
  //               'Create a prescription for ${_patientName(appointment.patientLabel)}.',
  //               textAlign: TextAlign.center,
  //               style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
  //             ),
  //             const SizedBox(height: AppSpacing.xl),
  //             SizedBox(
  //               width: double.infinity,
  //               child: FilledButton.icon(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   _showMessage('Prescription editor coming soon');
  //                 },
  //                 icon: const Icon(Icons.add_rounded),
  //                 label: const Text('Create Prescription'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _openPrescription(AppointmentHistoryItem appointment) {
    context.push(
      '/doctor/add-prescription/${appointment.id}?name=${Uri.encodeComponent(appointment.patientLabel)}&token=${Uri.encodeComponent(appointment.tokenNumber)}',
    );
  }
  //
  // void _showMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  String _patientName(String label) {
    return label.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 48, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No appointments found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try another date filter or patient name.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

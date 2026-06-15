import 'package:flutter/material.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../../../core/utils/responsive.dart';
import '../../widgets/doctor_drawer.dart';
import '../../widgets/doctor_sliver_app_bar.dart';

import 'widgets/history_toolbar.dart';
import 'widgets/appointment_history_table.dart';
import 'widgets/mobile_appointment_list.dart';

enum DoctorAppointmentFilter { today, lastSevenDays, all }

class DoctorAppointmentHistoryScreen extends StatefulWidget {
  const DoctorAppointmentHistoryScreen({super.key});

  @override
  State<DoctorAppointmentHistoryScreen> createState() => _DoctorAppointmentHistoryScreenState();
}

class _DoctorAppointmentHistoryScreenState extends State<DoctorAppointmentHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  DoctorAppointmentFilter _selectedFilter = DoctorAppointmentFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appointments = _filteredAppointments();
    final double horizontalPadding = Responsive.horizontalPadding(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.surfaceContainer,
      extendBodyBehindAppBar: true,
      drawer: const DoctorDrawer(doctor: DummyData.currentDoctor),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            DoctorSliverAppBar(
              expandedHeight: 140.0,
              scaffoldKey: _scaffoldKey,
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
                            selectedFilter: _selectedFilter,
                            searchController: _searchController,
                            onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
                            onSearchChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (appointments.isEmpty)
                            const _EmptyHistory()
                          else if (Responsive.isMobile(context))
                            MobileAppointmentList(
                              appointments: appointments,
                              onPrescriptionTap: _openPrescription,
                              patientIdentityBuilder: _buildPatientIdentity,
                              statusChipBuilder: _buildStatusChip,
                              tokenChipBuilder: _buildTokenChip,
                              infoChipBuilder: _buildInfoChip,
                            )
                          else
                            AppointmentHistoryTable(
                              appointments: appointments,
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

  List<AppointmentHistoryItem> _filteredAppointments() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final query = _searchController.text.trim().toLowerCase();

    return DummyData.appointmentHistory.where((appointment) {
      final appointmentDay = DateTime(
        appointment.date.year,
        appointment.date.month,
        appointment.date.day,
      );
      final matchesDate = switch (_selectedFilter) {
        DoctorAppointmentFilter.today => appointmentDay == today,
        DoctorAppointmentFilter.lastSevenDays =>
        !appointmentDay.isBefore(today.subtract(const Duration(days: 7))) &&
            !appointmentDay.isAfter(today),
        DoctorAppointmentFilter.all => true,
      };
      final matchesSearch = query.isEmpty ||
          appointment.patientLabel.toLowerCase().contains(query) ||
          appointment.tokenNumber.toLowerCase().contains(query) ||
          appointment.status.toLowerCase().contains(query);

      return matchesDate && matchesSearch;
    }).toList();
  }

  Widget _buildPatientIdentity(AppointmentHistoryItem appointment) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            _patientName(appointment.patientLabel).substring(0, 1).toUpperCase(),
            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _patientName(appointment.patientLabel),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
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
    final completed = status.toUpperCase() == 'COMPLETED';
    final foreground = completed ? colorScheme.secondary : colorScheme.error;
    final background = completed ? colorScheme.secondaryContainer : colorScheme.errorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: foreground.withValues(alpha: 0.2)),
      ),
      child: Text(
        completed ? 'Completed' : 'Cancelled',
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
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

  void _openPrescription(AppointmentHistoryItem appointment) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_rounded, size: 44, color: colorScheme.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Prescription',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Create a prescription for ${_patientName(appointment.patientLabel)}.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showMessage('Prescription editor coming soon');
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Prescription'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try another date filter or patient name.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yodoctor/modules/patient/screens/dashboard/widgets/patient_header.dart';
import 'package:yodoctor/modules/patient/widgets/custom_sliver_app_bar.dart';
import 'package:yodoctor/modules/patient/widgets/patient_drawer.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

import '../../controllers/patient_dashboard_controller.dart';
import 'widgets/appointment_card.dart';
import 'widgets/appointment_filter_chips.dart';
import 'widgets/token_card.dart';
import 'widgets/search_doctor_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<PatientDashboardController>(
      builder: (context, controller, child) {
        final loading = controller.isLoading;
        final data = controller.dashboardData;

        if (loading && data == null) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (data == null) return const SizedBox.shrink();

        final bool mobile = Responsive.isMobile(context);
        final double horizontal = Responsive.horizontalPadding(context);

        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: PatientDrawer(user: data.user),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CustomSliverAppBar(
                  expandedHeight: 190.0,
                  scaffoldKey: _scaffoldKey,
                  background: PatientHeader(user: data.user),
                ),              ];
            },
            body: RefreshIndicator(
              onRefresh: controller.loadDashboard,
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(horizontal, AppSpacing.lg, horizontal, AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchDoctorCard(),
                    const SizedBox(height: AppSpacing.xl),
                    TokenCard(token: data.todayToken ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader(context, colorScheme, 'Upcoming Appointments'),
                    const SizedBox(height: AppSpacing.sm),
                    AppointmentFilterChips(
                      filters: PatientDashboardController.availableFilters,
                      selectedFilter: controller.selectedFilter,
                      onFilterSelected: (filter) {
                        HapticFeedback.selectionClick();
                        controller.setFilter(filter);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (loading) LinearProgressIndicator(color: colorScheme.primary, backgroundColor: colorScheme.primaryContainer),
                    _buildAppointmentsContent(data, mobile),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildSectionHeader(BuildContext context, ColorScheme colorScheme, String title) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: colorScheme.onSurface,
        ),
      ),
      TextButton.icon(
        onPressed: () {},
        icon: Text('View All', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w700)),
        label: Icon(Icons.arrow_forward_rounded, size: 16, color: colorScheme.primary),
      ),
    ]);
  }

  Widget _buildAppointmentsContent(dynamic data, bool mobile) {
    if (data.appointments.isEmpty) return const _EmptyAppointments();
    if (mobile) {
      return Column(
          children: data.appointments
              .map<Widget>((appointment) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppointmentCard(appointment: appointment),
          ))
              .toList());
    }
    return LayoutBuilder(builder: (context, c) {
      final double itemWidth = (c.maxWidth - AppSpacing.md) / 3;
      return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: data.appointments
              .map<Widget>((appointment) => SizedBox(width: itemWidth, child: AppointmentCard(appointment: appointment)))
              .toList());
    });
  }
}


class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event_busy_rounded, size: 40, color: colorScheme.secondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Appointments Found',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'You don\'t have any appointments for the selected filter.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Book New'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


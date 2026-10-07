import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/patient/screens/dashboard/widgets/patient_header.dart';
import 'package:yodoctor/modules/patient/widgets/custom_sliver_app_bar.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

import '../../controllers/patient_dashboard_controller.dart';
import 'widgets/appointment_card.dart';
import 'widgets/token_card.dart';
import 'widgets/search_doctor_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(patientDashboardControllerProvider.notifier)
          .refreshTokenStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final state = ref.watch(patientDashboardControllerProvider);
    final loading = state.isLoading;
    final data = state.dashboardData;

    if (loading && data == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return Container(
        color: theme.scaffoldBackgroundColor,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CustomSliverAppBar(
                titleText: 'Dashboard',
                expandedHeight: 190.0,
                background: const PatientHeader(dashboard: null),
              ),
            ];
          },
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_off_rounded,
                      size: 48,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Dashboard Load Error',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    state.errorMessage ??
                        "Unable to connect to the server. Please check your internet connection.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: () {
                      ref
                          .read(patientDashboardControllerProvider.notifier)
                          .loadDashboard();
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text('Try Again'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final bool mobile = Responsive.isMobile(context);
    final double horizontal = Responsive.horizontalPadding(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CustomSliverAppBar(
              titleText: 'Dashboard',
              expandedHeight: 190.0,
              background: PatientHeader(dashboard: data),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () => ref
              .read(patientDashboardControllerProvider.notifier)
              .loadDashboard(),
          color: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontal,
                  AppSpacing.lg,
                  horizontal,
                  AppSpacing.xl,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    TokenCard(token: data.todayToken),
                    const SizedBox(height: AppSpacing.xl),

                    SearchDoctorCard(isSearch: data.todayToken == null),

                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader(
                      context,
                      colorScheme,
                      'Upcoming Appointments',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (loading)
                      LinearProgressIndicator(
                        color: colorScheme.primary,
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    _buildAppointmentsContent(data, mobile),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ColorScheme colorScheme,
    String title,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsContent(dynamic data, bool mobile) {
    if (data.appointments.isEmpty) return const _EmptyAppointments();
    if (mobile) {
      return Column(
        children: data.appointments
            .map<Widget>(
              (appointment) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppointmentCard(appointment: appointment),
              ),
            )
            .toList(),
      );
    }
    return LayoutBuilder(
      builder: (context, c) {
        final double itemWidth = (c.maxWidth - AppSpacing.md) / 3;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: data.appointments
              .map<Widget>(
                (appointment) => SizedBox(
                  width: itemWidth,
                  child: AppointmentCard(appointment: appointment),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer.transparency(0.6),
                    colorScheme.primaryContainer.transparency(0.1),
                  ],
                ),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                size: 48,
                color: colorScheme.primary.transparency(0.7),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'No Appointments',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Book an appointment with a doctor',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            InkWell(
              onTap: () => context.push(AppRoutes.search),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.transparency(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 20,
                      color: colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Book Appointment',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

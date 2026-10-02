import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_service_controller.dart';
import 'package:yodoctor/modules/doctor/screens/live_queue/widgets/emergency_cancellation_dialog.dart';
import 'widgets/certificate_service_card.dart';
import 'widgets/doctor_dashboard_shimmer.dart';
import 'widgets/doctor_header.dart';
import 'widgets/dashboard_cards.dart';
import '../../widgets/doctor_sliver_app_bar.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/doctor_dashboard_controller.dart';

class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({
    super.key,
    this.onShowQR,
    this.onOpenAppointments,
  });

  final VoidCallback? onShowQR;
  final VoidCallback? onOpenAppointments;

  @override
  ConsumerState<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends ConsumerState<DoctorDashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(doctorCertificateServiceProvider.notifier)
          .loadCertificateService();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dashboardAsync = ref.watch(doctorDashboardProvider);

    final hasData = dashboardAsync.hasValue;
    final isFirstLoad = dashboardAsync.isLoading && !hasData;

    if (dashboardAsync.hasError && !hasData) {
      return Scaffold(
        backgroundColor: colorScheme.surfaceContainer,
        body: Center(
          child: Text(
            'Error: ${dashboardAsync.error}',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    final doctorName = hasData
        ? dashboardAsync.value!.doctor.doctorName
        : 'Dr. ';
    final specialty = hasData
        ? dashboardAsync.value!.doctor.specialization
        : 'Specialist';
    final experienceYears = hasData
        ? dashboardAsync.value!.doctor.experienceYears
        : 0;
    final isAvailable = hasData
        ? dashboardAsync.value!.doctor.isAvailable
        : true;

    return Container(
      color: colorScheme.surfaceContainer,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            DoctorSliverAppBar(
              titleText: 'Dashboard',
              expandedHeight: 160,
              background: DoctorHeader(
                name: doctorName,
                specialty: specialty,
                experienceYears: experienceYears,
                rating: 5.0,
                isAvailable: isAvailable,
                onToggleAvailable: (val) {
                  HapticFeedback.lightImpact();
                  ref
                      .read(doctorDashboardProvider.notifier)
                      .toggleAvailability(val);
                },
              ),
            ),
          ];
        },
        body: isFirstLoad
            ? const DoctorDashboardBodyShimmer()
            : RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    ref.read(doctorDashboardProvider.notifier).loadDashboard(),
                    ref
                        .read(doctorCertificateServiceProvider.notifier)
                        .loadCertificateService(force: true),
                  ]);
                },
                child: _buildDashboardContent(context),
              ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    final dashboardAsync = ref.watch(doctorDashboardProvider);
    final data = dashboardAsync.value!;
    final isMobile = Responsive.isMobile(context);
    final double horizontalPadding = Responsive.horizontalPadding(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        AppSpacing.md,
        horizontalPadding,
        AppSpacing.xxxl + 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _buildDashboardGrid(context, data, isMobile),
        ),
      ),
    );
  }

  Widget _buildDashboardGrid(
    BuildContext context,
    dynamic data,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeroQueueCard(context, data),
        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: ActionCard(
                icon: Icons.book_online_rounded,
                title: 'Manual Booking',
                subtitle: 'Register walk-in patient',
                onTap: () => context.push(AppRoutes.doctorManualBooking),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ActionCard(
                icon: Icons.hourglass_empty_rounded,
                title: 'Pending Requests',
                subtitle: '${data.pendingRequests} awaiting approval',
                badgeCount: data.pendingRequests,
                badgeColor: AppTheme.pending(context),
                onTap: () {
                  context.push(
                    AppRoutes.doctorLiveQueue,
                    extra: {'initialIndex': 1},
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Today\'s Status Overview',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    count: data.todayQueue.toString(),
                    label: 'Patients',
                    icon: Icons.people_outline_rounded,
                    accentColor: AppTheme.info(context),
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                  _buildStatItem(
                    context,
                    count: data.pendingRequests.toString(),
                    label: 'Pending',
                    icon: Icons.hourglass_empty_rounded,
                    accentColor: AppTheme.pending(context),
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                  _buildStatItem(
                    context,
                    count: data.completedToday.toString(),
                    label: 'Done',
                    icon: Icons.check_circle_outline_rounded,
                    accentColor: AppTheme.success(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        CertificateServiceCard(),
        const SizedBox(height: AppSpacing.md),

        // 4. PATIENT REGISTRATION (QR TOOL)
        DirectBookingCard(
          onShowQR: widget.onShowQR ?? () => context.push(AppRoutes.doctorQr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 5. EMERGENCY CANCELLATION BUTTON
        Container(
          decoration: BoxDecoration(
            color: colorScheme.errorContainer.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.error.withValues(alpha: 0.15),
            ),
          ),
          child: Material(
            color: AppTheme.transparent,
            child: InkWell(
              onTap: () {
                EmergencyCancellationDialog.show(context, ref);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: colorScheme.error,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Cancellation',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Cancel remaining slots for today',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorScheme.error.withValues(alpha: 0.5),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroQueueCard(BuildContext context, dynamic data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final waitingCount = data.todayQueue;
    final isAvailable = data.doctor.isAvailable;

    String subtitleText;
    if (!isAvailable) {
      subtitleText = 'Queue is currently closed';
    } else if (waitingCount > 0) {
      subtitleText =
          '$waitingCount patient${waitingCount == 1 ? '' : 's'} waiting in live queue';
    } else {
      subtitleText = 'No patients waiting currently';
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.doctorLiveQueue),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.format_list_bulleted_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Queue',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitleText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        waitingCount.toString(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: colorScheme.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String count,
    required String label,
    required IconData icon,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: accentColor),
            ),
            const SizedBox(width: 8),
            Text(
              count,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

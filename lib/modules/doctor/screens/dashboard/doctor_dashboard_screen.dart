import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'widgets/doctor_header.dart';
import 'widgets/dashboard_cards.dart';
import '../../widgets/doctor_drawer.dart';
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
  ConsumerState<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends ConsumerState<DoctorDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch AsyncValue from Riverpod provider
    final dashboardAsync = ref.watch(doctorDashboardProvider);

    return dashboardAsync.when(
      loading: () => Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        body: Center(child: Text('Error: $error', style: theme.textTheme.bodyMedium)),
      ),
      data: (data) {
        final bool isMobile = Responsive.isMobile(context);
        final double horizontalPadding = Responsive.horizontalPadding(context);
        final bool isRefreshing = dashboardAsync.isRefreshing;

        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: colorScheme.surfaceContainerLow,
          drawer: DoctorDrawer(doctor: data.doctor),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                DoctorSliverAppBar(
                  expandedHeight: 180.0,
                  scaffoldKey: _scaffoldKey,
                  background: DoctorHeader(
                    name: data.doctor.fullName,
                    specialty: data.doctor.specialization,
                    experienceYears: data.doctor.experienceYears,
                    rating: 5.0,
                    isAvailable: data.isAvailable,
                    onToggleAvailable: (val) {
                      HapticFeedback.lightImpact();
                      ref.read(doctorDashboardProvider.notifier).toggleAvailability(val);
                    },
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: () => ref.read(doctorDashboardProvider.notifier).loadDashboard(),
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSpacing.lg,
                  horizontalPadding,
                  AppSpacing.xl + 40,
                ),
                child: ResponsiveContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isRefreshing) ...[
                        LinearProgressIndicator(
                          color: colorScheme.primary,
                          backgroundColor: colorScheme.primaryContainer,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      _buildDashboardGrid(context, data, isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardGrid(BuildContext context, dynamic data, bool isMobile) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ActionCard(
                  icon: Icons.format_list_bulleted_rounded,
                  title: 'Today\'s Queue',
                  subtitle: 'View and manage live patient queue',
                  onTap: widget.onOpenAppointments ??
                          () => context.push(AppRoutes.doctorAppointments),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ActionCard(
                  icon: Icons.book_online_rounded,
                  title: 'Manual Booking',
                  subtitle: 'Register a walk-in patient manually',
                  onTap: () => context.push(AppRoutes.doctorManualBooking),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = (constraints.maxWidth - AppSpacing.sm) / 2;

              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: StatCard(
                      count: data.pendingRequests,
                      label: 'Pending Requests',
                      badgeText: 'NEW',
                      type: StatType.pending,
                      icon: Icons.hourglass_empty_rounded,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: StatCard(
                      count: data.todayQueueCount,
                      label: 'Today\'s Queue',
                      badgeText: 'TODAY',
                      type: StatType.queue,
                      icon: Icons.people_outline_rounded,
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth,
                    child: StatCard(
                      count: data.completedTodayCount,
                      label: 'Completed Today',
                      badgeText: 'DONE',
                      type: StatType.completed,
                      icon: Icons.check_circle_outline_rounded,
                      isFullWidth: true,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.md),

          DirectBookingCard(
            onShowQR: widget.onShowQR ?? () => _showComingSoon(context, 'QR code panel coming soon'),
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: MiniActionCard(
                  icon: Icons.warning_amber_rounded,
                  title: 'Emergency Cancellations',
                  subtitle: 'Cancel remaining slots',
                  containerColor: colorScheme.errorContainer.withValues(alpha: 0.4),
                  foregroundColor: colorScheme.error,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Emergency cancellations initiated')),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: MiniActionCard(
                  icon: Icons.star_rounded,
                  title: 'Patient Reviews',
                  subtitle: 'Read feedback',
                  containerColor: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                  foregroundColor: colorScheme.secondary,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reviews list panel coming soon')),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = (constraints.maxWidth - (AppSpacing.md * 2)) / 3;

          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              SizedBox(
                width: itemWidth,
                height: 140,
                child: DoctorProfileCard(
                  name: data.doctor.fullName,
                  specialty: data.doctor.specialization,
                  experienceYears: data.doctor.experienceYears,
                  rating: 5.0,
                ),
              ),
              SizedBox(
                width: itemWidth,
                height: 140,
                child: ActionCard(
                  icon: Icons.format_list_bulleted_rounded,
                  title: 'Today\'s Queue',
                  subtitle: 'View and manage live patient queue',
                  onTap: widget.onOpenAppointments ??
                          () => context.push(AppRoutes.doctorAppointments),
                ),
              ),
              SizedBox(
                width: itemWidth,
                height: 140,
                child: ActionCard(
                  icon: Icons.book_online_rounded,
                  title: 'Manual Booking',
                  subtitle: 'Register a walk-in patient manually',
                  onTap: () => context.push(AppRoutes.doctorManualBooking),
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: StatCard(
                  count: data.pendingRequests,
                  label: 'Pending Requests',
                  badgeText: 'NEW',
                  type: StatType.pending,
                  icon: Icons.hourglass_empty_rounded,
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: StatCard(
                  count: data.todayQueueCount,
                  label: 'Today\'s Queue',
                  badgeText: 'TODAY',
                  type: StatType.queue,
                  icon: Icons.people_outline_rounded,
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: StatCard(
                  count: data.completedTodayCount,
                  label: 'Completed Today',
                  badgeText: 'DONE',
                  type: StatType.completed,
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: DirectBookingCard(
                  onShowQR: widget.onShowQR ?? () => _showComingSoon(context, 'QR code panel coming soon'),
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: MiniActionCard(
                  icon: Icons.warning_amber_rounded,
                  title: 'Emergency Cancellations',
                  subtitle: 'Cancel remaining slot appointments',
                  containerColor: colorScheme.errorContainer.withValues(alpha: 0.4),
                  foregroundColor: colorScheme.error,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Emergency cancellations initiated')),
                    );
                  },
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: MiniActionCard(
                  icon: Icons.star_rounded,
                  title: 'Patient Reviews',
                  subtitle: 'Read feedback from your patients',
                  containerColor: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                  foregroundColor: colorScheme.secondary,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reviews list panel coming soon')),
                    );
                  },
                ),
              )
            ],
          );
        },
      );
    }
  }

  void _showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
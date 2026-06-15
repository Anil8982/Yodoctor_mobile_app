import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'widgets/doctor_header.dart';
import 'widgets/dashboard_cards.dart';
import '../../widgets/doctor_drawer.dart';
import '../../widgets/doctor_sliver_app_bar.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../controllers/doctor_dashboard_controller.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({
    super.key,
    this.onShowQR,
    this.onOpenAppointments,
  });

  final VoidCallback? onShowQR;
  final VoidCallback? onOpenAppointments;

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<DoctorDashboardController>(
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

        final bool isMobile = Responsive.isMobile(context);
        final double horizontalPadding = Responsive.horizontalPadding(context);

        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: DoctorDrawer(doctor: data.doctor),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                DoctorSliverAppBar(
                  expandedHeight: 180.0,
                  scaffoldKey: _scaffoldKey,
                  background: DoctorHeader(
                    name: data.doctor.name,
                    specialty: data.doctor.specialty,
                    experienceYears: data.doctor.experienceYears,
                    rating: data.doctor.rating,
                    isAvailable: data.isAvailable,
                    onToggleAvailable: (val) {
                      HapticFeedback.lightImpact();
                      controller.toggleAvailability(val);
                    },
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: controller.loadDashboard,
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSpacing.lg,
                  horizontalPadding,
                  AppSpacing.xl + 40, // Extra padding at bottom for navigation bar clearance
                ),
                child: ResponsiveContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (loading) ...[
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
    // final colorScheme = Theme.of(context).colorScheme;

    if (isMobile) {
      // Mobile Layout: Column containing full-width/half-width rows
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [


          // Row 2: Today's Queue & Manual Booking (Side by side)
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

          // Row 3: Stats row (Pending, Today, Done)
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate width for 2 columns with spacing accounted for
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
                  // The 3rd card takes full width elegantly at the bottom
                  SizedBox(
                    width: constraints.maxWidth,
                    child: StatCard(
                      count: data.completedTodayCount,
                      label: 'Completed Today',
                      badgeText: 'DONE',
                      type: StatType.completed,
                      icon: Icons.check_circle_outline_rounded,
                      isFullWidth: true, // Custom flag to optimize layout if wide
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Row 4: Direct Booking Card (Full width)
          DirectBookingCard(
            onShowQR: widget.onShowQR ?? () => _showComingSoon(context, 'QR code panel coming soon'),
          ),
          const SizedBox(height: AppSpacing.md),

          // Row 5: Emergency Cancellations & Reviews
          Row(
            children: [
              // 1. Emergency Cancellations Card
              Expanded(
                child: MiniActionCard(
                  icon: Icons.warning_amber_rounded,
                  title: 'Emergency Cancellations',
                  subtitle: 'Cancel remaining slot appointments',
                  containerColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.error,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Emergency cancellations initiated')),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // 2. Patient Reviews Card
              Expanded(
                child: MiniActionCard(
                  icon: Icons.star_rounded,
                  title: 'Patient Reviews',
                  subtitle: 'Read feedback from your patients',
                  containerColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
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
              // Row 1: Profile, Queue, Manual Booking
              SizedBox(
                width: itemWidth,
                height: 140,
                child: DoctorProfileCard(
                  name: data.doctor.name,
                  specialty: data.doctor.specialty,
                  experienceYears: data.doctor.experienceYears,
                  rating: data.doctor.rating,
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

              // Row 2: Pending Requests stat, Today's queue stat, Completed Today stat
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

              // Row 3: Patient Direct Booking card, Emergency cancellations, Patient reviews
              SizedBox(
                width: itemWidth,
                child: DirectBookingCard(
                  onShowQR: widget.onShowQR ?? () => _showComingSoon(context, 'QR code panel coming soon'),
                ),
              ),
              MiniActionCard(
                icon: Icons.warning_amber_rounded,
                title: 'Emergency Cancellations',
                subtitle: 'Cancel remaining slot appointments',
                containerColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.error,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Emergency cancellations initiated')),
                  );
                },
              ),

              MiniActionCard(
                icon: Icons.star_rounded,
                title: 'Patient Reviews',
                subtitle: 'Read feedback from your patients',
                containerColor: Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reviews list panel coming soon')),
                  );
                },
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

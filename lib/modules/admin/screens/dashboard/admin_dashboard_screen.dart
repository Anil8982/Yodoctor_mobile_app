import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod वापरला
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:yodoctor/modules/admin/screens/dashboard/widgets/analytics_card.dart';
import 'package:yodoctor/modules/admin/screens/dashboard/widgets/platform_overview_section.dart';
import 'package:yodoctor/modules/admin/screens/dashboard/widgets/quick_action_card.dart';
import 'package:yodoctor/modules/admin/widgets/admin_drawer.dart';
import 'package:yodoctor/modules/admin/widgets/admin_header.dart';
import 'package:yodoctor/modules/admin/widgets/admin_sliver_app_bar.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

class AdminDashboardScreen extends ConsumerWidget {
  AdminDashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dashboardAsync = ref.watch(adminDashboardProvider);

    return dashboardAsync.when(
      loading: () => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
      data: (state) {
        final data = state.rawData;
        if (data == null) return const SizedBox.shrink();

        final horizontal = Responsive.horizontalPadding(context);

        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: AdminDrawer(admin: data.admin),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                AdminSliverAppBar(
                  expandedHeight: 190,
                  scaffoldKey: _scaffoldKey,
                  background: AdminHeader(),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: () => ref.read(adminDashboardProvider.notifier).refreshDashboard(),
              color: colorScheme.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontal,
                  AppSpacing.lg,
                  horizontal,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    PlatformOverviewWidget(),
                    const SizedBox(height: 24),
                    const AnalyticsWidget(),
                    const SizedBox(height: 24),
                    QuickActionsWidget(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
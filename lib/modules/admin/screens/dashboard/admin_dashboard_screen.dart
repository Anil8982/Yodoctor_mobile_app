import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:yodoctor/modules/admin/screens/dashboard/widgets/analytics_card.dart';
import 'package:yodoctor/modules/admin/screens/dashboard/widgets/platform_overview_section.dart';
import 'package:yodoctor/modules/admin/screens/dashboard/widgets/quick_action_card.dart';
import 'package:yodoctor/modules/admin/widgets/admin_drawer.dart';
import 'package:yodoctor/modules/admin/widgets/admin_header.dart';
import 'package:yodoctor/modules/admin/widgets/admin_sliver_app_bar.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnalyticsWidgetState> analyticsKey =
    GlobalKey<AnalyticsWidgetState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AdminDashboardController>(
      builder: (context, controller, child) {
        final loading = controller.isLoading;
        final data = controller.dashboardData;

        if (loading && data == null) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (data == null) {
          return const SizedBox.shrink();
        }

        final horizontal = Responsive.horizontalPadding(context);

        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer:  AdminDrawer(admin:data.admin),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                AdminSliverAppBar(
                  expandedHeight: 190,
                  scaffoldKey: _scaffoldKey,
                  background: AdminHeader(user: data.admin),
                ),
              ];
            },

            body: RefreshIndicator(
             onRefresh: () async {
  await controller.loadDashboard();

  analyticsKey.currentState?.resetAnalytics();
},
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

                    PlatformOverviewWidget(data: data),

                    const SizedBox(height: 24),

                    AnalyticsWidget(appointments: data.appointments,key: analyticsKey,),

                    const SizedBox(height: 24),

                    QuickActionsWidget(data: data),
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

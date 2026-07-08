import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../doctor/controllers/doctor_dashboard_controller.dart';
import 'widgets/doctor_bottom_nav.dart';
import 'widgets/doctor_drawer.dart';

class DoctorScaffoldShell extends ConsumerWidget {
  const DoctorScaffoldShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(doctorDashboardProvider);

    return Scaffold(
      drawer: dashboard.when(
        data: (data) => DoctorDrawer(doctor: data.doctor),
        loading: () => const Drawer(),
        error: (_, __) => const Drawer(),
      ),

      body: navigationShell,

      bottomNavigationBar: DoctorBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

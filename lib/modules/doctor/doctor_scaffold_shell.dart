import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'screens/appointments/doctor_appointment_history_screen.dart';
import 'screens/dashboard/doctor_dashboard_screen.dart';
import 'screens/certificate/doctor_certificate_dashboard_screen.dart';
import 'screens/reviews/doctor_reviews_screen.dart';
import 'widgets/doctor_bottom_nav.dart';

class DoctorScaffoldShell extends StatefulWidget {
  const DoctorScaffoldShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<DoctorScaffoldShell> createState() => _DoctorScaffoldShellState();
}

class _DoctorScaffoldShellState extends State<DoctorScaffoldShell> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.navigationShell.currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      DoctorDashboardScreen(
        onOpenAppointments: () {
          setState(() {
            _controller.index = 1;
            widget.navigationShell.goBranch(1);
          });
        },
      ),
      const DoctorAppointmentHistoryScreen(),
      const DoctorCertificateDashboardScreen(),
      const DoctorReviewsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.index != widget.navigationShell.currentIndex) {
      _controller.index = widget.navigationShell.currentIndex;
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: DoctorBottomNav.navBarItems(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      padding: const EdgeInsets.only(top: 8),
      navBarHeight: kBottomNavigationBarHeight + 10,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.zero,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (index) {
        widget.navigationShell.goBranch(index);
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:yodoctor/modules/patient/screens/dashboard/dashboard_screen.dart';
import 'package:yodoctor/modules/patient/screens/certificates/certificate_wallet_screen.dart';
import 'package:yodoctor/modules/patient/screens/history/appointments_history_screen.dart';
import 'package:yodoctor/modules/patient/screens/services/services_screen.dart';
import 'package:yodoctor/modules/patient/widgets/patient_bottom_nav.dart';
import 'package:yodoctor/modules/patient/widgets/qr_scanner.dart';

class PatientScaffoldShell extends StatefulWidget {
  const PatientScaffoldShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<PatientScaffoldShell> createState() => _PatientScaffoldShellState();
}

class _PatientScaffoldShellState extends State<PatientScaffoldShell> {
  late PersistentTabController _controller;
  int _lastActiveIndex = 0;

  @override
  void initState() {
    super.initState();
    final int initialNavIndex = widget.navigationShell.currentIndex >= 2
        ? widget.navigationShell.currentIndex + 1
        : widget.navigationShell.currentIndex;

    _controller = PersistentTabController(initialIndex: initialNavIndex);
    _lastActiveIndex = initialNavIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      DashboardScreen(),
      const CertificateWalletScreen(),
      const Scaffold(body: SizedBox.shrink()),
      // const FamilyMembersScreen(),
      const ServicesScreen(),
      const AppointmentsHistoryScreen(),
    ];
  }

  void _openQRScanner() {
    QrScannerSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final int expectedNavIndex = widget.navigationShell.currentIndex >= 2
        ? widget.navigationShell.currentIndex + 1
        : widget.navigationShell.currentIndex;

    if (_controller.index != expectedNavIndex) {
      _controller.index = expectedNavIndex;
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: PatientBottomNav.navBarItems(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      padding: const EdgeInsets.only(top: 8),
      navBarHeight: kBottomNavigationBarHeight + 10,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.zero,
        colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      navBarStyle: NavBarStyle.style15,
      onItemSelected: (index) {
        if (index == 2) {
          _controller.index = _lastActiveIndex;
          _openQRScanner();
        } else {
          _lastActiveIndex = index;

          final int routerBranchIndex = index >= 2 ? index - 1 : index;
          widget.navigationShell.goBranch(routerBranchIndex);
        }
      },
    );
  }
}
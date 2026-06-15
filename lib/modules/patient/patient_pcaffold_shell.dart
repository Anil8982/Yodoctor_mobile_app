import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:yodoctor/modules/patient/screens/dashboard/dashboard_screen.dart';
import 'package:yodoctor/modules/patient/screens/certificates/certificate_wallet_screen.dart';
import 'package:yodoctor/modules/patient/screens/family/family_members_screen.dart';
import 'package:yodoctor/modules/patient/screens/history/appointments_history_screen.dart';
import 'package:yodoctor/modules/patient/widgets/patient_bottom_nav.dart';

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

    _controller = PersistentTabController(initialIndex: widget.navigationShell.currentIndex);
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
      const FamilyMembersScreen(),
      const AppointmentsHistoryScreen(),
    ];
  }

  void _openQRScanner() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: const Center(
            child: Text(
              'QR Scanner Camera Open Here',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
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
          widget.navigationShell.goBranch(index);
        }
      },
    );
  }
}
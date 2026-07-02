import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:yodoctor/modules/admin/screens/dashboard/admin_dashboard_screen.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/screens/doctor_management_screen.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/screens/enquiry_screen.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/screens/home_care_bookings_screen.dart';
import 'package:yodoctor/modules/admin/widgets/admin_bottom_nav.dart';

class AdminScaffoldShell extends StatefulWidget {
  const AdminScaffoldShell({super.key});

  @override
  State<AdminScaffoldShell> createState() => _AdminScaffoldShellState();
}

class _AdminScaffoldShellState extends State<AdminScaffoldShell> {
  late PersistentTabController _controller;
  int _lastActiveIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      AdminDashboardScreen(),
     DoctorsManagementScreen(),
      // const Scaffold(body: SizedBox.shrink()),
      const EnquiryScreen(),
       const HomeCareBookingsScreen()
    ];
  }

  void _openAdminAction() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const SizedBox(
          height: 400,
          child: Center(
            child: Text(
              'Admin Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: AdminBottomNav.navBarItems(context),
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
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (index) {
        // if (index == 2) {
        //   _controller.index = _lastActiveIndex;
        //   _openAdminAction();
        // } else {
          _lastActiveIndex = index;
        // }
      },
    );
  }
}

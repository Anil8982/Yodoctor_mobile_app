import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:yodoctor/modules/admin/screens/dashboard/admin_dashboard_screen.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/doctor_management_screen.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/enquiry_screen.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/home_care_bookings_screen.dart';
import 'package:yodoctor/modules/admin/widgets/admin_bottom_nav.dart';

final adminTabControllerProvider = Provider.autoDispose<PersistentTabController>((ref) {
  final controller = PersistentTabController(initialIndex: 0);
  ref.onDispose(() => controller.dispose());
  return controller;
});

class AdminScaffoldShell extends ConsumerWidget {
  const AdminScaffoldShell({super.key});

  List<Widget> _buildScreens() {
    return [
      AdminDashboardScreen(),
      DoctorsManagementScreen(),
      EnquiryScreen(),
      HomeCareBookingsScreen(),
    ];
  }

  // void _openAdminAction(BuildContext context) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return const SizedBox(
  //         height: 400,
  //         child: Center(
  //           child: Text(
  //             'Admin Quick Actions',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = ref.watch(adminTabControllerProvider);

    return PersistentTabView(
      context,
      controller: tabController,
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
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (index) {

      },
    );
  }
}
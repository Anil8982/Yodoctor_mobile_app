import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/patient/widgets/patient_bottom_nav.dart';

class PatientScaffoldShell extends StatelessWidget {
  const PatientScaffoldShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final bool showNavBar = currentPath != '/profile' && currentPath != '/certificates/apply';
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: PatientBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        isVisible: showNavBar,
      ),
    );
  }
}
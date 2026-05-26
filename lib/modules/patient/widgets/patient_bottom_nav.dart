// import 'package:flutter/material.dart';
//
// class PatientBottomNav extends StatelessWidget {
//   const PatientBottomNav({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//     this.isVisible = true,
//   });
//
//   final int currentIndex;
//   final Function(int) onTap;
//   final bool isVisible;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return NavigationBar(
//       selectedIndex: currentIndex,
//       onDestinationSelected: onTap,
//       destinations: const [
//         NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
//         // NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
//         NavigationDestination(icon: Icon(Icons.wallet_membership_rounded), label: 'Certificates'),
//         NavigationDestination(icon: Icon(Icons.people_rounded), label: 'Family'),
//         NavigationDestination(icon: Icon(Icons.history_rounded), label: 'History'),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PatientBottomNav {
  const PatientBottomNav._();

  static List<PersistentBottomNavBarItem> navBarItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        title: "Home",
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.wallet_membership_rounded),
        title: "Certificates",
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Icon(Icons.qr_code_scanner_rounded, color: colorScheme.onPrimary, size: 26),
        ),
        title: "Scan",
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people_rounded),
        title: "Family",
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.history_rounded),
        title: "History",
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.onSurfaceVariant,
      ),
    ];
  }
}
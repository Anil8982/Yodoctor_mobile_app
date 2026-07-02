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
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.people_rounded),
      //   title: "Family",
      //   activeColorPrimary: colorScheme.primary,
      //   inactiveColorPrimary: colorScheme.onSurfaceVariant,
      // ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.medical_services_rounded),
        title: "Services",
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
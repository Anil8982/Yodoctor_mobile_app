import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class AdminBottomNav {
  const AdminBottomNav._();

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
        title: "Doctors Management",
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people_rounded),
        title: "Enquiries",
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.history_rounded),
        title: "Home Care Bookings",
        activeColorPrimary: colorScheme.primary,
        inactiveColorPrimary: colorScheme.onSurfaceVariant,
      ),
    ];
  }
}

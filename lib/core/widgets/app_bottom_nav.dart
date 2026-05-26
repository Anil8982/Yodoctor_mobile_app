// import 'package:flutter/material.dart';
//
// class AppBottomNavItem {
//   const AppBottomNavItem({required this.icon, required this.label});
//
//   final IconData icon;
//   final String label;
// }
//
// class AppBottomNav extends StatelessWidget {
//   const AppBottomNav({
//     super.key,
//     required this.items,
//     required this.currentIndex,
//     required this.onTap,
//   });
//
//   final List<AppBottomNavItem> items;
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return NavigationBar(
//       selectedIndex: currentIndex,
//       onDestinationSelected: onTap,
//       destinations: items
//           .map(
//             (AppBottomNavItem item) =>
//                 NavigationDestination(icon: Icon(item.icon), label: item.label),
//           )
//           .toList(),
//     );
//   }
// }

import 'package:flutter/material.dart';

class DoctorBottomNav extends StatelessWidget {
  const DoctorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      height: 72,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_rounded), label: "Home"),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_rounded),
          label: "History",
        ),
        NavigationDestination(
          icon: Icon(Icons.workspace_premium_rounded),
          label: "Certificates",
        ),
        NavigationDestination(icon: Icon(Icons.star_rounded), label: "Reviews"),
      ],
    );
  }
}

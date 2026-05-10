import 'package:flutter/material.dart';

class PatientBottomNav extends StatelessWidget {
  const PatientBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
        NavigationDestination(icon: Icon(Icons.people_rounded), label: 'Family'),
        NavigationDestination(icon: Icon(Icons.history_rounded), label: 'History'),
      ],
    );
  }
}
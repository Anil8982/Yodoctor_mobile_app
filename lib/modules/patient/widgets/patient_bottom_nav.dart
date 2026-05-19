import 'package:flutter/material.dart';

class PatientBottomNav extends StatelessWidget {
  const PatientBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isVisible = true,
  });

  final int currentIndex;
  final Function(int) onTap;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    const double navBarHeight = 80.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: isVisible ? navBarHeight + MediaQuery.of(context).padding.bottom : 0,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          minHeight: navBarHeight,
          maxHeight: navBarHeight,
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
              NavigationDestination(icon: Icon(Icons.people_rounded), label: 'Family'),
              NavigationDestination(icon: Icon(Icons.history_rounded), label: 'History'),
            ],
          ),
        ),
      ),
    );
  }
}
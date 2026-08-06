import 'package:flutter/material.dart';
import 'package:yodoctor/modules/widgets/app_bottom_nav.dart';

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
    return AppBottomNav(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        NavItemData(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: "Home",
        ),
        NavItemData(
          icon: Icons.calendar_month_outlined,
          activeIcon: Icons.calendar_month_rounded,
          label: "History",
        ),
        NavItemData(
          icon: Icons.workspace_premium_outlined,
          activeIcon: Icons.workspace_premium_rounded,
          label: "Certificates",
        ),
        NavItemData(
          icon: Icons.star_outline_rounded,
          activeIcon: Icons.star_rounded,
          label: "Reviews",
        ),
      ],
    );
  }
}
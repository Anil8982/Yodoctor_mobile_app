import 'package:flutter/material.dart';
import 'package:yodoctor/modules/widgets/app_bottom_nav.dart';

class PatientBottomNav extends StatelessWidget {
  const PatientBottomNav({
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
      centerWidgetGapIndex: 2,
      items: const [
        NavItemData(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: "Home",
        ),
        NavItemData(
          icon: Icons.wallet_membership_outlined,
          activeIcon: Icons.wallet_membership_rounded,
          label: "Certificates",
        ),
        NavItemData(
          icon: Icons.medical_services_outlined,
          activeIcon: Icons.medical_services_rounded,
          label: "Services",
        ),
        NavItemData(
          icon: Icons.history_outlined,
          activeIcon: Icons.history_rounded,
          label: "History",
        ),
      ],
    );
  }
}
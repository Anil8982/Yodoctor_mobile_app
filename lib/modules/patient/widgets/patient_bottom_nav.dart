import 'package:flutter/material.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final homeLabel = l10n?.homeTab ?? "Home";
    final certLabel = l10n?.certificatesTab ?? "Certificates";
    final servicesLabel = l10n?.servicesTab ?? "Services";
    final historyLabel = l10n?.appointmentsTab ?? "History";

    return AppBottomNav(
      currentIndex: currentIndex,
      onTap: onTap,
      centerWidgetGapIndex: 2,
      items: [
        NavItemData(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: homeLabel,
        ),
        NavItemData(
          icon: Icons.wallet_membership_outlined,
          activeIcon: Icons.wallet_membership_rounded,
          label: certLabel,
        ),
        NavItemData(
          icon: Icons.medical_services_outlined,
          activeIcon: Icons.medical_services_rounded,
          label: servicesLabel,
        ),
        NavItemData(
          icon: Icons.history_outlined,
          activeIcon: Icons.history_rounded,
          label: historyLabel,
        ),
      ],
    );
  }
}

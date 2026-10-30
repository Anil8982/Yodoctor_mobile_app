import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/patient_bottom_nav.dart';
import 'widgets/qr_scanner.dart';

class PatientScaffoldShell extends ConsumerWidget {
  const PatientScaffoldShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _openQRScanner(BuildContext context) {
    QrScannerSheet.show(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true, // Content flows behind the floating glass nav bar
      resizeToAvoidBottomInset: false,
      body: navigationShell,
      bottomNavigationBar: isKeyboardVisible
          ? null
          : PatientBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        onCenterButtonTap: () => _openQRScanner(context),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/patient_bottom_nav.dart';
import 'widgets/patient_drawer.dart';
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
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: PatientDrawer(),
      body: navigationShell,
      bottomNavigationBar: PatientBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
      floatingActionButton: isKeyboardVisible
          ? null
          : FloatingActionButton(
        heroTag: 'patient_qr_scanner',
        tooltip: 'Scan QR Code',
        onPressed: () => _openQRScanner(context),
        elevation: 4,
        child: const Icon(Icons.qr_code_scanner_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
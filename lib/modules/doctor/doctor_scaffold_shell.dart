// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
//
// import '../../core/utils/app_spacing.dart';
// import 'screens/appointments/doctor_appointment_history_screen.dart';
// import 'screens/dashboard/doctor_dashboard_screen.dart';
// import 'screens/certificate/doctor_certificate_dashboard_screen.dart'; // 👈 इम्पोर्ट असल्याची खात्री कर
// import 'widgets/doctor_bottom_nav.dart';
//
// class DoctorScaffoldShell extends StatefulWidget {
//   const DoctorScaffoldShell({
//     super.key,
//     required this.navigationShell,
//   });
//
//   final StatefulNavigationShell navigationShell;
//
//   @override
//   State<DoctorScaffoldShell> createState() => _DoctorScaffoldShellState();
// }
//
// class _DoctorScaffoldShellState extends State<DoctorScaffoldShell> {
//   late final PersistentTabController _controller;
//   int _lastActiveIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = PersistentTabController(initialIndex: widget.navigationShell.currentIndex);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   List<Widget> _buildScreens() {
//     return [
//       // Screen 0
//       DoctorDashboardScreen(
//         onShowQR: () => openQRCodeModal(context),
//         onOpenAppointments: () {
//           setState(() {
//             _lastActiveIndex = 1;
//             _controller.index = 1;
//             widget.navigationShell.goBranch(1);
//           });
//         },
//       ),
//       // Screen 1
//       const DoctorAppointmentHistoryScreen(),
//       // Screen 2:
//       const Scaffold(body: SizedBox.shrink()),
//       // Screen 3
//       const DoctorCertificateDashboardScreen(),
//       // Screen 4:
//       _buildPlaceholderScreen('Patient Reviews', Icons.star_rounded),
//     ];
//   }
//
//   Widget _buildPlaceholderScreen(String title, IconData icon) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Scaffold(
//       backgroundColor: colorScheme.surfaceContainer,
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: colorScheme.surfaceContainer,
//         foregroundColor: colorScheme.onSurface,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(AppSpacing.xl),
//           child: Container(
//             width: double.infinity,
//             constraints: const BoxConstraints(maxWidth: 520),
//             padding: const EdgeInsets.all(AppSpacing.xxl),
//             decoration: BoxDecoration(
//               color: colorScheme.surface,
//               borderRadius: BorderRadius.circular(28),
//               border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
//               boxShadow: [
//                 BoxShadow(
//                   color: colorScheme.shadow.withValues(alpha: 0.04),
//                   blurRadius: 22,
//                   offset: const Offset(0, 12),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     color: colorScheme.primaryContainer.withValues(alpha: 0.75),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(icon, size: 44, color: colorScheme.primary),
//                 ),
//                 const SizedBox(height: AppSpacing.lg),
//                 Text(
//                   '$title Panel',
//                   textAlign: TextAlign.center,
//                   style: textTheme.titleLarge?.copyWith(
//                     color: colorScheme.onSurface,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 const SizedBox(height: AppSpacing.xs),
//                 Text(
//                   'Manage and view details for $title.',
//                   textAlign: TextAlign.center,
//                   style: textTheme.bodyMedium?.copyWith(
//                     color: colorScheme.onSurfaceVariant,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void openQRCodeModal(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: colorScheme.surface,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: colorScheme.outlineVariant,
//                   borderRadius: BorderRadius.circular(99),
//                 ),
//               ),
//               const SizedBox(height: AppSpacing.xl),
//               Text(
//                 'Patient Direct Booking',
//                 style: textTheme.titleLarge?.copyWith(
//                   color: colorScheme.onSurface,
//                   fontWeight: FontWeight.w900,
//                   letterSpacing: -0.5,
//                 ),
//               ),
//               const SizedBox(height: AppSpacing.xs),
//               Text(
//                 'Patients can scan this QR code at your clinic desk to join the queue instantly.',
//                 textAlign: TextAlign.center,
//                 style: textTheme.bodyMedium?.copyWith(
//                   color: colorScheme.onSurfaceVariant,
//                   height: 1.4,
//                 ),
//               ),
//               const SizedBox(height: 28),
//               Container(
//                 padding: const EdgeInsets.all(AppSpacing.xl),
//                 decoration: BoxDecoration(
//                   color: colorScheme.primaryContainer.withValues(alpha: 0.35),
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(color: colorScheme.primary.withValues(alpha: 0.15), width: 1.5),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(AppSpacing.md),
//                       decoration: BoxDecoration(
//                         color: colorScheme.surface,
//                         borderRadius: BorderRadius.circular(18),
//                         boxShadow: [
//                           BoxShadow(
//                             color: colorScheme.shadow.withValues(alpha: 0.05),
//                             blurRadius: 14,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Icon(Icons.qr_code_2_rounded, size: 190, color: colorScheme.primary),
//                           const SizedBox(height: AppSpacing.xs),
//                           Text(
//                             'yodoctor.in/dr-rahul-verma',
//                             style: textTheme.labelMedium?.copyWith(
//                               color: colorScheme.primary,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: AppSpacing.md),
//                     Text(
//                       'Dr. Rahul Verma',
//                       style: textTheme.titleMedium?.copyWith(
//                         color: colorScheme.onSurface,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                     Text(
//                       'Orthopedic • 6 yrs exp',
//                       style: textTheme.bodySmall?.copyWith(
//                         color: colorScheme.onSurfaceVariant,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 28),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('QR Code PDF downloaded successfully')),
//                         );
//                       },
//                       icon: const Icon(Icons.download_rounded),
//                       label: const Text('Download PDF'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: colorScheme.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: BorderSide(color: colorScheme.primary),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: AppSpacing.sm),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('QR Code link shared successfully')),
//                         );
//                       },
//                       icon: const Icon(Icons.share_rounded),
//                       label: const Text('Share Code'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: colorScheme.primary,
//                         foregroundColor: colorScheme.onPrimary,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: AppSpacing.sm),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_controller.index != widget.navigationShell.currentIndex) {
//       _controller.index = widget.navigationShell.currentIndex;
//     }
//
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: DoctorBottomNav.navBarItems(context),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       handleAndroidBackButtonPress: true,
//       resizeToAvoidBottomInset: true,
//       stateManagement: true,
//       hideNavigationBarWhenKeyboardAppears: true,
//       padding: const EdgeInsets.only(top: 8),
//       navBarHeight: kBottomNavigationBarHeight + 10,
//       decoration: NavBarDecoration(
//         borderRadius: BorderRadius.zero,
//         border: Border(
//           top: BorderSide(
//             color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.35),
//           ),
//         ),
//       ),
//       navBarStyle: NavBarStyle.style15,
//       onItemSelected: (index) {
//         if (index == 2) {
//           _controller.index = _lastActiveIndex;
//           openQRCodeModal(context);
//         } else {
//           _lastActiveIndex = index;
//           widget.navigationShell.goBranch(index);
//         }
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../core/utils/app_spacing.dart';
import 'screens/appointments/doctor_appointment_history_screen.dart';
import 'screens/dashboard/doctor_dashboard_screen.dart';
import 'screens/certificate/doctor_certificate_dashboard_screen.dart';
import 'screens/reviews/doctor_reviews_screen.dart';
import 'widgets/doctor_bottom_nav.dart';

class DoctorScaffoldShell extends StatefulWidget {
  const DoctorScaffoldShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<DoctorScaffoldShell> createState() => _DoctorScaffoldShellState();
}

class _DoctorScaffoldShellState extends State<DoctorScaffoldShell> {
  late final PersistentTabController _controller;
  int _lastActiveIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.navigationShell.currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      DoctorDashboardScreen(
        onShowQR: () => openQRCodeModal(context),
        onOpenAppointments: () {
          setState(() {
            _lastActiveIndex = 1;
            _controller.index = 1;
            widget.navigationShell.goBranch(1);
          });
        },
      ),
      const DoctorAppointmentHistoryScreen(),
      const Scaffold(body: SizedBox.shrink()),
      const DoctorCertificateDashboardScreen(),
      const DoctorReviewsScreen(),
    ];
  }

  void openQRCodeModal(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Patient Direct Booking',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Patients can scan this QR code at your clinic desk to join the queue instantly.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colorScheme.primary.withValues(alpha: 0.15), width: 1.5),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.qr_code_2_rounded, size: 190, color: colorScheme.primary),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'yodoctor.in/dr-rahul-verma',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Dr. Rahul Verma',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Orthopedic • 6 yrs exp',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('QR Code PDF downloaded successfully')),
                        );
                      },
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download PDF'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('QR Code link shared successfully')),
                        );
                      },
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Share Code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.index != widget.navigationShell.currentIndex) {
      _controller.index = widget.navigationShell.currentIndex;
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: DoctorBottomNav.navBarItems(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      padding: const EdgeInsets.only(top: 8),
      navBarHeight: kBottomNavigationBarHeight + 10,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.zero,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      navBarStyle: NavBarStyle.style15,
      onItemSelected: (index) {
        if (index == 2) {
          _controller.index = _lastActiveIndex;
          openQRCodeModal(context);
        } else {
          _lastActiveIndex = index;
          widget.navigationShell.goBranch(index);
        }
      },
    );
  }
}
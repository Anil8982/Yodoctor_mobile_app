// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:chroma_theme/chroma_theme.dart';
//
// import 'core/routes/app_routes.dart';
// import 'modules/patient/controllers/appointment_history_controller.dart';
// import 'modules/patient/controllers/doctor_listing_controller.dart';
// import 'modules/patient/controllers/family_controller.dart';
// import 'modules/patient/controllers/patient_dashboard_controller.dart';
// import 'modules/patient/controllers/patient_search_controller.dart';
// import 'modules/patient/controllers/profile_controller.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => PatientSearchController()),
//         ChangeNotifierProvider(create: (_) => PatientDashboardController()),
//         ChangeNotifierProvider(create: (_) => DoctorListingController()),
//         ChangeNotifierProvider(create: (_) => ProfileController()),
//         ChangeNotifierProvider(create: (_) => FamilyController()),
//         ChangeNotifierProvider(create: (_) => AppointmentHistoryController()),
//       ],
//       child: const YoDoctorApp(),
//     ),
//   );
// }
//
// class YoDoctorApp extends StatelessWidget {
//   const YoDoctorApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChromaTheme(
//       initialMode: ChromaThemeMode.light,
//       initialPalette: ChromaPalette.blue,
//       child: Builder(
//         builder: (context) {
//           final theme = Theme.of(context);
//           final colorScheme = theme.colorScheme;
//
//           return MaterialApp.router(
//             title: 'yoDoctor',
//             debugShowCheckedModeBanner: false,
//             routerConfig: AppRouter.router,
//             theme: theme.copyWith(
//               scaffoldBackgroundColor:
//               colorScheme.surfaceContainerLowest,
//               appBarTheme: theme.appBarTheme.copyWith(
//                 elevation: 0,
//                 scrolledUnderElevation: 0,
//                 backgroundColor: Colors.transparent,
//                 foregroundColor: colorScheme.onSurface,
//                 centerTitle: false,
//               ),
//               cardTheme: theme.cardTheme.copyWith(
//                 color: colorScheme.surface,
//                 elevation: 2,
//                 shadowColor: Colors.black.withValues(alpha: 0.05),
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(24)),
//                 ),
//               ),
//               inputDecorationTheme: InputDecorationTheme(
//                 filled: true,
//                 fillColor: colorScheme.surface,
//                 hintStyle: TextStyle(
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//                 border: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(16)),
//                   borderSide: BorderSide.none,
//                 ),
//                 enabledBorder: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(16)),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius:
//                   const BorderRadius.all(Radius.circular(16)),
//                   borderSide: BorderSide(
//                     color: colorScheme.primary,
//                     width: 1.4,
//                   ),
//                 ),
//               ),
//               chipTheme: theme.chipTheme.copyWith(
//                 backgroundColor:
//                 colorScheme.surfaceContainerHigh,
//                 selectedColor:
//                 colorScheme.primaryContainer,
//                 labelStyle: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: colorScheme.onSurface,
//                 ),
//                 side: BorderSide.none,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

import 'modules/patient/controllers/appointment_history_controller.dart';
import 'modules/patient/controllers/doctor_listing_controller.dart';
import 'modules/patient/controllers/family_controller.dart';
import 'modules/patient/controllers/patient_dashboard_controller.dart';
import 'modules/patient/controllers/patient_search_controller.dart';
import 'modules/patient/controllers/profile_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientSearchController()),
        ChangeNotifierProvider(create: (_) => PatientDashboardController()),
        ChangeNotifierProvider(create: (_) => DoctorListingController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => FamilyController()),
        ChangeNotifierProvider(create: (_) => AppointmentHistoryController()),
      ],
      child: const YoDoctorApp(),
    ),
  );
}

class YoDoctorApp extends StatelessWidget {
  const YoDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    const AppRole currentRole = AppRole.patient;

    return MaterialApp.router(
      title: 'yoDoctor',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,

      theme: currentRole == AppRole.doctor
          ? AppTheme.doctorTheme
          : AppTheme.patientTheme,

      themeMode: ThemeMode.light,
    );
  }
}
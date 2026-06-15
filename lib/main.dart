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
import 'modules/patient/controllers/certificate_request.dart';
import 'modules/doctor/controllers/doctor_dashboard_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppRoleProvider()),
        ChangeNotifierProvider(create: (_) => PatientSearchController()),
        ChangeNotifierProvider(create: (_) => PatientDashboardController()),
        ChangeNotifierProvider(create: (_) => DoctorListingController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => FamilyController()),
        ChangeNotifierProvider(create: (_) => AppointmentHistoryController()),
        ChangeNotifierProvider(create: (_) => CertificateController()),
        ChangeNotifierProvider(create: (_) => DoctorDashboardController()),
      ],
      child: const YoDoctorApp(),
    ),
  );
}

class YoDoctorApp extends StatelessWidget {
  const YoDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<AppRoleProvider>(context);

    return MaterialApp.router(
      title: 'yoDoctor',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,

      theme: roleProvider.role == AppRole.doctor
          ? AppTheme.doctorTheme
          : AppTheme.patientTheme,

      themeMode: ThemeMode.light,
    );
  }
}
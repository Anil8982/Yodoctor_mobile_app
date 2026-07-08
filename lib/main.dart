import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import 'firebase_options.dart';
import 'core/providers/app_role_provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  await Hive.openBox('app_storage');


  runApp(
    const ProviderScope(
      child: YoDoctorApp(),
    ),
  );
}

class YoDoctorApp extends ConsumerWidget {
  const YoDoctorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(appRoleProvider);

    return MaterialApp.router(
      title: 'yoDoctor',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: _getThemeForRole(currentRole),
      themeMode: ThemeMode.light,
    );
  }

  ThemeData _getThemeForRole(AppRole role) {
    switch (role) {
      case AppRole.doctor:
        return AppTheme.doctorTheme;
      case AppRole.admin:
        return AppTheme.adminTheme;
      case AppRole.patient:
        return AppTheme.patientTheme;
    }
  }
}
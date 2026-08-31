import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/providers/storage_provider.dart';
import 'core/storage/hive_boxes.dart';
import 'core/storage/storage_service.dart';
import 'firebase_options.dart';
import 'core/providers/app_role_provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'modules/widgets/app_snack_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  await Hive.openBox(HiveBoxes.appStorage);
  await Hive.openBox(HiveBoxes.appConfig);

  final storage = StorageService();
  await storage.initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        storageProvider.overrideWithValue(storage),
      ],
      child: const YoDoctorApp(),
    ),
  );
}

class YoDoctorApp extends ConsumerWidget {
  const YoDoctorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(appRoleProvider);
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: appScaffoldMessengerKey,
      title: 'YoDoctor',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: _getThemeForRole(currentRole, Brightness.light),
      darkTheme: _getThemeForRole(currentRole, Brightness.dark),
      themeMode: ThemeMode.system,
    );
  }

  ThemeData _getThemeForRole(AppRole role, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    switch (role) {
      case AppRole.doctor:
        return isDark ? AppTheme.doctorDarkTheme : AppTheme.doctorTheme;
      case AppRole.admin:
        return isDark ? AppTheme.adminDarkTheme : AppTheme.adminTheme;
      case AppRole.patient:
        return isDark ? AppTheme.patientDarkTheme : AppTheme.patientTheme;
    }
  }
}
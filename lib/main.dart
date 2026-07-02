import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/routes/app_router.dart';

import 'core/theme/app_theme.dart' hide AppRole;
import 'core/providers/app_role_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
    // Reactively watch role changes safely from its dedicated file channel
    final currentRole = ref.watch(appRoleProvider);

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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/app_config/controllers/app_config_controller.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_status_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/subscription_status_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    AppLogger.info(
      'Splash: Screen initialized',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    // Setup fade + scale animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Start animation
    _animationController.forward();

    // Initialize auth
    Future.microtask(_initialize);
  }

  Future<void> _initialize() async {
    AppLogger.info(
      'Splash: Starting initialization...',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    await ref.read(appConfigProvider.notifier).checkAppConfig();

    // Wait for state to propagate
    await Future<void>.delayed(Duration.zero);

    final appConfigState = ref.read(appConfigProvider);

    AppLogger.info(
      'Splash: AppConfig status after check → ${appConfigState.status}',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    if (appConfigState.status != AppConfigStatus.ready) {
      AppLogger.warning(
        'Splash: App configuration is not ready. '
            'Status: ${appConfigState.status}',
        tag: LogTags.app,
        subTag: 'Splash',
      );
      // Router redirect handle करेल (maintenance/forceUpdate/error)
      _goToApp();
      return;
    }

    AppLogger.success(
      'Splash: App configuration is ready. Proceeding to main screen.',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    final storage = ref.read(storageProvider);
    final token = storage.getToken();
    final role = storage.getRole();

    AppLogger.info(
      'Splash: Auth check - token=${token != null ? 'present' : 'absent'}, role=$role',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    // Only doctors need verification flow trigger
    if (token != null && token.isNotEmpty && role == 'doctor') {
      AppLogger.info(
        'Splash: Triggering doctor verification flow',
        tag: LogTags.app,
        subTag: 'Splash',
      );

      // 1. First fetch verification status
      await ref.read(doctorStatusProvider.notifier).initialize();

      final doctorStateAfterInit = ref.read(doctorStatusProvider);
      AppLogger.info(
        'Splash: Doctor status after initialize → '
            'status=${doctorStateAfterInit.status}, '
            'isResolved=${doctorStateAfterInit.isResolved}',
        tag: LogTags.app,
        subTag: 'Splash',
      );

      // 2. Sequential Check: If approved, then check active subscription
      if (doctorStateAfterInit.status == 'APPROVED') {
        AppLogger.info(
          'Splash: Doctor is APPROVED, checking active subscription status',
          tag: LogTags.app,
          subTag: 'Splash',
        );
        await ref.read(subscriptionStatusProvider.notifier).checkActiveSubscription();

        final subStateAfterCheck = ref.read(subscriptionStatusProvider);
        AppLogger.info(
          'Splash: Subscription status after check → '
              'isResolved=${subStateAfterCheck.isResolved}, '
              'hasSubscription=${subStateAfterCheck.hasSubscription}',
          tag: LogTags.app,
          subTag: 'Splash',
        );
      }
    }

    _goToApp();
  }

  void _goToApp() {
    if (!mounted) {
      AppLogger.warning(
        'Splash: _goToApp() called but widget not mounted',
        tag: LogTags.app,
        subTag: 'Splash',
      );
      return;
    }

    AppLogger.info(
      'Splash: Initialization complete. Navigating to app...',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    final storage = ref.read(storageProvider);
    final token = storage.getToken();
    final role = storage.getRole();

    AppLogger.info(
      'Splash: Navigation params → token=${token != null ? 'YES' : 'NO'}, role=$role',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    // Unauthenticated → Landing
    if (token == null || token.isEmpty) {
      AppLogger.debug(
        'Splash: No token → Navigating to Landing',
        tag: LogTags.app,
        subTag: 'Splash',
      );
      context.go(AppRoutes.landing);
      AppLogger.success(
        'Splash: Navigation to Landing completed',
        tag: LogTags.app,
        subTag: 'Splash',
      );
      return;
    }

    AppLogger.debug(
      'Splash: Role-based navigation → $role',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    // Authenticated → Role-based navigation
    switch (role) {
      case 'patient':
        AppLogger.debug(
          'Splash: Patient → Navigating to Dashboard',
          tag: LogTags.app,
          subTag: 'Splash',
        );
        context.go(AppRoutes.dashboard);
        AppLogger.success(
          'Splash: Navigation to Patient Dashboard completed',
          tag: LogTags.app,
          subTag: 'Splash',
        );
        break;

      case 'admin':
        AppLogger.debug(
          'Splash: Admin → Navigating to Admin Dashboard',
          tag: LogTags.app,
          subTag: 'Splash',
        );
        context.go(AppRoutes.adminDashboard);
        AppLogger.success(
          'Splash: Navigation to Admin Dashboard completed',
          tag: LogTags.app,
          subTag: 'Splash',
        );
        break;

      case 'doctor':
        AppLogger.debug(
          'Splash: Doctor → Attempting Doctor Dashboard (router will redirect if needed)',
          tag: LogTags.app,
          subTag: 'Splash',
        );

        final doctorState = ref.read(doctorStatusProvider);
        final subState = ref.read(subscriptionStatusProvider);

        AppLogger.info(
          'Splash: Doctor navigation check → '
              'status=${doctorState.status}, '
              'isResolved=${doctorState.isResolved}, '
              'subResolved=${subState.isResolved}, '
              'hasSub=${subState.hasSubscription}',
          tag: LogTags.app,
          subTag: 'Splash',
        );

        context.go(AppRoutes.doctorDashboard);
        AppLogger.success(
          'Splash: Navigation to Doctor Dashboard completed',
          tag: LogTags.app,
          subTag: 'Splash',
        );
        break;

      default:
        AppLogger.warning(
          'Splash: Unknown role → Navigating to Landing',
          tag: LogTags.app,
          subTag: 'Splash',
        );
        context.go(AppRoutes.landing);
        AppLogger.success(
          'Splash: Navigation to Landing completed (default)',
          tag: LogTags.app,
          subTag: 'Splash',
        );
    }
  }

  @override
  void dispose() {
    AppLogger.info(
      'Splash: Screen disposed',
      tag: LogTags.app,
      subTag: 'Splash',
    );
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(scale: _scaleAnimation, child: child),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Logo
              SizedBox(
                width: screenWidth * 0.7,
                height: screenWidth * 0.7,
                child: Image.asset(
                  AppAssets.logo(context),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),

              // App Name
              Text(
                'YoDoctor',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              Text(
                'Your Health, Our Priority',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 48),

              // Loading indicator
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
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
    final storage = ref.read(storageProvider);
    final token = storage.getToken();
    final role = storage.getRole();

    AppLogger.info(
      'Splash: Auth check - token=${token != null ? 'present' : 'absent'}, role=$role',
      tag: LogTags.app,
      subTag: 'Splash',
    );

    // Only doctors need verification flow trigger
    // Patients and unauthenticated users rely on GoRouter redirect
    if (token != null && token.isNotEmpty && role == 'doctor') {
      AppLogger.info(
        'Splash: Triggering doctor verification',
        tag: LogTags.app,
        subTag: 'Splash',
      );

      // 1. First fetch verification status
      await ref.read(doctorStatusProvider.notifier).initialize();

      // 2. Sequential Check: If approved, then check active subscription
      final doctorState = ref.read(doctorStatusProvider);
      if (doctorState.status == 'APPROVED') {
        AppLogger.info(
          'Splash: Doctor is APPROVED, checking active subscription status',
          tag: LogTags.app,
          subTag: 'Splash',
        );
        await ref.read(subscriptionStatusProvider.notifier).checkActiveSubscription();
      }
    }

    // Navigation handled automatically by GoRouter redirect:
    // - No token → /landing
    // - Patient → /dashboard
    // - Doctor APPROVED → /doctor/dashboard
    // - Doctor PENDING/REJECTED → /waitingApproval
  }

  @override
  void dispose() {
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

import 'dart:math' as math;
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
    with TickerProviderStateMixin {
  // 🎨 Dedicated Medical Luxury Palette
  static const Color primaryBlue = Color(0xFF0284C7); // Rich Medical Cyan
  static const Color primaryTeal = Color(0xFF0D9488); // Deep Mint Green
  static const Color darkSlate = Color(0xFF0F172A); // Midnight Heading
  static const Color mutedSlate = Color(0xFF64748B); // Slate Caption
  static const Color surfacePure = Color(0xFFF8FAFC); // Clean Clinical White

  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  // Staggered Entrance Animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;
  late final Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();

    AppLogger.info('Splash: Initializing cinematic pipeline', tag: LogTags.app, subTag: 'Splash');

    // 1. Entrance Controller (Choreographed entrance in 1100ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.80, curve: Curves.easeOut),
      ),
    );

    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.60, 1.0, curve: Curves.easeOut),
      ),
    );

    // 2. Continuous Medical Pulse (Heartbeat wave radiating behind logo)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _entranceController.forward().then((_) {
      if (mounted) _pulseController.repeat();
    });

    Future.microtask(_initialize);
  }

  Future<void> _initialize() async {
    final startTime = DateTime.now();

    AppLogger.info('Splash: Starting initialization...', tag: LogTags.app, subTag: 'Splash');

    await ref.read(appConfigProvider.notifier).checkAppConfig();
    await Future<void>.delayed(Duration.zero);

    final appConfigState = ref.read(appConfigProvider);

    if (appConfigState.status != AppConfigStatus.ready) {
      _goToApp();
      return;
    }

    final storage = ref.read(storageProvider);
    final token = storage.getToken();
    final role = storage.getRole();

    if (token != null && token.isNotEmpty && role == 'doctor') {
      await ref.read(doctorStatusProvider.notifier).initialize();
      final doctorState = ref.read(doctorStatusProvider);

      if (doctorState.status == 'APPROVED') {
        await ref.read(subscriptionStatusProvider.notifier).checkActiveSubscription();
      }
    }

    // Ensure smooth entrance experience before transition (minimum 1.2s viewing window)
    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    if (elapsed < 1200) {
      await Future<void>.delayed(Duration(milliseconds: 1200 - elapsed));
    }

    _goToApp();
  }

  void _goToApp() {
    if (!mounted) return;

    final storage = ref.read(storageProvider);
    final token = storage.getToken();
    final role = storage.getRole();

    if (token == null || token.isEmpty) {
      context.go(AppRoutes.landing);
      return;
    }

    switch (role) {
      case 'patient':
        context.go(AppRoutes.dashboard);
        break;
      case 'admin':
        context.go(AppRoutes.adminDashboard);
        break;
      case 'doctor':
        context.go(AppRoutes.doctorDashboard);
        break;
      default:
        context.go(AppRoutes.landing);
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: surfacePure,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Dual Ambient Mesh Radiations (Top Right Cyan & Bottom Left Teal)
          Positioned(
            top: -size.width * 0.35,
            right: -size.width * 0.25,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x1F0284C7),
                    Color(0x000284C7),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.35,
            left: -size.width * 0.25,
            child: Container(
              width: size.width * 0.85,
              height: size.width * 0.85,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x1A0D9488),
                    Color(0x000D9488),
                  ],
                ),
              ),
            ),
          ),

          // 2. Central Core Architecture
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Heartbeat Pulse Wave Stack behind Logo
                SizedBox(
                  width: 170,
                  height: 170,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Continuous Radiating Pulse Rings
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final value = _pulseController.value;
                          final waveScale = 1.0 + (value * 0.42);
                          final waveOpacity = (1.0 - value).clamp(0.0, 1.0) * 0.35;

                          return Container(
                            width: 110 * waveScale,
                            height: 110 * waveScale,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryBlue.withValues(alpha: waveOpacity),
                                width: 2.5,
                              ),
                              gradient: RadialGradient(
                                colors: [
                                  primaryBlue.withValues(alpha: waveOpacity * 0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Glossy Glass Container for AppLogo
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Hero(
                            tag: 'AppLogo',
                            child: Container(
                              width: 108,
                              height: 108,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Color(0xFFF1F5F9),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryBlue.withValues(alpha: 0.18),
                                    blurRadius: 28,
                                    offset: const Offset(0, 12),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                  const BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 8,
                                    offset: Offset(-3, -3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(18),
                              child: Image.asset(
                                AppAssets.logoLightV,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Staggered Title & Tagline
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        const Text(
                          'YoDoctor',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: darkSlate,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Your health, connected.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: mutedSlate,
                            letterSpacing: 0.25,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Shimmering Status Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Smooth Pulsing Tiny Dot
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  final opacity = 0.4 +
                                      (0.6 * math.sin(_pulseController.value * math.pi));
                                  return Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryTeal.withValues(alpha: opacity),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Syncing secure portal...',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Trusted Network Footer
          Positioned(
            bottom: 24,
            child: FadeTransition(
              opacity: _footerFade,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    size: 14,
                    color: primaryTeal.withValues(alpha: 0.85),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Encrypted Healthcare Platform',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
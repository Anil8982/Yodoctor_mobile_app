import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/app_config/controllers/app_config_controller.dart';
import 'package:yodoctor/modules/auth/screens/landing/widgets/yo_role_btn.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 740;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // 1. Premium Glossy & Glassmorphic Curved Header
                      Container(
                        height: isCompact ? 180 : 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.0, 0.45, 1.0],
                            colors: [
                              colorScheme.secondary.blendWith(Colors.white, 0.15),
                              colorScheme.secondary.blendWith(colorScheme.primary.transparency(0.8)),
                              colorScheme.primary.transparency(0.8),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(56),
                            bottomRight: Radius.circular(56),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.28),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: colorScheme.secondary.withValues(alpha: 0.18),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(56),
                            bottomRight: Radius.circular(56),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // 🔮 Gloss Top Reflection Highlight Arc
                              Positioned(
                                top: -60,
                                left: -40,
                                child: Container(
                                  width: 220,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withValues(alpha: 0.28),
                                        Colors.white.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 🔮 Right Subtle Cyan/Mint Ambient Glow
                              Positioned(
                                top: 10,
                                right: -30,
                                child: Container(
                                  width: 170,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        colorScheme.primaryContainer.withValues(alpha: 0.25),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 🔮 Bottom-Left Accent Glow
                              Positioned(
                                bottom: -35,
                                left: 15,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withValues(alpha: 0.16),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 💎 Center Content with Glossy Logo Frame & Glass Pill
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: isCompact ? 12 : 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Glossy Halo Around App Logo
                                      Hero(
                                        tag: 'AppLogo',
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white.withValues(alpha: 0.85),
                                                Colors.white.withValues(alpha: 0.25),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.black.withValues(alpha: 0.18),
                                                blurRadius: 18,
                                                offset: const Offset(0, 7),
                                              ),
                                              BoxShadow(
                                                color: Colors.white.withValues(alpha: 0.35),
                                                blurRadius: 10,
                                                offset: const Offset(-2, -2),
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            width: isCompact ? 84 : 108,
                                            height: isCompact ? 84 : 108,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: Image.asset(
                                                AppAssets.logoLightV,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: isCompact ? 8 : 12),

                                      // Frosted Glass "Connected" Pill
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.18),
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(
                                              color: Colors.white.withValues(alpha: 0.38),
                                              width: 1.1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.black.withValues(alpha: 0.06),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withValues(alpha: 0.25),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.verified_rounded,
                                                  color: Colors.white,
                                                  size: isCompact ? 13 : 15,
                                                ),
                                              ),
                                              const SizedBox(width: 7),
                                              Text(
                                                'Your health, connected.',
                                                style: (isCompact
                                                    ? textTheme.labelMedium
                                                    : textTheme.bodyMedium)
                                                    ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.35,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black.withValues(alpha: 0.2),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 1),
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
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // 2. Main Title & Pill Section (Vertically Centered)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Healthcare simplified\n',
                                    style: (isCompact
                                        ? textTheme.titleLarge
                                        : textTheme.headlineMedium)
                                        ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colorScheme.onSurface,
                                      letterSpacing: 0.2,
                                      height: 1.15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'for everyone',
                                    style: (isCompact
                                        ? textTheme.titleLarge
                                        : textTheme.headlineMedium)
                                        ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colorScheme.primary,
                                      letterSpacing: 0.2,
                                      height: 1.15,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),

                            // Trust Badge Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.transparency(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colorScheme.secondary.transparency(0.18),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AppAssets.protectionIcon,
                                    height: 14,
                                    width: 14,
                                    color: colorScheme.secondary,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Secure & Certified Platform',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Choose your role to get started',
                            textAlign: TextAlign.center,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              fontSize: isCompact ? 12.5 : 14,
                            ),
                          ),
                          SizedBox(height: isCompact ? 10 : 12),

                          if (isCompact)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: YoRoleButton(
                                      isDoctor: true,
                                      isCompact: true,
                                      onTap: () {
                                        ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);
                                        context.push(AppRoutes.doctorLogin);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: YoRoleButton(
                                      isDoctor: false,
                                      isCompact: true,
                                      onTap: () {
                                        ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
                                        context.push(AppRoutes.patientLogin);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            YoRoleButton(
                              isDoctor: true,
                              onTap: () {
                                ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);
                                context.push(AppRoutes.doctorLogin);
                              },
                            ),
                            const SizedBox(height: 12),
                            YoRoleButton(
                              isDoctor: false,
                              onTap: () {
                                ref.read(appRoleProvider.notifier).setRole(AppRole.patient);
                                context.push(AppRoutes.patientLogin);
                              },
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: isCompact ? 10 : 16),

                      // 4. Feature Highlights Footer
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isCompact ? 8 : 14,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildFeatureItem(
                                  context,
                                  icon: Icons.verified_user_rounded,
                                  title: 'Secure & Private',
                                  subtitle: 'Your data is safe',
                                  iconColor: colorScheme.secondary,
                                  bgColor: colorScheme.secondary.transparency(0.08),
                                  isCompact: isCompact,
                                ),
                              ),
                              VerticalDivider(
                                color: colorScheme.outlineVariant.transparency(0.5),
                                thickness: 1,
                                indent: 4,
                                endIndent: 4,
                              ),
                              Expanded(
                                child: _buildFeatureItem(
                                  context,
                                  icon: Icons.access_time_filled_rounded,
                                  title: 'Quick Access',
                                  subtitle: 'Instant consultations',
                                  iconColor: colorScheme.primary,
                                  bgColor: colorScheme.primary.transparency(0.08),
                                  isCompact: isCompact,
                                ),
                              ),
                              VerticalDivider(
                                color: colorScheme.outlineVariant.transparency(0.5),
                                thickness: 1,
                                indent: 4,
                                endIndent: 4,
                              ),
                              Expanded(
                                child: _buildFeatureItem(
                                  context,
                                  icon: Icons.favorite_rounded,
                                  title: 'Trusted Care',
                                  subtitle: 'Certified doctors',
                                  iconColor: colorScheme.tertiary,
                                  bgColor: colorScheme.tertiary.transparency(0.08),
                                  isCompact: isCompact,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 5. Legal Links
                      _buildLegalLinks(context),

                      SizedBox(height: isCompact ? 8 : 14),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegalLinks(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appConfig = ref.watch(appConfigProvider).config;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'By continuing, you agree to our ',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.primary.transparency(0.5),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final url = appConfig?.legalAndSupport.privacyPolicyUrl ?? '';
                  AppLogger.info(
                    'Privacy Policy URL: $url',
                    tag: LogTags.app,
                    subTag: 'Landing',
                  );
                  if (url.isNotEmpty) {
                    context.push(
                      AppRoutes.webViewPage(
                        title: 'Privacy Policy',
                        url: url,
                      ),
                    );
                  }
                },
            ),
            TextSpan(
              text: ' and ',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            TextSpan(
              text: 'Terms of Service',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.primary.transparency(0.5),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final url = appConfig?.legalAndSupport.termsServiceUrl ?? '';
                  AppLogger.info(
                    'Terms of Service URL: $url',
                    tag: LogTags.app,
                    subTag: 'Landing',
                  );
                  if (url.isNotEmpty) {
                    context.push(
                      AppRoutes.webViewPage(
                        title: 'Terms of Service',
                        url: url,
                      ),
                    );
                  }
                },
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color iconColor,
        required Color bgColor,
        required bool isCompact,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              fontSize: 10.5,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.transparency(0.7),
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }
}
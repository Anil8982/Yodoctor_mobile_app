import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
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
      body: Container(
        color: colorScheme.surface,
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.secondary,
                                colorScheme.primary
                                    .blendWith(colorScheme.secondary, 0.5)
                                    .transparency(0.5),
                                colorScheme.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: -40,
                                bottom: 20,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.white.transparency(0.15),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -30,
                                right: -30,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.white.transparency(0.1),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 16),
                                    Hero(
                                      tag: 'AppLogo',
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          color: colorScheme.surfaceContainer,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.black.withValues(
                                                alpha: 0.12,
                                              ),
                                              blurRadius: 12,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            55,
                                          ),
                                          child: Image.asset(
                                            AppAssets.logoV(context),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.security_rounded,
                                          color: colorScheme.surfaceContainer,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Your health, connected.',
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: colorScheme.onPrimary,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.favorite_rounded,
                                          color: AppTheme.white.transparency(
                                            0.8,
                                          ),
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Healthcare simplified\n',
                                      style: textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'for everyone',
                                      style: textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: Image.asset(
                                  AppAssets.protectionIcon,
                                  height: 50,
                                  color: colorScheme.secondary.transparency(
                                    0.9,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Text(
                            'Choose your role to get started with your personalized health journey.',
                            textAlign: TextAlign.center,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Spacer(flex: 1),

                        YoRoleButton(
                          isDoctor: true,
                          onTap: () {
                            context.push(AppRoutes.doctorLogin);
                          },
                        ),
                        const SizedBox(height: 14),
                        YoRoleButton(
                          isDoctor: false,
                          onTap: () {
                            context.push(AppRoutes.patientLogin);
                          },
                        ),

                        const Spacer(flex: 1),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
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
                                    bgColor: colorScheme.secondary.transparency(
                                      0.08,
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: colorScheme.outlineVariant
                                      .transparency(0.6),
                                  thickness: 1,
                                  indent: 6,
                                  endIndent: 6,
                                ),
                                Expanded(
                                  child: _buildFeatureItem(
                                    context,
                                    icon: Icons.access_time_filled_rounded,
                                    title: 'Quick Access',
                                    subtitle: 'Healthcare at your fingertips',
                                    iconColor: colorScheme.primary,
                                    bgColor: colorScheme.primary.transparency(
                                      0.08,
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: colorScheme.outlineVariant
                                      .transparency(0.6),
                                  thickness: 1,
                                  indent: 6,
                                  endIndent: 6,
                                ),
                                Expanded(
                                  child: _buildFeatureItem(
                                    context,
                                    icon: Icons.favorite_rounded,
                                    title: 'Trusted Care',
                                    subtitle: 'Quality doctors you can trust',
                                    iconColor: colorScheme.tertiary,
                                    bgColor: colorScheme.tertiary.transparency(
                                      0.08,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Legal links section
                        _buildLegalLinks(context),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            subtitle,
            maxLines: 3,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.transparency(0.7),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
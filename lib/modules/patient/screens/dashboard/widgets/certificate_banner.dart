import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/l10n/app_localizations.dart';

class CertificateBanner extends StatelessWidget {
  const CertificateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    final String tagText =
        isHindi ? l10n.certificateLabel : 'Health Certificate';
    final String headlineText = isHindi
        ? l10n.serviceMedicalCertificateSubtitle
        : 'Get Your Digital\nHealth Certificate';
    final String buttonText =
        isHindi ? l10n.selectCertificateDoctor : 'Claim Now';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.88),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.16),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(
              alpha: isDark ? 0.35 : 0.22,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.doctorSelection),
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              // Ambient soft background circles
              Positioned(
                right: -30,
                bottom: -35,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.onPrimary.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                right: 70,
                top: -20,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.onPrimary.withValues(alpha: 0.05),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    // Left Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tagText,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary.withValues(
                                alpha: 0.85,
                              ),
                              fontWeight: FontWeight.w700,
                              fontSize: 11.5,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            headlineText,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 16.5,
                              letterSpacing: -0.4,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(99),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withValues(
                                    alpha: 0.12,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              buttonText,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Right Graphic Illustration
                    Container(
                      width: 82,
                      height: 94,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer
                                      .withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.verified_rounded,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 44,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: colorScheme.outlineVariant
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 28,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: colorScheme.outlineVariant
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

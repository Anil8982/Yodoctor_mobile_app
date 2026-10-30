import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/l10n/app_localizations.dart';

class FeaturedHomeCareCard extends StatelessWidget {
  const FeaturedHomeCareCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);
    final borderRadius = BorderRadius.circular(24);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(AppRoutes.homeServiceBooking);
        },
        borderRadius: borderRadius,
        splashColor: AppTheme.white.withValues(alpha: 0.15),
        child: Ink(
          height: 185,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E7D32),
                Color(0xFF00695C),
                Color(0xFF004D40),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00695C).withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: AppTheme.white.withValues(alpha: 0.20),
              width: 1.2,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Ambient glow circles
              Positioned(
                right: -30,
                bottom: -30,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.white.withValues(alpha: 0.08),
                  ),
                ),
              ),

              // 3D Illustration on right
              Positioned(
                right: -4,
                bottom: -4,
                width: 145,
                height: 145,
                child: Image.asset(
                  'assets/images/services/home_nursing_3d.webp',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),

              // Gradient scrim to ensure high text legibility
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.65, 1.0],
                      colors: [
                        const Color(0xFF2E7D32).withValues(alpha: 0.95),
                        const Color(0xFF00695C).withValues(alpha: 0.70),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Card Content
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge & Service Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 13,
                            color: AppTheme.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'DOORSTEP MEDICAL CARE',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 9.5,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title & Description
                    FractionallySizedBox(
                      widthFactor: 0.68,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n?.serviceHomeNursingCareTitle ??
                                'Home Nursing & Attendant Care',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16.5,
                              letterSpacing: -0.3,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n?.serviceHomeNursingCareSubtitle ??
                                'Qualified nurses for injections, dressings & elder care at home.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppTheme.white.withValues(alpha: 0.90),
                              fontSize: 11.5,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Button CTA
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n?.bookCareServiceDrawerItem ?? 'Book Care Now',
                            style: const TextStyle(
                              color: Color(0xFF004D40),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Color(0xFF004D40),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/screens/services/models/services_model.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class ServiceCard extends StatelessWidget {
  final MedicalService service;
  final VoidCallback? onQrTap;
  final bool isWide;

  const ServiceCard({
    super.key,
    required this.service,
    this.onQrTap,
    this.isWide = false,
  });

  bool get _isComingSoon =>
      service.type == MedicalServiceType.medicineDelivery ||
      service.title == 'Medicine Delivery' ||
      service.badgeText == 'SOON';

  void _handleTap(BuildContext context, AppLocalizations? l10n) {
    HapticFeedback.lightImpact();

    if (service.isQrScanner && onQrTap != null) {
      onQrTap!();
    } else if (_isComingSoon) {
      AppSnackBar.show(
        message: l10n?.medicineDeliveryComingSoon ??
            'Medicine delivery coming soon',
        type: AppSnackBarType.info,
      );
    } else if (service.route.isNotEmpty && service.route != '#') {
      context.push(service.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);
    final borderRadius = BorderRadius.circular(20);

    if (isWide) {
      return _buildWideCard(context, textTheme, l10n, borderRadius);
    }

    return _buildStandardCard(context, textTheme, l10n, borderRadius);
  }

  /// Standard Card with Stack & Large 3D Illustration at the Back
  Widget _buildStandardCard(
    BuildContext context,
    TextTheme textTheme,
    AppLocalizations? l10n,
    BorderRadius borderRadius,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleTap(context, l10n),
        borderRadius: borderRadius,
        splashColor: AppTheme.white.withValues(alpha: 0.18),
        highlightColor: AppTheme.white.withValues(alpha: 0.08),
        child: Ink(
          height: 158,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                service.baseColor,
                Color.lerp(service.baseColor, Colors.black, 0.14) ??
                    service.baseColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: service.baseColor.withValues(alpha: 0.28),
                blurRadius: 16,
                spreadRadius: -2,
                offset: const Offset(0, 6),
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
              // 1. Ambient Glow behind the illustration
              Positioned(
                right: -15,
                bottom: -15,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.white.withValues(alpha: 0.10),
                  ),
                ),
              ),

              // 2. Large 3D Illustration in Background Stack
              Positioned(
                right: -6,
                bottom: -6,
                width: 118,
                height: 118,
                child: Image.asset(
                  service.imagePath,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),

              // 3. Directional Gradient Scrim protecting text contrast
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.55, 1.0],
                      colors: [
                        service.baseColor.withValues(alpha: 0.90),
                        service.baseColor.withValues(alpha: 0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Content Layout with original text & styling
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar: Service Icon & Action Indicator / Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            service.icon,
                            color: AppTheme.white,
                            size: 20,
                          ),
                        ),
                        if (_isComingSoon)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              l10n?.comingSoonBadge ?? 'SOON',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 9.5,
                                letterSpacing: 0.5,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(6.5),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withValues(alpha: 0.20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: AppTheme.white,
                              size: 13,
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Bottom Text Area: Constrained to 68% width to prevent overlapping artwork
                    FractionallySizedBox(
                      widthFactor: 0.68,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            service.getLocalizedTitle(l10n),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              letterSpacing: -0.2,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            service.getLocalizedSubtitle(l10n),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppTheme.white.withValues(alpha: 0.88),
                              fontWeight: FontWeight.w400,
                              fontSize: 11.5,
                              letterSpacing: 0.05,
                              height: 1.25,
                            ),
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

  /// Wide Horizontal Card Layout with Stack & Large 3D Illustration at the Back
  Widget _buildWideCard(
    BuildContext context,
    TextTheme textTheme,
    AppLocalizations? l10n,
    BorderRadius borderRadius,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleTap(context, l10n),
        borderRadius: borderRadius,
        splashColor: AppTheme.white.withValues(alpha: 0.18),
        highlightColor: AppTheme.white.withValues(alpha: 0.08),
        child: Ink(
          height: 135,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                service.baseColor,
                Color.lerp(service.baseColor, Colors.black, 0.14) ??
                    service.baseColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: service.baseColor.withValues(alpha: 0.28),
                blurRadius: 16,
                spreadRadius: -2,
                offset: const Offset(0, 6),
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
              // 1. Ambient Glow behind illustration
              Positioned(
                right: -20,
                bottom: -20,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.white.withValues(alpha: 0.10),
                  ),
                ),
              ),

              // 2. Large 3D Illustration in Background Stack
              Positioned(
                right: -6,
                bottom: -6,
                width: 125,
                height: 125,
                child: Image.asset(
                  service.imagePath,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),

              // 3. Directional Gradient Scrim protecting text contrast
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.65, 1.0],
                      colors: [
                        service.baseColor.withValues(alpha: 0.95),
                        service.baseColor.withValues(alpha: 0.60),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Content Layout
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7.5),
                          decoration: BoxDecoration(
                            color: AppTheme.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            service.icon,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'OFFICIAL & VERIFIED',
                            style: TextStyle(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 9.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    FractionallySizedBox(
                      widthFactor: 0.68,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            service.getLocalizedTitle(l10n),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: -0.2,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            service.getLocalizedSubtitle(l10n),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppTheme.white.withValues(alpha: 0.88),
                              fontWeight: FontWeight.w400,
                              fontSize: 11.5,
                              letterSpacing: 0.05,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            service.getLocalizedAction(l10n),
                            style: TextStyle(
                              color: service.baseColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 11,
                            color: service.baseColor,
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

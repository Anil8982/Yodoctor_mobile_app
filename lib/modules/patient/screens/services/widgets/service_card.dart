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

  const ServiceCard({
    super.key,
    required this.service,
    this.onQrTap,
  });

  bool get _isComingSoon =>
      service.type == MedicalServiceType.medicineDelivery ||
          service.title == 'Medicine Delivery';

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
    } else if (service.route != '#') {
      context.push(service.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);
    final borderRadius = BorderRadius.circular(22);

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
          height: 165,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                service.baseColor,
                Color.lerp(service.baseColor, Colors.black, 0.12) ??
                    service.baseColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: service.baseColor.withValues(alpha: 0.28),
                blurRadius: 18,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
            ],
            // Subtle frosted border for premium depth
            border: Border.all(
              color: AppTheme.white.withValues(alpha: 0.18),
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
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.white.withValues(alpha: 0.10),
                  ),
                ),
              ),

              // 2. 3D Illustration
              Positioned(
                right: -6,
                bottom: -6,
                width: 122,
                height: 122,
                child: Image.asset(
                  service.imagePath,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
                ),
              ),

              // 3. Directional Gradient Scrim (Protects text contrast)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.55, 1.0],
                      colors: [
                        service.baseColor.withValues(alpha: 0.88),
                        service.baseColor.withValues(alpha: 0.40),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Content Layout
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar: Service Icon & Action Indicator / Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.5),
                          decoration: BoxDecoration(
                            color: AppTheme.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            service.icon,
                            color: AppTheme.white,
                            size: 22,
                          ),
                        ),
                        if (_isComingSoon)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'SOON',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 9.5,
                                letterSpacing: 0.6,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(7.5),
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

                    // Bottom Text Area: Constrained to 65% width to prevent overlapping artwork
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
                              color: AppTheme.white.withValues(alpha: 0.85),
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
}
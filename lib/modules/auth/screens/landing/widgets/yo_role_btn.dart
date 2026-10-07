import 'package:flutter/material.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class YoRoleButton extends StatelessWidget {
  final bool isDoctor;
  final VoidCallback onTap;
  final bool isCompact;

  const YoRoleButton({
    super.key,
    required this.isDoctor,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final Color buttonColor = isDoctor
        ? AppTheme.doctorColor
        : AppTheme.patientColor;

    final title = isDoctor ? 'I am a Doctor' : 'I am a Patient';
    final subtitle = isDoctor
        ? 'Manage patients & schedules'
        : 'Book appointments & track health';
    final imagePath = isDoctor ? AppAssets.doctorIcon : AppAssets.patientIcon;

    // 🎯 Compact Screen (Side-by-Side Horizontal Buttons)
    if (isCompact) {
      return Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: AppTheme.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: colorScheme.onPrimary.withValues(alpha: 0.15),
            highlightColor: AppTheme.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        color: buttonColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.75),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 🎯 Regular Screen (Exact Original Design)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: AppTheme.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: colorScheme.onPrimary.withValues(alpha: 0.15),
            highlightColor: AppTheme.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                height: 78,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          imagePath,
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                          color: buttonColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            subtitle,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimary.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_outlined,
                        color: colorScheme.onPrimary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
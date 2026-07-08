import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/theme/app_colors.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class YoRoleButton extends StatelessWidget {
  final bool isDoctor;
  final VoidCallback onTap;

  const YoRoleButton({super.key, required this.isDoctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final gradient = isDoctor
        ? AppTheme.doctorGradient
        : AppTheme.patientGradient;
    final title = isDoctor ? 'I am a Doctor' : 'I am a Patient';
    final subtitle = isDoctor
        ? 'Manage patients & schedules'
        : 'Book appointments & track health';
    final imagePath = isDoctor ? AppAssets.doctorIcon : AppAssets.patientIcon;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.transparency(0.25),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: colorScheme.onPrimary.transparency(0.15),
            highlightColor: Colors.transparent,
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
                        color: colorScheme.onPrimary.transparency(1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          imagePath,
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                          color: isDoctor
                              ? AppColors.yoBlue
                              : AppColors.yoGreen,
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
                              color: colorScheme.onPrimary.transparency(0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.transparency(0.2),
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

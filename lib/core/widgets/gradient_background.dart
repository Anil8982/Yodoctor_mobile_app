import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/app_radius.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius,
    this.colors,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = colors ?? AppTheme.patientGradient.colors;
    final AlignmentGeometry begin = AppTheme.patientGradient.begin;
    final AlignmentGeometry end = AppTheme.patientGradient.end;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: gradientColors,
        ),
        borderRadius: borderRadius ?? AppRadius.card,
      ),
      child: child,
    );
  }
}

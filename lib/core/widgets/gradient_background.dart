import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final List<Color> gradientColors = colors ?? [
      colorScheme.primary,
      colorScheme.secondary,
    ];

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: borderRadius ?? AppRadius.card,
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable shimmer wrapper that automatically uses theme-aware colors
/// from Material ColorScheme. Works seamlessly with light/dark themes.
class AppShimmer extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const AppShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Use surface colors for a subtle, theme-aware shimmer effect
    final baseColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);
    final highlightColor = colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: duration,
      child: child,
    );
  }
}

/// A skeleton box placeholder for shimmer loading states.
/// Automatically uses theme-aware colors.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// A skeleton circle avatar placeholder for shimmer loading states.
/// Automatically uses theme-aware colors.
class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// A skeleton chip placeholder for shimmer loading states.
/// Automatically uses theme-aware colors.
class ShimmerChip extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;

  const ShimmerChip({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height ?? 28,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: borderRadius,
      ),
    );
  }
}


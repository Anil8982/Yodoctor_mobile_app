import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class StepCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const StepCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(22),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.transparency(0.05),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
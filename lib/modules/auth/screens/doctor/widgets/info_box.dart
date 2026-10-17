import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String text;
  final IconData icon;

  const InfoBox({
    super.key,
    required this.text,
    this.icon = Icons.verified_user_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.transparency(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.transparency(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
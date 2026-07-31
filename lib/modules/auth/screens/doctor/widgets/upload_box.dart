import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String field;
  final String? uploadedFile;
  final VoidCallback onTap;

  const UploadBox({
    super.key,
    required this.icon,
    required this.label,
    required this.field,
    this.uploadedFile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDone = uploadedFile != null && uploadedFile!.isNotEmpty;

    final activeColor = isDone
        ? (colorScheme.tertiary != Colors.transparent
        ? colorScheme.tertiary
        : Colors.green)
        : colorScheme.primary;

    final bgColor = isDone
        ? activeColor.transparency(0.08)
        : colorScheme.primaryContainer.transparency(0.35);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone
                ? activeColor
                : colorScheme.outlineVariant.transparency(0.5),
            width: isDone ? 1.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeColor.transparency(0.12),
              ),
              child: Icon(
                isDone ? Icons.check_rounded : icon,
                color: activeColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDone ? activeColor : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDone ? uploadedFile! : 'Tap to upload',
                    style: textTheme.bodySmall?.copyWith(
                      color: isDone
                          ? activeColor
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isDone ? Icons.check_circle_rounded : Icons.upload_rounded,
              color: isDone ? activeColor : colorScheme.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
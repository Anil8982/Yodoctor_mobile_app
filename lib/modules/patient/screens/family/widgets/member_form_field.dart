import 'package:flutter/material.dart';

class MemberFormField extends StatelessWidget {
  const MemberFormField({
    super.key,
    required this.label,
    required this.child,
    this.icon,
    this.requiredField = true,
    this.helperText,
  });

  final String label;
  final Widget child;
  final IconData? icon;
  final bool requiredField;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (requiredField)
                Text(
                  ' *',
                  style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        Theme(
          data: theme.copyWith(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
          ),
          child: child,
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              helperText!,
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
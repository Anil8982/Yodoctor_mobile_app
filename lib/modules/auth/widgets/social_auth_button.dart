import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const SocialAuthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.height = 48,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.8),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
            else
              icon,
            const SizedBox(width: 12),
            Text(
              isLoading ? 'Connecting...' : label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isLoading ? colorScheme.outline : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

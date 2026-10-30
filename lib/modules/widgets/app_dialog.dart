import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final dynamic content; // Accepts String or Widget
  final IconData? icon;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool showCancel;
  final Color? customAccentColor;
  final List<Widget>? extraActions;
  final bool barrierDismissible;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    required this.onConfirm,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onCancel,
    this.isDestructive = false,
    this.showCancel = true,
    this.customAccentColor,
    this.extraActions,
    this.barrierDismissible = false,
  });

  // Easy static helper to show the dialog anywhere
  static Future<void> show({
    required BuildContext context,
    required String title,
    required dynamic content,
    IconData? icon,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool showCancel = true,
    Color? customAccentColor,
    List<Widget>? extraActions,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: AppTheme.black.withValues(alpha: 0.6),
      builder: (context) => AppDialog(
        title: title,
        content: content,
        icon: icon,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
        showCancel: showCancel,
        customAccentColor: customAccentColor,
        extraActions: extraActions,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final Color accentColor =
        customAccentColor ??
        (isDestructive ? colorScheme.error : colorScheme.primary);

    return Dialog(
      backgroundColor: AppTheme.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface.withValues(alpha: 0.95),
                    colorScheme.surface.withValues(alpha: 0.88),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Decorative top accent line
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withValues(alpha: 0.8),
                            accentColor.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Header Row (Icon + Title)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(icon, color: accentColor, size: 24),
                          ),
                          const SizedBox(width: 14),
                        ],
                        Expanded(
                          child: Text(
                            title,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Subtle divider
                    Container(
                      height: 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),

                    const SizedBox(height: 16),

                    if (content is Widget)
                      content
                    else
                      Text(
                        content.toString(),
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Action Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...?extraActions,
                        if (showCancel) ...[
                          Flexible(
                            child: TextButton(
                              onPressed:
                                  onCancel ?? () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                cancelLabel,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Flexible(
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onConfirm();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: isDestructive
                                  ? colorScheme.onError
                                  : colorScheme.onPrimary,
                              elevation: 2,
                              shadowColor: accentColor.withValues(alpha: 0.3),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              confirmLabel,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
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

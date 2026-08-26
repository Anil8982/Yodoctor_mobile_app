import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

enum AppSnackBarType { success, error, info, warning, loading }

class AppSnackBar {
  AppSnackBar._();

  static String? _lastKey;
  static DateTime? _lastShownTime;

  static void show({
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    bool copyable = false,
    bool dismissible = true,
    bool haptic = true,
    bool replaceCurrent = true,
    Widget? leading,
    Duration? duration,
    Color? customAccentColor,
    IconData? customIcon,
    double maxAdaptiveWidth = 420.0,
    // double bottomMargin = 24,
  }) {
    // 1. Throttle Duplicates
    final key = "$type:$message";
    final now = DateTime.now();
    if (_lastKey == key &&
        _lastShownTime != null &&
        now.difference(_lastShownTime!) < const Duration(milliseconds: 1200)) {
      return;
    }
    _lastKey = key;
    _lastShownTime = now;

    final context =
        appNavigatorKey.currentContext ??
        appScaffoldMessengerKey.currentContext;

    final isDarkMode = context != null
        ? Theme.of(context).brightness == Brightness.dark
        : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;

    final bottomSafeArea = context != null
        ? MediaQuery.of(context).padding.bottom
        : 0.0;

    // 2. Haptic
    if (haptic) {
      switch (type) {
        case AppSnackBarType.success:
          HapticFeedback.lightImpact();
          break;
        case AppSnackBarType.error:
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.click);
          break;
        case AppSnackBarType.warning:
          HapticFeedback.mediumImpact();
          break;
        case AppSnackBarType.info:
        case AppSnackBarType.loading:
          HapticFeedback.selectionClick();
          break;
      }
    }

    // 3. Color & Styles
    Color accentColor;
    Color textColor;
    Color cardBgColor;
    IconData iconData;
    Duration snackDuration = duration ?? const Duration(seconds: 3);

    switch (type) {
      case AppSnackBarType.success:
        accentColor = customAccentColor ?? const Color(0xFF10B981);
        iconData = customIcon ?? Icons.check_circle_rounded;
        textColor = isDarkMode
            ? const Color(0xFFA7F3D0)
            : const Color(0xFF065F46);
        cardBgColor = isDarkMode ? const Color(0xFF064E3B) : AppTheme.white;
        break;

      case AppSnackBarType.error:
        accentColor = customAccentColor ?? const Color(0xFFEF4444);
        iconData = customIcon ?? Icons.error_rounded;
        snackDuration = duration ?? const Duration(seconds: 4);
        textColor = isDarkMode
            ? const Color(0xFFFECACA)
            : const Color(0xFF991B1B);
        cardBgColor = isDarkMode ? const Color(0xFF7F1D1D) : AppTheme.white;
        break;

      case AppSnackBarType.warning:
        accentColor = customAccentColor ?? const Color(0xFFF59E0B);
        iconData = customIcon ?? Icons.warning_rounded;
        textColor = isDarkMode
            ? const Color(0xFFFDE68A)
            : const Color(0xFF92400E);
        cardBgColor = isDarkMode ? const Color(0xFF78350F) : AppTheme.white;
        break;

      case AppSnackBarType.loading:
        accentColor = customAccentColor ?? const Color(0xFF6366F1);
        iconData = Icons.hourglass_empty_rounded;
        snackDuration = duration ?? const Duration(hours: 1);
        textColor = isDarkMode ? AppTheme.white : const Color(0xFF0F172A);
        cardBgColor = isDarkMode ? const Color(0xFF1E293B) : AppTheme.white;
        break;

      case AppSnackBarType.info:
        accentColor = customAccentColor ?? const Color(0xFF3B82F6);
        iconData = customIcon ?? Icons.info_rounded;
        textColor = isDarkMode
            ? const Color(0xFFBFDBFE)
            : const Color(0xFF1E40AF);
        cardBgColor = isDarkMode ? const Color(0xFF1E3A8A) : AppTheme.white;
        break;
    }

    final messengerState = appScaffoldMessengerKey.currentState;
    if (messengerState == null) return;

    if (replaceCurrent) {
      messengerState.hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
    }

    messengerState.showSnackBar(
      SnackBar(
        duration: snackDuration,
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        backgroundColor: cardBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: accentColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomSafeArea),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        content: Row(
          children: [
            // Colored Accent Indicator Bar
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),

            // Icon with Background
            if (type == AppSnackBarType.loading)
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: accentColor,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: accentColor, size: 20),
              ),

            const SizedBox(width: 12),

            // Message
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ),

            // Copy Button
            if (copyable) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message));
                  AppSnackBar.hide();
                  AppSnackBar.show(
                    message: "Copied to clipboard",
                    type: AppSnackBarType.success,
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.copy_rounded,
                    color: textColor.withValues(alpha: 0.5),
                    size: 16,
                  ),
                ),
              ),
            ],

            // Action Button
            if (actionLabel != null && type != AppSnackBarType.loading) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  if (onAction != null) onAction();
                  AppSnackBar.hide();
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],

            // Close Icon
            if (dismissible && type != AppSnackBarType.loading) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: () => AppSnackBar.hide(),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.close_rounded,
                    color: textColor.withValues(alpha: 0.4),
                    size: 18,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static void hide() {
    appScaffoldMessengerKey.currentState?.hideCurrentSnackBar(
      reason: SnackBarClosedReason.hide,
    );
  }
}

/// ============================================
/// 📦 EXTENSIONS FOR EASY USAGE
/// ============================================

extension AppSnackBarExtension on BuildContext {
  void showSnackBar({
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    bool copyable = false,
    bool dismissible = true,
    bool haptic = true,
    bool replaceCurrent = true,
    Widget? leading,
    Duration? duration,
    Color? customAccentColor,
    IconData? customIcon,
    // double maxAdaptiveWidth = 420.0,
  }) {
    AppSnackBar.show(
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      copyable: copyable,
      dismissible: dismissible,
      haptic: haptic,
      replaceCurrent: replaceCurrent,
      leading: leading,
      duration: duration,
      customAccentColor: customAccentColor,
      customIcon: customIcon,
      // maxAdaptiveWidth: maxAdaptiveWidth,
    );
  }

  void showSuccessSnackBar(String message) {
    showSnackBar(message: message, type: AppSnackBarType.success);
  }

  void showErrorSnackBar(String message) {
    showSnackBar(message: message, type: AppSnackBarType.error);
  }

  void showWarningSnackBar(String message) {
    showSnackBar(message: message, type: AppSnackBarType.warning);
  }

  void showInfoSnackBar(String message) {
    showSnackBar(message: message, type: AppSnackBarType.info);
  }

  void showLoadingSnackBar(String message) {
    showSnackBar(
      message: message,
      type: AppSnackBarType.loading,
      dismissible: false,
    );
  }

  void hideCurrentSnackBar() {
    AppSnackBar.hide();
  }
}

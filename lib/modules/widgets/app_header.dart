import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';


class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Primary title text.
  final String? title;

  /// Custom Title Widget (overrides [title] if provided).
  final Widget? titleWidget;

  /// Optional custom TextStyle for the title.
  final TextStyle? titleStyle;

  /// Optional subtitle text displayed below the title.
  final String? subtitle;

  /// Optional custom leading widget to override the standard back button.
  final Widget? leading;

  /// Width allocated for [leading] widget.
  final double? leadingWidth;

  /// Whether to reserve space on the left when leading/back button is hidden.
  final bool reserveLeadingSpace;

  /// Controls whether to display the back button when navigation history exists.
  final bool showBackButton;

  /// Optional custom callback to override the back button behavior.
  final VoidCallback? onBackPressed;

  /// Route path to navigate to when [context.canPop()] returns false.
  final String? fallbackRoute;

  /// Optional ImageProvider for direct leading avatar usage.
  final ImageProvider? avatarImage;

  /// Optional Network Image URL for direct leading avatar usage.
  final String? avatarUrl;

  /// Radius for the built-in avatar when using [avatarImage] or [avatarUrl].
  final double avatarRadius;

  /// List of trailing action widgets displayed on the right side.
  final List<Widget>? actions;

  /// Flexible bottom widget implementing [PreferredSizeWidget].
  final PreferredSizeWidget? bottom;

  /// Center title alignment. If null, follows platform defaults.
  final bool? centerTitle;

  /// Elevation of the app header. M3 default is 0.0.
  final double elevation;

  /// Scrolled under elevation for M3 dynamic elevation on scroll.
  final double? scrolledUnderElevation;

  /// Background color of the header. Defaults to [ColorScheme.primary].
  final Color? backgroundColor;

  /// Explicit color override for text and icons (defaults to [ColorScheme.onPrimary]).
  final Color? foregroundColor;

  /// Status bar configuration (icons brightness, status bar color).
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Standard toolbar height override. Defaults to [kToolbarHeight] (56.0).
  final double toolbarHeight;

  /// Extra height added directly to the toolbar content region.
  final double extraHeight;

  const AppHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.subtitle,
    this.leading,
    this.leadingWidth,
    this.reserveLeadingSpace = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.fallbackRoute,
    this.avatarImage,
    this.avatarUrl,
    this.avatarRadius = 18.0,
    this.actions,
    this.bottom,
    this.centerTitle,
    this.elevation = 0.0,
    this.scrolledUnderElevation,
    this.backgroundColor,
    this.foregroundColor,
    this.systemOverlayStyle,
    this.toolbarHeight = kToolbarHeight,
    this.extraHeight = 0.0,
  }) : assert(
  title != null || titleWidget != null,
  'Either title or titleWidget must be provided.',
  );

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(toolbarHeight + extraHeight + bottomHeight);
  }

  /// Navigation logic with custom callback, canPop, custom fallbackRoute, and default '/' fallback.
  void _handleBackNavigation(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
      return;
    }

    if (context.canPop()) {
      context.pop();
    } else if (fallbackRoute != null && fallbackRoute!.isNotEmpty) {
      context.go(fallbackRoute!);
    } else {
      context.go('/');
    }
  }

  Widget? _buildAvatarWidget() {
    if (avatarImage != null) {
      return CircleAvatar(
        radius: avatarRadius,
        backgroundImage: avatarImage,
      );
    }

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: avatarRadius,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    return null;
  }

  Widget? _buildLeading(BuildContext context, Color fgColor) {
    if (leading != null) return leading;

    final avatarWidget = _buildAvatarWidget();
    if (avatarWidget != null) return avatarWidget;

    final canPop = context.canPop();

    if (showBackButton && (canPop || onBackPressed != null || fallbackRoute != null)) {
      return IconButton(
        icon: Icon(Icons.arrow_back, color: fgColor),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => _handleBackNavigation(context),
      );
    }

    return null;
  }

  Widget _buildTitleSection(BuildContext context, Color fgColor) {
    if (titleWidget != null) return titleWidget!;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final defaultTitleStyle = titleStyle ??
        textTheme.titleLarge?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.bold,
        );

    final titleText = Text(
      title!,
      style: defaultTitleStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    if (subtitle != null && subtitle!.trim().isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: centerTitle == true
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          titleText,
          const SizedBox(height: 2.0),
          Text(
            subtitle!,
            style: textTheme.bodySmall?.copyWith(
              color: fgColor.withValues(alpha: 0.8),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      );
    }

    return titleText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Default background is Primary, and Foreground is onPrimary
    final effectiveBgColor = backgroundColor ?? colorScheme.primary;
    final effectiveFgColor = foregroundColor ?? colorScheme.onPrimary;

    final leadingWidget = _buildLeading(context, effectiveFgColor);

    final double effectiveTitleSpacing = (leadingWidget == null && !reserveLeadingSpace)
        ? 16.0
        : (leadingWidget == null ? NavigationToolbar.kMiddleSpacing : 0.0);

    return AppBar(
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      leadingWidth: leadingWidth,
      title: _buildTitleSection(context, effectiveFgColor),
      centerTitle: centerTitle,
      actions: actions,
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation ?? 3.0,
      backgroundColor: effectiveBgColor,
      foregroundColor: effectiveFgColor,
      iconTheme: IconThemeData(color: effectiveFgColor),
      actionsIconTheme: IconThemeData(color: effectiveFgColor),
      systemOverlayStyle: systemOverlayStyle ??
          (ThemeData.estimateBrightnessForColor(effectiveBgColor) == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark),
      toolbarHeight: toolbarHeight + extraHeight,
      titleSpacing: effectiveTitleSpacing,
    );
  }
}
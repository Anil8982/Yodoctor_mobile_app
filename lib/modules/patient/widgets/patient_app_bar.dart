import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import '../controllers/profile_controller.dart';

/// Reusable Header Row content for Patient AppBars.
class PatientHeaderContent extends ConsumerWidget {
  const PatientHeaderContent({
    super.key,
    this.titleText,
    this.subtitleText,
    this.isDashboard = false,
    this.onNotificationTap,
    this.actions,
    this.showBackButton,
    this.onBackPressed,
    this.showNotificationBell,
  });

  final String? titleText;
  final String? subtitleText;
  final bool isDashboard;
  final VoidCallback? onNotificationTap;
  final List<Widget>? actions;
  final bool? showBackButton;
  final VoidCallback? onBackPressed;
  final bool? showNotificationBell;

  static String getTimeGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final locale = Localizations.localeOf(context).languageCode;
    if (hour < 12) {
      if (locale == 'mr' || locale == 'hi') return 'शुभ प्रभात';
      return 'Good morning';
    } else if (hour < 17) {
      if (locale == 'mr' || locale == 'hi') return 'शुभ दुपार';
      return 'Good afternoon';
    } else {
      if (locale == 'mr') return 'शुभ संध्याकाळ';
      if (locale == 'hi') return 'शुभ संध्या';
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.user;
    final String rawName = user?.fullName.trim() ?? '';
    final String firstName =
        rawName.isNotEmpty ? rawName.split(' ').first : 'Patient';

    final bool shouldShowBack = showBackButton ?? Navigator.canPop(context);
    // Notification bell is ONLY shown on root navigation tabs (when back button is not showing),
    // unless explicitly overridden via showNotificationBell.
    final bool shouldShowNotification = showNotificationBell ?? !shouldShowBack;

    final bool isDashboardMode = (isDashboard ||
            titleText == null ||
            titleText == 'Dashboard' ||
            titleText == 'डॅशबोर्ड') &&
        !shouldShowBack;

    final String greeting = getTimeGreeting(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Back button (if screen is pushed in navigation or explicitly requested)
        if (shouldShowBack) ...[
          _buildBackActionButton(context, colorScheme, onBackPressed),
          const SizedBox(width: 12),
        ],

        // 2. Main Title Area
        if (isDashboardMode) ...[
          _buildProfileAvatar(context, ref, colorScheme),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  firstName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 21,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ] else ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleText ?? 'YoDoctor',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 21,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitleText != null && subtitleText!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitleText!,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],

        // 3. Custom Actions if any
        if (actions != null) ...[
          ...actions!,
          const SizedBox(width: 8),
        ],

        // 4. Notification Bell Icon (only on root nav pages)
        if (shouldShowNotification)
          _buildNotificationButton(context, colorScheme, onNotificationTap),
      ],
    );
  }

  Widget _buildBackActionButton(
    BuildContext context,
    ColorScheme colorScheme,
    VoidCallback? onBackPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBackPressed ?? () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    final imageState = ref.watch(profileImageController);

    return InkWell(
      onTap: () => context.go(AppRoutes.profile),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1.8,
          ),
        ),
        child: CircleAvatar(
          radius: 21,
          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
          child: ClipOval(
            child: imageState.when(
              data: (imageUrl) {
                if (imageUrl != null && imageUrl.isNotEmpty) {
                  return Image.network(
                    imageUrl,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultProfileIcon(colorScheme),
                  );
                }
                return _buildDefaultProfileIcon(colorScheme);
              },
              loading: () => SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
              error: (_, _) => _buildDefaultProfileIcon(colorScheme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultProfileIcon(ColorScheme colorScheme) {
    return Icon(Icons.person_rounded, color: colorScheme.primary, size: 24);
  }

  Widget _buildNotificationButton(
    BuildContext context,
    ColorScheme colorScheme,
    VoidCallback? onNotificationTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onNotificationTap ?? () => context.push(AppRoutes.notifications),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: colorScheme.onSurface,
                size: 22,
              ),
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Standard PreferredSizeWidget AppBar for all patient screens.
class PatientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PatientAppBar({
    super.key,
    this.titleText,
    this.subtitleText,
    this.actions,
    this.onNotificationTap,
    this.isDashboard = false,
    this.showBackButton,
    this.onBackPressed,
    this.showNotificationBell,
    this.bottom,
    this.elevation = 1.5,
    this.scrolledUnderElevation = 4.0,
    this.showBottomDivider = true,
  });

  final String? titleText;
  final String? subtitleText;
  final List<Widget>? actions;
  final VoidCallback? onNotificationTap;
  final bool isDashboard;
  final bool? showBackButton;
  final VoidCallback? onBackPressed;
  final bool? showNotificationBell;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final double scrolledUnderElevation;
  final bool showBottomDivider;

  @override
  Size get preferredSize =>
      Size.fromHeight(74.0 + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      toolbarHeight: 74.0,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.6)
          : colorScheme.shadow.withValues(alpha: 0.08),
      shape: showBottomDivider
          ? Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant
                    .withValues(alpha: isDark ? 0.25 : 0.35),
                width: 0.8,
              ),
            )
          : null,
      surfaceTintColor: Colors.transparent,
      backgroundColor: theme.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      titleSpacing: 16,
      title: PatientHeaderContent(
        titleText: titleText,
        subtitleText: subtitleText,
        isDashboard: isDashboard,
        onNotificationTap: onNotificationTap,
        actions: actions,
        showBackButton: showBackButton,
        onBackPressed: onBackPressed,
        showNotificationBell: showNotificationBell,
      ),
      bottom: bottom,
    );
  }
}

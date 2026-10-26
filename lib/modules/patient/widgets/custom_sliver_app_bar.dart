import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import 'package:yodoctor/core/routes/app_routes.dart';

class CustomSliverAppBar extends ConsumerStatefulWidget {
  const CustomSliverAppBar({
    super.key,
    this.expandedHeight = defaultExpandedHeight,
    required this.background,
    this.titleText,
    this.onNotificationTap,
    this.actions,
  });

  static const double defaultExpandedHeight = 125.0;

  final double expandedHeight;
  final Widget background;
  final String? titleText;
  final VoidCallback? onNotificationTap;
  final List<Widget>? actions;

  @override
  ConsumerState<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends ConsumerState<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final maxScrollExtent = widget.expandedHeight - kToolbarHeight;

    return SliverLayoutBuilder(
      builder: (BuildContext context, SliverConstraints constraints) {
        final double expandRatio = maxScrollExtent > 0
            ? (constraints.scrollOffset / maxScrollExtent).clamp(0.0, 1.0)
            : 0.0;

        // 70% close (0.7) te 100% close (1.0) paryant smooth fade-in
        final double titleOpacity = ((expandRatio - 0.7) / 0.3).clamp(0.0, 1.0);
        final bool showTitle = titleOpacity > 0.0;

        return SliverAppBar(
          expandedHeight: widget.expandedHeight,
          pinned: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          stretch: true,
          backgroundColor: colorScheme.surface.withValues(alpha: 0),
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleSpacing: 16,
          title: Row(
            children: [
              // 1. Drawer / Back Button
              _buildActionButton(
                icon: Icons.notes_rounded,
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                colorScheme: colorScheme,
              ),

              if (widget.titleText != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Opacity(
                    opacity: titleOpacity,
                    child: showTitle
                        ? Text(
                            widget.titleText!,
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ] else ...[
                const Spacer(),
              ],

              if (titleOpacity < 0.5 || widget.titleText == null)
                const Spacer(),

              if (widget.actions != null) ...[
                ...widget.actions!,
                const SizedBox(width: 8),
              ],

              // 2. Notification Button (old position preserved)
              _buildActionButton(
                icon: Icons.notifications_outlined,
                colorScheme: colorScheme,
                onTap:
                    widget.onNotificationTap ??
                    () {
                      context.push(AppRoutes.notifications);
                    },
              ),
              const SizedBox(width: 12),

              // 3. Global Profile Avatar with actual image & fallback icon
              _buildProfileAvatar(context, colorScheme),
            ],
          ),
          flexibleSpace: Container(
            color: colorScheme.primary,
            child: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: widget.background,
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: colorScheme.onPrimary, size: 24),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, ColorScheme colorScheme) {
    final imageState = ref.watch(profileImageController);

    return InkWell(
      onTap: () => context.push(AppRoutes.profile),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.3),
          ),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.2),
          child: ClipOval(
            child: imageState.when(
              data: (imageUrl) {
                if (imageUrl != null && imageUrl.isNotEmpty) {
                  return Image.network(
                    imageUrl,
                    width: 36,
                    height: 36,
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
                  color: colorScheme.onPrimary,
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
    return Icon(Icons.person_rounded, color: colorScheme.onPrimary, size: 20);
  }
}

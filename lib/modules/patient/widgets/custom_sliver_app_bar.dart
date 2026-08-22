import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({
    super.key,
    required this.expandedHeight,
    required this.background,
    this.titleText,
    this.onNotificationTap,
  });

  final double expandedHeight;
  final Widget background;
  final String? titleText;
  final VoidCallback? onNotificationTap;

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
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

              if (titleOpacity < 0.5 || widget.titleText == null) const Spacer(),

              // 2. Notification Button
              _buildActionButton(
                icon: Icons.notifications_outlined,
                colorScheme: colorScheme,
                onTap: widget.onNotificationTap ??
                        () {
                      context.push(AppRoutes.notifications);
                    },
              ),
              const SizedBox(width: 12),

              // 3. Global Profile Avatar
              _buildProfileAvatar(context, colorScheme),
            ],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppTheme.patientGradient),
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
          child: Icon(
            Icons.person_rounded,
            color: colorScheme.onPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
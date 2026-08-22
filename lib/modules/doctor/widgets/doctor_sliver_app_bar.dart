import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';

import '../../../core/theme/app_theme.dart';

class DoctorSliverAppBar extends StatefulWidget {
  const DoctorSliverAppBar({
    super.key,
    required this.expandedHeight,
    required this.background,
    this.titleText,
    this.onProfileTap,
    this.onNotificationTap,
    this.isNavBar = true,
    this.extraActionIcon,
    this.onExtraActionTap,
  });

  final double expandedHeight;
  final Widget background;
  final String? titleText;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final bool isNavBar;
  final IconData? extraActionIcon;
  final VoidCallback? onExtraActionTap;

  @override
  State<DoctorSliverAppBar> createState() => _DoctorSliverAppBarState();
}

class _DoctorSliverAppBarState extends State<DoctorSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final maxScrollExtent = widget.expandedHeight - kToolbarHeight;

    return SliverLayoutBuilder(
      builder: (BuildContext context, SliverConstraints constraints) {
        final double expandRatio = maxScrollExtent > 0
            ? (constraints.scrollOffset / maxScrollExtent).clamp(0.0, 1.0)
            : 0.0;

        // 70% close (0.7) te 100% close (1.0) paryant opacity map keli
        final double titleOpacity = ((expandRatio - 0.7) / 0.3).clamp(0.0, 1.0);
        final bool showTitle = titleOpacity > 0.0;

        return SliverAppBar(
          expandedHeight: widget.expandedHeight,
          pinned: true,
          stretch: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: colorScheme.primary,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleSpacing: 16,
          title: Row(
            children: [
              _DoctorHeaderAction(
                icon: widget.isNavBar
                    ? Icons.notes_rounded
                    : Icons.arrow_back_ios_new_rounded,
                onTap: () {
                  if (widget.isNavBar) {
                    Scaffold.of(context).openDrawer();
                  } else {
                    context.pop();
                  }
                },
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
              if (widget.extraActionIcon != null && widget.onExtraActionTap != null) ...[
                if (titleOpacity < 0.5 || widget.titleText == null) const Spacer(),
                _DoctorHeaderAction(
                  icon: widget.extraActionIcon!,
                  onTap: widget.onExtraActionTap!,
                ),
                const SizedBox(width: 12),
              ],
              _DoctorHeaderAction(
                icon: Icons.notifications_outlined,
                onTap: widget.onNotificationTap ??
                        () {
                      context.push(AppRoutes.notifications);
                    },
              ),
              if (widget.isNavBar) ...[
                const SizedBox(width: 12),
                _DoctorProfileAvatar(
                  onTap: widget.onProfileTap ??
                          () {
                        context.push(AppRoutes.doctorProfile);
                      },
                ),
              ],
            ],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppTheme.doctorGradient),
            child: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: widget.background,
            ),
          ),
        );
      },
    );
  }
}

class _DoctorHeaderAction extends StatelessWidget {
  const _DoctorHeaderAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.08),
          ),
        ),
        child: Icon(icon, color: colorScheme.onPrimary, size: 20),
      ),
    );
  }
}

class _DoctorProfileAvatar extends StatelessWidget {
  const _DoctorProfileAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.35),
          ),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.18),
          child: Icon(
            Icons.medical_services_rounded,
            color: colorScheme.onPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
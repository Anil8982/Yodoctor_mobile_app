import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/models/dashboard/appointment_model.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';

class DoctorProfileCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;
  final bool showTrailingArrow;
  final Widget? bottomContent;

  const DoctorProfileCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.showTrailingArrow = false,
    this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.3),
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppTheme.black.withValues(alpha: 0.26)
                : colorScheme.shadow.transparency(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _DoctorAvatar(appointment: appointment),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DoctorInfo(appointment: appointment),
                    ),
                    if (showTrailingArrow) ...[
                      const SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      ),
                    ],
                  ],
                ),
                if (bottomContent != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(
                      height: 1,
                      thickness: 0.6,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  bottomContent!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final AppointmentModel appointment;

  const _DoctorAvatar({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final status = appointment.status;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: _buildAvatarContent(context, textTheme, colorScheme),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: _StatusBadge(status: status),
        ),
      ],
    );
  }

  Widget _buildAvatarContent(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    final imageUrl = appointment.profileImage;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 56,
          height: 56,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: child,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) => _DoctorInitial(
            name: appointment.doctorName,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ),
      );
    }
    return _DoctorInitial(
      name: appointment.doctorName,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }
}

class _DoctorInitial extends StatelessWidget {
  final String name;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DoctorInitial({
    required this.name,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final cleanName = name.replaceAll('Dr. ', '').trim();
    final initial = cleanName.isNotEmpty ? cleanName[0].toUpperCase() : 'D';

    return Center(
      child: Text(
        initial,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(context, status);
    final iconColor = _getStatusIconColor(context, status);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(_getStatusIcon(status), size: 10, color: iconColor),
      ),
    );
  }
}

class _DoctorInfo extends StatelessWidget {
  final AppointmentModel appointment;

  const _DoctorInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final formattedName = appointment.doctorName.startsWith('Dr. ')
        ? appointment.doctorName
        : 'Dr. ${appointment.doctorName}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedName,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              Icons.medical_services_rounded,
              size: 13,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                appointment.specialization,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        StatusChip(status: appointment.status),
      ],
    );
  }
}

Color _getStatusColor(BuildContext context, String status) {
  switch (status) {
    case 'ACCEPTED':
      return AppTheme.success(context);
    case 'PENDING':
      return AppTheme.pending(context);
    case 'CANCELLED':
      return AppTheme.cancelled(context);
    default:
      return AppTheme.error(context);
  }
}

Color _getStatusIconColor(BuildContext context, String status) {
  switch (status) {
    case 'ACCEPTED':
      return AppTheme.onSuccess(context);
    case 'PENDING':
      return AppTheme.onPending(context);
    case 'CANCELLED':
      return AppTheme.onCancelled(context);
    default:
      return AppTheme.onError(context);
  }
}

IconData _getStatusIcon(String status) {
  switch (status) {
    case 'ACCEPTED':
      return Icons.check_rounded;
    case 'PENDING':
      return Icons.access_time_filled_rounded;
    case 'CANCELLED':
      return Icons.close_rounded;
    default:
      return Icons.error_outline_rounded;
  }
}
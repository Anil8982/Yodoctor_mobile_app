import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/models/dashboard/appointment_model.dart';
import 'status_chip.dart';

class DoctorProfileCard extends StatelessWidget {
  final AppointmentModel appointment;

  const DoctorProfileCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _DoctorAvatar(appointment: appointment, colorScheme: colorScheme),
          const SizedBox(width: 16),
          Expanded(
            child: _DoctorInfo(
              appointment: appointment,
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final AppointmentModel appointment;
  final ColorScheme colorScheme;

  const _DoctorAvatar({required this.appointment, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final status = appointment.status;

    return Stack(
      children: [
        _buildAvatarContent(textTheme),
        Positioned(
          bottom: -4,
          right: -4,
          child: _StatusBadge(status: status, colorScheme: colorScheme),
        ),
      ],
    );
  }

  Widget _buildAvatarContent(TextTheme textTheme) {
    final imageUrl = appointment.profileImage;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 68,
          height: 68,
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
                width: 20,
                height: 20,
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
        style: textTheme.headlineMedium?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final ColorScheme colorScheme;

  const _StatusBadge({required this.status, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status, colorScheme);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(_getStatusIcon(status), size: 12, color: AppTheme.white),
      ),
    );
  }
}

class _DoctorInfo extends StatelessWidget {
  final AppointmentModel appointment;
  final ColorScheme colorScheme;

  const _DoctorInfo({required this.appointment, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointment.doctorName,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.medical_services_rounded,
              size: 14,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                appointment.specialization,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StatusChip(status: appointment.status),
      ],
    );
  }
}

Color _getStatusColor(String status, ColorScheme colorScheme) {
  switch (status) {
    case 'ACCEPTED':
      return colorScheme.tertiary;
    case 'PENDING':
      return AppTheme.amber.shade700;
    default:
      return colorScheme.error;
  }
}

IconData _getStatusIcon(String status) {
  switch (status) {
    case 'ACCEPTED':
      return Icons.check_rounded;
    case 'PENDING':
      return Icons.access_time_filled_rounded;
    default:
      return Icons.close_rounded;
  }
}

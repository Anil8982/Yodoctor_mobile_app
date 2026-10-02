import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/live_queue_controller.dart';
import 'package:yodoctor/modules/doctor/models/appointment/live_queue_model.dart';

class QueuePatientList extends ConsumerWidget {
  final List<LiveQueueItem> patients;

  const QueuePatientList({super.key, required this.patients});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifier = ref.read(liveQueueProvider.notifier);

    if (patients.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No patients in queue for this shift.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, index) {
        final appointment = patients[index];
        final status = appointment.status.toUpperCase();

        return _buildPatientTile(
          context,
          ref,
          appointment,
          status,
          theme,
          colorScheme,
          notifier,
        );
      },
    );
  }

  Widget _buildPatientTile(
    BuildContext context,
    WidgetRef ref,
    LiveQueueItem appointment,
    String status,
    ThemeData theme,
    ColorScheme colorScheme,
    LiveQueueNotifier notifier,
  ) {
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          statusColor.withValues(alpha: 0.07),
          colorScheme.surface,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildTokenAvatar(appointment, theme, colorScheme),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                _buildStatusIndicator(status, statusColor),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildActions(context, ref, appointment, status, notifier),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    return switch (status) {
      "ACCEPTED" => AppTheme.green,
      "IN_PROGRESS" => Colors.blue,
      "COMPLETED" => Colors.teal,
      "CANCELLED" => AppTheme.red,
      "SKIPPED" => AppTheme.orange,
      _ => AppTheme.grey,
    };
  }

  Widget _buildTokenAvatar(
    LiveQueueItem appointment,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        appointment.tokenNumber,
        style: theme.textTheme.titleSmall?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status, Color color) {
    final icon = switch (status) {
      "ACCEPTED" => Icons.access_time_rounded,
      "IN_PROGRESS" => Icons.timelapse_rounded,
      "COMPLETED" => Icons.check_circle_rounded,
      "CANCELLED" => Icons.cancel_rounded,
      "SKIPPED" => Icons.skip_next_rounded,
      _ => Icons.info_rounded,
    };

    final text = switch (status) {
      "ACCEPTED" => "WAITING",
      "IN_PROGRESS" => "IN PROGRESS",
      "COMPLETED" => "DONE",
      "CANCELLED" => "NO SHOW",
      "SKIPPED" => "SKIPPED",
      _ => status,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    LiveQueueItem appointment,
    String status,
    LiveQueueNotifier notifier,
  ) {
    if (status == "SKIPPED") {
      return FilledButton.icon(
        onPressed: () => notifier.recall(
          appointment.id,
          ref.read(liveQueueProvider).selectedSlot,
        ),
        icon: const Icon(Icons.replay_rounded, size: 16),
        label: const Text("Recall"),
        style: FilledButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      );
    }

    if (status == "COMPLETED" && !appointment.isWalkIn) {
      return FilledButton.tonalIcon(
        onPressed: () => context.push(
          '${AppRoutes.doctorAddPrescription.replaceFirst(':id', appointment.id)}?name=${Uri.encodeComponent(appointment.patientName)}&token=${Uri.encodeComponent(appointment.tokenNumber)}',
        ),
        icon: Icon(
          appointment.hasPrescription
              ? Icons.edit_note_rounded
              : Icons.receipt_long_rounded,
          size: 16,
        ),
        label: Text(appointment.hasPrescription ? "Update Rx" : "Rx"),
        style: FilledButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

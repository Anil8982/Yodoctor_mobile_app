import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/doctor/controllers/live_queue_controller.dart';
import 'package:yodoctor/modules/widgets/app_dialog.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class EmergencyCancellationDialog {
  static Future<void> show(BuildContext context, WidgetRef ref) async {
    await AppDialog.show(
      context: context,
      title: 'Emergency Cancellation',
      content:
      'This will cancel all remaining appointments for today. '
          'This action cannot be undone.',
      icon: Icons.warning_amber_rounded,
      confirmLabel: 'Cancel Remaining',
      cancelLabel: 'Keep Appointments',
      isDestructive: true,
      onConfirm: () async {
        final notifier = ref.read(liveQueueProvider.notifier);
        final state = ref.read(liveQueueProvider);

        final success = await notifier.cancelRemainingAppointments(
          slot: state.selectedSlot,
        );

        if (!context.mounted) return;

        final count = state.cancelledCount ?? 0;

        if (success) {
          AppSnackBar.show(
            message: count > 0
                ? '$count remaining appointment(s) cancelled.'
                : 'Remaining appointments cancelled successfully.',
            type: AppSnackBarType.success,
          );
        } else {
          AppSnackBar.show(
            message: state.cancelRemainingMessage ??
                'Failed to cancel remaining appointments.',
            type: AppSnackBarType.error,
          );
        }
      },
    );
  }
}
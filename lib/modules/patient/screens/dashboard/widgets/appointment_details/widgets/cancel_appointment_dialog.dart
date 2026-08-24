import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/patient_dashboard_controller.dart';
import 'package:yodoctor/modules/patient/models/dashboard/appointment_model.dart';
import 'package:yodoctor/modules/widgets/app_dialog.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class CancelAppointmentDialog {
  static void show(
    BuildContext context,
    WidgetRef ref, {
    required AppointmentModel appointment,
  }) {
    AppDialog.show(
      context: context,
      title: 'Cancel Appointment',
      content:
          'Are you sure you want to cancel this appointment?\n\nThis action cannot be undone.',
      icon: Icons.warning_rounded,
      confirmLabel: 'Cancel Appointment',
      cancelLabel: 'Keep',
      isDestructive: true,
      onConfirm: () async {
        if (!context.mounted) return;

        final notifier = ref.read(patientDashboardControllerProvider.notifier);

        final success = await notifier.cancelAppointment(appointment.id);

        if (!context.mounted) return;

        if (success) {
          Navigator.pop(context);
          AppSnackBar.show(
            message: 'Appointment cancelled successfully',
            type: AppSnackBarType.success,
          );
        } else {
          final currentState = ref.read(patientDashboardControllerProvider);
          AppSnackBar.show(
            message:
                currentState.errorMessage ?? "Unable to cancel appointment",
            type: AppSnackBarType.error,
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    AppDialog.show(
      context: context,
      title: l10n.cancelAppointment,
      content: l10n.cancelAppointmentConfirmation,
      icon: Icons.warning_rounded,
      confirmLabel: l10n.cancelAppointment,
      cancelLabel: l10n.keepAppointment,
      isDestructive: true,
      onConfirm: () async {
        if (!context.mounted) return;

        final notifier = ref.read(patientDashboardControllerProvider.notifier);

        final success = await notifier.cancelAppointment(appointment.id);

        if (!context.mounted) return;

        if (success) {
          Navigator.pop(context);
          AppSnackBar.show(
            message: l10n.appointmentCancelledSuccess,
            type: AppSnackBarType.success,
          );
        } else {
          final currentState = ref.read(patientDashboardControllerProvider);
          AppSnackBar.show(
            message: _getLocalizedErrorMessage(
              currentState.errorMessage,
              l10n,
            ),
            type: AppSnackBarType.error,
          );
        }
      },
    );
  }

  static String _getLocalizedErrorMessage(
    String? error,
    AppLocalizations l10n,
  ) {
    if (error == null ||
        error.isEmpty ||
        error == 'Unable to cancel appointment' ||
        error == 'Failed to cancel appointment') {
      return l10n.unableToCancelAppointment;
    }
    return error;
  }
}

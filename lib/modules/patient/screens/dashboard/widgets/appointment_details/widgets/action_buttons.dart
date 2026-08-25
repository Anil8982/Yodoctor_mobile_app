import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/models/dashboard/appointment_model.dart';
import 'package:yodoctor/modules/patient/screens/dashboard/widgets/appointment_details/widgets/cancel_appointment_dialog.dart';

class ActionButtons extends ConsumerWidget {
  final AppointmentModel appointment;
  final VoidCallback onClose;

  const ActionButtons({
    super.key,
    required this.appointment,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        _buildCancelButton(context, ref, appointment, colorScheme),
        const SizedBox(height: 12),
        _buildCloseButton(colorScheme),
      ],
    );
  }

  Widget _buildCancelButton(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel appointment,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => CancelAppointmentDialog.show(
          context,
          ref,
          appointment: appointment,
        ),
        icon: const Icon(Icons.cancel_outlined, size: 20),
        label: const Text(
          'Cancel Appointment',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: -0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.error,
          backgroundColor: colorScheme.error.withValues(alpha: 0.08),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: colorScheme.error.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: onClose,
        icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
        label: const Text(
          'Close',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: -0.3,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

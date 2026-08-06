import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/patient_dashboard_controller.dart';
import 'package:yodoctor/modules/patient/models/dashboard/appointment_model.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

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
        _buildCancelButton(context, ref, colorScheme),
        const SizedBox(height: 12),
        _buildCloseButton(colorScheme),
      ],
    );
  }

  Widget _buildCancelButton(
      BuildContext context,
      WidgetRef ref,
      ColorScheme colorScheme,
      ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => _handleCancel(context, ref),
        icon: const Icon(Icons.cancel_outlined, size: 20),
        label: const Text(
          'Cancel Appointment',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: -0.3),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.error,
          backgroundColor: colorScheme.error.withValues(alpha: 0.08),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: colorScheme.error.withValues(alpha: 0.2), width: 1.5),
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
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: -0.3),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }

  Future<void> _handleCancel(BuildContext context, WidgetRef ref) async {
    final confirmed = await _showConfirmDialog(context);
    if (confirmed != true || !context.mounted) return;

    final notifier = ref.read(patientDashboardControllerProvider.notifier);
    final success = await notifier.cancelAppointment(appointment.id);

    if (!context.mounted) return;

    if (success) {
      Navigator.pop(context);
      AppSnackBar.show(
        message: 'Appointment cancelled successfully',
        type: AppSnackBarType.success,
        bottomMargin: 0,
      );
    } else {
      final currentState = ref.read(patientDashboardControllerProvider);
      AppSnackBar.show(
        message: currentState.errorMessage ?? "Unable to cancel appointment",
        bottomMargin: 0,
        type: AppSnackBarType.error,
      );
    }
  }

  Future<bool?> _showConfirmDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: colorScheme.surface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.warning_rounded, color: colorScheme.error, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Cancel Appointment', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: Text(
          "Are you sure you want to cancel this appointment?\n\nThis action cannot be undone.",
          style: TextStyle(color: colorScheme.onSurfaceVariant, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Keep", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Cancel Appointment", style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
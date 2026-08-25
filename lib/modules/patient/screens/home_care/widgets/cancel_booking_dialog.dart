import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/home_care_history_controller.dart';
import 'package:yodoctor/modules/widgets/app_dialog.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class CancelBookingDialog {
  static void show(
    BuildContext context,
    WidgetRef ref, {
    required int bookingId,
  }) {
    AppDialog.show(
      context: context,
      title: 'Cancel Booking',
      content: 'Are you sure you want to cancel this home care booking?',
      icon: Icons.warning_rounded,
      confirmLabel: 'Yes, Cancel',
      cancelLabel: 'No',
      isDestructive: true,
      onConfirm: () async {
        AppSnackBar.show(
          message: 'Cancelling booking...',
          type: AppSnackBarType.loading,
          dismissible: false,
        );

        final success = await ref
            .read(homeCareHistoryProvider.notifier)
            .cancelBooking(bookingId);

        AppSnackBar.hide();

        if (success && context.mounted) {
          AppSnackBar.show(
            message: 'Booking cancelled successfully',
            type: AppSnackBarType.success,
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/controllers/home_care_history_controller.dart';
import 'package:yodoctor/modules/widgets/app_dialog.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class CancelBookingDialog {
  static void show(
    BuildContext context,
    WidgetRef ref, {
    required int bookingId,
  }) {
    final l10n = AppLocalizations.of(context);

    AppDialog.show(
      context: context,
      title: l10n?.cancelBooking ?? 'Cancel Booking',
      content: l10n?.cancelBookingConfirmation ??
          'Are you sure you want to cancel this home care booking?',
      icon: Icons.warning_rounded,
      confirmLabel: l10n?.yesCancel ?? 'Yes, Cancel',
      cancelLabel: l10n?.noKeep ?? 'No',
      isDestructive: true,
      onConfirm: () async {
        AppSnackBar.show(
          message: l10n?.cancellingBooking ?? 'Cancelling booking...',
          type: AppSnackBarType.loading,
          dismissible: false,
        );

        final success = await ref
            .read(homeCareHistoryProvider.notifier)
            .cancelBooking(bookingId);

        AppSnackBar.hide();

        if (success && context.mounted) {
          AppSnackBar.show(
            message: l10n?.bookingCancelledSuccess ??
                'Booking cancelled successfully',
            type: AppSnackBarType.success,
          );
        }
      },
    );
  }
}

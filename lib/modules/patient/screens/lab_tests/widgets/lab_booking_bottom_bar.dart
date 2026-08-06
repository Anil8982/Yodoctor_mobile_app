import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/booking_controller.dart';
import 'package:yodoctor/modules/patient/controllers/lab_test_controller.dart';
import 'package:yodoctor/modules/patient/models/lab/booking_state_model.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class LabBookingBottomBar extends ConsumerWidget {
  final BookingStateModel state;
  final double totalPayable;
  final LabState labState;
  final GlobalKey<FormState> formKey;
  final String? validationMessage;
  final ValueChanged<String?> onValidationChanged;

  const LabBookingBottomBar({
    super.key,
    required this.state,
    required this.totalPayable,
    required this.labState,
    required this.formKey,
    this.validationMessage,
    required this.onValidationChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isReady =
        state.fullName.isNotEmpty &&
        state.phoneNumber.isNotEmpty &&
        state.selectedTimeSlot.isNotEmpty;
    final isProcessing = labState.isPaymentLoading;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
              Text(
                '₹${totalPayable.toInt()}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: (isReady && !isProcessing)
                    ? () async {
                        final booking = ref.read(labBookingProvider);
                        if (booking.gender.isEmpty) {
                          onValidationChanged("Select gender");
                          return;
                        }
                        if (booking.selectedTimeSlot.isEmpty) {
                          onValidationChanged("Select a time slot");
                          return;
                        }
                        onValidationChanged(null);
                        if (!(formKey.currentState?.validate() ?? false))
                          return;

                        final notifier = ref.read(labProvider.notifier);
                        final bookingId = await notifier.createBooking(
                          booking: booking,
                        );

                        if (!context.mounted) return;

                        if (bookingId == null) {
                          AppSnackBar.show(
                            message: 'Booking failed',
                            type: AppSnackBarType.error,
                          );

                          return;
                        }

                        await notifier.initiatePayment(bookingId);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirm & Pay',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

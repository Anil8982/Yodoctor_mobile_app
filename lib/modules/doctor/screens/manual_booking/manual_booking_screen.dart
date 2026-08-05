import 'package:flutter/material.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../../core/utils/app_spacing.dart';
import 'widgets/booking_header.dart';
import 'widgets/manual_booking_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/manual_booking_controller.dart';

class ManualBookingScreen extends ConsumerStatefulWidget {
  const ManualBookingScreen({super.key});

  @override
  ConsumerState<ManualBookingScreen> createState() =>
      _ManualBookingScreenState();
}

class _ManualBookingScreenState extends ConsumerState<ManualBookingScreen> {
  bool _submittedOnce = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manualBookingProvider);
    final notifier = ref.read(manualBookingProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(title: 'Walk-in Registration'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BookingHeader(),
                  const SizedBox(height: AppSpacing.xxl),
                  ManualBookingForm(
                    formKey: notifier.formKey,
                    autovalidateMode: _submittedOnce
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    patientNameController: notifier.patientNameController,
                    mobileController: notifier.mobileController,
                    ageController: notifier.ageController,
                    selectedShift: state
                        .selectedShift, // 🎯 FIXED: Direct reactive state injection
                    loading: state.loading,
                    onShiftChanged: (value) {
                      if (value != null) {
                        notifier.changeShift(value);
                      }
                    },
                    onSubmit: () async {
                      setState(() {
                        _submittedOnce = true;
                      });
                      if (!notifier.formKey.currentState!.validate()) {
                        return;
                      }

                      final success = await notifier.submit();

                      if (!context.mounted) return;

                      if (success) {
                        AppSnackBar.show(
                          message: 'Patient booked successfully! 🚀',
                          type: AppSnackBarType.success,
                        );
                      } else {
                        final currentState = ref.read(manualBookingProvider);
                        AppSnackBar.show(
                          message:
                              currentState.errorMessage ??
                              "Registration failed. Try again.",
                          type: AppSnackBarType.error,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

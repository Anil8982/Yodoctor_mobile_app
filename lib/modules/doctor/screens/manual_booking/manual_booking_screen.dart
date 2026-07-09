import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manualBookingProvider);
    final notifier = ref.read(manualBookingProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Walk-in Registration',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
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
                      final success = await notifier.submit();

                      if (!context.mounted) return;

                      if (success) {
                        _showSnackBar(
                          context,
                          "Patient booked successfully! 🚀",
                          isError: false,
                        );
                      } else {
                        final currentState = ref.read(manualBookingProvider);
                        _showSnackBar(
                          context,
                          currentState.errorMessage ??
                              "Registration failed. Try again.",
                          isError: true,
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

  void _showSnackBar(
    BuildContext context,
    String msg, {
    required bool isError,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w700)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}

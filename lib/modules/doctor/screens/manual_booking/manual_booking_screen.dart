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
                  selectedShift: notifier.selectedShift,
                  loading: state.loading,
                  onShiftChanged: (value) {
                    if (value != null) {
                      notifier.changeShift(value);
                    }
                  },
                  onSubmit: () async {
                    try {
                      final success = await notifier.submit();

                      if (!mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Patient booked successfully"),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

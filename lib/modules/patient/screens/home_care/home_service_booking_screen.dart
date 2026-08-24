import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import '../../models/home_care/home_service_booking_model.dart';
import 'widgets/booking_personal_details.dart';
import 'widgets/booking_urgency_section.dart';
import 'widgets/booking_service_duration.dart';

class HomeServiceBookingScreen extends ConsumerStatefulWidget {
  const HomeServiceBookingScreen({super.key});

  @override
  ConsumerState<HomeServiceBookingScreen> createState() =>
      _HomeServiceBookingScreenState();
}

class _HomeServiceBookingScreenState
    extends ConsumerState<HomeServiceBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _daysController = TextEditingController();
  final _conditionController = TextEditingController();
  final _notesController = TextEditingController();
  bool _showDurationDateError = false;
  bool _hasSubmitted = false;

  bool _isTimeSlotDisabled(String label, HomeServiceBookingModel state) {
    final selectedDate = state.startDate;

    if (selectedDate == null) {
      return false;
    }

    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);

    final bookingDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    // Tomorrow or any future date → all slots enabled
    if (bookingDate.isAfter(currentDate)) {
      return false;
    }

    // Selected date is today → compare with current time
    if (DateUtils.isSameDay(bookingDate, currentDate)) {
      final currentMinutes = now.hour * 60 + now.minute;

      switch (label) {
        case 'Morning (6am - 12pm)':
          return currentMinutes >= 12 * 60;

        case 'Afternoon (12pm - 5pm)':
          return currentMinutes >= 17 * 60;

        case 'Evening (5pm - 9pm)':
          return currentMinutes >= 21 * 60;

        case 'Night (9pm - 6am)':
          return false; // tonight → tomorrow morning

        default:
          return false;
      }
    }

    return true; // Past date
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _daysController.dispose();
    _conditionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 🎯 Watching clean wrapper state instead of raw model instance
    final bookingState = ref.watch(homeServiceBookingProvider);
    final currentModel = bookingState.bookingModel;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(title: 'Book a Care Service'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (bookingState.isLoading) const LinearProgressIndicator(),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HOME HEALTHCARE SERVICES',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Schedule a nurse, home care, or consultation at your doorstep.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildCardSection(
                      context,
                      title: 'Personal Details',
                      icon: Icons.person_outline_rounded,
                      child: BookingPersonalDetails(
                        bookingState: currentModel,
                        nameController: _nameController,
                        phoneController: _phoneController,
                        ageController: _ageController,
                        addressController: _addressController,
                        hasSubmitted: _hasSubmitted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCardSection(
                      context,
                      title: 'Caregiver & Urgency',
                      icon: Icons.assignment_ind_outlined,
                      child: BookingUrgencySection(bookingState: currentModel),
                    ),
                    const SizedBox(height: 16),
                    _buildCardSection(
                      context,
                      title: 'Type of Service',
                      icon: Icons.medical_services_outlined,
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.1,
                        children: [
                          _buildServiceTile(
                            context,
                            'General Nursing',
                            Icons.local_hospital_rounded,
                            currentModel,
                          ),
                          _buildServiceTile(
                            context,
                            'Elderly Care',
                            Icons.elderly_rounded,
                            currentModel,
                          ),
                          _buildServiceTile(
                            context,
                            'Post Surgery',
                            Icons.wheelchair_pickup_rounded,
                            currentModel,
                          ),
                          _buildServiceTile(
                            context,
                            'ICU Nurse',
                            Icons.masks_rounded,
                            currentModel,
                          ),
                          _buildServiceTile(
                            context,
                            'Attendant',
                            Icons.hail_rounded,
                            currentModel,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCardSection(
                      context,
                      title: 'Medical Condition',
                      icon: Icons.health_and_safety_outlined,
                      child: AppTextField(
                        controller: _conditionController,
                        label: 'Medical Condition',
                        hint: 'Describe medical condition, symptoms...',
                        icon: Icons.description_rounded,
                        maxLines: 3,
                        minLines: 1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (val) => ref
                            .read(homeServiceBookingProvider.notifier)
                            .updateField(medicalCondition: val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCardSection(
                      context,
                      title: 'Service Duration',
                      icon: Icons.av_timer_rounded,
                      child: BookingServiceDuration(
                        bookingState: currentModel,
                        daysController: _daysController,
                        showDurationDateError: _showDurationDateError,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCardSection(
                      context,
                      title: 'Time Preference',
                      icon: Icons.access_time_rounded,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildTimeChip(
                            context,
                            'Morning (6am - 12pm)',
                            Icons.wb_sunny_rounded,
                            currentModel,
                          ),
                          _buildTimeChip(
                            context,
                            'Afternoon (12pm - 5pm)',
                            Icons.sunny,
                            currentModel,
                          ),
                          _buildTimeChip(
                            context,
                            'Evening (5pm - 9pm)',
                            Icons.wb_twilight_rounded,
                            currentModel,
                          ),
                          _buildTimeChip(
                            context,
                            'Night (9pm - 6am)',
                            Icons.dark_mode_rounded,
                            currentModel,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCardSection(
                      context,
                      title: 'Additional Notes',
                      icon: Icons.note_alt_outlined,
                      child: AppTextField(
                        controller: _notesController,
                        label: 'Additional Notes',
                        isOptional: true,
                        hint: 'Any special instructions? (Optional)',
                        icon: Icons.edit_note_rounded,
                        maxLines: 2,
                        minLines: 1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (val) => ref
                            .read(homeServiceBookingProvider.notifier)
                            .updateField(additionalNotes: val),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: bookingState.isLoading
                        ? null
                        : () async {
                            setState(() => _hasSubmitted = true);
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                            setState(() {
                              _showDurationDateError =
                                  currentModel.durationType.isEmpty ||
                                  currentModel.startDate == null;
                            });

                            if (_showDurationDateError) {
                              return;
                            }

                            final success = await ref
                                .read(homeServiceBookingProvider.notifier)
                                .createBooking();

                            if (!context.mounted) return;

                            final currentContextState = ref.read(
                              homeServiceBookingProvider,
                            );

                            if (success) {
                              AppSnackBar.show(
                                message: 'Booking submitted successfully',
                                type: AppSnackBarType.success,
                              );

                              if (!context.mounted) return;

                              ref
                                  .read(homeServiceBookingProvider.notifier)
                                  .resetBooking();

                              Navigator.pop(context);
                            } else {
                              AppSnackBar.show(
                                message:
                                    currentContextState.errorMessage ??
                                    "Booking request failed",
                                type: AppSnackBarType.error,
                              );
                            }
                          },
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text(
                      'Submit Booking Request',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Divider(height: 1),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildServiceTile(
    BuildContext context,
    String title,
    IconData icon,
    HomeServiceBookingModel state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSel = state.selectedServiceType == title;
    return InkWell(
      onTap: () => ref
          .read(homeServiceBookingProvider.notifier)
          .updateField(selectedServiceType: title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSel
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSel
                ? Colors.transparent
                : colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSel ? colorScheme.onPrimary : colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSel ? colorScheme.onPrimary : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(
    BuildContext context,
    String label,
    IconData icon,
    HomeServiceBookingModel state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSel = state.timePreference == label;
    final isDisabled = _isTimeSlotDisabled(label, state);
    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: InkWell(
        onTap: isDisabled
            ? null
            : () => ref
                  .read(homeServiceBookingProvider.notifier)
                  .updateField(timePreference: label),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSel ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSel
                  ? Colors.transparent
                  : colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            boxShadow: isSel
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSel
                    ? colorScheme.onPrimary
                    : isDisabled
                    ? colorScheme.outline
                    : colorScheme.onSurface,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSel
                      ? colorScheme.onPrimary
                      : isDisabled
                      ? colorScheme.outline
                      : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

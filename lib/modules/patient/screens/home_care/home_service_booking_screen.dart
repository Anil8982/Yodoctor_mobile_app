import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/screens/home_care/widgets/booking_header.dart';
import '../../../../core/models/patient/home_service_booking_model.dart';
import '../../../../core/utils/input_decoration_helper.dart';
import '../../controllers/home_service_controller.dart';
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
    final bookingState = ref.watch(homeServiceBookingProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Book a Care Service',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  const BookingHeader(),
                  const SizedBox(height: 20),

                  _buildCardSection(
                    context,
                    title: 'Personal Details',
                    icon: Icons.person_outline_rounded,
                    child: BookingPersonalDetails(
                      bookingState: bookingState,
                      nameController: _nameController,
                      phoneController: _phoneController,
                      ageController: _ageController,
                      addressController: _addressController,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardSection(
                    context,
                    title: 'Caregiver & Urgency',
                    icon: Icons.assignment_ind_outlined,
                    child: BookingUrgencySection(bookingState: bookingState),
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
                          bookingState,
                        ),
                        _buildServiceTile(
                          context,
                          'Elderly Care',
                          Icons.elderly_rounded,
                          bookingState,
                        ),
                        _buildServiceTile(
                          context,
                          'Post Surgery',
                          Icons.wheelchair_pickup_rounded,
                          bookingState,
                        ),
                        _buildServiceTile(
                          context,
                          'ICU Nurse',
                          Icons.masks_rounded,
                          bookingState,
                        ),
                        _buildServiceTile(
                          context,
                          'Attendant',
                          Icons.hail_rounded,
                          bookingState,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardSection(
                    context,
                    title: 'Medical Condition',
                    icon: Icons.health_and_safety_outlined,
                    child: TextFormField(
                      controller: _conditionController,
                      maxLines: 3,
                      decoration: AppInputDecoration.build(
                        context,
                        label: 'Describe medical condition, symptoms...',
                        prefixIcon: Icons.description_rounded,
                      ),
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
                      bookingState: bookingState,
                      daysController: _daysController,
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
                          bookingState,
                        ),
                        _buildTimeChip(
                          context,
                          'Afternoon (12pm - 5pm)',
                          Icons.sunny,
                          bookingState,
                        ),
                        _buildTimeChip(
                          context,
                          'Evening (5pm - 9pm)',
                          Icons.wb_twilight_rounded,
                          bookingState,
                        ),
                        _buildTimeChip(
                          context,
                          'Night (9pm - 6am)',
                          Icons.dark_mode_rounded,
                          bookingState,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCardSection(
                    context,
                    title: 'Additional Notes',
                    icon: Icons.note_alt_outlined,
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: AppInputDecoration.build(
                        context,
                        label: 'Any special instructions? (Optional)',
                        prefixIcon: Icons.edit_note_rounded,
                      ),
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
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) {
                      return;
                    }

                    final success = await ref
                        .read(homeServiceBookingProvider.notifier)
                        .createBooking();

                    if (!mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Booking submitted successfully"),
                        ),
                      );

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Booking failed")),
                      );
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text(
                    'Submit Booking Request',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
    return InkWell(
      onTap: () => ref
          .read(homeServiceBookingProvider.notifier)
          .updateField(timePreference: label),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSel ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSel ? Colors.transparent : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSel ? colorScheme.onPrimary : colorScheme.outline,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSel ? colorScheme.onPrimary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

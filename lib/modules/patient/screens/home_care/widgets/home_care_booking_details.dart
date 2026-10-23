import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/controllers/home_care_history_controller.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';

class HomeCareBookingDetails extends ConsumerWidget {
  const HomeCareBookingDetails({super.key});

  String _getServiceTitle(AppLocalizations? l10n, String type) {
    switch (type) {
      case 'General Nursing':
        return l10n?.serviceTypeGeneralNursing ?? 'General Nursing';
      case 'Elderly Care':
        return l10n?.serviceTypeElderlyCare ?? 'Elderly Care';
      case 'Post Surgery':
        return l10n?.serviceTypePostSurgery ?? 'Post Surgery';
      case 'ICU Nurse':
        return l10n?.serviceTypeIcuNurse ?? 'ICU Nurse';
      case 'Attendant':
        return l10n?.serviceTypeAttendant ?? 'Attendant';
      default:
        return type.isNotEmpty
            ? type
            : (l10n?.homeCareService ?? 'Home Care Service');
    }
  }

  String _getGenderLabel(AppLocalizations? l10n, String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return l10n?.genderMale ?? 'Male';
      case 'female':
        return l10n?.genderFemale ?? 'Female';
      case 'other':
        return l10n?.genderOther ?? 'Other';
      default:
        return gender;
    }
  }

  String _getGenderPreferenceLabel(AppLocalizations? l10n, String pref) {
    switch (pref.toLowerCase()) {
      case 'male':
        return l10n?.genderMale ?? 'Male';
      case 'female':
        return l10n?.genderFemale ?? 'Female';
      case 'no preference':
        return l10n?.noPreference ?? 'No Preference';
      default:
        return pref;
    }
  }

  String _getDurationLabel(AppLocalizations? l10n, String type) {
    switch (type) {
      case '1 Day':
        return l10n?.duration1Day ?? '1 Day';
      case 'Multiple Days':
        return l10n?.durationMultipleDays ?? 'Multiple Days';
      case 'Weekly':
        return l10n?.durationWeekly ?? 'Weekly';
      case 'Monthly':
        return l10n?.durationMonthly ?? 'Monthly';
      default:
        return type;
    }
  }

  String _getTimeSlotLabel(AppLocalizations? l10n, String slot) {
    switch (slot) {
      case 'Morning (6am - 12pm)':
        return l10n?.timeSlotMorning ?? 'Morning (6am - 12pm)';
      case 'Afternoon (12pm - 5pm)':
        return l10n?.timeSlotAfternoon ?? 'Afternoon (12pm - 5pm)';
      case 'Evening (5pm - 9pm)':
        return l10n?.timeSlotEvening ?? 'Evening (5pm - 9pm)';
      case 'Night (9pm - 6am)':
        return l10n?.timeSlotNight ?? 'Night (9pm - 6am)';
      default:
        return slot;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeCareHistoryProvider);
    final booking = state.selectedBooking;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Stack(
            children: [
              // Scrollable Content
              state.isDetailsLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    )
                  : booking == null
                  ? _buildErrorState(context, l10n)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 104, 20, 36),
                      children: [
                        // Status & Emergency Badge Row (Wrapped in LayoutBuilder / Flexible to prevent overflow)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              children: [
                                _buildStatusBadge(context, booking.status),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: _buildEmergencyChip(
                                      context,
                                      booking.emergencyBooking,
                                      l10n,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Section: Patient Information
                        _buildSectionContainer(
                          context,
                          title: l10n?.patientInformation ?? 'Patient Information',
                          icon: Icons.person_rounded,
                          children: [
                            _buildDetailTile(
                              context,
                              l10n?.patientName ?? 'Patient Name',
                              booking.fullName,
                              isBold: true,
                            ),
                            _buildDivider(context),
                            _buildDetailTile(
                              context,
                              l10n?.ageGender ?? 'Age / Gender',
                              '${l10n?.yearsOld(booking.patientAge) ?? '${booking.patientAge} Years'} / ${_getGenderLabel(l10n, booking.patientGender)}',
                            ),
                            if (booking.genderPreference.trim().isNotEmpty) ...[
                              _buildDivider(context),
                              _buildDetailTile(
                                context,
                                l10n?.preference ?? 'Preference',
                                _getGenderPreferenceLabel(
                                  l10n,
                                  booking.genderPreference,
                                ),
                              ),
                            ],
                            _buildDivider(context),
                            _buildDetailTile(
                              context,
                              l10n?.contact ?? 'Contact',
                              booking.contactNumber,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section: Service Information
                        _buildSectionContainer(
                          context,
                          title: l10n?.serviceInformation ?? 'Service Information',
                          icon: Icons.assignment_rounded,
                          children: [
                            if (booking.serviceType.trim().isNotEmpty) ...[
                              _buildDetailTile(
                                context,
                                l10n?.serviceType ?? 'Service Type',
                                _getServiceTitle(l10n, booking.serviceType),
                              ),
                            ],
                            if (booking.medicalCondition.trim().isNotEmpty) ...[
                              if (booking.serviceType.trim().isNotEmpty)
                                _buildDivider(context),
                              _buildDetailTile(
                                context,
                                l10n?.medicalCondition ?? 'Medical Condition',
                                booking.medicalCondition,
                              ),
                            ],
                            _buildDivider(context),
                            _buildDetailTile(
                              context,
                              l10n?.durationType ?? 'Duration Type',
                              _getDurationLabel(l10n, booking.durationType),
                            ),
                            if (booking.durationType.toLowerCase().contains(
                              'multiple',
                            )) ...[
                              _buildDivider(context),
                              _buildDetailTile(
                                context,
                                l10n?.numberOfDays ?? 'Number Of Days',
                                l10n?.daysCount(
                                      booking.numberOfDays,
                                    ) ??
                                    '${booking.numberOfDays} Days',
                              ),
                            ],
                            if (booking.timeSlot.trim().isNotEmpty) ...[
                              _buildDivider(context),
                              _buildDetailTile(
                                context,
                                l10n?.timeSlot ?? 'Time Slot',
                                _getTimeSlotLabel(l10n, booking.timeSlot),
                              ),
                            ],
                            if (booking.preferredDate != null) ...[
                              _buildDivider(context),
                              _buildDetailTile(
                                context,
                                l10n?.preferredDate ?? 'Preferred Date',
                                _formatDate(booking.preferredDate!),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section: Location & Notes
                        _buildSectionContainer(
                          context,
                          title: l10n?.locationAndNotes ?? 'Location & Notes',
                          icon: Icons.place_rounded,
                          children: [
                            _buildDetailTile(
                              context,
                              l10n?.serviceAddress ?? 'Service Address',
                              booking.address,
                              isFullWidth: true,
                            ),
                            if (booking.notes.trim().isNotEmpty) ...[
                              _buildDivider(context),
                              _buildDetailTile(
                                context,
                                l10n?.additionalNotes ?? 'Additional Notes',
                                booking.notes,
                                isFullWidth: true,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),

              // Glassmorphism Floating Top Header Section
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.75),
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.15,
                            ),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag Handle
                          Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Header Content
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.medical_services_rounded,
                                  color: colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n?.bookingDetails ?? 'Booking Details',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      booking?.bookingId ??
                                          (l10n?.homeCareService ??
                                              'Home Care Service'),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton.filledTonal(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.close_rounded, size: 20),
                                style: IconButton.styleFrom(
                                  backgroundColor: colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.5),
                                  foregroundColor: colorScheme.onSurfaceVariant,
                                ),
                                tooltip: l10n?.close ?? 'Close',
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildSectionContainer(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: colorScheme.primary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.outlineVariant.withValues(alpha: 0.0),
                    colorScheme.outlineVariant.withValues(alpha: 0.3),
                    colorScheme.outlineVariant.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final normalizedStatus = status.trim().toUpperCase();

    return StatusChip(status: normalizedStatus);
  }

  Widget _buildEmergencyChip(
    BuildContext context,
    bool isEmergency,
    AppLocalizations? l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isEmergency
            ? colorScheme.errorContainer.withValues(alpha: 0.7)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEmergency ? Icons.emergency_rounded : Icons.check_circle_rounded,
            size: 14,
            color: isEmergency ? colorScheme.error : colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              isEmergency
                  ? (l10n?.emergencyBadge ?? 'Emergency')
                  : (l10n?.regularBooking ?? 'Regular'),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isEmergency
                    ? colorScheme.onErrorContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    bool isFullWidth = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (value.trim().isEmpty) return const SizedBox.shrink();

    if (isFullWidth) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, AppLocalizations? l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              l10n?.failedToLoadDetails ?? 'Failed to load booking details',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}

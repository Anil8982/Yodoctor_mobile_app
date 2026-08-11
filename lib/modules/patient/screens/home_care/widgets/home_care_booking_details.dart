import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/home_care_history_controller.dart';

class HomeCareBookingDetails extends ConsumerWidget {
  const HomeCareBookingDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(homeCareHistoryProvider);
    final booking = state.selectedBooking;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
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
                ? _buildErrorState(context)
                : ListView(
              padding: const EdgeInsets.fromLTRB(20, 104, 20, 36),
              children: [
                // Status & Emergency Badge Row (Wrapped in LayoutBuilder / Flexible to prevent overflow)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: [
                        Expanded(child: _buildStatusBadge(context, booking.status)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _buildEmergencyChip(context, booking.emergencyBooking),
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
                  title: 'Patient Information',
                  icon: Icons.person_rounded,
                  children: [
                    _buildDetailTile(context, 'Patient Name', booking.fullName, isBold: true),
                    _buildDivider(context),
                    _buildDetailTile(context, 'Age / Gender', '${booking.patientAge} Years / ${booking.patientGender}'),
                    if (booking.genderPreference.trim().isNotEmpty) ...[
                      _buildDivider(context),
                      _buildDetailTile(context, 'Preference', booking.genderPreference),
                    ],
                    _buildDivider(context),
                    _buildDetailTile(context, 'Contact', booking.contactNumber),
                  ],
                ),

                const SizedBox(height: 16),

                // Section: Service Information
                _buildSectionContainer(
                  context,
                  title: 'Service Information',
                  icon: Icons.assignment_rounded,
                  children: [
                    if (booking.serviceType.trim().isNotEmpty) ...[
                      _buildDetailTile(context, 'Service Type', booking.serviceType),
                    ],
                    if (booking.medicalCondition.trim().isNotEmpty) ...[
                      if (booking.serviceType.trim().isNotEmpty) _buildDivider(context),
                      _buildDetailTile(context, 'Medical Condition', booking.medicalCondition),
                    ],
                    _buildDivider(context),
                    _buildDetailTile(context, 'Duration Type', booking.durationType),
                    if (booking.durationType.toLowerCase().contains('multiple')) ...[
                      _buildDivider(context),
                      _buildDetailTile(context, 'Number Of Days', '${booking.numberOfDays} Days'),
                    ],
                    if (booking.timeSlot.trim().isNotEmpty) ...[
                      _buildDivider(context),
                      _buildDetailTile(context, 'Time Slot', booking.timeSlot),
                    ],
                    if (booking.preferredDate != null) ...[
                      _buildDivider(context),
                      _buildDetailTile(context, 'Preferred Date', _formatDate(booking.preferredDate!)),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Section: Location & Notes
                _buildSectionContainer(
                  context,
                  title: 'Location & Notes',
                  icon: Icons.place_rounded,
                  children: [
                    _buildDetailTile(
                      context,
                      'Service Address',
                      booking.address,
                      isFullWidth: true,
                    ),
                    if (booking.notes.trim().isNotEmpty) ...[
                      _buildDivider(context),
                      _buildDetailTile(
                        context,
                        'Additional Notes',
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
                          color: colorScheme.outlineVariant.withValues(alpha: 0.15),
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
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
                                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
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
                                    'Booking Details',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    booking?.bookingId ?? 'Home Care Service',
                                    style: theme.textTheme.bodySmall?.copyWith(
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
                                backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                foregroundColor: colorScheme.onSurfaceVariant,
                              ),
                              tooltip: 'Close',
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
    final colorScheme = Theme.of(context).colorScheme;
    final normalizedStatus = status.trim().toUpperCase();

    Color backgroundColor;
    Color foregroundColor;

    switch (normalizedStatus) {
      case 'CANCELLED':
        backgroundColor = colorScheme.errorContainer;
        foregroundColor = colorScheme.onErrorContainer;
        break;
      case 'COMPLETED':
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        break;
      default:
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, size: 8, color: foregroundColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              status,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyChip(BuildContext context, bool isEmergency) {
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
              isEmergency ? 'Emergency' : 'Regular',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isEmergency ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant,
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

  Widget _buildErrorState(BuildContext context) {
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
              'Failed to load booking details',
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
import 'package:flutter/material.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_care_history_model.dart';

class HomeCareHistoryCard extends StatelessWidget {
  final HomeCareBookingModel booking;
  final VoidCallback onTap;
  final VoidCallback? onCancel;

  const HomeCareHistoryCard({
    super.key,
    required this.booking,
    required this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEmergency = booking.emergencyBooking;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isEmergency
              ? colorScheme.error.withValues(alpha: 0.3)
              : colorScheme.outlineVariant.withValues(alpha: 0.25),
          width: isEmergency ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isEmergency ? 0.06 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: ID, Status Badge & Emergency Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.assignment_outlined,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'ID: ${booking.bookingId.isNotEmpty ? booking.bookingId : booking.id.toString()}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isEmergency) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.emergency_rounded, size: 12, color: colorScheme.error),
                                const SizedBox(width: 4),
                                Text(
                                  'Emergency',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        _getStatusBadge(context, booking.status),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Service Title
                Text(
                  booking.serviceType.isNotEmpty ? booking.serviceType : 'Home Care Service',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                // Patient Info Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.fullName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${booking.patientAge} Years / ${booking.patientGender}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Location Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.place_rounded,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.address,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Cancel Action Section (if applicable)
                if (onCancel != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 14,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Tap for full details',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        onPressed: onCancel,
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: colorScheme.error,
                          size: 15,
                        ),
                        label: Text(
                          'Cancel Booking',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.1),
                          side: BorderSide(color: colorScheme.error.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getStatusBadge(BuildContext context, String status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, size: 6, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            status,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
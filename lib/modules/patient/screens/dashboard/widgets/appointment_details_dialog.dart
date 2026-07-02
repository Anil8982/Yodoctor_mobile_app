import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/models/patient/patient_appointment.dart';

class AppointmentDetailsDialog extends StatelessWidget {
  const AppointmentDetailsDialog({super.key, required this.appointment});

  final PatientAppointment appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool isAccepted = appointment.appointmentStatus == 'ACCEPTED';
    final Color statusColor = isAccepted ? colorScheme.primary : colorScheme.secondary;
    final Color statusBg = isAccepted
        ? colorScheme.primaryContainer.withValues(alpha: 0.4)
        : colorScheme.secondaryContainer.withValues(alpha: 0.45);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface.withValues(alpha: 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Appointment Details',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              appointment.doctorName.isNotEmpty
                                  ? appointment.doctorName.replaceAll('Dr. ', '')[0]
                                  : 'D',
                              style: textTheme.titleLarge?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.doctorName,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    appointment.specialty,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusBg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      appointment.appointmentStatus,
                                      style: textTheme.labelSmall?.copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle(textTheme, colorScheme, 'APPOINTMENT INFO'),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildGridInfoItem(context, Icons.person_rounded, 'Patient', appointment.patientName),
                        _buildGridInfoItem(context, Icons.calendar_month_rounded, 'Date', DateFormat('EEE, MMM dd, yyyy').format(appointment.dateTime)),
                        _buildGridInfoItem(context, Icons.access_time_filled_rounded, 'Time Slot', 'Evening'),
                        _buildGridInfoItem(context, Icons.tag_rounded, 'Token Number', '#1'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 24),

                    _buildSectionTitle(textTheme, colorScheme, 'CLINIC INFORMATION'),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildGridInfoItem(context, Icons.local_hospital_rounded, 'Clinic', appointment.hospital),
                        _buildGridInfoItem(context, Icons.payments_rounded, 'Consultation Fee', '₹500'),
                        _buildGridInfoItem(context, Icons.location_city_rounded, 'City', 'Chhatrapati Sambhajinagar'),
                        _buildGridInfoItem(context, Icons.badge_rounded, 'Experience', '7+ Years'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildGridInfoItem(context, Icons.map_rounded, 'Address', 'Ashoka Garden', isFullWidth: true),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cancel_rounded, size: 18),
                  label: const Text('Cancel Appointment'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: colorScheme.error.withValues(alpha: 0.04),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(TextTheme textTheme, ColorScheme colorScheme, String title) {
    return Text(
      title,
      style: textTheme.labelSmall?.copyWith(
        color: colorScheme.outline,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildGridInfoItem(BuildContext context, IconData icon, String label, String value, {bool isFullWidth = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: colorScheme.outline),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: isFullWidth ? 2 : 1,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );

    if (isFullWidth) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: content,
      );
    }

    return content;
  }
}

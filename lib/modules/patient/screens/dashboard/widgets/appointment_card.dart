import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_spacing.dart';
import '../../../models/dashboard/appointment_model.dart';
import 'appointment_details/appointment_details_bottom_sheet.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final String? imageUrl = appointment.profileImage;

    final bool isAccepted = appointment.status == 'ACCEPTED';
    final Color statusColor = isAccepted
        ? colorScheme.tertiary
        : Colors.amber.shade700;
    final Color statusBg = isAccepted
        ? colorScheme.tertiaryContainer
        : colorScheme.errorContainer;

    final String doctorInitial = appointment.doctorName.isNotEmpty
        ? appointment.doctorName.replaceAll('Dr. ', '').trim()[0].toUpperCase()
        : 'D';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
                : colorScheme.shadow.transparency(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            showAppointmentDetailsBottomSheet(context, appointment);
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Doctor Avatar Box
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colorScheme.primary, colorScheme.tertiary],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.transparency(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 56,
                                height: 56,
                                errorBuilder: (_, _, _) => Center(
                                  child: Text(
                                    doctorInitial,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                doctorInitial,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),

                    // Details Area
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment.doctorName,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.3,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      appointment.specialization,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Status Chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBg.transparency(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isAccepted
                                          ? Icons.check_circle_rounded
                                          : Icons.pending_rounded,
                                      size: 13,
                                      color: statusColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      appointment.status,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: statusColor,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(
                              height: 1,
                              thickness: 0.6,
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),

                          // Patient Info Row
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.person_outline_rounded,
                                size: 15,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Patient: ${appointment.familyName ?? "Self"}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

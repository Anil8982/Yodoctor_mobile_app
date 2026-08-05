import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../models/dashboard/appointment_model.dart';
import '../../../controllers/patient_dashboard_controller.dart';

class AppointmentDetailsDialog extends ConsumerWidget {
  const AppointmentDetailsDialog({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    bool isAccepted = appointment.status == 'ACCEPTED';
    final Color statusColor = isAccepted
        ? colorScheme.primary
        : colorScheme.secondary;
    final Color statusBg = isAccepted
        ? colorScheme.onPrimaryContainer.withValues(alpha: 0.2)
        : colorScheme.onSecondaryContainer.withValues(alpha: 0.2);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colorScheme.secondaryContainer,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
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
                            color: colorScheme.primaryContainer.withValues(
                              alpha: 0.35,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            image:
                                appointment.profileImage != null &&
                                    appointment.profileImage!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                      appointment.profileImage!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              appointment.profileImage == null ||
                                  appointment.profileImage!.isEmpty
                              ? Center(
                                  child: Text(
                                    appointment.doctorName.isNotEmpty
                                        ? appointment.doctorName
                                              .replaceAll('Dr. ', '')[0]
                                              .toUpperCase()
                                        : 'D',
                                    style: textTheme.titleLarge?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null,
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
                                    appointment.specialization,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusBg,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        appointment.status,
                                        style: textTheme.labelSmall?.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10,
                                        ),
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
                    _buildSectionTitle(
                      textTheme,
                      colorScheme,
                      'APPOINTMENT INFO',
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildGridInfoItem(
                          context,
                          Icons.person_rounded,
                          'Patient',
                          appointment.familyName ?? "Self",
                        ),
                        _buildGridInfoItem(
                          context,
                          Icons.calendar_month_rounded,
                          'Date',
                          appointment.appointmentDate,
                        ),
                        _buildGridInfoItem(
                          context,
                          Icons.access_time_filled_rounded,
                          'Time Slot',
                          appointment.appointmentSlot,
                        ),
                        _buildGridInfoItem(
                          context,
                          Icons.tag_rounded,
                          'Token Number',
                          '#${appointment.tokenNumber.toString()}', // 🎯 फिक्स: .toString() लावून कास्टिंग एरर घालवला
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                      textTheme,
                      colorScheme,
                      'CLINIC INFORMATION',
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildGridInfoItem(
                          context,
                          Icons.local_hospital_rounded,
                          'Clinic',
                          appointment.clinicName,
                        ),
                        _buildGridInfoItem(
                          context,
                          Icons.payments_rounded,
                          'Consultation Fee',
                          '₹${appointment.consultationFee}',
                        ),
                        _buildGridInfoItem(
                          context,
                          Icons.location_city_rounded,
                          'City',
                          appointment.city,
                        ),
                        _buildGridInfoItem(
                          context,
                          Icons.badge_rounded,
                          'Experience',
                          '${appointment.experience} Years',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildGridInfoItem(
                      context,
                      Icons.map_rounded,
                      'Address',
                      appointment.address,
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            if (appointment.status == "PENDING" ||
                appointment.status == "ACCEPTED")
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Cancel Appointment"),
                          content: const Text(
                            "Are you sure you want to cancel this appointment?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("No"),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      final controller = ref.read(
                        patientDashboardControllerProvider.notifier,
                      );
                      final success = await controller.cancelAppointment(
                        appointment.id,
                      );

                      if (!context.mounted) return;

                      if (success) {
                        Navigator.pop(context);
                        AppSnackBar.show(
                          message: 'Appointment cancelled successfully',
                          type: AppSnackBarType.success,
                        );
                      } else {
                        AppSnackBar.show(
                          message:
                              controller.errorMessage ??
                              "Unable to cancel appointment",
                          type: AppSnackBarType.error,
                        );
                      }
                    },
                    icon: const Icon(Icons.cancel_rounded, size: 18),
                    label: const Text('Cancel Appointment'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(
                        color: colorScheme.error.withValues(alpha: 0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: colorScheme.error.withValues(
                        alpha: 0.04,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
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

  Widget _buildSectionTitle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title,
  ) {
    return Text(
      title,
      style: textTheme.labelSmall?.copyWith(
        color: colorScheme.onSecondaryFixedVariant,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildGridInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isFullWidth = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: colorScheme.onSecondaryContainer.transparency(0.7),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: isFullWidth ? 2 : 1,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );

    if (isFullWidth) {
      return Padding(padding: const EdgeInsets.only(top: 4), child: content);
    }
    return content;
  }
}

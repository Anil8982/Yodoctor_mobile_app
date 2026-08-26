import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/models/dashboard/appointment_model.dart';
import 'widgets/doctor_profile_card.dart';
import 'widgets/info_section.dart';
import 'widgets/action_buttons.dart';
import 'widgets/appointment_header.dart';

void showAppointmentDetailsBottomSheet(
  BuildContext context,
  AppointmentModel appointment,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.transparent,
    isDismissible: true,
    builder: (_) => AppointmentDetailsBottomSheet(appointment: appointment),
  );
}

class AppointmentDetailsBottomSheet extends ConsumerWidget {
  const AppointmentDetailsBottomSheet({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75, // Standard fixed initial height
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppTheme.black.withValues(alpha: 0.54)
                    : colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              const SizedBox(height: 16),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              const AppointmentHeader(),

              // Content Scroll View
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DoctorProfileCard(appointment: appointment),
                      const SizedBox(height: 24),
                      InfoSection(appointment: appointment),
                      const SizedBox(height: 28),
                      if (appointment.status == "PENDING" ||
                          appointment.status == "ACCEPTED")
                        ActionButtons(
                          appointment: appointment,
                          onClose: () => Navigator.pop(context),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

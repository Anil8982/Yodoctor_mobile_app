import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/screens/appointments/models/appointment_queue_info.dart';
import 'package:yodoctor/modules/widgets/app_dialog.dart';

class AppointmentQueueDialog {
  static void show(
    BuildContext context, {
    required AppointmentQueueInfo queueInfo,
  }) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    AppDialog.show(
      context: context,
      icon: Icons.check_circle_rounded,
      title: l10n.bookingConfirmed,
      content: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${queueInfo.doctorName} - ${queueInfo.specialty}',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Text(
              '${l10n.patientInfoLabel}: ${queueInfo.patientLabel}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'YOUR TOKEN',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    queueInfo.tokenNumber,
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Now Serving: ${queueInfo.nowServing}',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_top_rounded,
                  size: 16,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${l10n.estimatedWaitingTime}: ${queueInfo.estimatedWait}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      confirmLabel: l10n.backToHome,
      showCancel: false,
      onConfirm: () {
        Navigator.of(context).pop();
        context.go(AppRoutes.dashboard);
      },
    );
  }
}

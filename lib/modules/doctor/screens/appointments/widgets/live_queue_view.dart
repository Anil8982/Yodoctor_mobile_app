import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';

import '../../../controllers/live_queue_controller.dart';
import '../../../models/appointment/live_queue_model.dart';
import '../../../screens/appointments/add_prescription_screen.dart';
import '../../../../doctor/screens/incoming_appointment/incoming_appointment_screen.dart';
import 'live_queue_shimmer.dart';

enum QueueShift { morning, evening }

class LiveQueueView extends ConsumerStatefulWidget {
  const LiveQueueView({super.key});

  @override
  ConsumerState<LiveQueueView> createState() => _LiveQueueViewState();
}

class _LiveQueueViewState extends ConsumerState<LiveQueueView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final queueState = ref.watch(liveQueueProvider);
    final notifier = ref.read(liveQueueProvider.notifier);
    final slot = queueState.selectedSlot;

    if (queueState.loading) {
      return const LiveQueueShimmer();
    }

    final todayAppointments = queueState.queue;
    final filteredTodayAppointments = todayAppointments;
    final hasWaitingPatient = filteredTodayAppointments.any(
          (e) => e.status.toUpperCase() == "ACCEPTED",
    );
    final totalCount = filteredTodayAppointments.length;

    final completedCount = filteredTodayAppointments
        .where((app) => app.status.toUpperCase() == 'COMPLETED')
        .length;
    final waitingCount = filteredTodayAppointments
        .where((e) => e.status.toUpperCase() == "ACCEPTED")
        .length;

    final currentPatient = queueState.current;
    final nextPatient = queueState.next;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Overview",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            _buildShiftToggle(colorScheme),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildCounterCards(
          totalCount,
          waitingCount,
          completedCount,
          colorScheme,
          theme,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildActionCards(notifier, currentPatient, slot),
        const SizedBox(height: AppSpacing.lg),
        _buildTrackerSection(
          currentPatient,
          nextPatient,
          notifier,
          slot,
          colorScheme,
          theme,
          hasWaitingPatient,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Patient List',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildPatientListSection(
          filteredTodayAppointments,
          notifier,
          colorScheme,
          theme,
        ),
      ],
    );
  }

  Widget _buildShiftToggle(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildShiftButton('Morning', QueueShift.morning, colorScheme),
          _buildShiftButton('Evening', QueueShift.evening, colorScheme),
        ],
      ),
    );
  }

  Widget _buildShiftButton(
      String text,
      QueueShift shift,
      ColorScheme colorScheme,
      ) {
    final selectedSlot = ref.watch(
      liveQueueProvider.select((state) => state.selectedSlot),
    );

    final isSelected = shift == QueueShift.morning
        ? selectedSlot == "MORNING"
        : selectedSlot == "EVENING";

    final notifier = ref.read(liveQueueProvider.notifier);

    return GestureDetector(
      onTap: () async {
        final slot = shift == QueueShift.morning ? "MORNING" : "EVENING";
        await notifier.changeSlot(slot);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterCards(
      int total,
      int waiting,
      int done,
      ColorScheme colorScheme,
      ThemeData theme,
      ) {
    return Row(
      children: [
        Expanded(
          child: _buildCounterCard(
            'Total',
            total.toString(),
            colorScheme.surfaceContainerLow,
            colorScheme.primary,
            theme,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildCounterCard(
            'Waiting',
            waiting.toString(),
            colorScheme.surfaceContainerLow,
            Colors.orange.shade800,
            theme,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildCounterCard(
            'Done',
            done.toString(),
            colorScheme.surfaceContainerLow,
            Colors.green.shade800,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildCounterCard(
      String label,
      String count,
      Color bgColor,
      Color textColor,
      ThemeData theme,
      ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            count,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(
      LiveQueueNotifier notifier,
      LiveQueueItem? current,
      String slot,
      ) {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            title: "Incoming",
            icon: Icons.access_time_filled_rounded,
            color: Colors.blue.pastel(0.9),
            iconColor: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const IncomingAppointmentScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _actionCard(
            title: "Skip",
            icon: Icons.skip_next_rounded,
            color: Colors.orange.pastel(0.9),
            iconColor: Colors.orange,
            onTap: current == null
                ? null
                : () {
              notifier.skip(current.id, slot);
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _actionCard(
            title: "No Show",
            icon: Icons.person_off_rounded,
            color: Colors.red.pastel(0.9),
            iconColor: Colors.red,
            onTap: current == null
                ? null
                : () async {
              await notifier.noShow(slot);
            },
          ),
        ),
      ],
    );
  }

  Widget _actionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 110,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: iconColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackerSection(
      LiveQueueItem? current,
      LiveQueueItem? next,
      LiveQueueNotifier notifier,
      String slot,
      ColorScheme colorScheme,
      ThemeData theme,
      bool hasWaitingPatient,
      ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildPatientTrackCard(
              'CURRENT PATIENT',
              current != null
                  ? _cleanPatientName(current.patientName)
                  : 'None',
              current?.tokenNumber ?? '-',
              colorScheme.primary,
              theme,
              action: (current != null && !hasWaitingPatient)
                  ? FilledButton.tonalIcon(
                onPressed: () async {
                  await notifier.nextToken(slot);
                },
                icon: const Icon(Icons.stop_circle_rounded, size: 18),
                label: const Text("Stop"),
              )
                  : null,
            ),
          ),
          Container(
            width: 1,
            height: 90,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NEXT PATIENT",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  next != null
                      ? _cleanPatientName(next.patientName)
                      : "No Patient",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Token #${next?.tokenNumber ?? '-'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (current == null && next != null && hasWaitingPatient)
                  FilledButton.icon(
                    onPressed: () async {
                      await notifier.start(next.id, slot);
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text("Start"),
                  ),
                if (current != null && next != null && hasWaitingPatient)
                  FilledButton.icon(
                    onPressed: () async {
                      await notifier.nextToken(slot);
                    },
                    icon: const Icon(Icons.skip_next_rounded, size: 18),
                    label: const Text("Next"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTrackCard(
      String title,
      String name,
      String token,
      Color accentColor,
      ThemeData theme, {
        Widget? action,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Token #$token',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (action != null) ...[
          const SizedBox(height: 10),
          action,
        ],
      ],
    );
  }

  Widget _buildPatientListSection(
      List<LiveQueueItem> patients,
      LiveQueueNotifier notifier,
      ColorScheme colorScheme,
      ThemeData theme,
      ) {
    if (patients.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        alignment: Alignment.center,
        child: Text(
          'No patients in queue for this shift.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      itemBuilder: (context, index) {
        final appointment = patients[index];
        final statusUpper = appointment.status.toUpperCase();
        final isCompleted = statusUpper == "COMPLETED";
        final isCancelled = statusUpper == "CANCELLED";
        final isSkipped = statusUpper == "SKIPPED";
        final isInProgress = statusUpper == "IN_PROGRESS";
        final isWaiting = statusUpper == "ACCEPTED";

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  appointment.tokenNumber,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cleanPatientName(appointment.patientName),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (isWaiting) _buildStatusChip("WAITING", Colors.green),
              if (isInProgress) _buildStatusChip("IN PROGRESS", Colors.blue),
              if (isSkipped)
                Row(
                  children: [
                    _buildStatusChip("SKIPPED", Colors.orange),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: () async {
                        final slot = ref.read(liveQueueProvider).selectedSlot;
                        await notifier.recall(appointment.id, slot);
                      },
                      child: const Text("Recall"),
                    ),
                  ],
                ),
              if (isCompleted)
                Row(
                  children: [
                    _buildStatusChip("DONE", Colors.green),
                    if (!appointment.isWalkIn) ...[
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddPrescriptionScreen(
                                appointmentId: appointment.id,
                                patientName: appointment.patientName,
                                tokenNumber: appointment.tokenNumber,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          appointment.hasPrescription
                              ? "Update Rx"
                              : "Prescription",
                        ),
                      ),
                    ],
                  ],
                ),
              if (isCancelled) _buildStatusChip("NO SHOW", Colors.red),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  String _cleanPatientName(String label) {
    return label.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
  }
}
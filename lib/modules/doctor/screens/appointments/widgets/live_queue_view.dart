import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';

import '../../../controllers/live_queue_controller.dart';
import '../../../../../core/models/doctor/live_queue_model.dart';
import '../../../screens/appointments/add_prescription_screen.dart';
import '../../../../doctor/screens/incoming_appointment/incoming_appointment_screen.dart';

enum QueueShift { morning, evening }

class LiveQueueView extends ConsumerStatefulWidget {
  const LiveQueueView({super.key});

  @override
  ConsumerState<LiveQueueView> createState() => _LiveQueueViewState();
}

class _LiveQueueViewState extends ConsumerState<LiveQueueView> {
  QueueShift _currentShift = QueueShift.morning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // final historyState = ref.watch(appointmentHistoryProvider);
    final queueState = ref.watch(liveQueueProvider);
    final notifier = ref.read(liveQueueProvider.notifier);

    final todayAppointments = queueState.queue;

    if (queueState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final slot = _currentShift == QueueShift.morning ? "MORNING" : "EVENING";

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

    final currentPatientIndex = currentPatient != null
        ? filteredTodayAppointments.indexOf(currentPatient)
        : -1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Overview",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
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
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
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
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
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
    final isSelected = _currentShift == shift;
    final notifier = ref.read(liveQueueProvider.notifier);
    return GestureDetector(
      onTap: () async {
        setState(() {
          _currentShift = shift;
        });

        await notifier.loadQueue(
          shift == QueueShift.morning ? "MORNING" : "EVENING",
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 12,
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
            colorScheme.primaryContainer,
            colorScheme.onPrimaryContainer,
            theme,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildCounterCard(
            'Waiting',
            waiting.toString(),
            Colors.orange.transparency(0.12),
            Colors.orange.shade900,
            theme,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildCounterCard(
            'Done',
            done.toString(),
            Colors.green.transparency(0.12),
            Colors.green.shade900,
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor.transparency(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            count,
            style: theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w900,
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
            title: "Incoming Appointments",
            icon: Icons.access_time_filled,
            color: const Color(0xffDDF7FF),
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
        const SizedBox(width: 16),
        Expanded(
          child: _actionCard(
            title: "Skip Appointment",
            icon: Icons.skip_next_rounded,
            color: const Color(0xffFFF7DB),
            iconColor: Colors.orange,
            onTap: current == null
                ? null
                : () {
                    notifier.skip(current.id, slot);
                  },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _actionCard(
            title: "Mark No Show",
            icon: Icons.person_off,
            color: const Color(0xffFFECEC),
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
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: iconColor),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: iconColor,
              ),
            ),
          ],
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.transparency(0.4)),
      ),
      child: Column(
        children: [
          Row(
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
                      ? FilledButton.icon(
                          onPressed: () async {
                            await notifier.nextToken(slot);
                          },
                          icon: const Icon(Icons.stop_circle),
                          label: const Text("Stop Appointment"),
                        )
                      : null,
                ),
              ),
              Container(
                width: 1,
                height: 70,
                color: colorScheme.outlineVariant.transparency(0.5),
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("NEXT PATIENT", style: theme.textTheme.labelSmall),

                    const SizedBox(height: 8),

                    Text(
                      next != null
                          ? _cleanPatientName(next.patientName)
                          : "No Patient",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text("Token #${next?.tokenNumber ?? '-'}"),

                    const SizedBox(height: 15),

                    /// ---------- BUTTON ----------
                    if (current == null && next != null && hasWaitingPatient)
                      FilledButton.icon(
                        onPressed: () async {
                          await notifier.start(next.id, slot);
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Start Appointment"),
                      ),

                    if (current != null && next != null && hasWaitingPatient)
                      FilledButton.icon(
                        onPressed: () async {
                          await notifier.nextToken(slot);
                        },
                        icon: const Icon(Icons.skip_next),
                        label: const Text("Call Next Patient"),
                      ),
                  ],
                ),
              ),
            ],
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
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Token #$token',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (action != null) ...[const SizedBox(height: 15), action],
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
          const Divider(height: 1, thickness: 0.5),
      itemBuilder: (context, index) {
        final appointment = patients[index];
        final statusUpper = appointment.status.toUpperCase();
        final isCompleted = statusUpper == "COMPLETED";
        final isCancelled = statusUpper == "CANCELLED";
        final isSkipped = statusUpper == "SKIPPED";
        final isInProgress = statusUpper == "IN_PROGRESS";
        final isWaiting = statusUpper == "ACCEPTED";

        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primaryContainer.transparency(0.4),
                child: Text(
                  appointment.tokenNumber,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
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
                      style: theme.textTheme.bodyLarge?.copyWith(
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
                    FilledButton(
                      onPressed: () async {
                        final slot = _currentShift == QueueShift.morning
                            ? "MORNING"
                            : "EVENING";

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
                    const SizedBox(width: 8),
                    FilledButton(
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
                            ? "Update Prescription"
                            : "Prescription",
                      ),
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  String _cleanPatientName(String label) {
    return label.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
  }
}

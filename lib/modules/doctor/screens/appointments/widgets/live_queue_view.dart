import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';

import '../../../../../core/models/appointment_history_item.dart';
import '../../../controllers/appointment_history_controller.dart';

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
    final historyNotifier = ref.read(appointmentHistoryProvider.notifier);

    final todayAppointments = historyNotifier.getTodayLiveQueue();

    final filteredTodayAppointments = todayAppointments.where((app) {
      if (_currentShift == QueueShift.morning) {
        return app.shift.toLowerCase().contains('morning');
      } else {
        return app.shift.toLowerCase().contains('evening');
      }
    }).toList();

    final totalCount = filteredTodayAppointments.length;
    final completedCount = filteredTodayAppointments.where((app) => app.status.toUpperCase() == 'COMPLETED').length;
    final waitingCount = totalCount - completedCount;

    final AppointmentHistoryItem? currentPatient = filteredTodayAppointments.isEmpty
        ? null
        : filteredTodayAppointments.firstWhere(
          (app) => app.status.toUpperCase() == 'IN PROGRESS' || app.status.toUpperCase() == 'ONGOING',
      orElse: () {
        final remaining = filteredTodayAppointments.where((app) =>
        app.status.toUpperCase() != 'COMPLETED' &&
            app.status.toUpperCase() != 'CANCELLED' &&
            app.status.toUpperCase() != 'SKIPPED'
        ).toList();
        return remaining.isNotEmpty ? remaining.first : filteredTodayAppointments.first;
      },
    );

    final currentPatientIndex = currentPatient != null ? filteredTodayAppointments.indexOf(currentPatient) : -1;
    AppointmentHistoryItem? nextPatient;

    if (currentPatientIndex != -1 && currentPatientIndex + 1 < filteredTodayAppointments.length) {
      final remainingNext = filteredTodayAppointments.sublist(currentPatientIndex + 1).where(
              (app) => app.status.toUpperCase() != 'COMPLETED' && app.status.toUpperCase() != 'CANCELLED'
      ).toList();
      if (remainingNext.isNotEmpty) {
        nextPatient = remainingNext.first;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Overview",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            _buildShiftToggle(colorScheme),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildCounterCards(totalCount, waitingCount, completedCount, colorScheme, theme),
        const SizedBox(height: AppSpacing.lg),

        _buildTrackerSection(currentPatient, nextPatient, historyNotifier, colorScheme, theme),
        const SizedBox(height: AppSpacing.lg),

        Text(
          'Patient List',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildPatientListSection(filteredTodayAppointments, historyNotifier, colorScheme, theme),
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

  Widget _buildShiftButton(String text, QueueShift shift, ColorScheme colorScheme) {
    final isSelected = _currentShift == shift;
    return GestureDetector(
      onTap: () => setState(() => _currentShift = shift),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterCards(int total, int waiting, int done, ColorScheme colorScheme, ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildCounterCard('Total', total.toString(), colorScheme.primaryContainer, colorScheme.onPrimaryContainer, theme)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _buildCounterCard('Waiting', waiting.toString(), Colors.orange.transparency(0.12), Colors.orange.shade900, theme)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _buildCounterCard('Done', done.toString(), Colors.green.transparency(0.12), Colors.green.shade900, theme)),
      ],
    );
  }

  Widget _buildCounterCard(String label, String count, Color bgColor, Color textColor, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: textColor.transparency(0.8), fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Text(count, style: theme.textTheme.titleLarge?.copyWith(color: textColor, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTrackerSection(AppointmentHistoryItem? current, AppointmentHistoryItem? next, AppointmentHistoryNotifier notifier, ColorScheme colorScheme, ThemeData theme) {
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
                  current != null ? _cleanPatientName(current.patientLabel) : 'None',
                  current?.tokenNumber ?? '-',
                  colorScheme.primary,
                  theme,
                ),
              ),
              Container(width: 1, height: 70, color: colorScheme.outlineVariant.transparency(0.5), margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md)),
              Expanded(
                child: _buildPatientTrackCard(
                  'NEXT PATIENT',
                  next != null ? _cleanPatientName(next.patientLabel) : 'No patient',
                  next?.tokenNumber ?? '-',
                  colorScheme.onSurfaceVariant,
                  theme,
                ),
              ),
            ],
          ),
          if (current != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => notifier.skipPatient(current.tokenNumber),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: BorderSide(color: Colors.orange.transparency(0.4)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.skip_next_rounded, size: 18),
                    label: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => notifier.cancelPatient(current.tokenNumber),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error.transparency(0.4)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.person_off_rounded, size: 18),
                    label: const Text('No Show'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => notifier.completePatient(current.tokenNumber),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Done'),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildPatientTrackCard(String title, String name, String token, Color accentColor, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: AppSpacing.xs),
        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text('Token #$token', style: theme.textTheme.bodyMedium?.copyWith(color: accentColor, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildPatientListSection(List<dynamic> patients, AppointmentHistoryNotifier notifier, ColorScheme colorScheme, ThemeData theme) {
    if (patients.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        alignment: Alignment.center,
        child: Text('No patients in queue for this shift.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 0.5),
      itemBuilder: (context, index) {
        final appointment = patients[index];
        final statusUpper = appointment.status.toUpperCase();
        final isCompleted = statusUpper == 'COMPLETED';
        final isCancelled = statusUpper == 'CANCELLED';
        final isSkipped = statusUpper == 'SKIPPED';

        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primaryContainer.transparency(0.4),
                child: Text(
                  appointment.tokenNumber,
                  style: theme.textTheme.titleSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_cleanPatientName(appointment.patientLabel), style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                    Text(appointment.shift, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (!isCompleted && !isCancelled && !isSkipped)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.transparency(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('WAITING', style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 10)),
                )
              else
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCancelled
                            ? colorScheme.errorContainer.transparency(0.4)
                            : isSkipped
                            ? Colors.orange.transparency(0.12)
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusUpper,
                        style: TextStyle(
                          color: isCancelled
                              ? colorScheme.error
                              : isSkipped
                              ? Colors.orange.shade900
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.assignment_turned_in_rounded, color: colorScheme.primary, size: 20),
                        tooltip: 'Prescription',
                      ),
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  String _cleanPatientName(String label) {
    return label.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
  }
}
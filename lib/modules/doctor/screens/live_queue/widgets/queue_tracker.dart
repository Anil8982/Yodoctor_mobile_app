import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import '../../../controllers/live_queue_controller.dart';
import '../../../models/appointment/live_queue_model.dart';

class QueueTracker extends ConsumerWidget {
  final LiveQueueItem? current;
  final LiveQueueItem? next;
  final bool hasWaitingPatient;

  const QueueTracker({
    super.key,
    required this.current,
    required this.next,
    required this.hasWaitingPatient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifier = ref.read(liveQueueProvider.notifier);
    final slot = ref.watch(
      liveQueueProvider.select((state) => state.selectedSlot),
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current Patient Section
          _buildPatientSection(
            context: context,
            title: 'CURRENT PATIENT',
            name: current?.patientName ?? 'No Patient Inside',
            token: current?.tokenNumber ?? '-',
            accentColor: colorScheme.primary,
            containerColor: colorScheme.primaryContainer.withValues(
              alpha: 0.35,
            ),
            borderColor: colorScheme.primary.withValues(alpha: 0.4),
            isLive: current != null,
            action: (current != null && !hasWaitingPatient)
                ? SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => notifier.nextToken(slot),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                ),
                icon: const Icon(Icons.stop_circle_rounded, size: 18),
                label: const Text("Finish Consultation"),
              ),
            )
                : null,
          ),

          const SizedBox(height: AppSpacing.md),

          // Next Patient Section
          _buildPatientSection(
            context: context,
            title: 'NEXT PATIENT',
            name: next?.patientName ?? 'No Patient in Queue',
            token: next?.tokenNumber ?? '-',
            accentColor: colorScheme.secondary,
            containerColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            borderColor: colorScheme.outlineVariant.withValues(alpha: 0.5),
            isLive: next != null,
            action: () {
              if (current == null && next != null && hasWaitingPatient) {
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => notifier.start(next!.id, slot),
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text("Start Consultation"),
                  ),
                );
              }
              if (current != null && next != null && hasWaitingPatient) {
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => notifier.nextToken(slot),
                    icon: const Icon(Icons.skip_next_rounded, size: 18),
                    label: const Text("Call Next Patient"),
                  ),
                );
              }
              return null;
            }(),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientSection({
    required BuildContext context,
    required String title,
    required String name,
    required String token,
    required Color accentColor,
    required Color containerColor,
    required Color borderColor,
    required bool isLive,
    Widget? action,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (isLive) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Container(
                  key: ValueKey<String>(token),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Token #$token',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              name,
              key: ValueKey<String>(name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
                color: isLive
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: action != null
                ? Padding(
              key: const ValueKey<bool>(true),
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: action,
            )
                : const SizedBox.shrink(key: ValueKey<bool>(false)),
          ),
        ],
      ),
    );
  }
}
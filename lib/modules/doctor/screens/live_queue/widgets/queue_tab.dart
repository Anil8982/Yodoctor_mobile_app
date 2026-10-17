import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';

import '../../../controllers/live_queue_controller.dart';
import 'live_queue_shimmer.dart';
import 'queue_overview.dart';
import 'queue_patient_list.dart';
import 'queue_tracker.dart';

class QueueTab extends ConsumerWidget {
  const QueueTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(liveQueueProvider);
    final notifier = ref.read(liveQueueProvider.notifier);
    final theme = Theme.of(context);

    if (state.loading) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: LiveQueueShimmer(),
        ),
      );
    }

    final todayAppointments = state.queue;
    final waitingCount = todayAppointments
        .where((e) => e.status.toUpperCase() == "ACCEPTED")
        .length;
    final completedCount = todayAppointments
        .where((e) => e.status.toUpperCase() == 'COMPLETED')
        .length;

    return RefreshIndicator(
      onRefresh: () async {
        await notifier.refresh();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QueueOverview(
                      totalCount: todayAppointments.length,
                      waitingCount: waitingCount,
                      completedCount: completedCount,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    QueueTracker(
                      current: state.current,
                      next: state.next,
                      hasWaitingPatient: todayAppointments.any(
                            (e) => e.status.toUpperCase() == "ACCEPTED",
                      ),
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
                    QueuePatientList(patients: todayAppointments),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
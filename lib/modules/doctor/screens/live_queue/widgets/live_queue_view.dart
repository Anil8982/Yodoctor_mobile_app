import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import '../../../controllers/incoming_appointment_controller.dart';
import '../../../controllers/live_queue_controller.dart';
import 'queue_tab.dart';
import 'incoming_tab.dart';

class LiveQueueView extends ConsumerStatefulWidget {
  final int initialIndex;

  const LiveQueueView({
    super.key,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<LiveQueueView> createState() => _LiveQueueViewState();
}

class _LiveQueueViewState extends ConsumerState<LiveQueueView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final queueState = ref.watch(liveQueueProvider);
    final waitingCount = queueState.queue
        .where((e) => e.status.toUpperCase() == "ACCEPTED")
        .length;

    final incomingState = ref.watch(incomingAppointmentProvider);
    final pendingCount = incomingState.appointments.where((e) {
      final status = e.status.toUpperCase();
      return status == "PENDING" || status == "REQUESTED";
    }).length;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          dividerColor: colorScheme.outlineVariant,
          dividerHeight: 1,
          indicatorColor: colorScheme.primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Queue'),
                  if (waitingCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        waitingCount.toString(),
                        style: TextStyle(
                          color: colorScheme.onError,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Incoming'),
                  if (pendingCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        pendingCount.toString(),
                        style: TextStyle(
                          color: colorScheme.onError,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              QueueTab(),
              IncomingTab(),
            ],
          ),
        ),
      ],
    );
  }
}
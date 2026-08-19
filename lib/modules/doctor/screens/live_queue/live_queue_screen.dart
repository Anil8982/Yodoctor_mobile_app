import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import '../../controllers/live_queue_controller.dart';
import 'widgets/live_queue_view.dart';

class LiveQueueScreen extends ConsumerWidget {
  final int initialIndex;

  const LiveQueueScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isRefreshing = ref.watch(
      liveQueueProvider.select((state) => state.refreshing),
    );

    Future<void> refresh() async {
      await ref.read(liveQueueProvider.notifier).refresh();
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: "Today's Queue",
        actions: [
          IconButton(
            tooltip: 'Refresh Queue',
            onPressed: isRefreshing ? null : refresh,
            icon: isRefreshing
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onPrimary,
              ),
            )
                : const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: LiveQueueView(initialIndex: initialIndex),
        ),
      ),
    );
  }
}
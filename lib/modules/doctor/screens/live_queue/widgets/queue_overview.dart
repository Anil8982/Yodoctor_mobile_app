import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import '../../../controllers/live_queue_controller.dart';

enum QueueShift { morning, evening }

class QueueOverview extends ConsumerStatefulWidget {
  final int totalCount;
  final int waitingCount;
  final int completedCount;

  const QueueOverview({
    super.key,
    required this.totalCount,
    required this.waitingCount,
    required this.completedCount,
  });

  @override
  ConsumerState<QueueOverview> createState() => _QueueOverviewState();
}

class _QueueOverviewState extends ConsumerState<QueueOverview> {
  bool _isExpanded = true;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifier = ref.read(liveQueueProvider.notifier);
    final queueState = ref.watch(liveQueueProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Overview",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: _toggleExpand,
                  icon: AnimatedRotation(
                    turns: _isExpanded ? 0.0 : 0.5, // Smooth 180-degree flip
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  splashRadius: 20,
                  tooltip: _isExpanded
                      ? "Collapse Overview"
                      : "Expand Overview",
                ),
              ],
            ),
            _buildShiftToggle(colorScheme, ref),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Fakt Counter cards la AnimatedCrossFade madhe thevla ahe (Hide/Show sathi)
        AnimatedCrossFade(
          firstChild: _buildCounterCards(
            widget.totalCount,
            widget.waitingCount,
            widget.completedCount,
            colorScheme,
            theme,
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),

        const SizedBox(height: AppSpacing.md),

        _buildActionCards(
          notifier,
          queueState.current,
          queueState.selectedSlot,
        ),
      ],
    );
  }

  Widget _buildShiftToggle(ColorScheme colorScheme, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildShiftButton('Morning', QueueShift.morning, colorScheme, ref),
          _buildShiftButton('Evening', QueueShift.evening, colorScheme, ref),
        ],
      ),
    );
  }

  Widget _buildShiftButton(
    String text,
    QueueShift shift,
    ColorScheme colorScheme,
    WidgetRef ref,
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
          color: isSelected ? colorScheme.primary : AppTheme.transparent,
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
            AppTheme.info(context),
            theme,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildCounterCard(
            'Waiting',
            waiting.toString(),
            colorScheme.surfaceContainerLow,
            AppTheme.pending(context),
            theme,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildCounterCard(
            'Done',
            done.toString(),
            colorScheme.surfaceContainerLow,
            AppTheme.success(context).withValues(),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Color.alphaBlend(textColor.withValues(alpha: 0.06), bgColor),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: textColor.withValues(alpha: 0.2), width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(LiveQueueNotifier notifier, current, String slot) {
    final bool isEnabled = current != null;

    return Row(
      children: [
        Expanded(
          child: _actionCard(
            title: "Skip",
            icon: Icons.skip_next_rounded,
            color: AppTheme.orange,
            isEnabled: isEnabled,
            onTap: isEnabled ? () => notifier.skip(current.id, slot) : null,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _actionCard(
            title: "No Show",
            icon: Icons.person_off_rounded,
            color: AppTheme.red,
            isEnabled: isEnabled,
            onTap: isEnabled ? () => notifier.noShow(slot) : null,
          ),
        ),
      ],
    );
  }

  Widget _actionCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isEnabled,
    VoidCallback? onTap,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.45,
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: color,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

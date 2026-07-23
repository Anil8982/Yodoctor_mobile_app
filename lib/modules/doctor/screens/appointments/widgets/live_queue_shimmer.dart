import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

/// LiveQueue specific shimmer skeleton that mimics the actual UI layout.
/// Uses AppShimmer, ShimmerBox, and ShimmerCircle for a consistent shimmer experience.
class LiveQueueShimmer extends StatelessWidget {
  const LiveQueueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Overview" title + shift toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerBox(width: 100, height: 24),
              const ShimmerBox(
                width: 150,
                height: 40,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 3 Counter cards (Total, Waiting, Done)
          Row(
            children: [
              Expanded(
                child: ShimmerBox(
                  height: 80,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ShimmerBox(
                  height: 80,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ShimmerBox(
                  height: 80,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 3 Action cards (Incoming, Skip, No Show)
          Row(
            children: [
              Expanded(
                child: ShimmerBox(
                  height: 120,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ShimmerBox(
                  height: 120,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ShimmerBox(
                  height: 120,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Current/Next Patient tracker card
          ShimmerBox(
            height: 140,
            borderRadius: const BorderRadius.all(Radius.circular(28)),
          ),
          const SizedBox(height: AppSpacing.lg),

          // "Patient List" title
          const ShimmerBox(width: 110, height: 24),
          const SizedBox(height: AppSpacing.md),

          // 4 Patient list items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, _) => Row(
              children: [
                const ShimmerCircle(size: 44),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ShimmerBox(
                    height: 18,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                const SizedBox(width: 16),
                ShimmerChip(
                  width: 70,
                  height: 28,
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

class LiveQueueShimmer extends StatelessWidget {
  const LiveQueueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: "Overview" title + Shift toggle (Morning/Evening)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerBox(width: 90, height: 26),
              const ShimmerBox(
                width: 160,
                height: 38,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // 2. 3 Counter cards (Total, Waiting, Done)
          Row(
            children: [
              Expanded(
                child: ShimmerBox(
                  height: 72,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ShimmerBox(
                  height: 72,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ShimmerBox(
                  height: 72,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 3. 2 Action cards (Skip, No Show)
          Row(
            children: [
              Expanded(
                child: ShimmerBox(
                  height: 52,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ShimmerBox(
                  height: 52,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 4. Current & Next Patient Tracker Card Container
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                // Current Patient Shimmer Section
                const ShimmerBox(
                  height: 95,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                const SizedBox(height: AppSpacing.md),
                // Next Patient Shimmer Section
                const ShimmerBox(
                  height: 95,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 5. "Patient List" title
          const ShimmerBox(width: 110, height: 24),
          const SizedBox(height: AppSpacing.md),

          // 6. Patient list items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (_, _) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  const ShimmerCircle(size: 44),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(
                          width: double.infinity,
                          height: 16,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        SizedBox(height: 6),
                        ShimmerBox(
                          width: 80,
                          height: 12,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const ShimmerBox(
                    width: 70,
                    height: 32,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
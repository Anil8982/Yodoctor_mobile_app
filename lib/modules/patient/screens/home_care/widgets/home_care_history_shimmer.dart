import 'package:flutter/material.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

class HomeCareHistoryShimmer extends StatelessWidget {
  const HomeCareHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: ID & Status Badge shimmer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ShimmerBox(
                          width: 26,
                          height: 26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(width: 8),
                        ShimmerBox(
                          width: 80,
                          height: 12,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    ShimmerBox(
                      width: 76,
                      height: 22,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Service Title shimmer
                ShimmerBox(
                  width: 160,
                  height: 18,
                  borderRadius: BorderRadius.circular(6),
                ),

                const SizedBox(height: 12),

                // Patient Info Container shimmer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      ShimmerBox(
                        width: 32,
                        height: 32,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                            width: 120,
                            height: 14,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          const SizedBox(height: 6),
                          ShimmerBox(
                            width: 90,
                            height: 10,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Location row shimmer
                Row(
                  children: [
                    ShimmerBox(
                      width: 16,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShimmerBox(
                        width: double.infinity,
                        height: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
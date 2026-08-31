import 'package:flutter/material.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

class MySubscriptionShimmer extends StatelessWidget {
  const MySubscriptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: AppShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Card Shimmer
                _buildPlanCardShimmer(colorScheme),
                const SizedBox(height: 32),

                // Stats Row Shimmer - ✅ FIXED: Wrap with LayoutBuilder
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = (constraints.maxWidth - 24) / 3;
                    return Row(
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: _buildStatCardShimmer(colorScheme),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: cardWidth,
                          child: _buildStatCardShimmer(colorScheme),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: cardWidth,
                          child: _buildStatCardShimmer(colorScheme),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Button Shimmer
                _buildButtonShimmer(colorScheme),
                const SizedBox(height: 20),

                // History Shimmer
                _buildHistoryShimmer(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCardShimmer(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 120, height: 14, borderRadius: BorderRadius.all(Radius.circular(7))),
          const SizedBox(height: 12),
          const ShimmerBox(width: 80, height: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
          const SizedBox(height: 20),
          const ShimmerBox(width: 60, height: 24, borderRadius: BorderRadius.all(Radius.circular(12))),
          const SizedBox(height: 16),
          const ShimmerChip(width: 70, height: 28),
          const SizedBox(height: 16),
          Row(
            children: [
              const ShimmerBox(width: 100, height: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
              const SizedBox(width: 8),
              const ShimmerBox(width: 80, height: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardShimmer(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerCircle(size: 20),
          const SizedBox(height: 12),
          const ShimmerBox(width: 60, height: 14, borderRadius: BorderRadius.all(Radius.circular(7))),
          const SizedBox(height: 4),
          const ShimmerBox(width: 80, height: 10, borderRadius: BorderRadius.all(Radius.circular(5))),
        ],
      ),
    );
  }

  Widget _buildButtonShimmer(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  Widget _buildHistoryShimmer(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 130, height: 16, borderRadius: BorderRadius.all(Radius.circular(8))),
          const SizedBox(height: 16),
          ...List.generate(2, (index) {
            return Padding(
              padding: EdgeInsets.only(top: index > 0 ? 12 : 0),
              child: Row(
                children: [
                  const ShimmerBox(width: 44, height: 44, borderRadius: BorderRadius.all(Radius.circular(12))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerBox(width: 100, height: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Expanded(child: ShimmerBox(height: 10, borderRadius: BorderRadius.all(Radius.circular(5)))),
                            const SizedBox(width: 8),
                            const Expanded(child: ShimmerBox(height: 10, borderRadius: BorderRadius.all(Radius.circular(5)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const ShimmerChip(width: 60, height: 24),
                  const SizedBox(width: 12),
                  const ShimmerBox(width: 50, height: 14, borderRadius: BorderRadius.all(Radius.circular(7))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
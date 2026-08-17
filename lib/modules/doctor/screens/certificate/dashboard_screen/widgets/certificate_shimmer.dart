import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

/// Certificate dashboard body shimmer - shows ONLY the content area shimmer
/// while keeping the actual app bar visible above.
/// Used during first load when certificate data is being fetched.
class CertificateDashboardShimmer extends StatelessWidget {
  const CertificateDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards shimmer
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                _buildShimmerCard(),
                const SizedBox(width: AppSpacing.md),
                _buildShimmerCard(),
                const SizedBox(width: AppSpacing.md),
                _buildShimmerCard(),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Toolbar shimmer
          Column(
            children: [
              ShimmerBox(
                height: 48,
                borderRadius: BorderRadius.circular(14),
              ),
              if (isMobile) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: ShimmerBox(
                        height: 48,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ShimmerBox(
                        height: 48,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Certificate list shimmer (4 items)
          Column(
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ShimmerBox(
                  height: isMobile ? 160 : 100,
                  borderRadius: BorderRadius.circular(24),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return ShimmerBox(
      width: 150,
      height: 85,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
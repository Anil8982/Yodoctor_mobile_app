import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

class SubscriptionVerificationShimmer extends StatelessWidget {
  const SubscriptionVerificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: AppShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔔 Banner Shimmer
                _buildBannerShimmer(),
                const SizedBox(height: 24),

                // 📢 Header Shimmer
                _buildHeaderShimmer(),
                const SizedBox(height: 24),

                // 💳 Plan Card Shimmer
                _buildPlanCardShimmer(),
                const SizedBox(height: 24),

                // ✨ Features Grid Shimmer
                _buildFeaturesShimmer(),
                const SizedBox(height: 24),

                // 📊 Plans Row Shimmer
                _buildPlansRowShimmer(),
                const SizedBox(height: 24),

                // 🔄 Button Shimmer
                _buildButtonShimmer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.transparency(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const ShimmerCircle(size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 180, height: 14, borderRadius: BorderRadius.all(Radius.circular(7))),
                const SizedBox(height: 8),
                const ShimmerBox(width: 250, height: 10, borderRadius: BorderRadius.all(Radius.circular(5))),
              ],
            ),
          ),
          const ShimmerCircle(size: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: 200, height: 24, borderRadius: BorderRadius.all(Radius.circular(12))),
        const SizedBox(height: 12),
        const ShimmerBox(width: double.infinity, height: 14, borderRadius: BorderRadius.all(Radius.circular(7))),
        const SizedBox(height: 6),
        ShimmerBox(
          width: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.width * 0.7,
          height: 14,
          borderRadius: const BorderRadius.all(Radius.circular(7)),
        ),
      ],
    );
  }

  Widget _buildPlanCardShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.transparency(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.transparency(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const ShimmerBox(width: 150, height: 16, borderRadius: BorderRadius.all(Radius.circular(8))),
          const SizedBox(height: 12),
          // Subtitle
          const ShimmerBox(width: 100, height: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
          const SizedBox(height: 20),
          // Price
          const ShimmerBox(width: 80, height: 28, borderRadius: BorderRadius.all(Radius.circular(14))),
          const SizedBox(height: 16),
          // Status badge
          const ShimmerChip(width: 80, height: 28),
          const SizedBox(height: 16),
          // Next billing
          Row(
            children: [
              const ShimmerBox(width: 120, height: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
              const SizedBox(width: 8),
              const ShimmerBox(width: 80, height: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: 150, height: 18, borderRadius: BorderRadius.all(Radius.circular(9))),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.transparency(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.transparency(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ShimmerCircle(size: 24),
                  const SizedBox(height: 12),
                  const ShimmerBox(width: 120, height: 12, borderRadius: BorderRadius.all(Radius.circular(6))),
                  const SizedBox(height: 6),
                  const ShimmerBox(width: 100, height: 10, borderRadius: BorderRadius.all(Radius.circular(5))),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlansRowShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ShimmerBox(width: 130, height: 18, borderRadius: BorderRadius.all(Radius.circular(9))),
            const ShimmerBox(width: 70, height: 14, borderRadius: BorderRadius.all(Radius.circular(7))),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.transparency(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.transparency(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerBox(width: 130, height: 14, borderRadius: BorderRadius.all(Radius.circular(7))),
                      const SizedBox(height: 8),
                      const ShimmerBox(width: 80, height: 10, borderRadius: BorderRadius.all(Radius.circular(5))),
                      const Spacer(),
                      const ShimmerBox(width: 60, height: 22, borderRadius: BorderRadius.all(Radius.circular(11))),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.transparency(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButtonShimmer() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.transparency(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.transparency(0.15)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

/// Certificate review screen shimmer skeleton
class CertificateReviewShimmer extends StatelessWidget {
  const CertificateReviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Patient info panel shimmer
            ShimmerBox(
              height: 350,
              borderRadius: BorderRadius.circular(24),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (!isMobile) ...[
              const SizedBox(height: AppSpacing.xl),
              // Action form shimmer
              ShimmerBox(
                height: 450,
                borderRadius: BorderRadius.circular(24),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
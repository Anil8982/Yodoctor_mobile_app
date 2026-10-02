import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

/// Doctor Dashboard body shimmer - shows ONLY the content area shimmer
/// while keeping the actual DoctorHeader visible above.
/// Used during first load when dashboard data is being fetched.
class DoctorDashboardBodyShimmer extends StatelessWidget {
  const DoctorDashboardBodyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl + 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action cards row (2 on mobile, 3 on desktop)
            if (isMobile) ...[
              Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      height: 140,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ShimmerBox(
                      height: 140,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      height: 140,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShimmerBox(
                      height: 140,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShimmerBox(
                      height: 140,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Stat cards
            if (isMobile) ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - AppSpacing.sm) / 2;
                  return Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: ShimmerBox(
                          height: 120,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: ShimmerBox(
                          height: 120,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth,
                        child: ShimmerBox(
                          height: 120,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      height: 140,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShimmerBox(
                      height: 140,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShimmerBox(
                      height: 140,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppSpacing.md),

            // Direct Booking Card shimmer
            ShimmerBox(
              height: 180,
              borderRadius: BorderRadius.circular(24),
            ),

            const SizedBox(height: AppSpacing.md),

            // Mini action cards
            if (isMobile) ...[
              Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      height: 130,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ShimmerBox(
                      height: 130,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      height: 130,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShimmerBox(
                      height: 130,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShimmerBox(
                      height: 130,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
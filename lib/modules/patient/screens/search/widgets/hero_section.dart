import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/gradient_background.dart';

import 'doctor_search_widget.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onSearch;

  const HeroSection({
    super.key,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return GradientBackground(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        topPadding + 70,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: DoctorSearchWidget(
        isHero: true,
        onSearchOverride: onSearch,
      ),
    );
  }
}
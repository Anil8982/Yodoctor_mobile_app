import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';

import 'doctor_search_widget.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onSearch;

  const HeroSection({
    super.key,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: colorScheme.primary,
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
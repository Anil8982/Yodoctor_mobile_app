import 'package:flutter/material.dart';
import '../../../../../core/utils/app_spacing.dart';
import '../../../../../core/widgets/app_search_field.dart';
import '../../../../../core/widgets/gradient_background.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.locationController,
    required this.searchController,
    required this.onSearchTap,
    required this.onLocationChanged,
    required this.onQueryChanged,
    required this.searchLayerLink,
  });

  final TextEditingController locationController;
  final TextEditingController searchController;
  final VoidCallback onSearchTap;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onQueryChanged;
  final LayerLink searchLayerLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return GradientBackground(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        topPadding + 70,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        children: <Widget>[
          // Text(
          //   'Your Doctor, Your Health',
          //   style: theme.textTheme.headlineMedium?.copyWith(
          //     color: colorScheme.onPrimary,
          //     fontWeight: FontWeight.w900,
          //   ),
          // ),
          // const SizedBox(height: AppSpacing.xl),
          _buildSearchWrapper(
            colorScheme,
            child: AppSearchField(
              controller: locationController,
              hintText: 'Location',
              onChanged: onLocationChanged,
              prefixIcon: Icon(
                Icons.location_on_rounded,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: CompositedTransformTarget(
                  link: searchLayerLink,
                  child: _buildSearchWrapper(
                    colorScheme,
                    child: AppSearchField(
                      controller: searchController,
                      hintText: 'Search doctors...',
                      onChanged: onQueryChanged,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildSearchButton(colorScheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton(ColorScheme colorScheme) {
    return InkWell(
      onTap: onSearchTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildSearchWrapper(ColorScheme colorScheme, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

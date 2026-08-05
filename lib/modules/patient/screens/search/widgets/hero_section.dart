import 'package:flutter/material.dart';
import '../../../../../core/utils/app_spacing.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/gradient_background.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.locationController,
    required this.searchController,
    required this.onSearchTap,
    required this.onLocationChanged,
    required this.onQueryChanged,
    required this.searchLayerLink,
    required this.locationLayerLink,
  });

  final TextEditingController locationController;
  final TextEditingController searchController;
  final VoidCallback onSearchTap;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onQueryChanged;
  final LayerLink searchLayerLink;
  final LayerLink locationLayerLink;

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
          CompositedTransformTarget(
            link: locationLayerLink,
            child: _buildSearchWrapper(
              colorScheme,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: locationController,
                builder: (context, value, child) {
                  return AppSearchField(
                    controller: locationController,
                    hintText: 'Location',
                    onChanged: onLocationChanged,
                    prefixIcon: Icon(
                      Icons.location_on_rounded,
                      color: colorScheme.primary,
                    ),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20),
                      onPressed: () {
                        locationController.clear();
                        onLocationChanged('');
                      },
                    )
                        : null,
                  );
                },
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
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: searchController,
                      builder: (context, value, child) {
                        return AppSearchField(
                          controller: searchController,
                          hintText: 'Search doctors...',
                          onChanged: onQueryChanged,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: colorScheme.primary,
                          ),
                          suffixIcon: value.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              searchController.clear();
                              onQueryChanged('');
                            },
                          )
                              : null,
                        );
                      },
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
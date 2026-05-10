import 'package:chroma_kit/chroma_kit.dart';
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
  });

  final TextEditingController locationController;
  final TextEditingController searchController;
  final VoidCallback onSearchTap;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return GradientBackground(
      // Gradient madhe Material Colors vapra (Primary to PrimaryFixed/Tertiary)
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        topPadding + 20,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Your Doctor, Your Health',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Search for Clinics, Doctors & Diseases',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.transparency(0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Location Search Field
          _buildSearchWrapper(
            colorScheme,
            child: AppSearchField(
              controller: locationController,
              hintText: 'Location',
              onChanged: onLocationChanged,
              prefixIcon: Icon(Icons.location_on_rounded, color: colorScheme.primary),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: _buildSearchWrapper(
                  colorScheme,
                  child: AppSearchField(
                    controller: searchController,
                    hintText: 'Search doctors...',
                    onChanged: onQueryChanged,
                    prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Action Button using Material Primary Container
              InkWell(
                onTap: onSearchTap,
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.transparency(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Icon(Icons.arrow_forward_rounded, color: colorScheme.onPrimaryContainer),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Material 3 Container for Search Fields
  Widget _buildSearchWrapper(ColorScheme colorScheme, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.transparency(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }
}
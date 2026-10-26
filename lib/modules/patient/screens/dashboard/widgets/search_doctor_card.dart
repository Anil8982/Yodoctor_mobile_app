import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/responsive.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/controllers/patient_search_controller.dart';

class SearchDoctorCard extends ConsumerStatefulWidget {
  final bool isSearch;

  const SearchDoctorCard({super.key, this.isSearch = false});

  @override
  ConsumerState<SearchDoctorCard> createState() => _SearchDoctorCardState();
}

class _SearchDoctorCardState extends ConsumerState<SearchDoctorCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchState = ref.read(patientSearchControllerProvider);
      if (searchState.specialties.isEmpty) {
        ref.read(patientSearchControllerProvider.notifier).initialize();
      }
    });
  }

  void _onSearchTap() {
    context.push(AppRoutes.search);
  }

  void _onSpecialtyTap(String specialty) {
    ref.read(patientSearchControllerProvider.notifier).selectSpecialty(specialty);
    context.push('${AppRoutes.search}?q=${Uri.encodeComponent(specialty)}');
  }

  IconData _getSpecialtyIcon(String specialty) {
    final lower = specialty.toLowerCase();
    if (lower.contains('general') || lower.contains('physician')) {
      return Icons.medical_services_outlined;
    } else if (lower.contains('cardio') || lower.contains('heart')) {
      return Icons.favorite_outline_rounded;
    } else if (lower.contains('dent') || lower.contains('tooth')) {
      return Icons.mood_rounded;
    } else if (lower.contains('pediatric') ||
        lower.contains('child') ||
        lower.contains('baby')) {
      return Icons.child_care_rounded;
    } else if (lower.contains('ortho') ||
        lower.contains('bone') ||
        lower.contains('joint')) {
      return Icons.accessibility_new_rounded;
    } else if (lower.contains('neuro') || lower.contains('brain')) {
      return Icons.psychology_outlined;
    } else if (lower.contains('eye') || lower.contains('ophthalm')) {
      return Icons.visibility_outlined;
    } else if (lower.contains('skin') || lower.contains('derma')) {
      return Icons.face_retouching_natural_outlined;
    } else if (lower.contains('ent') || lower.contains('ear')) {
      return Icons.hearing_outlined;
    } else if (lower.contains('gyn') || lower.contains('women')) {
      return Icons.female_rounded;
    } else if (lower.contains('physi') || lower.contains('therapy')) {
      return Icons.fitness_center_rounded;
    }
    return Icons.local_hospital_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isMobile = Responsive.isMobile(context);

    final searchState = ref.watch(patientSearchControllerProvider);
    final specialties = searchState.specialties;
    final displayedSpecialties = specialties.take(8).toList();

    final locationText = searchState.locationQuery.isNotEmpty
        ? searchState.locationQuery
        : l10n.location;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Section Title
        Text(
          l10n.findDoctors,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: -0.4,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 2. Responsive Search Bar
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onSearchTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(
                      alpha: isDark ? 0.25 : 0.05,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${l10n.searchDoctors}, clinics...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    height: 18,
                    width: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Icon(
                    Icons.location_on_outlined,
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    flex: 2,
                    child: Text(
                      locationText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 3. Specialties Grid (Gap reduced with EdgeInsets.zero & compact SizedBox)
        if (displayedSpecialties.isNotEmpty) ...[
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: displayedSpecialties.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 4 : 8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final specialty = displayedSpecialties[index];
              return _buildSpecialtyTile(
                context: context,
                specialty: specialty,
                icon: _getSpecialtyIcon(specialty),
                colorScheme: colorScheme,
                theme: theme,
              );
            },
          ),
        ] else if (searchState.isLoading) ...[
          const SizedBox(height: 10),
          _buildSpecialtiesShimmer(isMobile, colorScheme),
        ],
      ],
    );
  }

  Widget _buildSpecialtyTile({
    required BuildContext context,
    required String specialty,
    required IconData icon,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: () => _onSpecialtyTap(specialty),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            specialty,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesShimmer(bool isMobile, ColorScheme colorScheme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 4 : 8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 44,
              height: 10,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        );
      },
    );
  }
}
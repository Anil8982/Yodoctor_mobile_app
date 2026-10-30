import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
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

    final searchState = ref.watch(patientSearchControllerProvider);
    final specialties = searchState.specialties;

    final locationText = searchState.locationQuery.isNotEmpty
        ? searchState.locationQuery
        : l10n.location;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Search Bar
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

        const SizedBox(height: 16),

        // 2. Section Header: Specializations + See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.featuredSpecialties,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: -0.3,
                color: colorScheme.onSurface,
              ),
            ),
            InkWell(
              onTap: _onSearchTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.viewAll,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3. Specialties Single Line Horizontal Scroll
        if (specialties.isNotEmpty) ...[
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: specialties.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final specialty = specialties[index];
                return _buildSpecialtyItem(
                  context: context,
                  specialty: specialty,
                  icon: _getSpecialtyIcon(specialty),
                  colorScheme: colorScheme,
                  theme: theme,
                );
              },
            ),
          ),
        ] else if (searchState.isLoading) ...[
          _buildSpecialtiesShimmer(colorScheme),
        ],
      ],
    );
  }

  Widget _buildSpecialtyItem({
    required BuildContext context,
    required String specialty,
    required IconData icon,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onSpecialtyTap(specialty),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    width: 1.1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
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
        ),
      ),
    );
  }

  Widget _buildSpecialtiesShimmer(ColorScheme colorScheme) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 72,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 48,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';

class SearchDoctorCard extends StatelessWidget {
  const SearchDoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(AppRoutes.search),
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.transparency(0.85),
                colorScheme.primary.transparency(0.75),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: colorScheme.onPrimary.transparency(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.transparency(isDark ? 0.25 : 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Decorative Icon Watermark
              Positioned(
                right: -16,
                bottom: -20,
                child: Icon(
                  Icons.person_search_rounded,
                  color: colorScheme.onPrimary.transparency(0.12),
                  size: 130,
                ),
              ),

              // Content Area
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Find Your',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary.transparency(0.85),
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Best Doctor Near You',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Button Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.transparency(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Search Now',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
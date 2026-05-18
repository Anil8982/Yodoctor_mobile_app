import 'package:flutter/material.dart';

class SpecialtyCardList extends StatelessWidget {
  const SpecialtyCardList({
    super.key,
    required this.specialties,
    required this.onTap,
  });

  final List<String> specialties;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayList = specialties.take(5).toList();

    if (displayList.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final name = displayList[index];
        final style = _getStyle(name, colorScheme);
        final Color baseColor = style['color'] as Color;
        final Color onBaseColor = style['onColor'] as Color;
        final IconData iconData = style['icon'] as IconData;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => onTap(name),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 85, // Height kami keli
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    baseColor.withValues(alpha: 0.9),
                    baseColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Minimal Watermark Icon
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      iconData,
                      size: 70,
                      color: onBaseColor.withValues(alpha: 0.1),
                    ),
                  ),

                  Row(
                    children: [
                      // Compact Icon Container
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: onBaseColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(iconData, color: onBaseColor, size: 22),
                      ),
                      const SizedBox(width: 16),

                      // Text Info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: onBaseColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Search specialists',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: onBaseColor.withValues(alpha: 0.8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Minimal Arrow
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: onBaseColor.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _getStyle(String name, ColorScheme colorScheme) {
    final n = name.toLowerCase();
    if (n.contains('cardi')) {
      return {
        'icon': Icons.favorite_rounded,
        'color': colorScheme.error,
        'onColor': colorScheme.onError,
      };
    } else if (n.contains('neuro')) {
      return {
        'icon': Icons.psychology_rounded,
        'color': colorScheme.primary,
        'onColor': colorScheme.onPrimary,
      };
    } else if (n.contains('pedia')) {
      return {
        'icon': Icons.child_care_rounded,
        'color': colorScheme.secondary,
        'onColor': colorScheme.onSecondary,
      };
    } else if (n.contains('dent')) {
      return {
        'icon': Icons.health_and_safety_rounded,
        'color': colorScheme.tertiary,
        'onColor': colorScheme.onTertiary,
      };
    } else {
      return {
        'icon': Icons.medical_services_rounded,
        'color': colorScheme.primary,
        'onColor': colorScheme.onPrimary,
      };
    }
  }
}

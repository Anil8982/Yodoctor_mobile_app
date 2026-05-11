import 'package:chroma_kit/chroma_kit.dart';
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
    final displayList = specialties.take(5).toList();

    if (displayList.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final name = displayList[index];
        final style = _getStyle(name);
        final Color baseColor = style['color'];
        final IconData iconData = style['icon'];

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
                    baseColor.transparency(0.9),
                    baseColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: baseColor.transparency(0.15),
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
                      color: Colors.white.transparency(0.1),
                    ),
                  ),

                  Row(
                    children: [
                      // Compact Icon Container
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.transparency(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(iconData, color: Colors.white, size: 22),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Search specialists',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.transparency(0.8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Minimal Arrow
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.white70,
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

  Map<String, dynamic> _getStyle(String name) {
    final n = name.toLowerCase();
    if (n.contains('cardi')) {
      return {'icon': Icons.favorite_rounded, 'color': const Color(0xFFFF4D67)};
    } else if (n.contains('neuro')) {
      return {'icon': Icons.psychology_rounded, 'color': const Color(0xFF6C63FF)};
    } else if (n.contains('pedia')) {
      return {'icon': Icons.child_care_rounded, 'color': const Color(0xFFFF9F43)};
    } else if (n.contains('dent')) {
      return {'icon': Icons.health_and_safety_rounded, 'color': const Color(0xFF2196F3)};
    } else {
      return {'icon': Icons.medical_services_rounded, 'color': const Color(0xFF00B894)};
    }
  }
}
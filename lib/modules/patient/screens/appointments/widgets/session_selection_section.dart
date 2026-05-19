import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class SessionSelectionSection extends StatelessWidget {
  const SessionSelectionSection({
    super.key,
    required this.selectedSession,
    required this.onSessionChanged,
  });

  final String selectedSession;
  final ValueChanged<String> onSessionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Expanded(
          child: _buildSessionCard(
            label: 'Morning',
            subLabel: '09:00 AM - 12:00 PM',
            icon: Icons.light_mode_rounded,
            isSelected: selectedSession == 'Morning',
            onTap: () => onSessionChanged('Morning'),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSessionCard(
            label: 'Evening',
            subLabel: '04:00 PM - 08:00 PM',
            icon: Icons.dark_mode_rounded,
            isSelected: selectedSession == 'Evening',
            onTap: () => onSessionChanged('Evening'),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard({
    required String label,
    required String subLabel,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.transparency(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: textTheme.bodySmall?.copyWith(
                color: isSelected ? colorScheme.onPrimary.transparency(0.8) : colorScheme.outline,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
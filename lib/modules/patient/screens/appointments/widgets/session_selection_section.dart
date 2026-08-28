import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class SessionSelectionSection extends StatelessWidget {
  const SessionSelectionSection({
    super.key,
    required this.selectedSession,
    required this.onSessionChanged,
    required this.morningTime,
    required this.eveningTime,
  });

  final String selectedSession;
  final ValueChanged<String>? onSessionChanged;

  final String morningTime;
  final String eveningTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool hasMorning = morningTime.trim().isNotEmpty;
    final bool hasEvening = eveningTime.trim().isNotEmpty;

    if (!hasMorning && !hasEvening) {
      return const SizedBox.shrink();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onSessionChanged != null) {
        if (hasMorning && !hasEvening && selectedSession != 'Morning') {
          onSessionChanged!('Morning');
        } else if (!hasMorning && hasEvening && selectedSession != 'Evening') {
          onSessionChanged!('Evening');
        }
      }
    });

    return Row(
      children: [
        if (hasMorning) ...[
          Expanded(
            child: _buildSessionCard(
              label: 'Morning',
              subLabel: morningTime,
              icon: Icons.light_mode_rounded,
              isSelected: selectedSession == 'Morning',
              onTap: onSessionChanged != null ? () => onSessionChanged!('Morning') : null,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
          if (hasEvening) const SizedBox(width: 14),
        ],
        if (hasEvening)
          Expanded(
            child: _buildSessionCard(
              label: 'Evening',
              subLabel: eveningTime,
              icon: Icons.dark_mode_rounded,
              isSelected: selectedSession == 'Evening',
              onTap: onSessionChanged != null ? () => onSessionChanged!('Evening') : null,
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
    required VoidCallback? onTap,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final bool isDisabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDisabled && !isSelected
              ? colorScheme.surfaceContainerHighest.transparency(0.2)
              : (isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.primary.withValues(alpha: isDisabled ? 0.4 : 1.0),
              size: 24,
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withValues(alpha: isDisabled ? 0.4 : 1.0),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary.transparency(0.8)
                    : colorScheme.onSurfaceVariant.withValues(alpha: isDisabled ? 0.4 : 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
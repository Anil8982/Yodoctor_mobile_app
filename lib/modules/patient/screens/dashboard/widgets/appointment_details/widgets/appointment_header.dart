import 'package:flutter/material.dart';

class AppointmentHeader extends StatelessWidget {
  const AppointmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleLine('Appointment', textTheme, colorScheme.onSurface, FontWeight.w900),
              const SizedBox(height: 2),
              _buildTitleLine('Details', textTheme, colorScheme.primary, FontWeight.w300),
            ],
          ),
          _CloseButton(colorScheme: colorScheme),
        ],
      ),
    );
  }

  Widget _buildTitleLine(
      String text,
      TextTheme textTheme,
      Color color,
      FontWeight weight,
      ) {
    return Text(
      text,
      style: textTheme.titleLarge?.copyWith(
        fontWeight: weight,
        fontSize: 26,
        letterSpacing: -0.8,
        color: color,
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final ColorScheme colorScheme;

  const _CloseButton({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
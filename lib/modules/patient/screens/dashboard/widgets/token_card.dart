import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/dummy_data.dart';

class TokenCard extends StatelessWidget {
  const TokenCard({super.key, required this.token});

  final PatientToken token;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.transparency(0.5)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.transparency(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                // --- 1. SMALL TOKEN BOX ---
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'TOKEN',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        token.tokenNumber,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // --- 2. CLINIC INFO ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        token.clinicName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Now serving: ${token.nowServing}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 3. STATUS BADGE (Small) ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.transparency(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'WAITING',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 12),

            // --- 4. BOTTOM INFO (Patients Ahead & Time) ---
            Row(
              children: [
                Icon(Icons.people_alt_rounded, size: 14, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  '${token.patientsAhead} ahead',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Icon(Icons.timer_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Est: ${token.estimatedTime}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
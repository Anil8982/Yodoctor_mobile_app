import 'package:flutter/material.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import '../../../models/dashboard/today_token_model.dart';

class TokenCard extends StatelessWidget {
  const TokenCard({super.key, required this.token});

  final TodayTokenModel? token;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (token == null) {
      return _buildEmptyState(theme, colorScheme, isDark, l10n);
    }

    return _buildActiveToken(theme, colorScheme, isDark, l10n);
  }

  Widget _buildEmptyState(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(
              alpha: isDark ? 0.2 : 0.04,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.confirmation_number_outlined,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.noActiveToken,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: -0.3,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.tokenAppearHere,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveToken(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final String clinicText =
        (token!.clinicName != null && token!.clinicName!.isNotEmpty)
            ? token!.clinicName!
            : (token!.type.isNotEmpty ? token!.type : l10n.tokenLabel);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(
              alpha: isDark ? 0.35 : 0.22,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle decorative ambient circle using Material 3 onPrimary
          Positioned(
            right: -25,
            top: -25,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.onPrimary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: Clinic name + Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_hospital_rounded,
                            size: 15,
                            color: colorScheme.onPrimary.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              clinicText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(theme, colorScheme, l10n),
                  ],
                ),
                const SizedBox(height: 14),

                // Middle: Token Number & Queue Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Token Number Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: colorScheme.onPrimary.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.tokenLabel.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w800,
                              fontSize: 9.5,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            token!.token.toString(),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Queue Position & Serving info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (token!.nowServing != null) ...[
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: colorScheme.onPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    l10n.servingToken(
                                      token!.nowServing.toString(),
                                    ),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onPrimary.withValues(alpha: 0.95),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                          Row(
                            children: [
                              if (token!.patientsAhead != null) ...[
                                _buildStatPill(
                                  icon: Icons.people_outline_rounded,
                                  label: l10n.patientsAhead(
                                    token!.patientsAhead.toString(),
                                  ),
                                  colorScheme: colorScheme,
                                ),
                                const SizedBox(width: 10),
                              ],
                              if (token!.estimatedTime != null &&
                                  token!.estimatedTime!.isNotEmpty) ...[
                                _buildStatPill(
                                  icon: Icons.access_time_rounded,
                                  label: _formatEstimatedTime(
                                    token!.estimatedTime,
                                    l10n,
                                  ),
                                  colorScheme: colorScheme,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bottom: Progress Bar
                if (token!.patientsAhead != null) ...[
                  const SizedBox(height: 12),
                  _buildProgressBar(colorScheme),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: colorScheme.onPrimary.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            l10n.waiting,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 10.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ColorScheme colorScheme) {
    double progress = 0.3;
    final serving = int.tryParse(token!.nowServing?.toString() ?? '');
    final currentToken = int.tryParse(token!.token.toString());

    if (serving != null && currentToken != null && currentToken > serving) {
      final diff = currentToken - serving;
      final ahead = token!.patientsAhead ?? 0;
      if (ahead > 0) {
        progress = (diff - ahead) / diff;
        progress = progress.clamp(0.1, 0.9);
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 4,
        backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.22),
        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
      ),
    );
  }

  String _formatEstimatedTime(String? time, AppLocalizations l10n) {
    if (time == null || time.isEmpty) return "--";
    final match = RegExp(
      r'^(\d+)\s*(?:mins?|minutes?)?$',
      caseSensitive: false,
    ).firstMatch(time.trim());
    if (match != null) {
      final minutes = match.group(1)!;
      return l10n.estimatedMinutes(minutes);
    }
    return time;
  }
}

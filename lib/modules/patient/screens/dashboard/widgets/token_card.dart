import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import '../../../models/dashboard/today_token_model.dart';

class TokenCard extends StatelessWidget {
  const TokenCard({super.key, required this.token});

  final TodayTokenModel? token;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (token == null) {
      return _buildEmptyState(theme, colorScheme, isDark);
    }

    return _buildActiveToken(theme, colorScheme, isDark);
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.transparency(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Animated pulse icon for empty state
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.transparency(0.15),
                        colorScheme.primary.transparency(0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.transparency(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.confirmation_number_outlined,
                    color: colorScheme.primary.transparency(0.7),
                    size: 26,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No Active Token",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your token for today will appear here",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.transparency(0.8),
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

  Widget _buildActiveToken(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.primary.transparency(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.transparency(0.3)
                : colorScheme.primary.transparency(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Add tap handler for future functionality
            },
            splashColor: colorScheme.primary.transparency(0.05),
            highlightColor: colorScheme.primary.transparency(0.02),
            child: Row(
              children: [
                // Left Token Box - Enhanced design
                _buildTokenNumberBox(theme, colorScheme),

                // Right Content Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Clinic name with status badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                token!.clinicName ?? token!.type,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusBadge(theme, colorScheme),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // Now serving info
                        Row(
                          children: [
                            Icon(
                              Icons.play_circle_filled_rounded,
                              size: 13,
                              color: colorScheme.tertiary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Serving: ${token!.nowServing ?? "--"}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Progress indicator
                        if (token!.patientsAhead != null)
                          _buildProgressBar(theme, colorScheme),

                        const SizedBox(height: 8),

                        // Bottom stats
                        Row(
                          children: [
                            _buildStatItem(
                              icon: Icons.people_alt_rounded,
                              label: '${token!.patientsAhead ?? "--"} ahead',
                              color: colorScheme.primary,
                              theme: theme,
                            ),
                            const SizedBox(width: 16),
                            _buildStatItem(
                              icon: Icons.timer_outlined,
                              label: token!.estimatedTime ?? "--",
                              color: colorScheme.onSurfaceVariant,
                              theme: theme,
                            ),
                            const Spacer(),
                            // Subtle refresh hint
                            Icon(
                              Icons.refresh_rounded,
                              size: 12,
                              color: colorScheme.onSurfaceVariant.transparency(0.3),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTokenNumberBox(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: 95,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.transparency(0.8),
            colorScheme.primaryContainer.transparency(0.4),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: colorScheme.primary.transparency(0.15),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Token label with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.confirmation_number_rounded,
                size: 12,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'TOKEN',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Token number with subtle shadow
          Text(
            token!.token.toString(),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: -1,
              shadows: [
                Shadow(
                  color: colorScheme.primary.transparency(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.transparency(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.tertiary.transparency(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'WAITING',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme, ColorScheme colorScheme) {
    // Calculate progress if we have both token and now serving
    double progress = 0.3; // Default
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 2.5,
            backgroundColor: colorScheme.surfaceContainerHighest.transparency(0.4),
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.primary.transparency(0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color.transparency(0.8),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color.transparency(0.9),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
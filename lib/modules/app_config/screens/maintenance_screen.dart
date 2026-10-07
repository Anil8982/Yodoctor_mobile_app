import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/app_config/controllers/app_config_controller.dart';

class MaintenanceScreen extends ConsumerWidget {
  final String? message;

  const MaintenanceScreen({super.key, this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final appConfigState = ref.watch(appConfigProvider);
    final displayMessage =
        message ??
        appConfigState.config?.status.maintenanceMsg ??
        'We are currently performing maintenance. Please try again later.';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                _buildIllustration(context, colorScheme),
                const SizedBox(height: 26),

                Text(
                  'Under',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Maintenance',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 20),

                // Message (Dynamic from Firebase / parameter)
                Text(
                  displayMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 28),

                _buildTryAgainButton(context, ref, colorScheme),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.transparent,
        borderRadius: BorderRadius.circular(120),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/maintenance-pana.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: colorScheme.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTryAgainButton(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          AppLogger.info(
            'Retrying app configuration check...',
            tag: LogTags.app,
            subTag: 'AppConfigNotifier',
          );

          ref.read(appConfigProvider.notifier).retryAppConfig();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.shadow,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, size: 22),
            SizedBox(width: 5),
            Text(
              'Try Again',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

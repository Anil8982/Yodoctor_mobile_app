import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/app_config/controllers/app_config_controller.dart';

class MaintenanceScreen extends ConsumerWidget {
  final String? message;

  const MaintenanceScreen({super.key, this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final appConfigState = ref.watch(appConfigProvider);
    final displayMessage = message ??
        appConfigState.config?.status.maintenanceMsg ??
        'We are currently performing maintenance. Please try again later.';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Top-right soft background shape using M3 tonal surfaces
            Positioned(
              top: -120,
              right: -100,
              child: Container(
                width: 330,
                height: 330,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Bottom-left soft background shape using M3 primary container variants
            Positioned(
              bottom: -150,
              left: -130,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildLogo(context, colorScheme),

                    const SizedBox(height: 32),

                    // Maintenance illustration
                    _buildIllustration(context, colorScheme),

                    const SizedBox(height: 26),

                    // Heading
                    Text(
                      'Under',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 48,
                        height: 0.95,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Maintenance',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 46,
                        height: 1.05,
                        color: colorScheme.primary,
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

                    // Try Again button
                    _buildTryAgainButton(context, ref, colorScheme),

                    const SizedBox(height: 28),

                    // Patience card
                    _buildPatienceCard(context, colorScheme),

                    const SizedBox(height: 34),

                    // Footer
                    _buildFooter(context, colorScheme),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(Icons.favorite, color: colorScheme.onPrimary, size: 30),
        ),

        const SizedBox(width: 10),

        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Yo',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              TextSpan(
                text: 'Doctor',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(120),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone
          Positioned(
            right: 72,
            top: 25,
            child: Container(
              width: 130,
              height: 190,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colorScheme.outlineVariant, width: 6),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.settings, size: 68, color: colorScheme.primary),
              ),
            ),
          ),

          // Person / maintenance icon
          Positioned(
            left: 38,
            bottom: 28,
            child: Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.engineering,
                size: 72,
                color: colorScheme.onPrimary,
              ),
            ),
          ),

          // Toolbox
          Positioned(
            bottom: 12,
            right: 38,
            child: Container(
              width: 120,
              height: 58,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.handyman, color: colorScheme.onSecondary, size: 34),
            ),
          ),

          // Medical plus
          Positioned(
            left: 20,
            top: 55,
            child: Icon(Icons.add, size: 38, color: colorScheme.primary.withValues(alpha: 0.5)),
          ),

          Positioned(
            right: 20,
            top: 105,
            child: Icon(Icons.add, size: 34, color: colorScheme.primary.withValues(alpha: 0.5)),
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
      width: double.infinity,
      height: 58,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded, size: 27),
            SizedBox(width: 10),
            Text(
              'Try Again',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatienceCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.favorite, color: colorScheme.onSecondary, size: 25),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              'We appreciate your patience.\n'
                  'Our team is working to get things back up soon.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.45,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 55, height: 1, color: colorScheme.outlineVariant),

        const SizedBox(width: 14),

        Text(
          'Yo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colorScheme.primary,
          ),
        ),

        Text(
          'Doctor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colorScheme.secondary,
          ),
        ),

        const SizedBox(width: 14),

        Container(width: 55, height: 1, color: colorScheme.outlineVariant),
      ],
    );
  }
}
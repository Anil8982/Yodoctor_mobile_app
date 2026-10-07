import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class ForceUpdateScreen extends StatelessWidget {
  final String message;
  final String storeUrl;

  const ForceUpdateScreen({
    super.key,
    required this.message,
    required this.storeUrl,
  });

  Future<void> _updateApp() async {
    final uri = Uri.tryParse(storeUrl);

    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIllustration(context, colorScheme),
                const SizedBox(height: 24),

                Text(
                  "Update Required",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),

                const SizedBox(height: 32),

                OutlinedButton.icon(
                  onPressed: _updateApp,
                  icon: const Icon(Icons.system_update_rounded),
                  label: const Text('Update Now'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.green, width: 1.5),
                  ),
                ),
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
              'assets/images/update-pana.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.system_update_rounded,
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
}

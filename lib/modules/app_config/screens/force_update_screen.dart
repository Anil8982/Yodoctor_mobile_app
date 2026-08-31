import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.system_update_rounded,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),

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

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _updateApp,
                    child: const Text("Update Now"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
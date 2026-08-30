import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  final IconData? floatingIcon;
  final VoidCallback? onFloatingPressed;
  final String? floatingLabel;

  const WebViewScreen({
    super.key,
    required this.title,
    required this.url,
    this.floatingIcon,
    this.onFloatingPressed,
    this.floatingLabel,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (_) => setState(() => isLoading = false),
          onWebResourceError: (error) {
            debugPrint('WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppHeader(
        title: widget.title,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        onBackPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
        actions: [
          if (widget.onFloatingPressed != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: widget.onFloatingPressed,
                icon: Icon(widget.floatingIcon ?? Icons.add, size: 18),
                label: Text(widget.floatingLabel ?? ''),
                style: TextButton.styleFrom(foregroundColor: colors.primary),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: isLoading
              ? LinearProgressIndicator(
                  color: colors.primary,
                  backgroundColor: colors.surfaceContainerHighest,
                  minHeight: 3,
                )
              : const SizedBox(height: 3),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  double _backButtonX = 12;
  double _backButtonY = 10;

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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),

            if (isLoading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  color: colors.primary,
                  backgroundColor: colors.surfaceContainerHighest,
                  minHeight: 3,
                ),
              ),

            Positioned(
              top: _backButtonY,
              left: _backButtonX,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _backButtonX += details.delta.dx;
                    _backButtonY += details.delta.dy;
                  });
                },
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: colors.primary,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: colors.onSurface,
                    size: 25,
                  ),
                ),
              ),
            ),

            if (widget.onFloatingPressed != null)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: widget.onFloatingPressed,
                    icon: Icon(
                      widget.floatingIcon ?? Icons.add,
                      size: 20,
                    ),
                    label: Text(widget.floatingLabel ?? ''),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
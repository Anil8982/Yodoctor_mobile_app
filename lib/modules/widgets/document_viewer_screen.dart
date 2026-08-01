import 'dart:typed_data';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';

class DocumentViewerScreen extends ConsumerStatefulWidget {
  final String fileUrl;
  final String fileName;
  final bool isImage;
  final bool isPdf;

  const DocumentViewerScreen({
    super.key,
    required this.fileUrl,
    required this.fileName,
    this.isImage = false,
    this.isPdf = false,
  });

  @override
  ConsumerState<DocumentViewerScreen> createState() =>
      _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends ConsumerState<DocumentViewerScreen> {
  Uint8List? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final dio = ref.read(dioProvider);

      final response = await dio.get(
        widget.fileUrl,
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 400) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = 'FILE_ACCESS_RESTRICTED';
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _data = response.data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'NETWORK_ERROR';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppHeader(title: widget.fileName),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildError(colorScheme)
          : widget.isImage
          ? InteractiveViewer(
        child: Center(child: Image.memory(_data!)),
      )
          : _buildPlaceholder(colorScheme),
    );
  }

  Widget _buildError(ColorScheme colorScheme) {
    final isRestricted = _error == 'FILE_ACCESS_RESTRICTED';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isRestricted
                    ? Colors.orange.transparency(0.1)
                    : colorScheme.errorContainer.transparency(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRestricted ? Icons.lock_outline : Icons.wifi_off,
                size: 48,
                color: isRestricted ? Colors.orange : colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isRestricted ? 'Preview Unavailable' : 'Connection Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isRestricted
                  ? 'This file is stored securely. Please use download option to view it.'
                  : 'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _loadDocument();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.isPdf
                    ? Colors.red.transparency(0.1)
                    : colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
                size: 48,
                color: widget.isPdf ? Colors.red : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.isPdf ? 'PDF Document' : 'Preview Not Supported',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isPdf
                  ? 'PDF files cannot be previewed here.\nPlease download to view the document.'
                  : 'This file type cannot be previewed.\nPlease download to view.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
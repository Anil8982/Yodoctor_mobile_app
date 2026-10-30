import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

/// Centralized Attachment Preview widget for Images & PDFs
/// Supports: Local Files, Network URLs, or Raw Bytes
class AppAttachmentPreview extends StatefulWidget {
  final File? file;
  final String? url;
  final Uint8List? bytes;
  final String? title;
  final bool showAppBar;

  const AppAttachmentPreview({
    super.key,
    this.file,
    this.url,
    this.bytes,
    this.title,
    this.showAppBar = true,
  }) : assert(
          file != null || url != null || bytes != null,
          'Must provide either file, url, or bytes',
        );

  /// Shows the preview in a full-screen dialog or modal
  static Future<void> show(
    BuildContext context, {
    File? file,
    String? url,
    Uint8List? bytes,
    String? title,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: AppAttachmentPreview(
            file: file,
            url: url,
            bytes: bytes,
            title: title,
            showAppBar: true,
          ),
        ),
      ),
    );
  }

  @override
  State<AppAttachmentPreview> createState() => _AppAttachmentPreviewState();
}

class _AppAttachmentPreviewState extends State<AppAttachmentPreview> {
  bool _isLoading = true;
  String? _errorMessage;
  Uint8List? _loadedBytes;
  File? _localFile;
  bool _isPdf = false;
  PdfController? _pdfController;
  int _totalPages = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _initializeAttachment();
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  bool _checkIsPdf({String? path, Uint8List? bytes}) {
    if (path != null) {
      final lower = path.toLowerCase().split('?').first;
      if (lower.endsWith('.pdf')) return true;
    }
    if (bytes != null && bytes.length >= 4) {
      // Magic number for PDF: %PDF -> [0x25, 0x50, 0x44, 0x46]
      if (bytes[0] == 0x25 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x44 &&
          bytes[3] == 0x46) {
        return true;
      }
    }
    return false;
  }

  Future<void> _initializeAttachment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.file != null) {
        _localFile = widget.file;
        _loadedBytes = await widget.file!.readAsBytes();
        _isPdf = _checkIsPdf(path: widget.file!.path, bytes: _loadedBytes);
      } else if (widget.bytes != null) {
        _loadedBytes = widget.bytes;
        _isPdf = _checkIsPdf(path: widget.title, bytes: _loadedBytes);
      } else if (widget.url != null) {
        _isPdf = _checkIsPdf(path: widget.url);
        final dio = Dio();
        final response = await dio.get<List<int>>(
          widget.url!,
          options: Options(responseType: ResponseType.bytes),
        );
        if (response.data != null && response.data!.isNotEmpty) {
          _loadedBytes = Uint8List.fromList(response.data!);
          _isPdf = _isPdf || _checkIsPdf(bytes: _loadedBytes);
        } else {
          throw Exception('File data is empty');
        }
      }

      if (_isPdf && _loadedBytes != null) {
        _pdfController = PdfController(
          document: PdfDocument.openData(_loadedBytes!),
        );
        final doc = await PdfDocument.openData(_loadedBytes!);
        _totalPages = doc.pagesCount;
        await doc.close();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load file: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _openExternal() async {
    try {
      String? filePath = _localFile?.path;
      if (filePath == null && _loadedBytes != null) {
        final dir = await getTemporaryDirectory();
        final ext = _isPdf ? '.pdf' : '.jpg';
        final name = (widget.title != null && widget.title!.isNotEmpty)
            ? widget.title!
            : 'attachment_${DateTime.now().millisecondsSinceEpoch}$ext';
        final file = File('${dir.path}/$name');
        await file.writeAsBytes(_loadedBytes!);
        filePath = file.path;
      }

      if (filePath != null) {
        await OpenFilex.open(filePath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayTitle = widget.title ?? (_isPdf ? 'PDF Document' : 'Attachment Preview');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.black.withValues(alpha: 0.85),
              foregroundColor: Colors.white,
              elevation: 0,
              title: Text(
                displayTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                if (_loadedBytes != null)
                  IconButton(
                    icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
                    tooltip: 'Open with external app',
                    onPressed: _openExternal,
                  ),
              ],
            )
          : null,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading preview...',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.broken_image_rounded, size: 56, color: Colors.redAccent),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                            ),
                            onPressed: _initializeAttachment,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : _isPdf
                    ? _buildPdfView()
                    : _buildImageView(),
      ),
    );
  }

  Widget _buildImageView() {
    if (_loadedBytes == null) {
      return const Center(
        child: Text('No image data', style: TextStyle(color: Colors.white70)),
      );
    }

    return Stack(
      children: [
        Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.8,
            maxScale: 4.0,
            child: Image.memory(
              _loadedBytes!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.error_outline, color: Colors.red, size: 48),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pinch_rounded, size: 16, color: Colors.white70),
                  SizedBox(width: 6),
                  Text(
                    'Pinch to zoom',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPdfView() {
    if (_pdfController == null) {
      return const Center(
        child: Text('Unable to render PDF', style: TextStyle(color: Colors.white70)),
      );
    }

    return Column(
      children: [
        Expanded(
          child: PdfView(
            controller: _pdfController!,
            scrollDirection: Axis.vertical,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            onDocumentLoaded: (document) {
              setState(() {
                _totalPages = document.pagesCount;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.black.withValues(alpha: 0.85),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                onPressed: _currentPage > 1
                    ? () => _pdfController?.previousPage(
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 200),
                        )
                    : null,
              ),
              Text(
                'Page $_currentPage of $_totalPages',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                onPressed: _currentPage < _totalPages
                    ? () => _pdfController?.nextPage(
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 200),
                        )
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

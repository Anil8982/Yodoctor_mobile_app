import 'dart:io';
import 'dart:typed_data';
import 'package:debug_bubble/debug_bubble.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as px;

class AttachmentUtils {
  AttachmentUtils._();

  static const String _tag = 'AttachmentUtils';
  static const int _bytesPerMb = 1024 * 1024;

  /// Format byte count into human-readable text (e.g. "650 KB", "1.2 MB").
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < _bytesPerMb) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = bytes / _bytesPerMb;
    return '${mb.toStringAsFixed(2)} MB';
  }

  /// Check whether a file is within the maximum size limit.
  static Future<bool> isUnderLimit(
    File file, {
    double maxFileSizeMb = 1.0,
  }) async {
    try {
      if (!await file.exists()) return false;
      final length = await file.length();
      return length <= (maxFileSizeMb * _bytesPerMb);
    } catch (_) {
      return false;
    }
  }

  /// 1. Standalone image compressor: Compresses any image file (JPG, PNG, WebP)
  /// down to [maxFileSizeMb] (default 1 MB).
  static Future<File> compressImage(
    File file, {
    double maxFileSizeMb = 1.0,
    int initialQuality = 85,
  }) async {
    try {
      final maxBytes = (maxFileSizeMb * _bytesPerMb).round();
      final currentSize = await file.length();

      // If already within limit, return original file
      if (currentSize <= maxBytes) {
        return file;
      }

      final bytes = await file.readAsBytes();
      final compressedBytes = await compressImageBytes(
        bytes,
        maxFileSizeMb: maxFileSizeMb,
        initialQuality: initialQuality,
      );

      final tempDir = await getTemporaryDirectory();
      final extension = p.extension(file.path).isNotEmpty
          ? p.extension(file.path)
          : '.jpg';
      final fileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}$extension';
      final compressedFile = File('${tempDir.path}/$fileName');
      await compressedFile.writeAsBytes(compressedBytes);

      DebugLog.info(
        'Image compressed: ${formatFileSize(currentSize)} -> ${formatFileSize(compressedBytes.length)}',
        tag: _tag,
      );

      return compressedFile;
    } catch (e, st) {
      DebugLog.error('Image compression failed', error: e, stackTrace: st, tag: _tag);
      return file;
    }
  }

  /// 2. Standalone in-memory image bytes compressor.
  static Future<Uint8List> compressImageBytes(
    Uint8List bytes, {
    double maxFileSizeMb = 1.0,
    int initialQuality = 85,
  }) async {
    final maxBytes = (maxFileSizeMb * _bytesPerMb).round();
    if (bytes.length <= maxBytes) {
      return bytes;
    }

    img.Image? rawDecoded = img.decodeImage(bytes);
    if (rawDecoded == null) {
      return bytes;
    }

    // Auto-rotate if needed
    img.Image currentImage = img.bakeOrientation(rawDecoded);

    // Initial resize if very large
    if (currentImage.width > 1920 || currentImage.height > 1920) {
      currentImage = img.copyResize(
        currentImage,
        width: currentImage.width > currentImage.height ? 1920 : null,
        height: currentImage.height >= currentImage.width ? 1920 : null,
        interpolation: img.Interpolation.linear,
      );
    }

    int quality = initialQuality;
    Uint8List encoded =
        Uint8List.fromList(img.encodeJpg(currentImage, quality: quality));

    while (encoded.length > maxBytes && quality > 20) {
      quality -= 15;
      if (quality < 50 &&
          (currentImage.width > 1200 || currentImage.height > 1200)) {
        currentImage = img.copyResize(
          currentImage,
          width: currentImage.width > currentImage.height
              ? (currentImage.width * 0.8).round()
              : null,
          height: currentImage.height >= currentImage.width
              ? (currentImage.height * 0.8).round()
              : null,
          interpolation: img.Interpolation.linear,
        );
      }
      encoded =
          Uint8List.fromList(img.encodeJpg(currentImage, quality: quality));
    }

    return encoded;
  }

  /// 3. Combine multiple image files into a single compact multi-page PDF (< 1 MB).
  static Future<File> createPdfFromImages(
    List<File> imageFiles, {
    double maxFileSizeMb = 1.0,
  }) async {
    if (imageFiles.isEmpty) {
      throw ArgumentError('No image files provided for PDF creation.');
    }

    final tempDir = await getTemporaryDirectory();
    final pdfDoc = pw.Document();

    final count = imageFiles.length;
    // Calculate targeted size per image so the overall PDF remains under maxFileSizeMb
    final targetBytesPerImage = ((maxFileSizeMb * 0.85 * _bytesPerMb) / count).round();
    final targetMbPerImage = targetBytesPerImage / _bytesPerMb;

    for (int i = 0; i < imageFiles.length; i++) {
      final imgFile = imageFiles[i];
      final rawBytes = await imgFile.readAsBytes();

      // Compress individual page image
      final compressedBytes = await compressImageBytes(
        rawBytes,
        maxFileSizeMb: targetMbPerImage.clamp(0.15, 0.9),
        initialQuality: count > 3 ? 65 : 80,
      );

      final pdfImage = pw.MemoryImage(compressedBytes);
      pdfDoc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(16),
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pdfImage,
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );
    }

    final pdfBytes = await pdfDoc.save();
    final outputPdfFile = File(
      '${tempDir.path}/prescription_doc_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await outputPdfFile.writeAsBytes(pdfBytes);

    DebugLog.success(
      'Created multi-image PDF ($count pages): ${formatFileSize(pdfBytes.length)}',
      tag: _tag,
    );

    return outputPdfFile;
  }

  /// 4. Compress an existing PDF file if it exceeds [maxFileSizeMb].
  /// Downsamples pages silently in the background and re-packs into a new PDF.
  static Future<File> compressPdf(
    File pdfFile, {
    double maxFileSizeMb = 1.0,
  }) async {
    try {
      final maxBytes = (maxFileSizeMb * _bytesPerMb).round();
      final currentSize = await pdfFile.length();

      if (currentSize <= maxBytes) {
        return pdfFile;
      }

      DebugLog.info(
        'PDF is ${formatFileSize(currentSize)}, re-compressing under ${maxFileSizeMb}MB...',
        tag: _tag,
      );

      final document = await px.PdfDocument.openFile(pdfFile.path);
      final pageCount = document.pagesCount;
      final tempDir = await getTemporaryDirectory();
      final newPdfDoc = pw.Document();

      final targetBytesPerPage = ((maxFileSizeMb * 0.8 * _bytesPerMb) / pageCount).round();
      final targetMbPerPage = targetBytesPerPage / _bytesPerMb;

      for (int i = 1; i <= pageCount; i++) {
        final page = await document.getPage(i);
        // Render PDF page to an image
        final pageImage = await page.render(
          width: page.width * 1.5,
          height: page.height * 1.5,
          format: px.PdfPageImageFormat.jpeg,
        );
        await page.close();

        if (pageImage != null && pageImage.bytes.isNotEmpty) {
          final compressedBytes = await compressImageBytes(
            pageImage.bytes,
            maxFileSizeMb: targetMbPerPage.clamp(0.12, 0.85),
            initialQuality: pageCount > 3 ? 60 : 75,
          );

          final pwImage = pw.MemoryImage(compressedBytes);
          newPdfDoc.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: const pw.EdgeInsets.all(12),
              build: (context) {
                return pw.Center(
                  child: pw.Image(
                    pwImage,
                    fit: pw.BoxFit.contain,
                  ),
                );
              },
            ),
          );
        }
      }
      await document.close();

      final newBytes = await newPdfDoc.save();
      final compressedPdf = File(
        '${tempDir.path}/optimized_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await compressedPdf.writeAsBytes(newBytes);

      DebugLog.success(
        'PDF compressed: ${formatFileSize(currentSize)} -> ${formatFileSize(newBytes.length)}',
        tag: _tag,
      );

      return compressedPdf;
    } catch (e, st) {
      DebugLog.error('PDF compression failed, returning original file', error: e, stackTrace: st, tag: _tag);
      return pdfFile;
    }
  }

  /// 5. Master Processor: Automatically handles single image, multiple images,
  /// or large PDFs and returns a single optimized File guaranteed <= [maxFileSizeMb].
  static Future<File> processAttachment(
    List<String> filePaths, {
    double maxFileSizeMb = 1.0,
  }) async {
    if (filePaths.isEmpty) {
      throw ArgumentError('No files selected for attachment processing.');
    }

    final validFiles = filePaths
        .map((p) => File(p))
        .where((f) => f.existsSync())
        .toList();

    if (validFiles.isEmpty) {
      throw FileNotFoundException('Selected attachment files could not be found.');
    }

    final bool allImages = validFiles.every((f) => _isImageFile(f.path));
    final bool hasPdf = validFiles.any((f) => _isPdfFile(f.path));

    // Case 1: Multiple images -> convert to single multi-page compressed PDF
    if (allImages && validFiles.length > 1) {
      return createPdfFromImages(validFiles, maxFileSizeMb: maxFileSizeMb);
    }

    // Case 2: Single image -> compress image
    if (allImages && validFiles.length == 1) {
      return compressImage(validFiles.first, maxFileSizeMb: maxFileSizeMb);
    }

    // Case 3: PDF file -> check size and compress if > maxFileSizeMb
    if (hasPdf && validFiles.length == 1) {
      return compressPdf(validFiles.first, maxFileSizeMb: maxFileSizeMb);
    }

    // Case 4: Mixed or multiple PDFs -> if single first is PDF, compress it
    return compressPdf(validFiles.first, maxFileSizeMb: maxFileSizeMb);
  }

  static bool _isImageFile(String path) {
    final ext = p.extension(path).toLowerCase();
    return ext == '.jpg' ||
        ext == '.jpeg' ||
        ext == '.png' ||
        ext == '.webp' ||
        ext == '.bmp';
  }

  static bool _isPdfFile(String path) {
    return p.extension(path).toLowerCase() == '.pdf';
  }
}

class FileNotFoundException implements Exception {
  final String message;
  const FileNotFoundException(this.message);

  @override
  String toString() => message;
}

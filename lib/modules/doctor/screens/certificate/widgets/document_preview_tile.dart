import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_document_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentPreviewTile extends StatelessWidget {
  const DocumentPreviewTile({
    super.key,
    required this.document,
  });

  final DoctorDocumentModel document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // ✅ File icon based on type
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: document.isPdf
                  ? colorScheme.errorContainer.withValues(alpha: 0.3)
                  : document.isImage
                  ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : colorScheme.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              document.isPdf
                  ? Icons.picture_as_pdf_rounded
                  : document.isImage
                  ? Icons.image_rounded
                  : Icons.insert_drive_file_rounded,
              color: document.isPdf
                  ? colorScheme.error
                  : document.isImage
                  ? colorScheme.primary
                  : colorScheme.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  document.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      document.isPdf
                          ? 'PDF Document'
                          : document.isImage
                          ? 'Image File'
                          : 'Document',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (document.createdAt != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        document.formattedDate,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // ✅ View button with actual file opening
          SizedBox(
            height: 36,
            child: OutlinedButton.icon(
              onPressed: () => _openFile(context, document.fullUrl),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                elevation: 0,
              ),
              icon: const Icon(Icons.visibility_rounded, size: 14),
              label: Text(
                'View',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFile(BuildContext context, String path) async {
    try {
      if (path.isEmpty) {
        _showError(context, 'No file URL available');
        return;
      }

      // Normalize path (already done in model)
      final normalizedPath = path.replaceAll('\\', '/');

      // If it's a full URL, launch it
      if (normalizedPath.startsWith('http://') || normalizedPath.startsWith('https://')) {
        final uri = Uri.parse(normalizedPath);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (!context.mounted) return;
          _showError(context, 'Cannot open file: $normalizedPath');
        }
      } else {
        // For relative paths, show message
        _showError(context, 'File preview not available. Path: $normalizedPath');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Error opening file: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
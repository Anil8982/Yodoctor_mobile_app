import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_document_model.dart';
import 'package:yodoctor/modules/widgets/document_viewer_screen.dart';

class DocumentPreviewTile extends StatelessWidget {
  const DocumentPreviewTile({super.key, required this.document});

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
                    Flexible(
                      child: Text(
                        document.isPdf
                            ? 'PDF Document'
                            : document.isImage
                            ? 'Image File'
                            : 'Document',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (document.createdAt != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.3,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          document.formattedDate,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            height: 36,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DocumentViewerScreen(
                      fileUrl: document.fullUrl,
                      fileName: document.fileName,
                      isImage: document.isImage,
                      isPdf: document.isPdf,
                    ),
                  ),
                );
              },
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
}

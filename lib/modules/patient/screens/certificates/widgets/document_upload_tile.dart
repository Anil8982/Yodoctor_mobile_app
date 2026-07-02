import 'package:flutter/material.dart';

class DocumentUploadTile extends StatelessWidget {
  const DocumentUploadTile({
    super.key,
    required this.label,
    required this.hint,
    required this.uploadedFileName,
    required this.uploadProgress,
    required this.onUpload,
    required this.onRemove,
    this.isRequired = false,
    this.hasError = false,
  });

  final String label;
  final String hint;
  final String? uploadedFileName;
  final double? uploadProgress;
  final Function(String fileName) onUpload;
  final VoidCallback onRemove;
  final bool isRequired;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUploading = uploadProgress != null;
    final isUploaded = uploadedFileName != null;

    Color getTileBgColor() {
      if (isUploaded) return colorScheme.primaryContainer.withValues(alpha: 0.15);
      if (hasError) return colorScheme.errorContainer.withValues(alpha: 0.2);
      return colorScheme.outlineVariant.withValues(alpha: 0.1);
    }

    Color getBorderColor() {
      if (isUploaded) return colorScheme.primary;
      if (hasError) return colorScheme.error.withValues(alpha: 0.8);
      return colorScheme.outlineVariant;
    }

    double getBorderWidth() {
      return (isUploaded || hasError) ? 1.5 : 1.0;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: getTileBgColor(),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: getBorderColor(),
                width: getBorderWidth(),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isUploading || isUploaded
                    ? null
                    : () {
                  final extension = label.contains('Report') ? 'pdf' : 'jpg';
                  final cleanLabel = label.toLowerCase().replaceAll(' ', '_');
                  onUpload('${cleanLabel}_upload.$extension');
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    children: [
                      if (isUploading) ...[
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                value: uploadProgress,
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Uploading document...',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: uploadProgress,
                                      minHeight: 4,
                                      backgroundColor: colorScheme.surfaceContainerHigh,
                                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else if (isUploaded) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.file_present_rounded,
                                color: colorScheme.onPrimaryContainer,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    uploadedFileName!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Document uploaded successfully',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
                              onPressed: onRemove,
                              tooltip: 'Delete Upload',
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: hasError
                                    ? colorScheme.errorContainer
                                    : colorScheme.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.cloud_upload_outlined,
                                color: hasError
                                    ? colorScheme.onErrorContainer
                                    : colorScheme.onSurfaceVariant,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Click to upload',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: hasError ? colorScheme.error : colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    hasError ? 'This document is required!' : hint,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
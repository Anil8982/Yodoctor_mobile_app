import 'dart:io';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/attachment_utils.dart';
import 'package:yodoctor/modules/widgets/app_attachment_preview.dart';

class PrescriptionAttachmentSection extends StatelessWidget {
  final String? existingAttachmentUrl;
  final File? selectedLocalAttachment;
  final bool isBusy;
  final bool isProcessing;
  final bool isDownloading;
  final VoidCallback onPick;
  final VoidCallback onRemoveLocal;
  final VoidCallback onDownloadExisting;

  const PrescriptionAttachmentSection({
    super.key,
    required this.existingAttachmentUrl,
    required this.selectedLocalAttachment,
    required this.isBusy,
    required this.isProcessing,
    required this.isDownloading,
    required this.onPick,
    required this.onRemoveLocal,
    required this.onDownloadExisting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasExistingAttachment = existingAttachmentUrl != null &&
        existingAttachmentUrl!.isNotEmpty;
    final hasLocalAttachment = selectedLocalAttachment != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasExistingAttachment && !hasLocalAttachment) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    color: colorScheme.primary,
                    size: 26,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Uploaded Document",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          existingAttachmentUrl!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: "Preview Document",
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    icon: Icon(
                      Icons.visibility_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: () => AppAttachmentPreview.show(
                      context,
                      url: existingAttachmentUrl,
                      title: "Prescription Attachment",
                    ),
                  ),
                  IconButton(
                    tooltip: "Download File",
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    icon: isDownloading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.download_rounded, size: 20),
                    onPressed: isDownloading ? null : onDownloadExisting,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (hasLocalAttachment) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.transparency(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.transparency(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    p.extension(selectedLocalAttachment!.path).toLowerCase() == '.pdf'
                        ? Icons.picture_as_pdf_rounded
                        : Icons.image_rounded,
                    color: colorScheme.primary,
                    size: 26,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.basename(selectedLocalAttachment!.path),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text(
                              AttachmentUtils.formatFileSize(
                                selectedLocalAttachment!.lengthSync(),
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.transparency(0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "Ready to upload",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: "Preview",
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    icon: Icon(
                      Icons.visibility_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: () => AppAttachmentPreview.show(
                      context,
                      file: selectedLocalAttachment,
                      title: p.basename(selectedLocalAttachment!.path),
                    ),
                  ),
                  IconButton(
                    tooltip: "Remove",
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    icon: Icon(
                      Icons.close_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    onPressed: isBusy ? null : onRemoveLocal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isBusy || isProcessing ? null : onPick,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                side: BorderSide(color: colorScheme.outlineVariant),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: isProcessing
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.attach_file_rounded, size: 20),
              label: Text(
                isProcessing
                    ? "Optimizing document..."
                    : hasLocalAttachment
                    ? "Change Document"
                    : hasExistingAttachment
                    ? "Replace Document"
                    : "Attach Document (PDF or Images)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
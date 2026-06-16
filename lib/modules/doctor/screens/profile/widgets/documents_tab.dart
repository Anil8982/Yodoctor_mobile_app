import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';

class DocumentsTab extends StatefulWidget {
  const DocumentsTab({super.key, required this.controller});
  final DoctorProfileController controller;

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Uploaded Documents', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.xxs),
          Text('Manage your official medical certifications and identity proofs required for compliance checks.', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.xl),

          if (widget.controller.uploadedDocs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Text('No documents uploaded yet.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.controller.uploadedDocs.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final doc = widget.controller.uploadedDocs[index];
                final String docName = doc['name'] ?? 'Document';
                final String status = doc['status'] ?? 'Pending';
                final bool isVerified = status.toLowerCase() == 'verified';

                return Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.picture_as_pdf_outlined, color: colorScheme.primary, size: 22),
                    ),
                    title: Text(docName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: isVerified
                            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                            : colorScheme.errorContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isVerified ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: AppSpacing.xl),

          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File picker opening...')),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload_outlined, color: colorScheme.primary, size: 28),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Upload New Document', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.primary)),
                  const SizedBox(height: 2),
                  Text('Supports PDF, PNG or JPG (Max 5MB)', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_service_controller.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/widgets/certificate_service_bottom_sheet.dart';

class CertificateServiceCard extends ConsumerWidget {
  const CertificateServiceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final state = ref.watch(doctorCertificateServiceProvider);
    final service = state.service;

    // 1. Loading State
    if (state.isLoading && service == null) {
      return Card.outlined(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        ),
      );
    }

    // 2. Unavailable State
    if (service == null) {
      return Card.outlined(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Certificate service unavailable',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton.filledTonal(
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                onPressed: () {
                  ref
                      .read(doctorCertificateServiceProvider.notifier)
                      .loadCertificateService(force: true);
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                tooltip: 'Retry',
              ),
            ],
          ),
        ),
      );
    }

    final isActive = service.enabled;
    final successColor = AppTheme.success(context);

    // 3. Active / Loaded State (Exact image content + Premium Compact Layout)
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive
              ? successColor.withValues(alpha: 0.3)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: isActive ? 1.5 : 1,
        ),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Icon, Title & Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isActive ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Certificate Service',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Medical Certificate',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive
                        ? successColor.withValues(alpha: 0.12)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? successColor : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isActive ? 'Active' : 'Inactive',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isActive ? successColor : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Description text from the screenshot
            Text(
              'Allow patients to apply for medical certificates through your profile.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 14),

            // Fee info string format: Certificate Fee - ₹1
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                children: [
                  const TextSpan(text: 'Certificate Fee - '),
                  TextSpan(
                    text: '₹${service.fee.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Full-width Outlined Button as shown in the screenshot
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () {
                  CertificateServiceBottomSheet.show(context);
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text(
                  'Edit Service',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(
                    color: colorScheme.primary,
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
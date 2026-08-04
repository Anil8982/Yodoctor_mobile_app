import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../controllers/doctor_qr_controller.dart';

class DoctorQrScreen extends ConsumerWidget {
  const DoctorQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorQrProvider);
    final notifier = ref.read(doctorQrProvider.notifier);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom; // 👈 Get System Bottom Inset

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: const AppHeader(title: 'My Digital QR'),
      body: Column(
        children: [
          if (state.downloadLoading)
            LinearProgressIndicator(
              color: colorScheme.primary,
              backgroundColor: colorScheme.primaryContainer.transparency(0.3),
              minHeight: 3,
            ),

          Expanded(
            child: state.loading && state.qr == null
                ? const Center(child: CircularProgressIndicator())
                : state.qr == null
                ? _buildErrorState(context, state, notifier)
                : RefreshIndicator(
              onRefresh: () async {
                await notifier.loadQr();
              },
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl + bottomPadding + 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      children: [
                        Card(
                          elevation: 0,
                          color: colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                            side: BorderSide(
                              color: colorScheme.outlineVariant
                                  .transparency(0.3),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                  colorScheme.primaryContainer,
                                  child: Icon(
                                    Icons.medical_services_rounded,
                                    size: 28,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  state.qr!.doctorName,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  state.qr!.specialization,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                    colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer
                                        .transparency(0.5),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  child: Text(
                                    "ID: ${state.qr!.doctorId}",
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: AppSpacing.xl),

                                Container(
                                  padding: const EdgeInsets.all(
                                    AppSpacing.lg,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      24,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.shadow
                                            .transparency(0.06),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: colorScheme.outlineVariant
                                          .transparency(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      QrImageView(
                                        data: state.qr!.qrUrl,
                                        version: QrVersions.auto,
                                        size: 210,
                                        eyeStyle: QrEyeStyle(
                                          eyeShape: QrEyeShape.square,
                                          color: colorScheme.primary,
                                        ),
                                        dataModuleStyle:
                                        const QrDataModuleStyle(
                                          dataModuleShape:
                                          QrDataModuleShape
                                              .square,
                                          color: Colors.black87,
                                        ),
                                        embeddedImage: const AssetImage(
                                          'assets/images/app_logo.png',
                                        ),
                                        embeddedImageStyle:
                                        const QrEmbeddedImageStyle(
                                          size: Size(30, 30),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: AppSpacing.sm,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.qr_code_scanner_rounded,
                                            size: 16,
                                            color: colorScheme
                                                .onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Scan to book appointment",
                                            style: theme
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                              color: colorScheme
                                                  .onSurfaceVariant,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: AppSpacing.lg),

                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: state.qr!.qrUrl,
                                      ),
                                    );

                                    AppSnackBar.show(
                                      message: "Link copied to clipboard",
                                      type: AppSnackBarType.info,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme
                                          .surfaceContainerHighest
                                          .transparency(0.5),
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.link_rounded,
                                          size: 16,
                                          color: colorScheme.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            state.qr!.qrUrl,
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: theme
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                              color:
                                              colorScheme.primary,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.copy_rounded,
                                          size: 14,
                                          color: colorScheme.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            icon: state.downloadLoading
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: colorScheme.onPrimary,
                              ),
                            )
                                : const Icon(
                              Icons.picture_as_pdf_rounded,
                            ),
                            label: Text(
                              state.downloadLoading
                                  ? "Generating PDF..."
                                  : "Download Printable PDF",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: state.downloadLoading
                                ? null
                                : () async {
                              final success = await notifier
                                  .downloadQr();

                              if (success) {
                                AppSnackBar.show(
                                  message: "QR PDF downloaded successfully",
                                  type: AppSnackBarType.success,
                                );
                              } else {
                                final errorState = ref.read(
                                  doctorQrProvider,
                                );
                                AppSnackBar.show(
                                  message: errorState.downloadError ??
                                      "Failed to generate PDF document",
                                  type: AppSnackBarType.error,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context,
      dynamic state,
      dynamic notifier,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Setup Required",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              state.errorMessage ?? "No QR code metadata available",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: notifier.loadQr,
              label: const Text("Retry Setup"),
            ),
          ],
        ),
      ),
    );
  }
}
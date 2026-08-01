import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(title: 'My QR Code'),
      body: Column(
        children: [
          if (state.loading && state.qr != null)
            LinearProgressIndicator(
              color: colorScheme.primary,
              backgroundColor: colorScheme.primaryContainer.transparency(0.2),
            ),

          Expanded(
            child: state.loading && state.qr == null
                ? const Center(child: CircularProgressIndicator())
                : state.qr == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorMessage ??
                              "No QR code asset metadata available",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        FilledButton(
                          onPressed: notifier.loadQr,
                          child: const Text("Retry Setup"),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: colorScheme.outlineVariant.transparency(
                                0.2,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Text(
                                  "Scan QR to Book Appointment",
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                QrImageView(
                                  data: state.qr!.qrUrl,
                                  version: QrVersions.auto,
                                  size: 250,
                                  eyeStyle: QrEyeStyle(
                                    eyeShape: QrEyeShape.square,
                                    color: colorScheme.primary,
                                  ),
                                  dataModuleStyle: QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.square,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  state.qr!.doctorName,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  state.qr!.specialization,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Doctor ID",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                                ),
                                Text(
                                  state.qr!.doctorId.toString(),
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                SelectableText(
                                  state.qr!.qrUrl,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: FilledButton.icon(
                                    icon: const Icon(Icons.download_rounded),
                                    label: const Text("Download PDF"),
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final success = await notifier
                                          .downloadQr();
                                      if (!context.mounted) return;

                                      if (success) {
                                        _showSnackBar(
                                          context,
                                          "QR PDF downloaded successfully",
                                          isError: false,
                                        );
                                      } else {
                                        final errorState = ref.read(
                                          doctorQrProvider,
                                        );
                                        _showSnackBar(
                                          context,
                                          errorState.errorMessage ??
                                              "Failed to compile document bytes",
                                          isError: true,
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
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String msg, {
    required bool isError,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(
      context,
    ).clearSnackBars(); // Instantly flushes active sheets to avoid execution delay
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w700)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}

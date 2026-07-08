import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      appBar: AppBar(title: const Text("My QR Code"), centerTitle: true),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.qr == null
          ? Center(
              child: FilledButton(
                onPressed: notifier.loadQr,
                child: const Text("Retry"),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Card(
                    elevation: 2,
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
                          ),

                          Text(
                            state.qr!.doctorName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            state.qr!.specialization,
                            style: theme.textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 20),

                          Text("Doctor ID", style: theme.textTheme.labelLarge),

                          Text(
                            state.qr!.doctorId.toString(),
                            style: theme.textTheme.headlineSmall,
                          ),

                          const SizedBox(height: 20),

                          SelectableText(
                            state.qr!.qrUrl,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              icon: const Icon(Icons.download),
                              label: const Text("Download PDF"),
                              onPressed: () async {
                                try {
                                  await notifier.downloadQr();

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "QR downloaded successfully",
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
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
    );
  }
}

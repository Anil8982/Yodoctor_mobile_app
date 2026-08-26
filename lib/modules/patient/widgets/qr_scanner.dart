import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/controllers/qr_scanner_controller.dart';

class QrScannerSheet extends ConsumerStatefulWidget {
  const QrScannerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.transparent,
      builder: (context) => const QrScannerSheet(),
    );
  }

  @override
  ConsumerState<QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends ConsumerState<QrScannerSheet> {
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final state = ref.watch(qrScannerControllerProvider);
    final controller = ref.read(qrScannerControllerProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Camera View
          MobileScanner(
            controller: _cameraController,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                  controller.handleScannedQr(barcode.rawValue!, context);
                  break;
                }
              }
            },
          ),

          // 2. Cut-out Overlay
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              AppTheme.black.transparency(0.7),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.black.transparency(0.5),
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Scanner Frame & QR Icon (Dynamic Color based on state)
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(
                  color: state.isCooldownActive
                      ? colorScheme.error
                      : colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Icon(
                  Icons.qr_code_2_rounded,
                  size: 100,
                  color: state.isCooldownActive
                      ? colorScheme.error.transparency(0.4)
                      : colorScheme.onSurface.transparency(0.15),
                ),
              ),
            ),
          ),

          // 4. Processing Overlay
          if (state.isLoading)
            Positioned.fill(
              child: Container(
                color: AppTheme.black.transparency(0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppTheme.white),
                      const SizedBox(height: 16),
                      Text(
                        'Verifying...',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 5. Header
          Positioned(
            top: 16,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Scan Doctor QR",
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.white.transparency(0.1),
                  ),
                  icon: Icon(Icons.close, color: AppTheme.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 6. Instructions
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: state.isCooldownActive
                        ? colorScheme.errorContainer.transparency(0.9)
                        : colorScheme.primaryContainer.transparency(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    state.isCooldownActive
                        ? state.errorMessage ?? "Invalid QR - Try Again"
                        : "Scan Doctor QR",
                    style: textTheme.labelLarge?.copyWith(
                      color: state.isCooldownActive
                          ? colorScheme.onErrorContainer
                          : colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  state.isCooldownActive
                      ? "Scanner will resume shortly..."
                      : "Align the QR code within the frame",
                  style: textTheme.bodySmall?.copyWith(
                    color: AppTheme.white.withValues(alpha: 0.70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

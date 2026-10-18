import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/routes/app_routes.dart';

class QrScannerState {
  final bool isLoading;
  final String? errorMessage;
  final bool isCooldownActive;

  QrScannerState({
    this.isLoading = false,
    this.errorMessage,
    this.isCooldownActive = false,
  });

  QrScannerState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isCooldownActive,
    bool clearError = false,
  }) {
    return QrScannerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isCooldownActive: isCooldownActive ?? this.isCooldownActive,
    );
  }
}

final qrScannerControllerProvider =
NotifierProvider<QrScannerController, QrScannerState>(
  QrScannerController.new,
);

class QrScannerController extends Notifier<QrScannerState> {
  static const String _subTag = 'QrScannerController';
  Timer? _cooldownTimer;

  @override
  QrScannerState build() {
    ref.onDispose(() {
      _cooldownTimer?.cancel();
    });
    return QrScannerState();
  }

  void handleScannedQr(String scannedString, BuildContext context) {
    if (state.isLoading || state.isCooldownActive) {
      return;
    }

    AppLogger.info(
      'Parsing scanned QR string: $scannedString',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final Uri uri = Uri.parse(scannedString);
      final String? doctorIdParam = uri.queryParameters['doctorId'];

      if (doctorIdParam == null || doctorIdParam.isEmpty) {
        AppLogger.error(
          'Missing "doctorId" parameter in scanned URL',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        _triggerFastCooldown('Invalid QR: Doctor ID not found.');
        return;
      }

      final int? doctorId = int.tryParse(doctorIdParam);
      if (doctorId == null) {
        AppLogger.error(
          'Failed to parse "doctorId" as integer: $doctorIdParam',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        _triggerFastCooldown('Invalid QR: Malformed Doctor ID.');
        return;
      }

      AppLogger.success(
        'Valid Doctor ID extracted: $doctorId. Routing directly to detail page.',
        tag: LogTags.patient,
        subTag: _subTag,
      );

      _cooldownTimer?.cancel();
      state = QrScannerState();

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        GoRouter.of(context).push('${AppRoutes.doctorDetail}/$doctorId');
      }
    } catch (e, stackTrace) {
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Failed to parse QR code string',
        tag: LogTags.patient,
        subTag: _subTag,
      );
      _triggerFastCooldown('Invalid QR structure.');
    }
  }

  void _triggerFastCooldown(String message) {
    _cooldownTimer?.cancel();

    state = state.copyWith(
      isLoading: false,
      errorMessage: message,
      isCooldownActive: true,
    );

    _cooldownTimer = Timer(const Duration(milliseconds: 2000), () {
      state = QrScannerState(); // Quick reset
    });
  }

  void clearError() {
    _cooldownTimer?.cancel();
    state = QrScannerState();
  }
}
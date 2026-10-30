import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/session/app_session_controller.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'app_dialog.dart';

class LogoutDialog {
  static void show(
    BuildContext context,
    WidgetRef ref, {
    required AppRole role,
  }) {
    final isDoctor = role == AppRole.doctor;
    final l10n = AppLocalizations.of(context)!;
    final sessionController = ref.read(appSessionProvider);

    AppDialog.show(
      context: context,
      title: l10n.endingSessionTitle,
      content: l10n.logoutContent,
      icon: Icons.power_settings_new_rounded,
      confirmLabel: l10n.logoutButtonLabel,
      cancelLabel: l10n.cancel,
      isDestructive: true,
      onConfirm: () async {
        DebugLog.info(
          '${isDoctor ? "Doctor" : "Patient"} confirmed logout from dialog gate',
          tag: LogTags.auth,
          subTag: 'LogoutDialog',
        );

        try {
          await sessionController.logout(role);

          DebugLog.success(
            'Flushed session context. Dropping core router anchor.',
            tag: LogTags.auth,
            subTag: 'LogoutDialog',
          );
        } catch (e, st) {
          DebugLog.error(
            'Failed to intercept and cleanly terminate session',
            error: e,
            stackTrace: st,
            tag: LogTags.auth,
            subTag: 'LogoutDialog',
          );
        }
      },
    );
  }
}

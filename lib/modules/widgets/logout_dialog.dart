import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/session/app_session_controller.dart';
import 'app_dialog.dart';

class LogoutDialog {
  static void show(BuildContext context, WidgetRef ref, {required AppRole role}) {
    final isDoctor = role == AppRole.doctor;

    final sessionController = ref.read(appSessionProvider);

    AppDialog.show(
      context: context,
      title: 'Ending Session?',
      content: 'Are you sure you want to log out? You will need to re-authenticate to access your medical dashboard.',
      icon: Icons.power_settings_new_rounded,
      confirmLabel: 'Log Out',
      cancelLabel: 'Cancel',
      isDestructive: true,
      onConfirm: () async {
        AppLogger.info(
          '${isDoctor ? "Doctor" : "Patient"} confirmed logout from dialog gate',
          tag: LogTags.auth,
          subTag: 'LogoutDialog',
        );

        try {
          await sessionController.logout(role);

          AppLogger.success(
            'Flushed session context. Dropping core router anchor.',
            tag: LogTags.auth,
            subTag: 'LogoutDialog',
          );
        } catch (e, st) {
          AppLogger.exception(
            e,
            st,
            message: 'Failed to intercept and cleanly terminate session',
            tag: LogTags.auth,
            subTag: 'LogoutDialog',
          );
        }
      },
    );
  }
}
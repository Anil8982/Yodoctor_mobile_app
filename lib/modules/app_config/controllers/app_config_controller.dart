import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/utils/app_version_utils.dart';

import '../models/app_config_model.dart';
import '../repositories/app_config_repository.dart';
import '../repositories/firebase_app_config_repository.dart';

enum AppConfigStatus { loading, maintenance, forceUpdate, ready, error }

class AppConfigState {
  final AppConfigStatus status;
  final AppConfigModel? config;
  final String? errorMessage;

  const AppConfigState({
    this.status = AppConfigStatus.loading,
    this.config,
    this.errorMessage,
  });
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final appConfigRepositoryProvider = Provider<AppConfigRepository>((ref) {
  return FirebaseAppConfigRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

final appConfigProvider = NotifierProvider<AppConfigNotifier, AppConfigState>(
  AppConfigNotifier.new,
);

class AppConfigNotifier extends Notifier<AppConfigState> {
  static const String _subTag = 'AppConfigNotifier';

  bool _hasLoaded = false;
  bool _isLoading = false;

  @override
  AppConfigState build() {
    Future.microtask(checkAppConfig);
    return const AppConfigState();
  }

  Future<void> checkAppConfig() async {
    if (_hasLoaded || _isLoading) return;

    _isLoading = true;
    state = const AppConfigState(status: AppConfigStatus.loading);

    AppLogger.info(
      'Loading app configuration...',
      tag: LogTags.app,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(appConfigRepositoryProvider);
      final config = await repository.getAppConfig();

      AppLogger.success(
        'App configuration loaded successfully.',
        tag: LogTags.app,
        subTag: _subTag,
      );

      // 1. Maintenance check
      if (config.status.isMaintenanceMode) {
        AppLogger.warning(
          'App is currently under maintenance.',
          tag: LogTags.app,
          subTag: _subTag,
        );

        _hasLoaded = true;
        state = AppConfigState(
          status: AppConfigStatus.maintenance,
          config: config,
        );

        return;
      }

      // 2. Get installed app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      AppLogger.info(
        'Current version: $currentVersion | '
            'Minimum version: ${config.versioning.minVersion} | '
            'Latest version: ${config.versioning.latestVersion}',
        tag: LogTags.app,
        subTag: _subTag,
      );

      // 3. Force update check
      final needsForceUpdate = VersionUtils.isLower(
        currentVersion,
        config.versioning.minVersion,
      );

      if (needsForceUpdate) {
        AppLogger.warning(
          'Force update required.',
          tag: LogTags.app,
          subTag: _subTag,
        );

        _hasLoaded = true;
        state = AppConfigState(
          status: AppConfigStatus.forceUpdate,
          config: config,
        );

        return;
      }

      // 4. Ready - All checks completed successfully
      _hasLoaded = true;

      AppLogger.success(
        'App configuration check passed. Continuing to app.',
        tag: LogTags.app,
        subTag: _subTag,
      );

      state = AppConfigState(
        status: AppConfigStatus.ready,
        config: config,
      );
    } catch (e, st) {
      final userFriendlyMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Failed to load app configuration';

      state = AppConfigState(
        status: AppConfigStatus.error,
        errorMessage: userFriendlyMessage,
      );

      AppLogger.exception(
        e,
        st,
        message: 'Failed to load app configuration',
        tag: LogTags.app,
        subTag: _subTag,
      );
    } finally {
      _isLoading = false;
    }
  }

  Future<void> retryAppConfig() async {
    _hasLoaded = false;
    await checkAppConfig();
  }
}
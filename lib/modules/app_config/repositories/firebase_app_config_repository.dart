import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/storage/storage_service.dart';

import '../models/app_config_model.dart';
import 'app_config_repository.dart';

class FirebaseAppConfigRepository implements AppConfigRepository {
  final FirebaseFirestore _firestore;
  final StorageService _storageService;

  FirebaseAppConfigRepository({
    required FirebaseFirestore firestore,
    required StorageService storageService,
  })  : _firestore = firestore,
        _storageService = storageService;

  @override
  Future<AppConfigModel> getAppConfig() async {
    try {
      final config = await _fetchFromFirestore();

      // Save to cache - but don't fail if caching fails
      await _saveToCache(config);

      return config;
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Firebase error while loading app configuration: [${e.code}] ${e.message}',
        subTag: 'AppConfig',
      );

      return _getCachedConfigOrThrow(
        errorMessage: 'Unable to connect to servers. Please check your internet connection and try again.',
      );
    } catch (e, stackTrace) {
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Unexpected parsing or configuration error',
        subTag: 'AppConfig',
      );

      return _getCachedConfigOrThrow(
        errorMessage: 'Something went wrong while setting up the app. Please try again later.',
      );
    }
  }

  Future<AppConfigModel> _fetchFromFirestore() async {
    final configCollection = _firestore.collection('app_config');

    // Fetch all 4 separate documents in parallel
    final results = await Future.wait([
      configCollection.doc('versioning').get(),
      configCollection.doc('status').get(),
      configCollection.doc('legal_and_support').get(),
      configCollection.doc('app_links').get(),
    ]);

    final versioningDoc = results[0];
    final statusDoc = results[1];
    final legalDoc = results[2];
    final appLinksDoc = results[3];

    if (!versioningDoc.exists &&
        !statusDoc.exists &&
        !legalDoc.exists &&
        !appLinksDoc.exists) {
      AppLogger.warning(
        'App configuration documents not found in app_config collection',
        subTag: 'AppConfig',
      );
      throw Exception('App configuration not found.');
    }

    return AppConfigModel(
      versioning: VersioningConfig.fromJson(versioningDoc.data() ?? {}),
      status: StatusConfig.fromJson(statusDoc.data() ?? {}),
      legalAndSupport: LegalAndSupportConfig.fromJson(legalDoc.data() ?? {}),
      appLinks: AppLinksConfig.fromJson(appLinksDoc.data() ?? {}),
    );
  }

  Future<void> _saveToCache(AppConfigModel config) async {
    try {
      await _storageService.saveAppConfig(config);
      AppLogger.info(
        'Latest app configuration cached locally.',
        subTag: 'AppConfig',
      );
    } catch (e) {
      // Don't fail the whole operation if caching fails
      AppLogger.warning(
        'Failed to cache app configuration locally: $e',
        subTag: 'AppConfig',
      );
    }
  }

  AppConfigModel _getCachedConfigOrThrow({required String errorMessage}) {
    try {
      final cachedConfig = _storageService.getAppConfig();

      if (cachedConfig != null) {
        AppLogger.warning(
          'Using cached app configuration as fallback.',
          subTag: 'AppConfig',
        );
        return cachedConfig;
      }
    } catch (e) {
      AppLogger.warning(
        'Failed to read cached configuration: $e',
        subTag: 'AppConfig',
      );
    }

    throw Exception(errorMessage);
  }
}
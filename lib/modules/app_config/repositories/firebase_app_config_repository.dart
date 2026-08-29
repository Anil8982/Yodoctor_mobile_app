import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/app_config_model.dart';
import 'app_config_repository.dart';

class FirebaseAppConfigRepository implements AppConfigRepository {
  final FirebaseFirestore _firestore;

  FirebaseAppConfigRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<AppConfigModel> getAppConfig() async {
    try {
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
        AppLogger.warning('App configuration documents not found in app_config collection', subTag: 'AppConfig');
        throw Exception('App configuration not found.');
      }

      return AppConfigModel(
        versioning: VersioningConfig.fromJson(versioningDoc.data() ?? {}),
        status: StatusConfig.fromJson(statusDoc.data() ?? {}),
        legalAndSupport: LegalAndSupportConfig.fromJson(legalDoc.data() ?? {}),
        appLinks: AppLinksConfig.fromJson(appLinksDoc.data() ?? {}),
      );
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Firebase error while loading app configuration: [${e.code}] ${e.message}',
        subTag: 'AppConfig',
      );
      throw Exception('Unable to connect to servers. Please check your internet connection and try again.');
    } catch (e, stackTrace) {
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Unexpected parsing or configuration error',
        subTag: 'AppConfig',
      );
      throw Exception('Something went wrong while setting up the app. Please try again later.');
    }
  }
}
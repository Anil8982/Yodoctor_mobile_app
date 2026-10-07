import '../models/app_config_model.dart';

abstract class AppConfigRepository {
  Future<AppConfigModel> getAppConfig();
}
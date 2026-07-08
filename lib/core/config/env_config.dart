import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? '';
}
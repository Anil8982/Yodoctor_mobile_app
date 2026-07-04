import 'package:flutter/material.dart';

abstract final class AppAssets {
  static const appLogo = 'assets/logos/app_logo.png';
  static const appLogoFg = 'assets/logos/app_logo_fg.png';
  static const appLogoBg = 'assets/logos/app_logo_bg.png';

  static const badge = 'assets/logos/badge.png';
  static const icon = 'assets/logos/logo.png';

  static const logoLight = 'assets/logos/yo_light.png';
  static const logoDark = 'assets/logos/yo_dark.png';

  static const logoLightV = 'assets/logos/yo_light_v.png';
  static const logoDarkV = 'assets/logos/yo_dark_v.png';

  static const google = 'assets/logos/google.png';

  static String logo(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? logoDark
        : logoLight;
  }

  static String logoV(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? logoDarkV
        : logoLightV;
  }
}

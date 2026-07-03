abstract final class AppAssets {
  // Adaptive Icon
  static const appLogo = 'assets/logos/app_logo.png';
  static const appLogoFg = 'assets/logos/app_logo_fg.png';
  static const appLogoBg = 'assets/logos/app_logo_bg.png';

  // Badge
  static const badge = 'assets/logos/badge.png';

  // Icon Only
  static const icon = 'assets/logos/logo.png';

  // Horizontal Logos
  static const logoLight = 'assets/logos/yo_light.png';
  static const logoDark = 'assets/logos/yo_dark.png';

  // Vertical Logos
  static const logoLightV = 'assets/logos/yo_light_v.png';
  static const logoDarkV = 'assets/logos/yo_dark_v.png';

  static String logo(bool isDark) =>
      isDark ? logoDark : logoLight;

  static String logoV(bool isDark) =>
      isDark ? logoDarkV : logoLightV;
}
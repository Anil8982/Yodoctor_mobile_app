import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';

class LocaleNotifier extends Notifier<Locale> {
  static const Locale defaultLocale = Locale('en');
  static const Locale englishLocale = Locale('en');
  static const Locale hindiLocale = Locale('hi');

  static const List<Locale> supportedLocales = [
    englishLocale,
    hindiLocale,
  ];

  @override
  Locale build() {
    final storage = ref.read(storageProvider);
    final savedLanguage = storage.getLocale();

    if (savedLanguage == 'hi') {
      return hindiLocale;
    }
    return defaultLocale;
  }

  Future<void> setLocale(Locale newLocale) async {
    if (!supportedLocales.any((loc) => loc.languageCode == newLocale.languageCode)) {
      return;
    }
    state = newLocale;
    final storage = ref.read(storageProvider);
    await storage.saveLocale(newLocale.languageCode);
  }

  Future<void> toggleLocale() async {
    final nextLocale = state.languageCode == 'en' ? hindiLocale : englishLocale;
    await setLocale(nextLocale);
  }

  Future<void> clearLocale() async {
    state = defaultLocale;
    final storage = ref.read(storageProvider);
    await storage.clearLocale();
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

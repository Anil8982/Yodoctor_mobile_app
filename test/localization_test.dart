import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yodoctor/core/providers/locale_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/storage/storage_service.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/l10n/app_localizations_en.dart';
import 'package:yodoctor/l10n/app_localizations_hi.dart';

class MockStorageService extends StorageService {
  String? _savedLocale;

  @override
  Future<void> saveLocale(String languageCode) async {
    _savedLocale = languageCode;
  }

  @override
  String? getLocale() {
    return _savedLocale;
  }

  @override
  Future<void> clearLocale() async {
    _savedLocale = null;
  }
}

void main() {
  group('Localization Class Tests', () {
    test('English translations match expected keys', () {
      final l10n = AppLocalizationsEn();
      expect(l10n.dashboard, 'Dashboard');
      expect(l10n.dashboardLoadError, 'Dashboard Load Error');
      expect(l10n.tryAgain, 'Try Again');
      expect(l10n.upcomingAppointments, 'Upcoming Appointments');
      expect(l10n.noAppointments, 'No Appointments');
      expect(l10n.bookAppointment, 'Book Appointment');
      expect(l10n.patientDashboard, 'Patient Dashboard');
      expect(l10n.findYour, 'Find Your');
      expect(l10n.bestDoctorNearYou, 'Best Doctor Near You');
      expect(l10n.searchNow, 'Search Now');
      expect(l10n.noActiveToken, 'No Active Token');
      expect(l10n.tokenLabel, 'TOKEN');
      expect(l10n.waiting, 'WAITING');
      expect(l10n.patientSelf, 'Self');
      expect(l10n.servingToken('42'), 'Serving: 42');
      expect(l10n.patientsAhead('3'), '3 ahead');
      expect(l10n.patientLabel('John'), 'Patient: John');
      expect(l10n.upcomingVisitsCount(1), '1 upcoming visit');
      expect(l10n.upcomingVisitsCount(3), '3 upcoming visits');
      expect(l10n.estimatedMinutes('15'), '15 mins');
      expect(l10n.unableToCancelAppointment, 'Unable to cancel appointment');
      expect(l10n.appointmentCancelledSuccess, 'Appointment cancelled successfully');
      expect(l10n.cancelAppointment, 'Cancel Appointment');
      expect(l10n.keepAppointment, 'Keep');
      expect(l10n.close, 'Close');
      expect(l10n.appointmentTitle, 'Appointment');
      expect(l10n.detailsTitle, 'Details');
      expect(l10n.appointmentInformation, 'Appointment Information');
      expect(l10n.clinicInformation, 'Clinic Information');
      expect(l10n.clinicAddress, 'Clinic Address');
      expect(l10n.feeLabel, 'Fee');
      expect(l10n.cityLabel, 'City');
      expect(l10n.experienceLabel, 'Experience');
      expect(l10n.experienceYears('5'), '5 Yrs');
    });

    test('Hindi translations match expected keys and render correctly', () {
      final l10n = AppLocalizationsHi();
      expect(l10n.dashboard, 'डैशबोर्ड');
      expect(l10n.dashboardLoadError, 'डैशबोर्ड लोड त्रुटि');
      expect(l10n.tryAgain, 'पुनः प्रयास करें');
      expect(l10n.upcomingAppointments, 'आगामी अपॉइंटमेंट्स');
      expect(l10n.noAppointments, 'कोई अपॉइंटमेंट नहीं');
      expect(l10n.bookAppointment, 'अपॉइंटमेंट बुक करें');
      expect(l10n.patientDashboard, 'मरीज़ डैशबोर्ड');
      expect(l10n.findYour, 'ढूंढें अपना');
      expect(l10n.bestDoctorNearYou, 'नज़दीकी सर्वश्रेष्ठ डॉक्टर');
      expect(l10n.searchNow, 'अभी खोजें');
      expect(l10n.noActiveToken, 'कोई सक्रिय टोकन नहीं');
      expect(l10n.tokenLabel, 'टोकन');
      expect(l10n.waiting, 'प्रतीक्षारत');
      expect(l10n.patientSelf, 'स्वयं');
      expect(l10n.servingToken('42'), 'सेवारत: 42');
      expect(l10n.patientsAhead('3'), '3 आगे');
      expect(l10n.patientLabel('John'), 'मरीज़: John');
      expect(l10n.upcomingVisitsCount(1), '1 आगामी विज़िट');
      expect(l10n.upcomingVisitsCount(3), '3 आगामी विज़िट');
      expect(l10n.estimatedMinutes('15'), '15 मिनट');
      expect(l10n.unableToCancelAppointment, 'अपॉइंटमेंट रद्द करने में असमर्थ');
      expect(l10n.appointmentCancelledSuccess, 'अपॉइंटमेंट सफलतापूर्वक रद्द की गई');
      expect(l10n.cancelAppointment, 'अपॉइंटमेंट रद्द करें');
      expect(l10n.keepAppointment, 'रखें');
      expect(l10n.close, 'बंद करें');
      expect(l10n.appointmentTitle, 'अपॉइंटमेंट');
      expect(l10n.detailsTitle, 'विवरण');
      expect(l10n.appointmentInformation, 'अपॉइंटमेंट जानकारी');
      expect(l10n.clinicInformation, 'क्लिनिक जानकारी');
      expect(l10n.clinicAddress, 'क्लिनिक का पता');
      expect(l10n.feeLabel, 'शुल्क');
      expect(l10n.cityLabel, 'शहर');
      expect(l10n.experienceLabel, 'अनुभव');
      expect(l10n.experienceYears('5'), '5 वर्ष');
    });
  });

  group('LocaleNotifier State & Persistence Tests', () {
    test('defaults to English when storage is empty', () {
      final mockStorage = MockStorageService();
      final container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(mockStorage),
        ],
      );
      addTearDown(container.dispose);

      final locale = container.read(localeProvider);
      expect(locale, const Locale('en'));
      expect(locale.languageCode, 'en');
    });

    test('restores saved Hindi locale from storage on launch', () {
      final mockStorage = MockStorageService();
      mockStorage.saveLocale('hi');

      final container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(mockStorage),
        ],
      );
      addTearDown(container.dispose);

      final locale = container.read(localeProvider);
      expect(locale, const Locale('hi'));
      expect(locale.languageCode, 'hi');
    });

    test('updates state and persists to storage on setLocale', () async {
      final mockStorage = MockStorageService();
      final container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(mockStorage),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(localeProvider.notifier);
      await notifier.setLocale(const Locale('hi'));

      expect(container.read(localeProvider), const Locale('hi'));
      expect(mockStorage.getLocale(), 'hi');

      await notifier.setLocale(const Locale('en'));
      expect(container.read(localeProvider), const Locale('en'));
      expect(mockStorage.getLocale(), 'en');
    });

    test('toggleLocale alternates between English and Hindi', () async {
      final mockStorage = MockStorageService();
      final container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(mockStorage),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(localeProvider.notifier);
      expect(container.read(localeProvider), const Locale('en'));

      await notifier.toggleLocale();
      expect(container.read(localeProvider), const Locale('hi'));
      expect(mockStorage.getLocale(), 'hi');

      await notifier.toggleLocale();
      expect(container.read(localeProvider), const Locale('en'));
      expect(mockStorage.getLocale(), 'en');
    });

    test('ignores unsupported locale', () async {
      final mockStorage = MockStorageService();
      final container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(mockStorage),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(localeProvider.notifier);
      await notifier.setLocale(const Locale('fr'));

      expect(container.read(localeProvider), const Locale('en'));
      expect(mockStorage.getLocale(), isNull);
    });
  });

  group('Locale Widget Integration Tests', () {
    testWidgets('AppLocalizations provides localized strings based on locale', (
      tester,
    ) async {
      Widget buildTestApp(Locale locale) {
        return MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return Scaffold(
                appBar: AppBar(title: Text(l10n.dashboard)),
                body: Column(
                  children: [
                    Text(l10n.noAppointments),
                    Text(l10n.bookAppointment),
                    Text(l10n.findYour),
                    Text(l10n.bestDoctorNearYou),
                  ],
                ),
              );
            },
          ),
        );
      }

      // 1. Verify English rendering
      await tester.pumpWidget(buildTestApp(const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('No Appointments'), findsOneWidget);
      expect(find.text('Book Appointment'), findsOneWidget);
      expect(find.text('Find Your'), findsOneWidget);
      expect(find.text('Best Doctor Near You'), findsOneWidget);

      // 2. Switch to Hindi and verify re-rendering
      await tester.pumpWidget(buildTestApp(const Locale('hi')));
      await tester.pumpAndSettle();

      expect(find.text('डैशबोर्ड'), findsOneWidget);
      expect(find.text('कोई अपॉइंटमेंट नहीं'), findsOneWidget);
      expect(find.text('अपॉइंटमेंट बुक करें'), findsOneWidget);
      expect(find.text('ढूंढें अपना'), findsOneWidget);
      expect(find.text('नज़दीकी सर्वश्रेष्ठ डॉक्टर'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yodoctor/core/providers/locale_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/storage/storage_service.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/l10n/app_localizations_en.dart';
import 'package:yodoctor/l10n/app_localizations_hi.dart';
import 'package:yodoctor/modules/patient/screens/profile/widgets/profile_language_setting_card.dart';
import 'package:yodoctor/modules/patient/screens/services/models/services_model.dart';
import 'package:yodoctor/modules/patient/screens/services/widgets/services_header.dart';
import 'package:yodoctor/modules/patient/screens/services/widgets/service_card.dart';

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
      // Certificate section keys
      expect(l10n.certificateWallet, 'Certificate Wallet');
      expect(l10n.medicalCertificates, 'Medical Certificates');
      expect(l10n.applyCertificate, 'Apply Certificate');
      expect(l10n.applyForCertificate, 'Apply for Certificate');
      expect(l10n.stepType, 'Type');
      expect(l10n.stepMedicalInfo, 'Medical Info');
      expect(l10n.stepDocuments, 'Documents');
      expect(l10n.stepReview, 'Review');
      expect(l10n.certMedicalFitness, 'Medical Fitness');
      expect(l10n.certVaccination, 'Vaccination');
      expect(l10n.docProfilePhoto, 'Profile Photo');
      expect(l10n.docGovtId, 'Government ID Proof');
      expect(l10n.certificateDetails, 'Certificate Details');
      expect(l10n.certificatesTab, 'Certificates');
      expect(l10n.certificateDrawerItem, 'Certificate');
      expect(l10n.certificateCountWithFilter(0, 'All'), '0 certificates | All');
      expect(l10n.certificateCountWithFilter(1, 'All'), '1 certificate | All');
      expect(l10n.certificateCountWithFilter(5, 'Pending'), '5 certificates | Pending');
      expect(l10n.language, 'Language');
      expect(l10n.profileSettings, 'Profile Settings');
      // Services section keys
      expect(l10n.services, 'Services');
      expect(l10n.servicesTab, 'Services');
      expect(l10n.servicesHeaderTitle, 'YoDoctor Services');
      expect(l10n.servicesHeaderSubtitle, 'Select a service to get instant medical care.');
      expect(l10n.activeServicesCount(0), '0 active services');
      expect(l10n.activeServicesCount(1), '1 active service');
      expect(l10n.activeServicesCount(6), '6 active services');
      expect(l10n.serviceMedicineDeliveryTitle, 'Medicine Delivery');
      expect(l10n.serviceMedicineDeliverySubtitle, 'Essentials at your doorstep');
      expect(l10n.medicineDeliveryComingSoon, 'Medicine delivery coming soon');
      expect(l10n.serviceLabTestTitle, 'Lab Test');
      expect(l10n.serviceLabTestSubtitle, 'Sample Pickup at Your Door');
      expect(l10n.serviceQrScanTokenTitle, 'Scan Qr & get Appointment Token');
      expect(l10n.serviceQrScanTokenSubtitle, 'Scan & Book Instantly');
      expect(l10n.serviceOnlineAppointmentTitle, 'Online Booking Appointment');
      expect(l10n.serviceOnlineAppointmentSubtitle, 'Book from anywhere');
      expect(l10n.serviceMedicalCertificateTitle, 'Apply for Medical Certificate');
      expect(l10n.serviceMedicalCertificateSubtitle, 'Consult from home');
      expect(l10n.serviceHomeNursingCareTitle, 'Home Nursing Care Service booking');
      expect(l10n.serviceHomeNursingCareSubtitle, 'Care at your home');
      expect(l10n.scanDoctorQr, 'Scan Doctor QR');
      expect(l10n.verifying, 'Verifying...');
      expect(l10n.alignQrCodeWithinFrame, 'Align the QR code within the frame');
      expect(l10n.invalidQrTryAgain, 'Invalid QR - Try Again');
      expect(l10n.scannerWillResumeShortly, 'Scanner will resume shortly...');
      expect(l10n.scanQrCodeTooltip, 'Scan QR Code');
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
      expect(l10n.upcomingVisitsCount(0), '0 आगामी विज़िट');
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
      // Certificate section keys
      expect(l10n.certificateWallet, 'प्रमाणपत्र वॉलेट');
      expect(l10n.medicalCertificates, 'चिकित्सा प्रमाणपत्र');
      expect(l10n.applyCertificate, 'प्रमाणपत्र आवेदन');
      expect(l10n.applyForCertificate, 'प्रमाणपत्र के लिए आवेदन करें');
      expect(l10n.stepType, 'प्रकार');
      expect(l10n.stepMedicalInfo, 'चिकित्सा जानकारी');
      expect(l10n.stepDocuments, 'दस्तावेज़');
      expect(l10n.stepReview, 'समीक्षा');
      expect(l10n.certMedicalFitness, 'मेडिकल फिटनेस');
      expect(l10n.certVaccination, 'टीकाकरण');
      expect(l10n.docProfilePhoto, 'प्रोफ़ाइल फ़ोटो');
      expect(l10n.docGovtId, 'सरकारी पहचान पत्र');
      expect(l10n.certificateDetails, 'प्रमाणपत्र विवरण');
      expect(l10n.certificatesTab, 'प्रमाणपत्र');
      expect(l10n.certificateDrawerItem, 'प्रमाणपत्र');
      expect(l10n.certificateCountWithFilter(0, 'सभी'), '0 प्रमाणपत्र | सभी');
      expect(l10n.certificateCountWithFilter(1, 'सभी'), '1 प्रमाणपत्र | सभी');
      expect(l10n.certificateCountWithFilter(5, 'लंबित'), '5 प्रमाणपत्र | लंबित');
      expect(l10n.language, 'भाषा');
      expect(l10n.profileSettings, 'प्रोफ़ाइल सेटिंग्स');
      // Services section keys
      expect(l10n.services, 'सेवाएं');
      expect(l10n.servicesTab, 'सेवाएं');
      expect(l10n.servicesHeaderTitle, 'योडॉक्टर सेवाएं');
      expect(l10n.servicesHeaderSubtitle, 'त्वरित चिकित्सा सेवा प्राप्त करने के लिए एक सेवा चुनें।');
      expect(l10n.activeServicesCount(0), '0 सक्रिय सेवाएं');
      expect(l10n.activeServicesCount(1), '1 सक्रिय सेवा');
      expect(l10n.activeServicesCount(6), '6 सक्रिय सेवाएं');
      expect(l10n.serviceMedicineDeliveryTitle, 'दवा वितरण');
      expect(l10n.serviceMedicineDeliverySubtitle, 'ज़रूरी दवाएं आपके दरवाज़े पर');
      expect(l10n.medicineDeliveryComingSoon, 'दवा वितरण सेवा जल्द उपलब्ध होगी');
      expect(l10n.serviceLabTestTitle, 'लैब टेस्ट');
      expect(l10n.serviceLabTestSubtitle, 'घर बैठे सैंपल पिकअप');
      expect(l10n.serviceQrScanTokenTitle, 'QR स्कैन करें और टोकन पाएं');
      expect(l10n.serviceQrScanTokenSubtitle, 'स्कैन करें और तुरंत बुक करें');
      expect(l10n.serviceOnlineAppointmentTitle, 'ऑनलाइन अपॉइंटमेंट बुकिंग');
      expect(l10n.serviceOnlineAppointmentSubtitle, 'कहीं से भी बुक करें');
      expect(l10n.serviceMedicalCertificateTitle, 'मेडिकल सर्टिफिकेट के लिए आवेदन करें');
      expect(l10n.serviceMedicalCertificateSubtitle, 'घर बैठे परामर्श लें');
      expect(l10n.serviceHomeNursingCareTitle, 'होम नर्सिंग केयर सेवा बुकिंग');
      expect(l10n.serviceHomeNursingCareSubtitle, 'आपके घर पर देखभाल सेवा');
      expect(l10n.scanDoctorQr, 'डॉक्टर QR स्कैन करें');
      expect(l10n.verifying, 'सत्यापित किया जा रहा है...');
      expect(l10n.alignQrCodeWithinFrame, 'QR कोड को फ्रेम के अंदर रखें');
      expect(l10n.invalidQrTryAgain, 'अमान्य QR - पुनः प्रयास करें');
      expect(l10n.scannerWillResumeShortly, 'स्कैनर शीघ्र पुनः शुरू होगा...');
      expect(l10n.scanQrCodeTooltip, 'QR कोड स्कैन करें');
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

    testWidgets('ProfileLanguageSettingCard switches language and updates state/storage', (
      tester,
    ) async {
      final mockStorage = MockStorageService();

      Widget buildTestApp() {
        return ProviderScope(
          overrides: [
            storageProvider.overrideWithValue(mockStorage),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(localeProvider);
              return MaterialApp(
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const Scaffold(
                  body: SingleChildScrollView(
                    child: ProfileLanguageSettingCard(),
                  ),
                ),
              );
            },
          ),
        );
      }

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Default is English
      expect(find.text('LANGUAGE'), findsOneWidget);
      expect(find.text('English'), findsWidgets);

      // Tap Hindi option
      await tester.tap(find.text('हिन्दी'));
      await tester.pumpAndSettle();

      // State and storage should be updated to Hindi immediately
      expect(mockStorage.getLocale(), 'hi');
      expect(find.text('भाषा'), findsOneWidget);

      // Tap English option
      await tester.tap(find.text('English').first);
      await tester.pumpAndSettle();

      // State and storage should be updated back to English
      expect(mockStorage.getLocale(), 'en');
      expect(find.text('LANGUAGE'), findsOneWidget);
    });

    testWidgets('ServicesHeader and ServiceCard render correctly in English and Hindi', (
      tester,
    ) async {
      Widget buildServicesTestApp(Locale locale) {
        return MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ServicesHeader(servicesCount: medicalServicesList.length),
                  ...medicalServicesList.map(
                    (s) => ServiceCard(service: s),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // 1. English
      await tester.pumpWidget(buildServicesTestApp(const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('YoDoctor Services'), findsOneWidget);
      expect(find.text('Select a service to get instant medical care.'), findsOneWidget);
      expect(find.text('6 active services'), findsOneWidget);
      expect(find.text('Medicine Delivery'), findsOneWidget);
      expect(find.text('Essentials at your doorstep'), findsOneWidget);
      expect(find.text('Lab Test'), findsOneWidget);
      expect(find.text('Apply for Medical Certificate'), findsOneWidget);

      // 2. Hindi
      await tester.pumpWidget(buildServicesTestApp(const Locale('hi')));
      await tester.pumpAndSettle();

      expect(find.text('योडॉक्टर सेवाएं'), findsOneWidget);
      expect(find.text('त्वरित चिकित्सा सेवा प्राप्त करने के लिए एक सेवा चुनें।'), findsOneWidget);
      expect(find.text('6 सक्रिय सेवाएं'), findsOneWidget);
      expect(find.text('दवा वितरण'), findsOneWidget);
      expect(find.text('ज़रूरी दवाएं आपके दरवाज़े पर'), findsOneWidget);
      expect(find.text('लैब टेस्ट'), findsOneWidget);
      expect(find.text('मेडिकल सर्टिफिकेट के लिए आवेदन करें'), findsOneWidget);
    });
  });
}

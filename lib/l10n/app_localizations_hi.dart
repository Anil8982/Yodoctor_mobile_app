// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get dashboardLoadError => 'डैशबोर्ड लोड त्रुटि';

  @override
  String get dashboardLoadErrorSubtitle =>
      'सर्वर से कनेक्ट करने में असमर्थ। कृपया अपना इंटरनेट कनेक्शन जांचें।';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get upcomingAppointments => 'आगामी अपॉइंटमेंट्स';

  @override
  String get noAppointments => 'कोई अपॉइंटमेंट नहीं';

  @override
  String get bookAppointmentSubtitle => 'डॉक्टर के साथ अपॉइंटमेंट बुक करें';

  @override
  String get bookAppointment => 'अपॉइंटमेंट बुक करें';

  @override
  String get patientDashboard => 'मरीज़ डैशबोर्ड';

  @override
  String upcomingVisitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आगामी विज़िट',
      one: '1 आगामी विज़िट',
      zero: '0 आगामी विज़िट',
    );
    return '$_temp0';
  }

  @override
  String get findYour => 'ढूंढें अपना';

  @override
  String get bestDoctorNearYou => 'नज़दीकी सर्वश्रेष्ठ डॉक्टर';

  @override
  String get searchNow => 'अभी खोजें';

  @override
  String get noActiveToken => 'कोई सक्रिय टोकन नहीं';

  @override
  String get tokenAppearHere => 'आज का आपका टोकन यहाँ दिखाई देगा';

  @override
  String get tokenLabel => 'टोकन';

  @override
  String get waiting => 'प्रतीक्षारत';

  @override
  String servingToken(String token) {
    return 'सेवारत: $token';
  }

  @override
  String patientsAhead(String count) {
    return '$count आगे';
  }

  @override
  String patientLabel(String name) {
    return 'मरीज़: $name';
  }

  @override
  String get patientSelf => 'स्वयं';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageEnglish => 'English (अंग्रेज़ी)';

  @override
  String get languageHindi => 'हिन्दी (Hindi)';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String estimatedMinutes(String count) {
    return '$count मिनट';
  }

  @override
  String get unableToCancelAppointment => 'अपॉइंटमेंट रद्द करने में असमर्थ';

  @override
  String get appointmentCancelledSuccess => 'अपॉइंटमेंट सफलतापूर्वक रद्द की गई';

  @override
  String get cancelAppointment => 'अपॉइंटमेंट रद्द करें';

  @override
  String get cancelAppointmentConfirmation =>
      'क्या आप वाकई इस अपॉइंटमेंट को रद्द करना चाहते हैं?\n\nयह कार्रवाई पूर्ववत नहीं की जा सकती।';

  @override
  String get keepAppointment => 'रखें';

  @override
  String get close => 'बंद करें';

  @override
  String get appointmentTitle => 'अपॉइंटमेंट';

  @override
  String get detailsTitle => 'विवरण';

  @override
  String get appointmentInformation => 'अपॉइंटमेंट जानकारी';

  @override
  String get clinicInformation => 'क्लिनिक जानकारी';

  @override
  String get clinicAddress => 'क्लिनिक का पता';

  @override
  String get patientInfoLabel => 'मरीज़';

  @override
  String get dateLabel => 'दिनांक';

  @override
  String get timeSlotLabel => 'समय स्लॉट';

  @override
  String get tokenNumberLabel => 'टोकन';

  @override
  String get clinicLabel => 'क्लिनिक';

  @override
  String get feeLabel => 'शुल्क';

  @override
  String get cityLabel => 'शहर';

  @override
  String get experienceLabel => 'अनुभव';

  @override
  String experienceYears(String count) {
    return '$count वर्ष';
  }
}

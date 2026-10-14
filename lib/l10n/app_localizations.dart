import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// Dashboard title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Error title shown when dashboard fails to load
  ///
  /// In en, this message translates to:
  /// **'Dashboard Load Error'**
  String get dashboardLoadError;

  /// Error message when dashboard loading fails
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your internet connection.'**
  String get dashboardLoadErrorSubtitle;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Section header for upcoming appointments
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// Title shown when there are no appointments
  ///
  /// In en, this message translates to:
  /// **'No Appointments'**
  String get noAppointments;

  /// Subtitle suggesting user to book an appointment
  ///
  /// In en, this message translates to:
  /// **'Book an appointment with a doctor'**
  String get bookAppointmentSubtitle;

  /// Button to book an appointment
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// Header title when dashboard has not loaded data
  ///
  /// In en, this message translates to:
  /// **'Patient Dashboard'**
  String get patientDashboard;

  /// Badge showing number of upcoming visits
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 upcoming visit} other{{count} upcoming visits}}'**
  String upcomingVisitsCount(int count);

  /// Find your prefix in doctor search promo
  ///
  /// In en, this message translates to:
  /// **'Find Your'**
  String get findYour;

  /// Headline in doctor search card
  ///
  /// In en, this message translates to:
  /// **'Best Doctor Near You'**
  String get bestDoctorNearYou;

  /// Search button CTA text
  ///
  /// In en, this message translates to:
  /// **'Search Now'**
  String get searchNow;

  /// Title when user has no active token today
  ///
  /// In en, this message translates to:
  /// **'No Active Token'**
  String get noActiveToken;

  /// Subtitle for empty token card
  ///
  /// In en, this message translates to:
  /// **'Your token for today will appear here'**
  String get tokenAppearHere;

  /// Token badge label
  ///
  /// In en, this message translates to:
  /// **'TOKEN'**
  String get tokenLabel;

  /// Status badge for waiting token
  ///
  /// In en, this message translates to:
  /// **'WAITING'**
  String get waiting;

  /// Current serving token display
  ///
  /// In en, this message translates to:
  /// **'Serving: {token}'**
  String servingToken(String token);

  /// Number of patients ahead in the queue
  ///
  /// In en, this message translates to:
  /// **'{count} ahead'**
  String patientsAhead(String count);

  /// Label displaying patient name in appointment card
  ///
  /// In en, this message translates to:
  /// **'Patient: {name}'**
  String patientLabel(String name);

  /// Default name when appointment is for the user themselves
  ///
  /// In en, this message translates to:
  /// **'Self'**
  String get patientSelf;

  /// Modal title for language selector
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Hindi language option
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// Tooltip or action description for language switcher
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Estimated wait time in minutes
  ///
  /// In en, this message translates to:
  /// **'{count} mins'**
  String estimatedMinutes(String count);

  /// Error message when appointment cancellation fails
  ///
  /// In en, this message translates to:
  /// **'Unable to cancel appointment'**
  String get unableToCancelAppointment;

  /// Success message when appointment is cancelled
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled successfully'**
  String get appointmentCancelledSuccess;

  /// Cancel appointment button or dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get cancelAppointment;

  /// Confirmation message when canceling appointment
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?\n\nThis action cannot be undone.'**
  String get cancelAppointmentConfirmation;

  /// Button to keep appointment
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keepAppointment;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Appointment header line 1
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointmentTitle;

  /// Appointment header line 2
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// Section header for appointment info
  ///
  /// In en, this message translates to:
  /// **'Appointment Information'**
  String get appointmentInformation;

  /// Section header for clinic info
  ///
  /// In en, this message translates to:
  /// **'Clinic Information'**
  String get clinicInformation;

  /// Clinic address card label
  ///
  /// In en, this message translates to:
  /// **'Clinic Address'**
  String get clinicAddress;

  /// Patient card label
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patientInfoLabel;

  /// Date card label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// Time slot card label
  ///
  /// In en, this message translates to:
  /// **'Time Slot'**
  String get timeSlotLabel;

  /// Token number card label
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get tokenNumberLabel;

  /// Clinic name card label
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get clinicLabel;

  /// Fee card label
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get feeLabel;

  /// City card label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// Experience card label
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experienceLabel;

  /// Doctor years of experience
  ///
  /// In en, this message translates to:
  /// **'{count} Yrs'**
  String experienceYears(String count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

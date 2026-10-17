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
  /// **'{count, plural, =0{0 upcoming visits} =1{1 upcoming visit} other{{count} upcoming visits}}'**
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

  /// Search doctors by location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Search doctors by name etc.
  ///
  /// In en, this message translates to:
  /// **'Search doctors'**
  String get searchDoctors;

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

  /// Notification screen title
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// Title when no notifications match the search or filter
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUp;

  /// Subtitle when filter don't have any notifications.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications right now.'**
  String get noNotificationsMatchFilter;

  /// Shows notifications for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Shows older notifications
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get older;

  /// Shows badge of unread notifications
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 unread} =1{1 unread} other{{count} unread}}'**
  String unreadCount(num count);

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

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Subtitle for language settings option
  ///
  /// In en, this message translates to:
  /// **'Choose application language'**
  String get chooseAppLanguage;

  /// Profile settings screen title
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

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

  /// Time session card label
  ///
  /// In en, this message translates to:
  /// **'Time Session'**
  String get timeSessionLabel;

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

  /// Morning slot label
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// Evening slot label
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// License number label
  ///
  /// In en, this message translates to:
  /// **'License No.'**
  String get licenseNum;

  /// Available days label
  ///
  /// In en, this message translates to:
  /// **'Available Days'**
  String get availableDays;

  /// Find Doctors screen title
  ///
  /// In en, this message translates to:
  /// **'Find Doctors'**
  String get findDoctors;

  /// Doctor count badge
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 found} =1{1 found} other{{count} found}}'**
  String foundCount(int count);

  /// Featured Specialties header line 1 on Find doctors screen
  ///
  /// In en, this message translates to:
  /// **'Featured Specialties'**
  String get featuredSpecialties;

  /// Available Doctors header line 2 on Find doctors screen
  ///
  /// In en, this message translates to:
  /// **'Available Doctors'**
  String get availableDoctors;

  /// Title when no doctors match the search or filter
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noDoctorsFound;

  /// Subtitle when filter yields no doctors
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms or location'**
  String get noDoctorsMatchFilter;

  /// Consultation fees of doctor
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get consultation;

  /// Contact number label
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Button to book an appointment now
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// Doctor Details screen title
  ///
  /// In en, this message translates to:
  /// **'Doctor Details'**
  String get doctorDetails;

  /// Shows status of doctor availability.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Shows status of doctor availability.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// Header 1 on doctor details screen
  ///
  /// In en, this message translates to:
  /// **'About Doctor'**
  String get aboutDoctor;

  /// When need to read, doctor details more
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// When need to read, doctor details less
  ///
  /// In en, this message translates to:
  /// **'Read Less'**
  String get readLess;

  /// When no details found for doctor
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescriptionFound;

  /// Heading 1 on book appointment screen
  ///
  /// In en, this message translates to:
  /// **'Patient Profile'**
  String get patientProfile;

  /// Subtitle 1 on book appointment screen
  ///
  /// In en, this message translates to:
  /// **'For Self'**
  String get forSelf;

  /// Subtitle 2 on book appointment screen
  ///
  /// In en, this message translates to:
  /// **'Family Member'**
  String get familyMember;

  /// Button label to confirms the appointment
  ///
  /// In en, this message translates to:
  /// **'Confirm Appointment'**
  String get confirmAppointment;

  /// Message for payable information
  ///
  /// In en, this message translates to:
  /// **'Payable at clinic during visit'**
  String get payableAtClinic;

  /// Dialog title to confirms appointment
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get bookingConfirmed;

  /// Shows waiting time for own turn
  ///
  /// In en, this message translates to:
  /// **'Est. Wait Time'**
  String get estimatedWaitingTime;

  /// Button label back to home
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Certificate Wallet screen title
  ///
  /// In en, this message translates to:
  /// **'Certificate Wallet'**
  String get certificateWallet;

  /// Medical certificates header title
  ///
  /// In en, this message translates to:
  /// **'Medical Certificates'**
  String get medicalCertificates;

  /// Subtitle explaining certificate wallet functionality
  ///
  /// In en, this message translates to:
  /// **'Track requests and download approved certificate.'**
  String get trackRequestsSubtitle;

  /// Certificate count badge with active filter label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 certificates | {filter}} =1{1 certificate | {filter}} other{{count} certificates | {filter}}}'**
  String certificateCountWithFilter(int count, String filter);

  /// Search input placeholder in certificate wallet
  ///
  /// In en, this message translates to:
  /// **'Search by type or doctor...'**
  String get searchByTypeOrDoctor;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Pending filter option
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get filterPending;

  /// Approved filter option
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get filterApproved;

  /// Rejected filter option
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get filterRejected;

  /// Floating action button label for applying certificate
  ///
  /// In en, this message translates to:
  /// **'Apply Certificate'**
  String get applyCertificate;

  /// Label indicating which doctor is assigned
  ///
  /// In en, this message translates to:
  /// **'Assigned to: '**
  String get assignedTo;

  /// Button to view and download approved certificate
  ///
  /// In en, this message translates to:
  /// **'View & Download Certificate'**
  String get viewAndDownloadCertificate;

  /// Note displayed on rejected certificate card
  ///
  /// In en, this message translates to:
  /// **'Note: Request was declined by doctor due to insufficient medical evidence.'**
  String get requestDeclinedNote;

  /// Title when no certificates match the search or filter
  ///
  /// In en, this message translates to:
  /// **'No Certificates Found'**
  String get noCertificatesFound;

  /// Subtitle when filter yields no certificates
  ///
  /// In en, this message translates to:
  /// **'No certificate match the \"{filter}\" filter.'**
  String noCertificatesMatchFilter(String filter);

  /// Screen title for doctor selection screen
  ///
  /// In en, this message translates to:
  /// **'Select Certificate Doctor'**
  String get selectCertificateDoctor;

  /// Message when no certificate doctors are available
  ///
  /// In en, this message translates to:
  /// **'No certificate doctors available at the moment.'**
  String get noCertificateDoctorsAvailable;

  /// Doctor card certificate fee display
  ///
  /// In en, this message translates to:
  /// **'Certificate Fee — ₹{fee}'**
  String certificateFee(String fee);

  /// Screen title for certificate application
  ///
  /// In en, this message translates to:
  /// **'Apply for Certificate'**
  String get applyForCertificate;

  /// Subtitle showing assigned doctor and specialty
  ///
  /// In en, this message translates to:
  /// **'Requesting from {name} — {specialty}'**
  String requestingFromDoctor(String name, String specialty);

  /// Default subtitle on certificate application screen
  ///
  /// In en, this message translates to:
  /// **'Choose certificate type and details'**
  String get chooseCertificateTypeSubtitle;

  /// Step 1 name: certificate type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get stepType;

  /// Step 2 name: medical info
  ///
  /// In en, this message translates to:
  /// **'Medical Info'**
  String get stepMedicalInfo;

  /// Step 3 name: documents
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get stepDocuments;

  /// Step 4 name: review and submit
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get stepReview;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Back button label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Submit request button label
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// Validation message when no certificate type is selected
  ///
  /// In en, this message translates to:
  /// **'Please select a certificate type'**
  String get pleaseSelectCertificateType;

  /// Validation message when mandatory files are missing
  ///
  /// In en, this message translates to:
  /// **'Please upload required verification files.'**
  String get pleaseUploadRequiredFiles;

  /// Validation message when disclaimer checkbox is not ticked
  ///
  /// In en, this message translates to:
  /// **'Please confirm accuracy verification to proceed.'**
  String get pleaseConfirmAccuracy;

  /// Success message after completing certificate application and payment
  ///
  /// In en, this message translates to:
  /// **'Payment completed and certificate request submitted successfully.'**
  String get certificateRequestSuccess;

  /// Error message when certificate request submission fails
  ///
  /// In en, this message translates to:
  /// **'We couldn’t complete your certificate request. Please try again in a moment.'**
  String get certificateRequestFailed;

  /// Header title for step 1
  ///
  /// In en, this message translates to:
  /// **'Select Certificate Type'**
  String get selectCertificateType;

  /// Header description for step 1
  ///
  /// In en, this message translates to:
  /// **'Choose the matching variant for your application.'**
  String get selectCertificateTypeDesc;

  /// Medical Fitness certificate option
  ///
  /// In en, this message translates to:
  /// **'Medical Fitness'**
  String get certMedicalFitness;

  /// Medical Fitness certificate description
  ///
  /// In en, this message translates to:
  /// **'For employment or sports'**
  String get certMedicalFitnessDesc;

  /// Vaccination certificate option
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get certVaccination;

  /// Vaccination certificate description
  ///
  /// In en, this message translates to:
  /// **'Immunization records'**
  String get certVaccinationDesc;

  /// Disability certificate option
  ///
  /// In en, this message translates to:
  /// **'Disability'**
  String get certDisability;

  /// Disability certificate description
  ///
  /// In en, this message translates to:
  /// **'Official disability proof'**
  String get certDisabilityDesc;

  /// Second Opinion certificate option
  ///
  /// In en, this message translates to:
  /// **'Second Opinion'**
  String get certSecondOpinion;

  /// Second Opinion certificate description
  ///
  /// In en, this message translates to:
  /// **'Expert medical review'**
  String get certSecondOpinionDesc;

  /// Discharge Summary certificate option
  ///
  /// In en, this message translates to:
  /// **'Discharge Summary'**
  String get certDischargeSummary;

  /// Discharge Summary certificate description
  ///
  /// In en, this message translates to:
  /// **'Summary of hospital discharge'**
  String get certDischargeSummaryDesc;

  /// Assigned Doctor card title
  ///
  /// In en, this message translates to:
  /// **'Assigned Doctor'**
  String get assignedDoctor;

  /// Dropdown label for purpose of certificate
  ///
  /// In en, this message translates to:
  /// **'Purpose of Certificate'**
  String get purposeOfCertificate;

  /// Dropdown hint for certificate purpose
  ///
  /// In en, this message translates to:
  /// **'Select Purpose'**
  String get selectPurpose;

  /// Travel purpose option
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get purposeTravel;

  /// Employment purpose option
  ///
  /// In en, this message translates to:
  /// **'Employment'**
  String get purposeEmployment;

  /// Sports purpose option
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get purposeSports;

  /// School/University purpose option
  ///
  /// In en, this message translates to:
  /// **'School/University'**
  String get purposeSchoolUniversity;

  /// Insurance purpose option
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get purposeInsurance;

  /// Other purpose option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get purposeOther;

  /// Validation error for purpose field
  ///
  /// In en, this message translates to:
  /// **'Please select a purpose'**
  String get pleaseSelectPurpose;

  /// Label for additional notes text field
  ///
  /// In en, this message translates to:
  /// **'Additional Notes For Doctor'**
  String get additionalNotesForDoctor;

  /// Hint text for additional notes field
  ///
  /// In en, this message translates to:
  /// **'Any special instructions? (Optional)'**
  String get additionalNotesHint;

  /// Header title for step 2
  ///
  /// In en, this message translates to:
  /// **'Medical Details'**
  String get medicalDetails;

  /// Header description for step 2
  ///
  /// In en, this message translates to:
  /// **'Provide baseline biometrics to appear on your medical clearance.'**
  String get medicalDetailsDesc;

  /// It shows when no data/value is available
  ///
  /// In en, this message translates to:
  /// **'Not Provided'**
  String get notProvided;

  /// Full name input field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Full name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// Validation message when name is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get pleaseEnterName;

  /// Validation message for minimum characters in name
  ///
  /// In en, this message translates to:
  /// **'Name should have at least 2 characters'**
  String get nameMinCharacters;

  /// Validation error for non-alphabet characters
  ///
  /// In en, this message translates to:
  /// **'Only alphabets are allowed'**
  String get onlyAlphabetsAllowed;

  /// Email address input field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Email address field hint
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmailAddress;

  /// Validation message when email address is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get pleaseEnterEmailAddress;

  /// Phone number input field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Validation error for empty phone
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// Validation message when phone number is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// Validation message when less than 10 digits are entered in number
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get phoneMinDigitsAllowed;

  /// Date of birth field label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Hint for date picker field
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Shows Selected Date
  ///
  /// In en, this message translates to:
  /// **'Selected Date'**
  String get selectedDate;

  /// Generic required validation text
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// Gender dropdown label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Gender dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// Other gender option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// Blood group dropdown label
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// Blood group dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select Blood Group'**
  String get selectBloodGroup;

  /// Height label
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Hint for height field
  ///
  /// In en, this message translates to:
  /// **'e.g. 170'**
  String get heightHint;

  /// Validation message when age is not a valid number
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumber;

  /// Validation error when height is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid height'**
  String get enterValidHeight;

  /// Weight label
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// Hint for weight field
  ///
  /// In en, this message translates to:
  /// **'e.g. 65'**
  String get weightHint;

  /// Validation error when weight is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight'**
  String get enterValidWeight;

  /// Known medical conditions label
  ///
  /// In en, this message translates to:
  /// **'Known Medical Conditions'**
  String get knownMedicalConditions;

  /// Medical conditions hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Diabetes, Hypertension, Asthma'**
  String get medicalConditionsHint;

  /// Current medications label
  ///
  /// In en, this message translates to:
  /// **'Current Medications'**
  String get currentMedications;

  /// Medications hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Metformin 500mg, Daily Multivitamins'**
  String get medicationsHint;

  /// Header title for step 3
  ///
  /// In en, this message translates to:
  /// **'Upload Supporting Files'**
  String get uploadSupportingFiles;

  /// Header description for step 3
  ///
  /// In en, this message translates to:
  /// **'Provide documentation for validation processing.'**
  String get uploadSupportingFilesDesc;

  /// Profile photo upload label
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get docProfilePhoto;

  /// Profile photo upload hint
  ///
  /// In en, this message translates to:
  /// **'Upload your profile picture (jpg, png)'**
  String get docProfilePhotoHint;

  /// Government ID proof upload label
  ///
  /// In en, this message translates to:
  /// **'Government ID Proof'**
  String get docGovtId;

  /// Government ID proof upload hint
  ///
  /// In en, this message translates to:
  /// **'Official Identity Documentation'**
  String get docGovtIdHint;

  /// Medical reports upload label
  ///
  /// In en, this message translates to:
  /// **'Medical Reports'**
  String get docMedicalReports;

  /// Medical reports upload hint
  ///
  /// In en, this message translates to:
  /// **'Previous diagnostic data reports'**
  String get docMedicalReportsHint;

  /// Prescription upload label
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get docPrescription;

  /// Prescription upload hint
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s authorized prescriptions'**
  String get docPrescriptionHint;

  /// Status text while uploading a file
  ///
  /// In en, this message translates to:
  /// **'Uploading document...'**
  String get uploadingDocument;

  /// Status text when file upload is complete
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploadedSuccess;

  /// Tooltip for removing uploaded file
  ///
  /// In en, this message translates to:
  /// **'Delete Upload'**
  String get deleteUploadTooltip;

  /// CTA text inside document upload box
  ///
  /// In en, this message translates to:
  /// **'Click to upload'**
  String get clickToUpload;

  /// Error text when required document is missing
  ///
  /// In en, this message translates to:
  /// **'This document is required!'**
  String get documentRequired;

  /// Header title for step 4
  ///
  /// In en, this message translates to:
  /// **'Review Application'**
  String get reviewApplication;

  /// Header description for step 4
  ///
  /// In en, this message translates to:
  /// **'Confirm accuracy of entries before submitting to evaluation channels.'**
  String get reviewApplicationDesc;

  /// Card header for certificate info in review step
  ///
  /// In en, this message translates to:
  /// **'Certificate Baseline Parameters'**
  String get certificateBaselineParameters;

  /// Certificate type review label
  ///
  /// In en, this message translates to:
  /// **'Certificate Type'**
  String get certificateTypeLabel;

  /// Assigned doctor review label
  ///
  /// In en, this message translates to:
  /// **'Assigned Medical Doctor'**
  String get assignedDoctorLabel;

  /// Specialty review label
  ///
  /// In en, this message translates to:
  /// **'Medical Specialty'**
  String get medicalSpecialtyLabel;

  /// Purpose review label
  ///
  /// In en, this message translates to:
  /// **'Intended Purpose'**
  String get intendedPurposeLabel;

  /// Additional notes review label
  ///
  /// In en, this message translates to:
  /// **'Additional Context Notes'**
  String get additionalNotesLabel;

  /// Default label when field is empty
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneLabel;

  /// Not available placeholder
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailableLabel;

  /// Card header for patient info in review step
  ///
  /// In en, this message translates to:
  /// **'Patient Diagnostic Information'**
  String get patientDiagnosticInformation;

  /// Full legal name review label
  ///
  /// In en, this message translates to:
  /// **'Full Legal Name'**
  String get fullLegalNameLabel;

  /// Date of birth review label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// Gender review label
  ///
  /// In en, this message translates to:
  /// **'Biological Gender'**
  String get biologicalGenderLabel;

  /// Blood group review label
  ///
  /// In en, this message translates to:
  /// **'Blood Group Staging'**
  String get bloodGroupStagingLabel;

  /// Height review label
  ///
  /// In en, this message translates to:
  /// **'Height Metric'**
  String get heightMetricLabel;

  /// Weight review label
  ///
  /// In en, this message translates to:
  /// **'Weight Metric'**
  String get weightMetricLabel;

  /// Conditions review label
  ///
  /// In en, this message translates to:
  /// **'Chronic Medical Conditions'**
  String get chronicMedicalConditionsLabel;

  /// Prescriptions review label
  ///
  /// In en, this message translates to:
  /// **'Current Active Prescriptions'**
  String get activePrescriptionsLabel;

  /// Header for uploaded files list in review step
  ///
  /// In en, this message translates to:
  /// **'Uploaded Verification Materials'**
  String get uploadedVerificationMaterials;

  /// Legal disclaimer notice box in review step
  ///
  /// In en, this message translates to:
  /// **'By dispatching this electronic request profile, you explicitly affirm that all biometric info matches verified personal medical tracking history.'**
  String get disclaimerNotice;

  /// Legal confirmation checkbox in review step
  ///
  /// In en, this message translates to:
  /// **'I legally verify that my submitted profile fields are accurate.'**
  String get disclaimerCheckbox;

  /// Certificate details screen title
  ///
  /// In en, this message translates to:
  /// **'Certificate Details'**
  String get certificateDetails;

  /// Message when certificate is not found
  ///
  /// In en, this message translates to:
  /// **'Certificate not found'**
  String get certificateNotFound;

  /// Certificate label
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificateLabel;

  /// Doctor label
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorLabel;

  /// Purpose label
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purposeLabel;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Medicines label
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicinesLabel;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// Timeline label
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineLabel;

  /// When press Log Out, user exists out of the app
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutButtonLabel;

  /// Session ends
  ///
  /// In en, this message translates to:
  /// **'Ending Session?'**
  String get endingSessionTitle;

  /// Take confirmation from user when they exists out of app.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? You will need to re-authenticate to access your medical dashboard.'**
  String get logoutContent;

  /// Logout item label in drawer
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutDrawerItem;

  /// My Profile item label in drawer
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfileDrawerItem;

  /// Family item label in drawer
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get familyDrawerItem;

  /// Home tab label on bottom nav
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// Home item label in drawer
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeDrawerItem;

  /// Certificates tab label on bottom nav
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificatesTab;

  /// Certificate item label in drawer
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificateDrawerItem;

  /// Appointments history tab label on bottom nav
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get appointmentsTab;

  /// Appointments history item label in drawer
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsDrawerItem;

  /// Services header or screen title
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// Services tab label on bottom nav
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTab;

  /// Title displayed on services header
  ///
  /// In en, this message translates to:
  /// **'YoDoctor Services'**
  String get servicesHeaderTitle;

  /// Subtitle displayed on services header
  ///
  /// In en, this message translates to:
  /// **'Select a service to get instant medical care.'**
  String get servicesHeaderSubtitle;

  /// Active services count badge
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 active services} =1{1 active service} other{{count} active services}}'**
  String activeServicesCount(int count);

  /// Medicine Delivery service title
  ///
  /// In en, this message translates to:
  /// **'Medicine Delivery'**
  String get serviceMedicineDeliveryTitle;

  /// Medicine Delivery service subtitle
  ///
  /// In en, this message translates to:
  /// **'Essentials at your doorstep'**
  String get serviceMedicineDeliverySubtitle;

  /// Message shown when medicine delivery is tapped
  ///
  /// In en, this message translates to:
  /// **'Medicine delivery coming soon'**
  String get medicineDeliveryComingSoon;

  /// Lab Test service title
  ///
  /// In en, this message translates to:
  /// **'Lab Test'**
  String get serviceLabTestTitle;

  /// Lab Test service subtitle
  ///
  /// In en, this message translates to:
  /// **'Sample Pickup at Your Door'**
  String get serviceLabTestSubtitle;

  /// Scan QR service title
  ///
  /// In en, this message translates to:
  /// **'Scan Qr & get Appointment Token'**
  String get serviceQrScanTokenTitle;

  /// Scan QR service subtitle
  ///
  /// In en, this message translates to:
  /// **'Scan & Book Instantly'**
  String get serviceQrScanTokenSubtitle;

  /// Online booking service title
  ///
  /// In en, this message translates to:
  /// **'Online Booking Appointment'**
  String get serviceOnlineAppointmentTitle;

  /// Online booking service subtitle
  ///
  /// In en, this message translates to:
  /// **'Book from anywhere'**
  String get serviceOnlineAppointmentSubtitle;

  /// Medical certificate service title
  ///
  /// In en, this message translates to:
  /// **'Apply for Medical Certificate'**
  String get serviceMedicalCertificateTitle;

  /// Medical certificate service subtitle
  ///
  /// In en, this message translates to:
  /// **'Consult from home'**
  String get serviceMedicalCertificateSubtitle;

  /// Home nursing care service title
  ///
  /// In en, this message translates to:
  /// **'Home Nursing Care Service booking'**
  String get serviceHomeNursingCareTitle;

  /// Home nursing care service subtitle
  ///
  /// In en, this message translates to:
  /// **'Care at your home'**
  String get serviceHomeNursingCareSubtitle;

  /// Scan doctor QR sheet title
  ///
  /// In en, this message translates to:
  /// **'Scan Doctor QR'**
  String get scanDoctorQr;

  /// Verifying state in QR scanner
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// Instruction text in QR scanner
  ///
  /// In en, this message translates to:
  /// **'Align the QR code within the frame'**
  String get alignQrCodeWithinFrame;

  /// Error label in QR scanner
  ///
  /// In en, this message translates to:
  /// **'Invalid QR - Try Again'**
  String get invalidQrTryAgain;

  /// Cooldown message in QR scanner
  ///
  /// In en, this message translates to:
  /// **'Scanner will resume shortly...'**
  String get scannerWillResumeShortly;

  /// Tooltip for QR scan FAB
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCodeTooltip;

  /// Error when doctor ID is missing in scanned QR
  ///
  /// In en, this message translates to:
  /// **'Invalid QR: Doctor ID not found.'**
  String get invalidQrDoctorIdNotFound;

  /// Error when doctor ID in scanned QR is not a valid number
  ///
  /// In en, this message translates to:
  /// **'Invalid QR: Malformed Doctor ID.'**
  String get invalidQrMalformedDoctorId;

  /// Error when QR format/structure is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid QR structure.'**
  String get invalidQrStructure;

  /// Title for Book a Care Service screen
  ///
  /// In en, this message translates to:
  /// **'Book a Care Service'**
  String get bookCareService;

  /// Drawer item label for Book Care Service
  ///
  /// In en, this message translates to:
  /// **'Book Care Service'**
  String get bookCareServiceDrawerItem;

  /// Drawer item label for Home Care History
  ///
  /// In en, this message translates to:
  /// **'Home Care History'**
  String get homeCareHistoryDrawerItem;

  /// Category badge on Book Care Service screen
  ///
  /// In en, this message translates to:
  /// **'HOME HEALTHCARE SERVICES'**
  String get homeHealthcareServices;

  /// Subtitle describing home care booking
  ///
  /// In en, this message translates to:
  /// **'Schedule a nurse, home care, or consultation at your doorstep.'**
  String get scheduleNurseDesc;

  /// Personal Details section header
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// Caregiver & Urgency section header
  ///
  /// In en, this message translates to:
  /// **'Caregiver & Urgency'**
  String get caregiverAndUrgency;

  /// Type of Service section header
  ///
  /// In en, this message translates to:
  /// **'Type of Service'**
  String get typeOfService;

  /// Medical Condition field/section header
  ///
  /// In en, this message translates to:
  /// **'Medical Condition'**
  String get medicalCondition;

  /// Service Duration section header
  ///
  /// In en, this message translates to:
  /// **'Service Duration'**
  String get serviceDuration;

  /// Time Preference section header
  ///
  /// In en, this message translates to:
  /// **'Time Preference'**
  String get timePreference;

  /// Additional Notes field/section header
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// General Nursing service option
  ///
  /// In en, this message translates to:
  /// **'General Nursing'**
  String get serviceTypeGeneralNursing;

  /// Elderly Care service option
  ///
  /// In en, this message translates to:
  /// **'Elderly Care'**
  String get serviceTypeElderlyCare;

  /// Post Surgery service option
  ///
  /// In en, this message translates to:
  /// **'Post Surgery'**
  String get serviceTypePostSurgery;

  /// ICU Nurse service option
  ///
  /// In en, this message translates to:
  /// **'ICU Nurse'**
  String get serviceTypeIcuNurse;

  /// Attendant service option
  ///
  /// In en, this message translates to:
  /// **'Attendant'**
  String get serviceTypeAttendant;

  /// Morning time slot option
  ///
  /// In en, this message translates to:
  /// **'Morning (6am - 12pm)'**
  String get timeSlotMorning;

  /// Afternoon time slot option
  ///
  /// In en, this message translates to:
  /// **'Afternoon (12pm - 5pm)'**
  String get timeSlotAfternoon;

  /// Evening time slot option
  ///
  /// In en, this message translates to:
  /// **'Evening (5pm - 9pm)'**
  String get timeSlotEvening;

  /// Night time slot option
  ///
  /// In en, this message translates to:
  /// **'Night (9pm - 6am)'**
  String get timeSlotNight;

  /// Hint text for medical condition field
  ///
  /// In en, this message translates to:
  /// **'Describe medical condition, symptoms...'**
  String get medicalConditionHint;

  /// Button to submit booking request
  ///
  /// In en, this message translates to:
  /// **'Submit Booking Request'**
  String get submitBookingRequest;

  /// Success message when booking is submitted
  ///
  /// In en, this message translates to:
  /// **'Booking submitted successfully'**
  String get bookingSubmittedSuccess;

  /// Error message when booking submission fails
  ///
  /// In en, this message translates to:
  /// **'Booking request failed'**
  String get bookingRequestFailed;

  /// Validation message when duration is empty
  ///
  /// In en, this message translates to:
  /// **'Please select service duration'**
  String get pleaseSelectServiceDuration;

  /// Validation message when start date is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select start date'**
  String get pleaseSelectStartDate;

  /// Contact number field label
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// Patient age field label
  ///
  /// In en, this message translates to:
  /// **'Patient Age'**
  String get patientAge;

  /// Patient gender field label
  ///
  /// In en, this message translates to:
  /// **'Patient Gender'**
  String get patientGender;

  /// Address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Contact number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter contact number'**
  String get enterContactNumber;

  /// Validation error for empty age
  ///
  /// In en, this message translates to:
  /// **'Enter age'**
  String get enterAge;

  /// Address field hint
  ///
  /// In en, this message translates to:
  /// **'Enter complete address'**
  String get enterCompleteAddress;

  /// Validation message when full name is empty
  ///
  /// In en, this message translates to:
  /// **'Full name required'**
  String get fullNameRequired;

  /// Validation message for invalid name
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name'**
  String get enterValidName;

  /// Validation message when phone is empty
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// Validation message when phone has invalid starting digit
  ///
  /// In en, this message translates to:
  /// **'Phone no. must start with 6, 7, 8, or 9'**
  String get phoneInvalidPrefix;

  /// Validation message when age is empty
  ///
  /// In en, this message translates to:
  /// **'Age is required'**
  String get ageRequired;

  /// Validation message when age <= 0
  ///
  /// In en, this message translates to:
  /// **'Age must be greater than 0'**
  String get ageMinValidation;

  /// Validation message when age > 120
  ///
  /// In en, this message translates to:
  /// **'Age cannot be more than 120'**
  String get ageMaxValidation;

  /// Validation message when gender is not selected
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get selectGenderValidation;

  /// Validation message when address is empty
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// Validation message when address is too short
  ///
  /// In en, this message translates to:
  /// **'Address at least 5 characters'**
  String get addressMinValidation;

  /// Button to autofill location using GPS
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// Label for caregiver gender preference
  ///
  /// In en, this message translates to:
  /// **'Preferred Caregiver Gender'**
  String get preferredCaregiverGender;

  /// Hint for caregiver gender preference
  ///
  /// In en, this message translates to:
  /// **'Select Preference'**
  String get selectPreference;

  /// Option for no caregiver gender preference
  ///
  /// In en, this message translates to:
  /// **'No Preference'**
  String get noPreference;

  /// Validation message when caregiver gender is empty
  ///
  /// In en, this message translates to:
  /// **'Please select gender preference'**
  String get selectGenderPreferenceValidation;

  /// Checkbox title for emergency service
  ///
  /// In en, this message translates to:
  /// **'Need Emergency Service'**
  String get needEmergencyService;

  /// Subtitle explaining emergency turnaround time
  ///
  /// In en, this message translates to:
  /// **'Within 2 hours'**
  String get within2Hours;

  /// 1 Day duration option
  ///
  /// In en, this message translates to:
  /// **'1 Day'**
  String get duration1Day;

  /// Multiple Days duration option
  ///
  /// In en, this message translates to:
  /// **'Multiple Days'**
  String get durationMultipleDays;

  /// Weekly duration option
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get durationWeekly;

  /// Monthly duration option
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get durationMonthly;

  /// Label for number of days field
  ///
  /// In en, this message translates to:
  /// **'Number of Days'**
  String get numberOfDays;

  /// Hint for number of days field
  ///
  /// In en, this message translates to:
  /// **'Enter days'**
  String get enterDays;

  /// Validation message for invalid days value
  ///
  /// In en, this message translates to:
  /// **'Invalid days'**
  String get invalidDays;

  /// Validation message when days exceed 365
  ///
  /// In en, this message translates to:
  /// **'Max 365 days'**
  String get max365Days;

  /// Label for start date field
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// Title for Home Care History screen
  ///
  /// In en, this message translates to:
  /// **'Home Care History'**
  String get homeCareHistory;

  /// Title when home care history is empty
  ///
  /// In en, this message translates to:
  /// **'No Home Care History Yet'**
  String get noHomeCareHistoryYet;

  /// Description when home care history is empty
  ///
  /// In en, this message translates to:
  /// **'Your requested home care services will appear here once you schedule a session with our specialists.'**
  String get noHomeCareHistoryDesc;

  /// Badge label for emergency booking
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergencyBadge;

  /// Hint on card indicating it can be tapped
  ///
  /// In en, this message translates to:
  /// **'Tap for full details'**
  String get tapForFullDetails;

  /// Button and dialog title to cancel booking
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// Fallback service title
  ///
  /// In en, this message translates to:
  /// **'Home Care Service'**
  String get homeCareService;

  /// Age with years suffix
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 Years} =1{1 Year} other{{count} Years}}'**
  String yearsOld(int count);

  /// Number of days with days suffix
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 Days} =1{1 Day} other{{count} Days}}'**
  String daysCount(int count);

  /// All filter option for home care history
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get homeCareFilterAll;

  /// Pending filter option for home care history
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get homeCareFilterPending;

  /// Confirmed filter option for home care history
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED'**
  String get homeCareFilterConfirmed;

  /// Completed filter option for home care history
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get homeCareFilterCompleted;

  /// Cancelled filter option for home care history
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get homeCareFilterCancelled;

  /// Header for booking details sheet
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// Patient information section header
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get patientInformation;

  /// Patient name label
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// Combined age and gender label
  ///
  /// In en, this message translates to:
  /// **'Age / Gender'**
  String get ageGender;

  /// Caregiver preference label
  ///
  /// In en, this message translates to:
  /// **'Preference'**
  String get preference;

  /// Service information section header
  ///
  /// In en, this message translates to:
  /// **'Service Information'**
  String get serviceInformation;

  /// Service type label
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// Duration type label
  ///
  /// In en, this message translates to:
  /// **'Duration Type'**
  String get durationType;

  /// Time slot label
  ///
  /// In en, this message translates to:
  /// **'Time Slot'**
  String get timeSlot;

  /// Preferred date label
  ///
  /// In en, this message translates to:
  /// **'Preferred Date'**
  String get preferredDate;

  /// Location & Notes section header
  ///
  /// In en, this message translates to:
  /// **'Location & Notes'**
  String get locationAndNotes;

  /// Service address label
  ///
  /// In en, this message translates to:
  /// **'Service Address'**
  String get serviceAddress;

  /// Standard non-emergency booking badge
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardBooking;

  /// Error header when booking details cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Details'**
  String get failedToLoadDetails;

  /// Error message when booking details cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Unable to retrieve complete booking details. Please try again later.'**
  String get unableToRetrieveBookingDetails;

  /// Confirmation message when canceling a home care booking
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this home care booking?'**
  String get cancelBookingConfirmation;

  /// Confirmation button to cancel
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// Cancel button to keep booking
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noKeep;

  /// Loading message while cancellation is in progress
  ///
  /// In en, this message translates to:
  /// **'Cancelling booking...'**
  String get cancellingBooking;

  /// Success message when booking is cancelled
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully'**
  String get bookingCancelledSuccess;

  /// Button to book new care service
  ///
  /// In en, this message translates to:
  /// **'Book New Care Service'**
  String get bookNewCareService;

  /// Regular non-emergency booking badge
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regularBooking;

  /// Family members screen title
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// Header title on family members screen
  ///
  /// In en, this message translates to:
  /// **'Family Health Network'**
  String get familyHealthNetwork;

  /// Subtitle describing family health network
  ///
  /// In en, this message translates to:
  /// **'Monitor and manage medical data for your linked family profiles.'**
  String get familyHealthNetworkSubtitle;

  /// Active linked family member profile count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 profiles active} =1{1 profile active} other{{count} profiles active}}'**
  String activeProfilesCount(int count);

  /// Floating action button to add family member
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// Button to add family member in selection sheet
  ///
  /// In en, this message translates to:
  /// **'Add Family Member'**
  String get addFamilyMember;

  /// Dropdown placeholder to choose family member
  ///
  /// In en, this message translates to:
  /// **'Choose Member'**
  String get chooseMember;

  /// Screen header when adding a new family member
  ///
  /// In en, this message translates to:
  /// **'Add New Member'**
  String get addNewMember;

  /// Screen header when updating an existing family member
  ///
  /// In en, this message translates to:
  /// **'Update Member'**
  String get updateMember;

  /// Snackbar message when a family member is added
  ///
  /// In en, this message translates to:
  /// **'Member added successfully.'**
  String get memberAddedSuccess;

  /// Snackbar message when a family member is updated
  ///
  /// In en, this message translates to:
  /// **'Member updated successfully.'**
  String get memberUpdatedSuccess;

  /// Empty state title when no family members exist
  ///
  /// In en, this message translates to:
  /// **'No family members yet'**
  String get noFamilyMembersYet;

  /// Empty state description for family members
  ///
  /// In en, this message translates to:
  /// **'Create profiles for your family members to manage their health records easily.'**
  String get createFamilyProfilesDesc;

  /// Age label
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Height field label with unit
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCmLabel;

  /// Weight field label with unit
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKgLabel;

  /// Remove button label
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Button label to save updated member details
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Button label to save new member
  ///
  /// In en, this message translates to:
  /// **'Save Member'**
  String get saveMember;

  /// Relation label
  ///
  /// In en, this message translates to:
  /// **'Relation'**
  String get relation;

  /// Select relation dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select Relation'**
  String get selectRelation;

  /// Father relation label
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get relationFather;

  /// Mother relation label
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get relationMother;

  /// Spouse relation label
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get relationSpouse;

  /// Son relation label
  ///
  /// In en, this message translates to:
  /// **'Son'**
  String get relationSon;

  /// Daughter relation label
  ///
  /// In en, this message translates to:
  /// **'Daughter'**
  String get relationDaughter;

  /// Brother relation label
  ///
  /// In en, this message translates to:
  /// **'Brother'**
  String get relationBrother;

  /// Sister relation label
  ///
  /// In en, this message translates to:
  /// **'Sister'**
  String get relationSister;

  /// Other relation label
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get relationOther;

  /// Validation error when name is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get pleaseEnterFullName;

  /// Validation error when name has fewer than 2 characters
  ///
  /// In en, this message translates to:
  /// **'Name should have at least 2 characters'**
  String get nameMinLengthError;

  /// Validation error when gender is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get pleaseSelectGender;

  /// Hint for date of birth field
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get selectDateOfBirth;

  /// Validation error when relation is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select relation'**
  String get pleaseSelectRelation;

  /// Validation error when height is out of range
  ///
  /// In en, this message translates to:
  /// **'Height should be between 30 and 250 cm'**
  String get heightRangeError;

  /// Validation error when weight is out of range
  ///
  /// In en, this message translates to:
  /// **'Weight should be between 2 and 350 kg'**
  String get weightRangeError;

  /// Height with cm unit
  ///
  /// In en, this message translates to:
  /// **'{height} cm'**
  String heightInCm(String height);

  /// Weight with kg unit
  ///
  /// In en, this message translates to:
  /// **'{weight} kg'**
  String weightInKg(String weight);

  /// Lab tests screen title
  ///
  /// In en, this message translates to:
  /// **'Lab Tests'**
  String get labTests;

  /// Popular packages section title
  ///
  /// In en, this message translates to:
  /// **'Popular Packages'**
  String get popularPackages;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Empty state when no lab tests match category
  ///
  /// In en, this message translates to:
  /// **'No tests available in this category'**
  String get noTestsAvailableInCategory;

  /// All packages and tests screen title
  ///
  /// In en, this message translates to:
  /// **'All Packages & Tests'**
  String get allPackagesAndTests;

  /// Badge in lab hero section
  ///
  /// In en, this message translates to:
  /// **'Trusted by 50,000+ Families'**
  String get trustedByFamilies;

  /// Heading in lab hero section
  ///
  /// In en, this message translates to:
  /// **'Book Lab Tests from the Comfort of Home'**
  String get bookLabTestsComfortOfHome;

  /// Subtitle in lab hero section
  ///
  /// In en, this message translates to:
  /// **'Accurate Reports • Affordable Prices • Home Sample Collection'**
  String get labHeroSubtitle;

  /// Trust banner item 1 title
  ///
  /// In en, this message translates to:
  /// **'Lowest Prices'**
  String get lowestPrices;

  /// Trust banner item 1 description
  ///
  /// In en, this message translates to:
  /// **'Transparent'**
  String get transparentDesc;

  /// Trust banner item 2 title
  ///
  /// In en, this message translates to:
  /// **'Home Coll.'**
  String get homeCollectionShort;

  /// Trust banner item 2 description
  ///
  /// In en, this message translates to:
  /// **'7 days/week'**
  String get sevenDaysAWeek;

  /// Trust banner item 3 title
  ///
  /// In en, this message translates to:
  /// **'Accurate'**
  String get accurateTitle;

  /// Trust banner item 3 description
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedDesc;

  /// Trust banner item 4 title
  ///
  /// In en, this message translates to:
  /// **'100% Private'**
  String get hundredPercentPrivate;

  /// Trust banner item 4 description
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get encryptedDesc;

  /// Lab support banner heading
  ///
  /// In en, this message translates to:
  /// **'Not sure which test to book?'**
  String get notSureWhichTestToBook;

  /// Lab support banner description
  ///
  /// In en, this message translates to:
  /// **'Our advisors are available 7 days a week to guide you.'**
  String get labSupportAdvisorsAvailable;

  /// Call support button with phone number
  ///
  /// In en, this message translates to:
  /// **'Call {phone}'**
  String callSupportPhone(String phone);

  /// Package badge label
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get packageType;

  /// Essential test badge label
  ///
  /// In en, this message translates to:
  /// **'Essential'**
  String get essentialType;

  /// Discount badge
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String percentOff(String percent);

  /// Number of parameters count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 Params} =1{1 Param} other{{count} Params}}'**
  String paramsCount(int count);

  /// Home sample collection feature tag
  ///
  /// In en, this message translates to:
  /// **'Home Sample Collection'**
  String get homeSampleCollection;

  /// View button label
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewButton;

  /// Added to cart state label
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get addedButton;

  /// Add to cart button label
  ///
  /// In en, this message translates to:
  /// **'+ Add'**
  String get addButton;

  /// Test details title
  ///
  /// In en, this message translates to:
  /// **'Test Details'**
  String get testDetails;

  /// Error message when test is not found
  ///
  /// In en, this message translates to:
  /// **'Test not found'**
  String get testNotFound;

  /// Snackbar when test is added to cart
  ///
  /// In en, this message translates to:
  /// **'{title} added to cart'**
  String addedToCart(String title);

  /// Snackbar when test is removed from cart
  ///
  /// In en, this message translates to:
  /// **'{title} removed from cart'**
  String removedFromCart(String title);

  /// Number of parameters in test details
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 Parameters} =1{1 Parameter} other{{count} Parameters}}'**
  String parametersCount(int count);

  /// Saved amount label
  ///
  /// In en, this message translates to:
  /// **'Save ₹{amount}'**
  String saveAmount(String amount);

  /// NABL certified badge
  ///
  /// In en, this message translates to:
  /// **'NABL Certified Labs'**
  String get nablCertifiedLabs;

  /// Free home sample pickup badge
  ///
  /// In en, this message translates to:
  /// **'Free Home Sample Pickup'**
  String get freeHomeSamplePickup;

  /// 24 hours report badge
  ///
  /// In en, this message translates to:
  /// **'24 Hours Report'**
  String get twentyFourHoursReport;

  /// Section header about this test
  ///
  /// In en, this message translates to:
  /// **'About This Test'**
  String get aboutThisTest;

  /// Includes section header
  ///
  /// In en, this message translates to:
  /// **'Includes'**
  String get includes;

  /// Fallback description for lab test
  ///
  /// In en, this message translates to:
  /// **'This test helps evaluate overall health status and detects a wide range of conditions, including anemia, infection, and various other clinical parameters.'**
  String get defaultTestDescription;

  /// Add to cart button label
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// Add and book button label
  ///
  /// In en, this message translates to:
  /// **'Add & Book'**
  String get addAndBook;

  /// My cart screen title
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// Parameters included in package
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 Parameters Included} =1{1 Parameter Included} other{{count} Parameters Included}}'**
  String parametersIncluded(int count);

  /// Add more tests button
  ///
  /// In en, this message translates to:
  /// **'Add More Tests'**
  String get addMoreTests;

  /// Price summary section title
  ///
  /// In en, this message translates to:
  /// **'Price Summary'**
  String get priceSummary;

  /// Total MRP line item
  ///
  /// In en, this message translates to:
  /// **'Total MRP'**
  String get totalMRP;

  /// You save line item
  ///
  /// In en, this message translates to:
  /// **'You Save'**
  String get youSave;

  /// Banner showing discount savings in cart
  ///
  /// In en, this message translates to:
  /// **'Great deal! You\'re saving {discount}% on this order.'**
  String savingDiscountNotice(String discount);

  /// Total payable line item
  ///
  /// In en, this message translates to:
  /// **'Total Payable'**
  String get totalPayable;

  /// Proceed to book slot button
  ///
  /// In en, this message translates to:
  /// **'Proceed to Book Slot'**
  String get proceedToBookSlot;

  /// Empty cart title
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// Empty cart description
  ///
  /// In en, this message translates to:
  /// **'Looks like you haven\'t added any lab tests yet. Explore our packages to get started.'**
  String get cartEmptyDesc;

  /// Button to add tests from empty cart
  ///
  /// In en, this message translates to:
  /// **'Add Tests & Packages'**
  String get addTestsAndPackages;

  /// Book a slot screen title
  ///
  /// In en, this message translates to:
  /// **'Book a Slot'**
  String get bookSlotTitle;

  /// Number of tests selected in slot booking
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 tests selected • } =1{1 test selected • } other{{count} tests selected • }}'**
  String testsSelectedCount(int count);

  /// Step 1 title for patient details
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get patientDetails;

  /// Step 2 title for sample pickup address
  ///
  /// In en, this message translates to:
  /// **'Sample Pickup Address'**
  String get samplePickupAddress;

  /// Step 3 title for date & time selection
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get selectDateTime;

  /// Validation error and hint for full name
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// Validation error for short name
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get nameMin3Characters;

  /// Validation error for invalid age
  ///
  /// In en, this message translates to:
  /// **'Invalid age'**
  String get invalidAge;

  /// Validation error for age range
  ///
  /// In en, this message translates to:
  /// **'Age must be between 1 and 120'**
  String get ageRangeError;

  /// Hint for phone number
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit number'**
  String get enter10DigitNumber;

  /// Validation error for invalid phone
  ///
  /// In en, this message translates to:
  /// **'Enter valid 10-digit number'**
  String get enterValid10DigitNumber;

  /// Button to fetch current location
  ///
  /// In en, this message translates to:
  /// **'Use My Current Location'**
  String get useMyCurrentLocation;

  /// Full address field label
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get fullAddress;

  /// Full address field hint
  ///
  /// In en, this message translates to:
  /// **'House/Flat No., Street, Area, City'**
  String get fullAddressHint;

  /// Validation error for empty address
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddress;

  /// Validation error for short address
  ///
  /// In en, this message translates to:
  /// **'Address is too short'**
  String get addressTooShort;

  /// Snackbar message when today slots are full
  ///
  /// In en, this message translates to:
  /// **'Today\'s slots are closed. select other day slots'**
  String get todaySlotsClosedMessage;

  /// Morning shift header
  ///
  /// In en, this message translates to:
  /// **'Morning Slot'**
  String get morningSlot;

  /// Afternoon shift header
  ///
  /// In en, this message translates to:
  /// **'Afternoon Slot'**
  String get afternoonSlot;

  /// Evening shift header
  ///
  /// In en, this message translates to:
  /// **'Evening Slot'**
  String get eveningSlot;

  /// Total price label
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// Validation error when time slot is not selected
  ///
  /// In en, this message translates to:
  /// **'Select a time slot'**
  String get selectTimeSlotValidation;

  /// Error message when booking fails
  ///
  /// In en, this message translates to:
  /// **'Booking failed'**
  String get bookingFailed;

  /// Confirm and pay button
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay'**
  String get confirmAndPay;

  /// Plan name for lab test booking in payment success
  ///
  /// In en, this message translates to:
  /// **'Lab Test Booking'**
  String get labTestBooking;
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

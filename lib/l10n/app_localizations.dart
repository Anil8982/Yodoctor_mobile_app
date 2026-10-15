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

  /// Consultation fees of doctor
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get consultation;

  /// Contact to doctor
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Button to book an appointment now
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

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

  /// Hint for additional notes field
  ///
  /// In en, this message translates to:
  /// **'Describe specific conditions or background details contextually...'**
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

  /// Validation message when non-alphabetic characters are entered in name
  ///
  /// In en, this message translates to:
  /// **'Only alphabets are allowed'**
  String get onlyAlphabetsAllowed;

  /// Date of birth field label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Date field placeholder
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Required field validation message
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

  /// Height field label
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Height field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. 175'**
  String get heightHint;

  /// Validation for non-numeric number
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumber;

  /// Validation for out-of-range height
  ///
  /// In en, this message translates to:
  /// **'Enter a valid height (1 - 300 cm)'**
  String get enterValidHeight;

  /// Weight field label
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// Weight field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. 70'**
  String get weightHint;

  /// Validation for out-of-range weight
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight (1 - 500 kg)'**
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

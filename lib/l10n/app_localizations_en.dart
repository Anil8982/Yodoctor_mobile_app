// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get dashboardLoadError => 'Dashboard Load Error';

  @override
  String get dashboardLoadErrorSubtitle =>
      'Unable to connect to the server. Please check your internet connection.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get noAppointments => 'No Appointments';

  @override
  String get bookAppointmentSubtitle => 'Book an appointment with a doctor';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get patientDashboard => 'Patient Dashboard';

  @override
  String upcomingVisitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count upcoming visits',
      one: '1 upcoming visit',
      zero: '0 upcoming visits',
    );
    return '$_temp0';
  }

  @override
  String get findYour => 'Find Your';

  @override
  String get bestDoctorNearYou => 'Best Doctor Near You';

  @override
  String get searchNow => 'Search Now';

  @override
  String get location => 'Location';

  @override
  String get searchDoctors => 'Search doctors';

  @override
  String get noActiveToken => 'No Active Token';

  @override
  String get tokenAppearHere => 'Your token for today will appear here';

  @override
  String get tokenLabel => 'TOKEN';

  @override
  String get waiting => 'WAITING';

  @override
  String servingToken(String token) {
    return 'Serving: $token';
  }

  @override
  String patientsAhead(String count) {
    return '$count ahead';
  }

  @override
  String patientLabel(String name) {
    return 'Patient: $name';
  }

  @override
  String get patientSelf => 'Self';

  @override
  String get notification => 'Notification';

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get noNotificationsMatchFilter =>
      'You don\'t have any notifications right now.';

  @override
  String get today => 'Today';

  @override
  String get older => 'Older';

  @override
  String unreadCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread',
      one: '1 unread',
      zero: '0 unread',
    );
    return '$_temp0';
  }

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get language => 'Language';

  @override
  String get chooseAppLanguage => 'Choose application language';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String estimatedMinutes(String count) {
    return '$count mins';
  }

  @override
  String get unableToCancelAppointment => 'Unable to cancel appointment';

  @override
  String get appointmentCancelledSuccess =>
      'Appointment cancelled successfully';

  @override
  String get cancelAppointment => 'Cancel Appointment';

  @override
  String get cancelAppointmentConfirmation =>
      'Are you sure you want to cancel this appointment?\n\nThis action cannot be undone.';

  @override
  String get keepAppointment => 'Keep';

  @override
  String get close => 'Close';

  @override
  String get appointmentTitle => 'Appointment';

  @override
  String get detailsTitle => 'Details';

  @override
  String get appointmentInformation => 'Appointment Information';

  @override
  String get clinicInformation => 'Clinic Information';

  @override
  String get clinicAddress => 'Clinic Address';

  @override
  String get patientInfoLabel => 'Patient';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeSlotLabel => 'Time Slot';

  @override
  String get timeSessionLabel => 'Time Session';

  @override
  String get tokenNumberLabel => 'Token';

  @override
  String get clinicLabel => 'Clinic';

  @override
  String get feeLabel => 'Fee';

  @override
  String get cityLabel => 'City';

  @override
  String get experienceLabel => 'Experience';

  @override
  String experienceYears(String count) {
    return '$count Yrs';
  }

  @override
  String get morning => 'Morning';

  @override
  String get evening => 'Evening';

  @override
  String get licenseNum => 'License No.';

  @override
  String get availableDays => 'Available Days';

  @override
  String get findDoctors => 'Find Doctors';

  @override
  String foundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count found',
      one: '1 found',
      zero: '0 found',
    );
    return '$_temp0';
  }

  @override
  String get featuredSpecialties => 'Featured Specialties';

  @override
  String get availableDoctors => 'Available Doctors';

  @override
  String get noDoctorsFound => 'No doctors found';

  @override
  String get noDoctorsMatchFilter =>
      'Try adjusting your search terms or location';

  @override
  String get consultation => 'Consultation';

  @override
  String get contact => 'Contact';

  @override
  String get bookNow => 'Book Now';

  @override
  String get doctorDetails => 'Doctor Details';

  @override
  String get available => 'Available';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get aboutDoctor => 'About Doctor';

  @override
  String get readMore => 'Read More';

  @override
  String get readLess => 'Read Less';

  @override
  String get noDescriptionFound => 'No description available.';

  @override
  String get patientProfile => 'Patient Profile';

  @override
  String get forSelf => 'For Self';

  @override
  String get familyMember => 'Family Member';

  @override
  String get confirmAppointment => 'Confirm Appointment';

  @override
  String get payableAtClinic => 'Payable at clinic during visit';

  @override
  String get bookingConfirmed => 'Booking Confirmed';

  @override
  String get estimatedWaitingTime => 'Est. Wait Time';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get certificateWallet => 'Certificate Wallet';

  @override
  String get medicalCertificates => 'Medical Certificates';

  @override
  String get trackRequestsSubtitle =>
      'Track requests and download approved certificate.';

  @override
  String certificateCountWithFilter(int count, String filter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count certificates | $filter',
      one: '1 certificate | $filter',
      zero: '0 certificates | $filter',
    );
    return '$_temp0';
  }

  @override
  String get searchByTypeOrDoctor => 'Search by type or doctor...';

  @override
  String get filterAll => 'All';

  @override
  String get filterPending => 'Pending';

  @override
  String get filterApproved => 'Approved';

  @override
  String get filterRejected => 'Rejected';

  @override
  String get applyCertificate => 'Apply Certificate';

  @override
  String get assignedTo => 'Assigned to: ';

  @override
  String get viewAndDownloadCertificate => 'View & Download Certificate';

  @override
  String get requestDeclinedNote =>
      'Note: Request was declined by doctor due to insufficient medical evidence.';

  @override
  String get noCertificatesFound => 'No Certificates Found';

  @override
  String noCertificatesMatchFilter(String filter) {
    return 'No certificate match the \"$filter\" filter.';
  }

  @override
  String get selectCertificateDoctor => 'Select Certificate Doctor';

  @override
  String get noCertificateDoctorsAvailable =>
      'No certificate doctors available at the moment.';

  @override
  String certificateFee(String fee) {
    return 'Certificate Fee — ₹$fee';
  }

  @override
  String get applyForCertificate => 'Apply for Certificate';

  @override
  String requestingFromDoctor(String name, String specialty) {
    return 'Requesting from $name — $specialty';
  }

  @override
  String get chooseCertificateTypeSubtitle =>
      'Choose certificate type and details';

  @override
  String get stepType => 'Type';

  @override
  String get stepMedicalInfo => 'Medical Info';

  @override
  String get stepDocuments => 'Documents';

  @override
  String get stepReview => 'Review';

  @override
  String get cancel => 'Cancel';

  @override
  String get back => 'Back';

  @override
  String get continueButton => 'Continue';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get pleaseSelectCertificateType => 'Please select a certificate type';

  @override
  String get pleaseUploadRequiredFiles =>
      'Please upload required verification files.';

  @override
  String get pleaseConfirmAccuracy =>
      'Please confirm accuracy verification to proceed.';

  @override
  String get certificateRequestSuccess =>
      'Payment completed and certificate request submitted successfully.';

  @override
  String get certificateRequestFailed =>
      'We couldn’t complete your certificate request. Please try again in a moment.';

  @override
  String get selectCertificateType => 'Select Certificate Type';

  @override
  String get selectCertificateTypeDesc =>
      'Choose the matching variant for your application.';

  @override
  String get certMedicalFitness => 'Medical Fitness';

  @override
  String get certMedicalFitnessDesc => 'For employment or sports';

  @override
  String get certVaccination => 'Vaccination';

  @override
  String get certVaccinationDesc => 'Immunization records';

  @override
  String get certDisability => 'Disability';

  @override
  String get certDisabilityDesc => 'Official disability proof';

  @override
  String get certSecondOpinion => 'Second Opinion';

  @override
  String get certSecondOpinionDesc => 'Expert medical review';

  @override
  String get certDischargeSummary => 'Discharge Summary';

  @override
  String get certDischargeSummaryDesc => 'Summary of hospital discharge';

  @override
  String get assignedDoctor => 'Assigned Doctor';

  @override
  String get purposeOfCertificate => 'Purpose of Certificate';

  @override
  String get selectPurpose => 'Select Purpose';

  @override
  String get purposeTravel => 'Travel';

  @override
  String get purposeEmployment => 'Employment';

  @override
  String get purposeSports => 'Sports';

  @override
  String get purposeSchoolUniversity => 'School/University';

  @override
  String get purposeInsurance => 'Insurance';

  @override
  String get purposeOther => 'Other';

  @override
  String get pleaseSelectPurpose => 'Please select a purpose';

  @override
  String get additionalNotesForDoctor => 'Additional Notes For Doctor';

  @override
  String get additionalNotesHint =>
      'Describe specific conditions or background details contextually...';

  @override
  String get medicalDetails => 'Medical Details';

  @override
  String get medicalDetailsDesc =>
      'Provide baseline biometrics to appear on your medical clearance.';

  @override
  String get notProvided => 'Not Provided';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Enter full name';

  @override
  String get pleaseEnterName => 'Please enter name';

  @override
  String get nameMinCharacters => 'Name should have at least 2 characters';

  @override
  String get onlyAlphabetsAllowed => 'Only alphabets are allowed';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterEmailAddress => 'Enter email address';

  @override
  String get pleaseEnterEmailAddress => 'Please enter email address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter phone number';

  @override
  String get phoneMinDigitsAllowed => 'Enter a valid 10-digit mobile number';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectedDate => 'Selected Date';

  @override
  String get requiredField => 'Required';

  @override
  String get gender => 'Gender';

  @override
  String get selectGender => 'Select Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get bloodGroup => 'Blood Group';

  @override
  String get selectBloodGroup => 'Select Blood Group';

  @override
  String get height => 'Height';

  @override
  String get heightHint => 'e.g. 175';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String get enterValidHeight => 'Enter a valid height (1 - 300 cm)';

  @override
  String get weight => 'Weight';

  @override
  String get weightHint => 'e.g. 70';

  @override
  String get enterValidWeight => 'Enter a valid weight (1 - 500 kg)';

  @override
  String get knownMedicalConditions => 'Known Medical Conditions';

  @override
  String get medicalConditionsHint => 'e.g., Diabetes, Hypertension, Asthma';

  @override
  String get currentMedications => 'Current Medications';

  @override
  String get medicationsHint => 'e.g., Metformin 500mg, Daily Multivitamins';

  @override
  String get uploadSupportingFiles => 'Upload Supporting Files';

  @override
  String get uploadSupportingFilesDesc =>
      'Provide documentation for validation processing.';

  @override
  String get docProfilePhoto => 'Profile Photo';

  @override
  String get docProfilePhotoHint => 'Upload your profile picture (jpg, png)';

  @override
  String get docGovtId => 'Government ID Proof';

  @override
  String get docGovtIdHint => 'Official Identity Documentation';

  @override
  String get docMedicalReports => 'Medical Reports';

  @override
  String get docMedicalReportsHint => 'Previous diagnostic data reports';

  @override
  String get docPrescription => 'Prescription';

  @override
  String get docPrescriptionHint => 'Doctor\'s authorized prescriptions';

  @override
  String get uploadingDocument => 'Uploading document...';

  @override
  String get documentUploadedSuccess => 'Document uploaded successfully';

  @override
  String get deleteUploadTooltip => 'Delete Upload';

  @override
  String get clickToUpload => 'Click to upload';

  @override
  String get documentRequired => 'This document is required!';

  @override
  String get reviewApplication => 'Review Application';

  @override
  String get reviewApplicationDesc =>
      'Confirm accuracy of entries before submitting to evaluation channels.';

  @override
  String get certificateBaselineParameters => 'Certificate Baseline Parameters';

  @override
  String get certificateTypeLabel => 'Certificate Type';

  @override
  String get assignedDoctorLabel => 'Assigned Medical Doctor';

  @override
  String get medicalSpecialtyLabel => 'Medical Specialty';

  @override
  String get intendedPurposeLabel => 'Intended Purpose';

  @override
  String get additionalNotesLabel => 'Additional Context Notes';

  @override
  String get noneLabel => 'None';

  @override
  String get notAvailableLabel => 'N/A';

  @override
  String get patientDiagnosticInformation => 'Patient Diagnostic Information';

  @override
  String get fullLegalNameLabel => 'Full Legal Name';

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get biologicalGenderLabel => 'Biological Gender';

  @override
  String get bloodGroupStagingLabel => 'Blood Group Staging';

  @override
  String get heightMetricLabel => 'Height Metric';

  @override
  String get weightMetricLabel => 'Weight Metric';

  @override
  String get chronicMedicalConditionsLabel => 'Chronic Medical Conditions';

  @override
  String get activePrescriptionsLabel => 'Current Active Prescriptions';

  @override
  String get uploadedVerificationMaterials => 'Uploaded Verification Materials';

  @override
  String get disclaimerNotice =>
      'By dispatching this electronic request profile, you explicitly affirm that all biometric info matches verified personal medical tracking history.';

  @override
  String get disclaimerCheckbox =>
      'I legally verify that my submitted profile fields are accurate.';

  @override
  String get certificateDetails => 'Certificate Details';

  @override
  String get certificateNotFound => 'Certificate not found';

  @override
  String get certificateLabel => 'Certificate';

  @override
  String get doctorLabel => 'Doctor';

  @override
  String get purposeLabel => 'Purpose';

  @override
  String get statusLabel => 'Status';

  @override
  String get medicinesLabel => 'Medicines';

  @override
  String get notesLabel => 'Notes';

  @override
  String get timelineLabel => 'Timeline';

  @override
  String get logoutButtonLabel => 'Log Out';

  @override
  String get endingSessionTitle => 'Ending Session?';

  @override
  String get logoutContent =>
      'Are you sure you want to log out? You will need to re-authenticate to access your medical dashboard.';

  @override
  String get logoutDrawerItem => 'Logout';

  @override
  String get myProfileDrawerItem => 'My Profile';

  @override
  String get familyDrawerItem => 'Family';

  @override
  String get homeTab => 'Home';

  @override
  String get homeDrawerItem => 'Home';

  @override
  String get certificatesTab => 'Certificates';

  @override
  String get certificateDrawerItem => 'Certificate';

  @override
  String get appointmentsTab => 'History';

  @override
  String get appointmentsDrawerItem => 'Appointments';

  @override
  String get services => 'Services';

  @override
  String get servicesTab => 'Services';

  @override
  String get servicesHeaderTitle => 'YoDoctor Services';

  @override
  String get servicesHeaderSubtitle =>
      'Select a service to get instant medical care.';

  @override
  String activeServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active services',
      one: '1 active service',
      zero: '0 active services',
    );
    return '$_temp0';
  }

  @override
  String get serviceMedicineDeliveryTitle => 'Medicine Delivery';

  @override
  String get serviceMedicineDeliverySubtitle => 'Essentials at your doorstep';

  @override
  String get medicineDeliveryComingSoon => 'Medicine delivery coming soon';

  @override
  String get serviceLabTestTitle => 'Lab Test';

  @override
  String get serviceLabTestSubtitle => 'Sample Pickup at Your Door';

  @override
  String get serviceQrScanTokenTitle => 'Scan Qr & get Appointment Token';

  @override
  String get serviceQrScanTokenSubtitle => 'Scan & Book Instantly';

  @override
  String get serviceOnlineAppointmentTitle => 'Online Booking Appointment';

  @override
  String get serviceOnlineAppointmentSubtitle => 'Book from anywhere';

  @override
  String get serviceMedicalCertificateTitle => 'Apply for Medical Certificate';

  @override
  String get serviceMedicalCertificateSubtitle => 'Consult from home';

  @override
  String get serviceHomeNursingCareTitle => 'Home Nursing Care Service booking';

  @override
  String get serviceHomeNursingCareSubtitle => 'Care at your home';

  @override
  String get scanDoctorQr => 'Scan Doctor QR';

  @override
  String get verifying => 'Verifying...';

  @override
  String get alignQrCodeWithinFrame => 'Align the QR code within the frame';

  @override
  String get invalidQrTryAgain => 'Invalid QR - Try Again';

  @override
  String get scannerWillResumeShortly => 'Scanner will resume shortly...';

  @override
  String get scanQrCodeTooltip => 'Scan QR Code';

  @override
  String get invalidQrDoctorIdNotFound => 'Invalid QR: Doctor ID not found.';

  @override
  String get invalidQrMalformedDoctorId => 'Invalid QR: Malformed Doctor ID.';

  @override
  String get invalidQrStructure => 'Invalid QR structure.';
}

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
  String get additionalNotesHint => 'Any special instructions? (Optional)';

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
  String get heightHint => 'e.g. 170';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String get enterValidHeight => 'Enter a valid height';

  @override
  String get weight => 'Weight';

  @override
  String get weightHint => 'e.g. 65';

  @override
  String get enterValidWeight => 'Enter a valid weight';

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

  @override
  String get bookCareService => 'Book a Care Service';

  @override
  String get bookCareServiceDrawerItem => 'Book Care Service';

  @override
  String get homeCareHistoryDrawerItem => 'Home Care History';

  @override
  String get homeHealthcareServices => 'HOME HEALTHCARE SERVICES';

  @override
  String get scheduleNurseDesc =>
      'Schedule a nurse, home care, or consultation at your doorstep.';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get caregiverAndUrgency => 'Caregiver & Urgency';

  @override
  String get typeOfService => 'Type of Service';

  @override
  String get medicalCondition => 'Medical Condition';

  @override
  String get serviceDuration => 'Service Duration';

  @override
  String get timePreference => 'Time Preference';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get serviceTypeGeneralNursing => 'General Nursing';

  @override
  String get serviceTypeElderlyCare => 'Elderly Care';

  @override
  String get serviceTypePostSurgery => 'Post Surgery';

  @override
  String get serviceTypeIcuNurse => 'ICU Nurse';

  @override
  String get serviceTypeAttendant => 'Attendant';

  @override
  String get timeSlotMorning => 'Morning (6am - 12pm)';

  @override
  String get timeSlotAfternoon => 'Afternoon (12pm - 5pm)';

  @override
  String get timeSlotEvening => 'Evening (5pm - 9pm)';

  @override
  String get timeSlotNight => 'Night (9pm - 6am)';

  @override
  String get medicalConditionHint => 'Describe medical condition, symptoms...';

  @override
  String get submitBookingRequest => 'Submit Booking Request';

  @override
  String get bookingSubmittedSuccess => 'Booking submitted successfully';

  @override
  String get bookingRequestFailed => 'Booking request failed';

  @override
  String get pleaseSelectServiceDuration => 'Please select service duration';

  @override
  String get pleaseSelectStartDate => 'Please select start date';

  @override
  String get contactNumber => 'Contact Number';

  @override
  String get patientAge => 'Patient Age';

  @override
  String get patientGender => 'Patient Gender';

  @override
  String get address => 'Address';

  @override
  String get enterContactNumber => 'Enter contact number';

  @override
  String get enterAge => 'Enter age';

  @override
  String get enterCompleteAddress => 'Enter complete address';

  @override
  String get fullNameRequired => 'Full name required';

  @override
  String get enterValidName => 'Enter a valid name';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalidPrefix => 'Phone no. must start with 6, 7, 8, or 9';

  @override
  String get ageRequired => 'Age is required';

  @override
  String get ageMinValidation => 'Age must be greater than 0';

  @override
  String get ageMaxValidation => 'Age cannot be more than 120';

  @override
  String get selectGenderValidation => 'Select gender';

  @override
  String get addressRequired => 'Address is required';

  @override
  String get addressMinValidation => 'Address at least 5 characters';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get preferredCaregiverGender => 'Preferred Caregiver Gender';

  @override
  String get selectPreference => 'Select Preference';

  @override
  String get noPreference => 'No Preference';

  @override
  String get selectGenderPreferenceValidation =>
      'Please select gender preference';

  @override
  String get needEmergencyService => 'Need Emergency Service';

  @override
  String get within2Hours => 'Within 2 hours';

  @override
  String get duration1Day => '1 Day';

  @override
  String get durationMultipleDays => 'Multiple Days';

  @override
  String get durationWeekly => 'Weekly';

  @override
  String get durationMonthly => 'Monthly';

  @override
  String get numberOfDays => 'Number of Days';

  @override
  String get enterDays => 'Enter days';

  @override
  String get invalidDays => 'Invalid days';

  @override
  String get max365Days => 'Max 365 days';

  @override
  String get startDate => 'Start Date';

  @override
  String get homeCareHistory => 'Home Care History';

  @override
  String get noHomeCareHistoryYet => 'No Home Care History Yet';

  @override
  String get noHomeCareHistoryDesc =>
      'Your requested home care services will appear here once you schedule a session with our specialists.';

  @override
  String get emergencyBadge => 'Emergency';

  @override
  String get tapForFullDetails => 'Tap for full details';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get homeCareService => 'Home Care Service';

  @override
  String yearsOld(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Years',
      one: '1 Year',
      zero: '0 Years',
    );
    return '$_temp0';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Days',
      one: '1 Day',
    );
    return '$_temp0';
  }

  @override
  String get homeCareFilterAll => 'ALL';

  @override
  String get homeCareFilterPending => 'PENDING';

  @override
  String get homeCareFilterConfirmed => 'CONFIRMED';

  @override
  String get homeCareFilterCompleted => 'COMPLETED';

  @override
  String get homeCareFilterCancelled => 'CANCELLED';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get patientInformation => 'Patient Information';

  @override
  String get patientName => 'Patient Name';

  @override
  String get ageGender => 'Age / Gender';

  @override
  String get preference => 'Preference';

  @override
  String get serviceInformation => 'Service Information';

  @override
  String get serviceType => 'Service Type';

  @override
  String get durationType => 'Duration Type';

  @override
  String get timeSlot => 'Time Slot';

  @override
  String get preferredDate => 'Preferred Date';

  @override
  String get locationAndNotes => 'Location & Notes';

  @override
  String get serviceAddress => 'Service Address';

  @override
  String get standardBooking => 'Standard';

  @override
  String get failedToLoadDetails => 'Failed to Load Details';

  @override
  String get unableToRetrieveBookingDetails =>
      'Unable to retrieve complete booking details. Please try again later.';

  @override
  String get cancelBookingConfirmation =>
      'Are you sure you want to cancel this home care booking?';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get noKeep => 'No';

  @override
  String get cancellingBooking => 'Cancelling booking...';

  @override
  String get bookingCancelledSuccess => 'Booking cancelled successfully';

  @override
  String get bookNewCareService => 'Book New Care Service';

  @override
  String get regularBooking => 'Regular';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get familyHealthNetwork => 'Family Health Network';

  @override
  String get familyHealthNetworkSubtitle =>
      'Monitor and manage medical data for your linked family profiles.';

  @override
  String activeProfilesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count profiles active',
      one: '1 profile active',
      zero: '0 profiles active',
    );
    return '$_temp0';
  }

  @override
  String get addMember => 'Add Member';

  @override
  String get addFamilyMember => 'Add Family Member';

  @override
  String get chooseMember => 'Choose Member';

  @override
  String get addNewMember => 'Add New Member';

  @override
  String get updateMember => 'Update Member';

  @override
  String get memberAddedSuccess => 'Member added successfully.';

  @override
  String get memberUpdatedSuccess => 'Member updated successfully.';

  @override
  String get noFamilyMembersYet => 'No family members yet';

  @override
  String get createFamilyProfilesDesc =>
      'Create profiles for your family members to manage their health records easily.';

  @override
  String get age => 'Age';

  @override
  String get heightCmLabel => 'Height (cm)';

  @override
  String get weightKgLabel => 'Weight (kg)';

  @override
  String get remove => 'Remove';

  @override
  String get update => 'Update';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveMember => 'Save Member';

  @override
  String get relation => 'Relation';

  @override
  String get selectRelation => 'Select Relation';

  @override
  String get relationFather => 'Father';

  @override
  String get relationMother => 'Mother';

  @override
  String get relationSpouse => 'Spouse';

  @override
  String get relationSon => 'Son';

  @override
  String get relationDaughter => 'Daughter';

  @override
  String get relationBrother => 'Brother';

  @override
  String get relationSister => 'Sister';

  @override
  String get relationOther => 'Other';

  @override
  String get pleaseEnterFullName => 'Please enter full name';

  @override
  String get nameMinLengthError => 'Name should have at least 2 characters';

  @override
  String get pleaseSelectGender => 'Please select gender';

  @override
  String get selectDateOfBirth => 'Select date of birth';

  @override
  String get pleaseSelectRelation => 'Please select relation';

  @override
  String get heightRangeError => 'Height should be between 30 and 250 cm';

  @override
  String get weightRangeError => 'Weight should be between 2 and 350 kg';

  @override
  String heightInCm(String height) {
    return '$height cm';
  }

  @override
  String weightInKg(String weight) {
    return '$weight kg';
  }
}

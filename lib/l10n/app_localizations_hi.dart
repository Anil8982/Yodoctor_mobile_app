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
  String get dashboardLoadError => 'डैशबोर्ड लोड नहीं हो सका';

  @override
  String get dashboardLoadErrorSubtitle =>
      'सर्वर से कनेक्ट नहीं हो पा रहे हैं। कृपया अपना इंटरनेट चेक करें।';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get upcomingAppointments => 'आने वाले अपॉइंटमेंट्स';

  @override
  String get noAppointments => 'कोई अपॉइंटमेंट नहीं है';

  @override
  String get bookAppointmentSubtitle => 'डॉक्टर के साथ अपॉइंटमेंट बुक करें';

  @override
  String get bookAppointment => 'अपॉइंटमेंट बुक करें';

  @override
  String get patientDashboard => 'पेशेंट डैशबोर्ड';

  @override
  String upcomingVisitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आने वाली विज़िट्स',
      one: '1 आने वाली विज़िट',
      zero: 'कोई विज़िट नहीं',
    );
    return '$_temp0';
  }

  @override
  String get findYour => 'ढूंढें अपना';

  @override
  String get bestDoctorNearYou => 'नज़दीकी सबसे अच्छे डॉक्टर';

  @override
  String get searchNow => 'अभी खोजें';

  @override
  String get location => 'लोकेशन';

  @override
  String get searchDoctors => 'डॉक्टर खोजें';

  @override
  String get noActiveToken => 'कोई ऐक्टिव टोकन नहीं';

  @override
  String get tokenAppearHere => 'आज का आपका टोकन यहाँ दिखेगा';

  @override
  String get tokenLabel => 'टोकन';

  @override
  String get waiting => 'वेटिंग';

  @override
  String servingToken(String token) {
    return 'वर्तमान टोकन: $token';
  }

  @override
  String patientsAhead(String count) {
    return '$count लोग आगे हैं';
  }

  @override
  String patientLabel(String name) {
    return 'मरीज़: $name';
  }

  @override
  String get patientSelf => 'स्वयं (खुद)';

  @override
  String get notification => 'नोटिफिकेशन्स';

  @override
  String get allCaughtUp => 'सब अपडेट है!';

  @override
  String get noNotificationsMatchFilter =>
      'फ़िलहाल कोई नया नोटिफिकेशन नहीं है।';

  @override
  String get today => 'आज';

  @override
  String get older => 'पहले के';

  @override
  String unreadCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नए नोटिफिकेशन्स',
      one: '1 नया नोटिफिकेशन',
      zero: 'सब पढ़े हुए',
    );
    return '$_temp0';
  }

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get language => 'भाषा';

  @override
  String get chooseAppLanguage => 'ऐप की भाषा चुनें';

  @override
  String get profileSettings => 'प्रोफ़ाइल सेटिंग्स';

  @override
  String estimatedMinutes(String count) {
    return '$count मिनट';
  }

  @override
  String get unableToCancelAppointment => 'अपॉइंटमेंट कैंसिल नहीं हो सकी';

  @override
  String get appointmentCancelledSuccess =>
      'अपॉइंटमेंट सफलतापूर्वक कैंसिल हो गई';

  @override
  String get cancelAppointment => 'अपॉइंटमेंट कैंसिल करें';

  @override
  String get cancelAppointmentConfirmation =>
      'क्या आप वाकई यह अपॉइंटमेंट कैंसिल करना चाहते हैं?\n\nइसे वापस बदला नहीं जा सकेगा।';

  @override
  String get keepAppointment => 'रहने दें';

  @override
  String get close => 'बंद करें';

  @override
  String get appointmentTitle => 'अपॉइंटमेंट';

  @override
  String get detailsTitle => 'विवरण';

  @override
  String get appointmentInformation => 'अपॉइंटमेंट की जानकारी';

  @override
  String get clinicInformation => 'क्लिनिक की जानकारी';

  @override
  String get clinicAddress => 'क्लिनिक का पता';

  @override
  String get patientInfoLabel => 'मरीज़';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get timeSlotLabel => 'टाइम स्लॉट';

  @override
  String get timeSessionLabel => 'सेशन';

  @override
  String get tokenNumberLabel => 'टोकन नंबर';

  @override
  String get clinicLabel => 'क्लिनिक';

  @override
  String get feeLabel => 'फीस';

  @override
  String get cityLabel => 'शहर';

  @override
  String get experienceLabel => 'अनुभव';

  @override
  String experienceYears(String count) {
    return '$count साल का अनुभव';
  }

  @override
  String get morning => 'सुबह';

  @override
  String get evening => 'शाम';

  @override
  String get licenseNum => 'लाइसेंस नं.';

  @override
  String get availableDays => 'उपलब्ध दिन';

  @override
  String get findDoctors => 'डॉक्टर खोजें';

  @override
  String foundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count डॉक्टर मिले',
      one: '1 डॉक्टर मिला',
      zero: '0 डॉक्टर मिले',
    );
    return '$_temp0';
  }

  @override
  String get featuredSpecialties => 'प्रमुख विशेषज्ञताएं';

  @override
  String get availableDoctors => 'उपलब्ध डॉक्टर';

  @override
  String get noDoctorsFound => 'कोई डॉक्टर नहीं मिले';

  @override
  String get noDoctorsMatchFilter => 'सर्च या लोकेशन बदलकर दोबारा देखें';

  @override
  String get consultation => 'परामर्श फीस';

  @override
  String get contact => 'संपर्क करें';

  @override
  String get bookNow => 'अभी बुक करें';

  @override
  String get doctorDetails => 'डॉक्टर की जानकारी';

  @override
  String get available => 'उपलब्ध';

  @override
  String get notAvailable => 'उपलब्ध नहीं';

  @override
  String get aboutDoctor => 'डॉक्टर के बारे में';

  @override
  String get readMore => 'और पढ़ें';

  @override
  String get readLess => 'कम पढ़ें';

  @override
  String get noDescriptionFound => 'कोई विवरण उपलब्ध नहीं है।';

  @override
  String get patientProfile => 'मरीज़ की प्रोफ़ाइल';

  @override
  String get forSelf => 'खुद के लिए';

  @override
  String get familyMember => 'परिवार के सदस्य के लिए';

  @override
  String get confirmAppointment => 'अपॉइंटमेंट कन्फर्म करें';

  @override
  String get payableAtClinic => 'क्लिनिक में विज़िट के दौरान भुगतान करें';

  @override
  String get bookingConfirmed => 'बुकिंग कन्फर्म हो गई!';

  @override
  String get estimatedWaitingTime => 'अनुमानित वेटिंग टाइम';

  @override
  String get backToHome => 'होम पर जाएं';

  @override
  String get certificateWallet => 'सर्टिफिकेट वॉलेट';

  @override
  String get medicalCertificates => 'मेडिकल सर्टिफिकेट';

  @override
  String get trackRequestsSubtitle =>
      'रिक्वेस्ट ट्रैक करें और सर्टिफिकेट डाउनलोड करें।';

  @override
  String certificateCountWithFilter(int count, String filter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सर्टिफिकेट | $filter',
      one: '1 सर्टिफिकेट | $filter',
      zero: '0 सर्टिफिकेट | $filter',
    );
    return '$_temp0';
  }

  @override
  String certificateCountText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सर्टिफिकेट',
      one: '1 सर्टिफिकेट',
      zero: '0 सर्टिफिकेट',
    );
    return '$_temp0';
  }

  @override
  String get searchByTypeOrDoctor => 'टाइप या डॉक्टर के नाम से खोजें...';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterPending => 'पेंडिंग';

  @override
  String get filterApproved => 'स्वीकृत';

  @override
  String get filterRejected => 'अस्वीकृत';

  @override
  String get applyCertificate => 'सर्टिफिकेट के लिए अप्लाई करें';

  @override
  String get assignedTo => 'डॉक्टर: ';

  @override
  String get viewAndDownloadCertificate => 'सर्टिफिकेट देखें और डाउनलोड करें';

  @override
  String get requestDeclinedNote =>
      'नोट: पर्याप्त मेडिकल रिपोर्ट्स न होने के कारण डॉक्टर ने अनुरोध अस्वीकार कर दिया।';

  @override
  String get noCertificatesFound => 'कोई सर्टिफिकेट नहीं मिला';

  @override
  String noCertificatesMatchFilter(String filter) {
    return '\"$filter\" में कोई सर्टिफिकेट नहीं है।';
  }

  @override
  String get selectCertificateDoctor => 'डॉक्टर चुनें';

  @override
  String get noCertificateDoctorsAvailable =>
      'फिलहाल कोई डॉक्टर उपलब्ध नहीं हैं।';

  @override
  String certificateFee(String fee) {
    return 'सर्टिफिकेट फीस — ₹$fee';
  }

  @override
  String get applyForCertificate => 'मेडिकल सर्टिफिकेट आवेदन';

  @override
  String requestingFromDoctor(String name, String specialty) {
    return '$name ($specialty) से अनुरोध';
  }

  @override
  String get chooseCertificateTypeSubtitle =>
      'सर्टिफिकेट का प्रकार और विवरण चुनें';

  @override
  String get stepType => 'प्रकार';

  @override
  String get stepMedicalInfo => 'मेडिकल विवरण';

  @override
  String get stepDocuments => 'दस्तावेज़';

  @override
  String get stepReview => 'रिव्यू';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get back => 'पीछे जाएं';

  @override
  String get continueButton => 'आगे बढ़ें';

  @override
  String get submitRequest => 'रिक्वेस्ट सबमिट करें';

  @override
  String get pleaseSelectCertificateType => 'कृपया सर्टिफिकेट का प्रकार चुनें';

  @override
  String get pleaseUploadRequiredFiles => 'कृपया ज़रूरी दस्तावेज़ अपलोड करें।';

  @override
  String get pleaseConfirmAccuracy =>
      'आगे बढ़ने के लिए कृपया जानकारी की पुष्टि करें।';

  @override
  String get certificateRequestSuccess =>
      'पेमेंट पूरा हुआ और सर्टिफिकेट रिक्वेस्ट सफलतापूर्वक सबमिट हो गई।';

  @override
  String get certificateRequestFailed =>
      'अनुरोध पूरा नहीं हो सका। कृपया थोड़ी देर बाद फिर कोशिश करें।';

  @override
  String get selectCertificateType => 'सर्टिफिकेट का प्रकार चुनें';

  @override
  String get selectCertificateTypeDesc =>
      'अपनी ज़रूरत के अनुसार सही विकल्प चुनें।';

  @override
  String get certMedicalFitness => 'मेडिकल फिटनेस';

  @override
  String get certMedicalFitnessDesc => 'नौकरी या खेलकूद के लिए';

  @override
  String get certVaccination => 'वैक्सीनेशन (टीकाकरण)';

  @override
  String get certVaccinationDesc => 'टीकाकरण रिकॉर्ड के लिए';

  @override
  String get certDisability => 'दिव्यांगता सर्टिफिकेट';

  @override
  String get certDisabilityDesc => 'आधिकारिक दिव्यांगता प्रमाण';

  @override
  String get certSecondOpinion => 'सेकंड ओपिनियन';

  @override
  String get certSecondOpinionDesc => 'विशेषज्ञ डॉक्टर की राय';

  @override
  String get certDischargeSummary => 'डिस्चार्ज समरी';

  @override
  String get certDischargeSummaryDesc => 'अस्पताल डिस्चार्ज का सारांश';

  @override
  String get assignedDoctor => 'चुने गए डॉक्टर';

  @override
  String get purposeOfCertificate => 'सर्टिफिकेट का उद्देश्य';

  @override
  String get selectPurpose => 'उद्देश्य चुनें';

  @override
  String get purposeTravel => 'यात्रा (Travel)';

  @override
  String get purposeEmployment => 'नौकरी (Job)';

  @override
  String get purposeSports => 'खेलकूद (Sports)';

  @override
  String get purposeSchoolUniversity => 'स्कूल / कॉलेज';

  @override
  String get purposeInsurance => 'बीमा (Insurance)';

  @override
  String get purposeOther => 'अन्य';

  @override
  String get pleaseSelectPurpose => 'कृपया उद्देश्य चुनें';

  @override
  String get additionalNotesForDoctor => 'डॉक्टर के लिए अतिरिक्त जानकारी';

  @override
  String get additionalNotesHint => 'कोई विशेष निर्देश? (वैकल्पिक)';

  @override
  String get medicalDetails => 'मेडिकल जानकारी';

  @override
  String get medicalDetailsDesc =>
      'सर्टिफिकेट पर दर्शाने के लिए अपनी बुनियादी जानकारी दर्ज करें।';

  @override
  String get notProvided => 'उपलब्ध नहीं';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get enterFullName => 'पूरा नाम लिखें';

  @override
  String get pleaseEnterName => 'कृपया नाम दर्ज करें';

  @override
  String get nameMinCharacters => 'नाम में कम से कम 2 अक्षर होने चाहिए';

  @override
  String get onlyAlphabetsAllowed => 'केवल अक्षरों की अनुमति है';

  @override
  String get emailAddress => 'ईमेल आईडी';

  @override
  String get enterEmailAddress => 'ईमेल आईडी दर्ज करें';

  @override
  String get pleaseEnterEmailAddress => 'कृपया ईमेल आईडी दर्ज करें';

  @override
  String get phoneNumber => 'मोबाइल नंबर';

  @override
  String get enterPhoneNumber => 'फ़ोन नंबर दर्ज करें';

  @override
  String get pleaseEnterPhoneNumber => 'कृपया मोबाइल नंबर दर्ज करें';

  @override
  String get phoneMinDigitsAllowed => '10 अंकों का सही मोबाइल नंबर दर्ज करें';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get selectDate => 'तारीख चुनें';

  @override
  String get selectedDate => 'चुनी गई तारीख';

  @override
  String get requiredField => 'यह फ़ील्ड ज़रूरी है';

  @override
  String get gender => 'लिंग';

  @override
  String get selectGender => 'लिंग चुनें';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'महिला';

  @override
  String get genderOther => 'अन्य';

  @override
  String get bloodGroup => 'ब्लड ग्रुप';

  @override
  String get selectBloodGroup => 'ब्लड ग्रुप चुनें';

  @override
  String get height => 'ऊंचाई (Height)';

  @override
  String get heightHint => 'जैसे 175 सेमी';

  @override
  String get enterValidNumber => 'मान्य संख्या दर्ज करें';

  @override
  String get enterValidHeight => 'सही ऊंचाई दर्ज करें';

  @override
  String get weight => 'वजन (Weight)';

  @override
  String get weightHint => 'जैसे 70 किग्रा';

  @override
  String get enterValidWeight => 'सही वजन दर्ज करें';

  @override
  String get knownMedicalConditions => 'पुरानी बीमारियां (यदि कोई हो)';

  @override
  String get medicalConditionsHint => 'जैसे डायबिटीज़, बीपी, अस्थमा';

  @override
  String get currentMedications => 'वर्तमान में चल रही दवाएं';

  @override
  String get medicationsHint => 'जैसे मेटफ़ॉर्मिन 500mg, विटामिन्स';

  @override
  String get uploadSupportingFiles => 'दस्तावेज़ अपलोड करें';

  @override
  String get uploadSupportingFilesDesc =>
      'सत्यापन के लिए ज़रूरी दस्तावेज़ अपलोड करें।';

  @override
  String get docProfilePhoto => 'प्रोफ़ाइल फ़ोटो';

  @override
  String get docProfilePhotoHint => 'अपनी फ़ोटो अपलोड करें (JPG, PNG)';

  @override
  String get docGovtId => 'सरकारी पहचान पत्र';

  @override
  String get docGovtIdHint => 'आधार, पैन या वोटर आईडी कार्ड';

  @override
  String get docMedicalReports => 'मेडिकल रिपोर्ट्स';

  @override
  String get docMedicalReportsHint => 'पुरानी टेस्ट या जांच रिपोर्ट्स';

  @override
  String get docPrescription => 'डॉक्टर का पर्चा (Prescription)';

  @override
  String get docPrescriptionHint => 'डॉक्टर द्वारा लिखा गया पर्चा';

  @override
  String get uploadingDocument => 'दस्तावेज़ अपलोड हो रहा है...';

  @override
  String get documentUploadedSuccess => 'दस्तावेज़ अपलोड हो गया';

  @override
  String get deleteUploadTooltip => 'हटाएं';

  @override
  String get clickToUpload => 'अपलोड करने के लिए टैप करें';

  @override
  String get documentRequired => 'यह दस्तावेज़ अपलोड करना ज़रूरी है!';

  @override
  String get reviewApplication => 'आवेदन की समीक्षा करें';

  @override
  String get reviewApplicationDesc =>
      'सबमिट करने से पहले कृपया सभी जानकारी जांच लें।';

  @override
  String get certificateBaselineParameters => 'सर्टिफिकेट विवरण';

  @override
  String get certificateTypeLabel => 'सर्टिफिकेट प्रकार';

  @override
  String get assignedDoctorLabel => 'डॉक्टर';

  @override
  String get medicalSpecialtyLabel => 'विशेषज्ञता';

  @override
  String get intendedPurposeLabel => 'उद्देश्य';

  @override
  String get additionalNotesLabel => 'अतिरिक्त नोट्स';

  @override
  String get noneLabel => 'कोई नहीं';

  @override
  String get notAvailableLabel => 'उपलब्ध नहीं';

  @override
  String get patientDiagnosticInformation => 'मरीज़ का विवरण';

  @override
  String get fullLegalNameLabel => 'पूरा नाम';

  @override
  String get dateOfBirthLabel => 'जन्म तिथि';

  @override
  String get biologicalGenderLabel => 'लिंग';

  @override
  String get bloodGroupStagingLabel => 'ब्लड ग्रुप';

  @override
  String get heightMetricLabel => 'ऊंचाई';

  @override
  String get weightMetricLabel => 'वजन';

  @override
  String get chronicMedicalConditionsLabel => 'पुरानी बीमारियां';

  @override
  String get activePrescriptionsLabel => 'चल रही दवाएं';

  @override
  String get uploadedVerificationMaterials => 'अपलोड किए गए दस्तावेज़';

  @override
  String get disclaimerNotice =>
      'यह अनुरोध भेजकर आप पुष्टि करते हैं कि दर्ज की गई सभी स्वास्थ्य जानकारी बिल्कुल सटीक और प्रामाणिक है।';

  @override
  String get disclaimerCheckbox =>
      'मैं पुष्टि करता/करती हूँ कि दी गई सभी जानकारी सही है।';

  @override
  String get certificateDetails => 'सर्टिफिकेट विवरण';

  @override
  String get certificateNotFound => 'सर्टिफिकेट नहीं मिला';

  @override
  String get certificateLabel => 'सर्टिफिकेट';

  @override
  String get doctorLabel => 'डॉक्टर';

  @override
  String get purposeLabel => 'उद्देश्य';

  @override
  String get statusLabel => 'स्थिति';

  @override
  String get medicinesLabel => 'दवाएं';

  @override
  String get notesLabel => 'नोट्स';

  @override
  String get timelineLabel => 'टाइमलाइन';

  @override
  String get logoutButtonLabel => 'लॉग आउट करें';

  @override
  String get endingSessionTitle => 'लॉग आउट करें?';

  @override
  String get logoutContent =>
      'क्या आप वाकई लॉग आउट करना चाहते हैं? दोबारा इस्तेमाल करने के लिए आपको फिर से लॉगिन करना होगा।';

  @override
  String get logoutDrawerItem => 'लॉग आउट';

  @override
  String get myProfileDrawerItem => 'मेरी प्रोफ़ाइल';

  @override
  String get familyDrawerItem => 'परिवार';

  @override
  String get homeTab => 'होम';

  @override
  String get homeDrawerItem => 'होम';

  @override
  String get certificatesTab => 'सर्टिफिकेट्स';

  @override
  String get certificateDrawerItem => 'सर्टिफिकेट';

  @override
  String get appointmentsTab => 'अपॉइंटमेंट्स';

  @override
  String get appointmentsDrawerItem => 'अपॉइंटमेंट्स';

  @override
  String get services => 'सेवाएं';

  @override
  String get servicesTab => 'सेवाएं';

  @override
  String get servicesHeaderTitle => 'YoDoctor सेवाएं';

  @override
  String get servicesHeaderSubtitle =>
      'त्वरित चिकित्सा सेवा के लिए उपयुक्त विकल्प चुनें।';

  @override
  String activeServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेवाएं उपलब्ध',
      one: '1 सेवा उपलब्ध',
      zero: '0 सेवाएं उपलब्ध',
    );
    return '$_temp0';
  }

  @override
  String get serviceMedicineDeliveryTitle => 'दवा मंगवाएं';

  @override
  String get serviceMedicineDeliverySubtitle => 'ज़रूरी दवाएं सीधे आपके घर पर';

  @override
  String get medicineDeliveryComingSoon => 'दवा डिलीवरी सेवा जल्द ही शुरू होगी';

  @override
  String get serviceLabTestTitle => 'लैब टेस्ट';

  @override
  String get serviceLabTestSubtitle => 'घर बैठे सैंपल कलेक्शन';

  @override
  String get serviceQrScanTokenTitle => 'QR स्कैन करें और टोकन लें';

  @override
  String get serviceQrScanTokenSubtitle => 'स्कैन करें और तुरंत टोकन पाएं';

  @override
  String get serviceOnlineAppointmentTitle => 'ऑनलाइन अपॉइंटमेंट';

  @override
  String get serviceOnlineAppointmentSubtitle => 'कहीं से भी डॉक्टर बुक करें';

  @override
  String get serviceMedicalCertificateTitle => 'मेडिकल सर्टिफिकेट';

  @override
  String get serviceMedicalCertificateSubtitle => 'घर बैठे डॉक्टर से बनवाएं';

  @override
  String get serviceHomeNursingCareTitle => 'होम नर्सिंग केयर';

  @override
  String get serviceHomeNursingCareSubtitle => 'घर पर देखभाल और नर्सिंग सेवा';

  @override
  String get scanDoctorQr => 'डॉक्टर का QR स्कैन करें';

  @override
  String get verifying => 'जांच हो रही है...';

  @override
  String get alignQrCodeWithinFrame => 'QR कोड को फ्रेम के बीच में लाएं';

  @override
  String get invalidQrTryAgain => 'अमान्य QR - फिर कोशिश करें';

  @override
  String get scannerWillResumeShortly => 'स्कैनर तुरंत दोबारा शुरू होगा...';

  @override
  String get scanQrCodeTooltip => 'QR कोड स्कैन करें';

  @override
  String get invalidQrDoctorIdNotFound => 'अमान्य QR: डॉक्टर आईडी नहीं मिली।';

  @override
  String get invalidQrMalformedDoctorId =>
      'अमान्य QR: डॉक्टर आईडी सही नहीं है।';

  @override
  String get invalidQrStructure => 'अमान्य QR फॉर्मेट।';

  @override
  String get bookCareService => 'केयर सर्विस बुक करें';

  @override
  String get bookCareServiceDrawerItem => 'केयर सर्विस बुक करें';

  @override
  String get homeCareHistoryDrawerItem => 'होम केयर हिस्ट्री';

  @override
  String get homeHealthcareServices => 'होम हेल्थकेयर सेवाएं';

  @override
  String get scheduleNurseDesc =>
      'घर पर ही नर्स, बुजुर्गों की देखभाल या अटेंडेंट बुक करें।';

  @override
  String get personalDetails => 'व्यक्तिगत जानकारी';

  @override
  String get caregiverAndUrgency => 'केयरगिवर और प्राथमिकता';

  @override
  String get typeOfService => 'सेवा का प्रकार';

  @override
  String get medicalCondition => 'बीमारी / स्वास्थ्य स्थिति';

  @override
  String get serviceDuration => 'सेवा की अवधि';

  @override
  String get timePreference => 'पसंदीदा समय';

  @override
  String get additionalNotes => 'अतिरिक्त निर्देश';

  @override
  String get serviceTypeGeneralNursing => 'सामान्य नर्सिंग';

  @override
  String get serviceTypeElderlyCare => 'बुजुर्गों की देखभाल';

  @override
  String get serviceTypePostSurgery => 'सर्जरी के बाद देखभाल';

  @override
  String get serviceTypeIcuNurse => 'ICU नर्स';

  @override
  String get serviceTypeAttendant => 'पेशेंट अटेंडेंट';

  @override
  String get timeSlotMorning => 'सुबह (6:00 AM - 12:00 PM)';

  @override
  String get timeSlotAfternoon => 'दोपहर (12:00 PM - 5:00 PM)';

  @override
  String get timeSlotEvening => 'शाम (5:00 PM - 9:00 PM)';

  @override
  String get timeSlotNight => 'रात (9:00 PM - 6:00 AM)';

  @override
  String get medicalConditionHint =>
      'मरीज़ की स्थिति, बीमारी या लक्षण बताएं...';

  @override
  String get submitBookingRequest => 'बुकिंग रिक्वेस्ट भेजें';

  @override
  String get bookingSubmittedSuccess => 'बुकिंग सफलतापूर्वक सबमिट हो गई';

  @override
  String get bookingRequestFailed =>
      'बुकिंग नहीं हो सकी, कृपया दोबारा प्रयास करें';

  @override
  String get pleaseSelectServiceDuration => 'कृपया सेवा की अवधि चुनें';

  @override
  String get pleaseSelectStartDate => 'कृपया शुरू होने की तारीख चुनें';

  @override
  String get contactNumber => 'मोबाइल नंबर';

  @override
  String get patientAge => 'मरीज़ की उम्र';

  @override
  String get patientGender => 'मरीज़ का लिंग';

  @override
  String get address => 'पता';

  @override
  String get enterContactNumber => 'मोबाइल नंबर दर्ज करें';

  @override
  String get enterAge => 'उम्र दर्ज करें';

  @override
  String get enterCompleteAddress => 'पूरा पता दर्ज करें';

  @override
  String get fullNameRequired => 'पूरा नाम ज़रूरी है';

  @override
  String get enterValidName => 'कृपया सही नाम दर्ज करें';

  @override
  String get phoneRequired => 'मोबाइल नंबर ज़रूरी है';

  @override
  String get phoneInvalidPrefix => 'नंबर 6, 7, 8 या 9 से शुरू होना चाहिए';

  @override
  String get ageRequired => 'उम्र दर्ज करना ज़रूरी है';

  @override
  String get ageMinValidation => 'उम्र 0 से अधिक होनी चाहिए';

  @override
  String get ageMaxValidation => 'उम्र 120 से कम होनी चाहिए';

  @override
  String get selectGenderValidation => 'कृपया लिंग चुनें';

  @override
  String get addressRequired => 'पता दर्ज करना ज़रूरी है';

  @override
  String get addressMinValidation => 'पता कम से कम 5 अक्षरों का होना चाहिए';

  @override
  String get useCurrentLocation => 'वर्तमान लोकेशन का उपयोग करें';

  @override
  String get preferredCaregiverGender => 'केयरगिवर का लिंग (प्राथमिकता)';

  @override
  String get selectPreference => 'प्राथमिकता चुनें';

  @override
  String get noPreference => 'कोई भी चलेगा (No Preference)';

  @override
  String get selectGenderPreferenceValidation => 'कृपया प्राथमिकता चुनें';

  @override
  String get needEmergencyService => 'इमरजेंसी सेवा की आवश्यकता है';

  @override
  String get within2Hours => '2 घंटे के भीतर';

  @override
  String get duration1Day => '1 दिन';

  @override
  String get durationMultipleDays => 'कुछ दिन';

  @override
  String get durationWeekly => 'साप्ताहिक (हफ़्ते भर)';

  @override
  String get durationMonthly => 'मासिक (महीने भर)';

  @override
  String get numberOfDays => 'दिनों की संख्या';

  @override
  String get enterDays => 'दिन लिखें';

  @override
  String get invalidDays => 'अमान्य संख्या';

  @override
  String get max365Days => 'अधिकतम 365 दिन';

  @override
  String get startDate => 'शुरू होने की तारीख';

  @override
  String get homeCareHistory => 'होम केयर हिस्ट्री';

  @override
  String get noHomeCareHistoryYet => 'कोई होम केयर हिस्ट्री नहीं है';

  @override
  String get noHomeCareHistoryDesc =>
      'जब आप कोई होम केयर सर्विस बुक करेंगे, तो वह यहाँ दिखाई देगी।';

  @override
  String get emergencyBadge => 'इमरजेंसी';

  @override
  String get tapForFullDetails => 'पूरी जानकारी के लिए टैप करें';

  @override
  String get cancelBooking => 'बुकिंग रद्द करें';

  @override
  String get homeCareService => 'होम केयर सेवा';

  @override
  String yearsOld(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count साल',
      one: '1 साल',
      zero: '0 साल',
    );
    return '$_temp0';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '1 दिन',
      zero: '0 दिन',
    );
    return '$_temp0';
  }

  @override
  String get homeCareFilterAll => 'सभी';

  @override
  String get homeCareFilterPending => 'पेंडिंग';

  @override
  String get homeCareFilterConfirmed => 'कन्फर्म';

  @override
  String get homeCareFilterCompleted => 'पूर्ण';

  @override
  String get homeCareFilterCancelled => 'कैंसिल';

  @override
  String get bookingDetails => 'बुकिंग विवरण';

  @override
  String get patientInformation => 'मरीज़ की जानकारी';

  @override
  String get patientName => 'मरीज़ का नाम';

  @override
  String get ageGender => 'उम्र / लिंग';

  @override
  String get preference => 'प्राथमिकता';

  @override
  String get serviceInformation => 'सर्विस की जानकारी';

  @override
  String get serviceType => 'सर्विस का प्रकार';

  @override
  String get durationType => 'अवधि';

  @override
  String get timeSlot => 'टाइम स्लॉट';

  @override
  String get preferredDate => 'पसंदीदा तारीख';

  @override
  String get locationAndNotes => 'लोकेशन और नोट्स';

  @override
  String get serviceAddress => 'सेवा का पता';

  @override
  String get standardBooking => 'रेगुलर';

  @override
  String get failedToLoadDetails => 'विवरण लोड नहीं हो सका';

  @override
  String get unableToRetrieveBookingDetails =>
      'बुकिंग विवरण लोड नहीं हो सका। कृपया बाद में प्रयास करें।';

  @override
  String get cancelBookingConfirmation =>
      'क्या आप वाकई इस होम केयर बुकिंग को कैंसिल करना चाहते हैं?';

  @override
  String get yesCancel => 'हाँ, कैंसिल करें';

  @override
  String get noKeep => 'नहीं, रहने दें';

  @override
  String get cancellingBooking => 'बुकिंग कैंसिल की जा रही है...';

  @override
  String get bookingCancelledSuccess => 'बुकिंग कैंसिल हो गई';

  @override
  String get bookNewCareService => 'नई सर्विस बुक करें';

  @override
  String get regularBooking => 'सामान्य';

  @override
  String get familyMembers => 'परिवार के सदस्य';

  @override
  String get familyHealthNetwork => 'फैमिली हेल्थ नेटवर्क';

  @override
  String get familyHealthNetworkSubtitle =>
      'अपने परिवार के सदस्यों के हेल्थ रिकॉर्ड्स को मैनेज करें।';

  @override
  String activeProfilesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रोफ़ाइल्स ऐक्टिव',
      one: '1 प्रोफ़ाइल ऐक्टिव',
      zero: 'कोई प्रोफ़ाइल नहीं',
    );
    return '$_temp0';
  }

  @override
  String get addMember => 'सदस्य जोड़ें';

  @override
  String get addFamilyMember => 'परिवार का सदस्य जोड़ें';

  @override
  String get chooseMember => 'सदस्य चुनें';

  @override
  String get addNewMember => 'नया सदस्य जोड़ें';

  @override
  String get updateMember => 'जानकारी अपडेट करें';

  @override
  String get memberAddedSuccess => 'सदस्य सफलतापूर्वक जोड़ दिया गया।';

  @override
  String get memberUpdatedSuccess => 'जानकारी सफलतापूर्वक अपडेट कर दी गई।';

  @override
  String get noFamilyMembersYet => 'परिवार का कोई सदस्य नहीं जुड़ा है';

  @override
  String get createFamilyProfilesDesc =>
      'अपने परिवार के सदस्यों की सेहत पर नज़र रखने के लिए उनकी प्रोफ़ाइल जोड़ें।';

  @override
  String get age => 'उम्र';

  @override
  String get heightCmLabel => 'ऊंचाई (सेमी)';

  @override
  String get weightKgLabel => 'वजन (किग्रा)';

  @override
  String get remove => 'हटाएं';

  @override
  String get update => 'अपडेट करें';

  @override
  String get saveChanges => 'बदलाव सहेजें';

  @override
  String get saveMember => 'सेव करें';

  @override
  String get relation => 'रिश्ता / संबंध';

  @override
  String get selectRelation => 'संबंध चुनें';

  @override
  String get relationFather => 'पिता';

  @override
  String get relationMother => 'माता';

  @override
  String get relationSpouse => 'पति / पत्नी';

  @override
  String get relationSon => 'बेटा';

  @override
  String get relationDaughter => 'बेटी';

  @override
  String get relationBrother => 'भाई';

  @override
  String get relationSister => 'बहन';

  @override
  String get relationOther => 'अन्य';

  @override
  String get pleaseEnterFullName => 'कृपया पूरा नाम दर्ज करें';

  @override
  String get nameMinLengthError => 'नाम कम से कम 2 अक्षरों का होना चाहिए';

  @override
  String get pleaseSelectGender => 'कृपया लिंग चुनें';

  @override
  String get selectDateOfBirth => 'जन्म तिथि चुनें';

  @override
  String get pleaseSelectRelation => 'कृपया संबंध चुनें';

  @override
  String get heightRangeError => 'ऊंचाई 30 से 250 सेमी के बीच होनी चाहिए';

  @override
  String get weightRangeError => 'वजन 2 से 350 किग्रा के बीच होना चाहिए';

  @override
  String heightInCm(String height) {
    return '$height सेमी';
  }

  @override
  String weightInKg(String weight) {
    return '$weight किग्रा';
  }

  @override
  String get labTests => 'लैब टेस्ट';

  @override
  String get popularPackages => 'लोकप्रिय पैकेज';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get noTestsAvailableInCategory =>
      'इस श्रेणी में कोई टेस्ट उपलब्ध नहीं है';

  @override
  String get allPackagesAndTests => 'सभी पैकेज और टेस्ट';

  @override
  String get trustedByFamilies => '50,000+ परिवारों का भरोसा';

  @override
  String get bookLabTestsComfortOfHome => 'घर बैठे आसानी से लैब टेस्ट बुक करें';

  @override
  String get labHeroSubtitle => 'सटीक रिपोर्ट • सही दाम • घर पर सैंपल कलेक्शन';

  @override
  String get lowestPrices => 'किफायती दरें';

  @override
  String get transparentDesc => 'पारदर्शी';

  @override
  String get homeCollectionShort => 'होम कलेक्शन';

  @override
  String get sevenDaysAWeek => 'हफ़्ते के 7 दिन';

  @override
  String get accurateTitle => 'सटीक रिपोर्ट';

  @override
  String get verifiedDesc => 'सत्यापित लैब्स';

  @override
  String get hundredPercentPrivate => '100% सुरक्षित';

  @override
  String get encryptedDesc => 'गोपनीय';

  @override
  String get notSureWhichTestToBook => 'समझ नहीं आ रहा कौन सा टेस्ट कराएं?';

  @override
  String get labSupportAdvisorsAvailable =>
      'हमारे हेल्थ एक्सपर्ट्स आपकी मदद के लिए हफ़्ते के सातों दिन उपलब्ध हैं।';

  @override
  String callSupportPhone(String phone) {
    return 'कॉल करें $phone';
  }

  @override
  String get packageType => 'पैकेज';

  @override
  String get essentialType => 'ज़रूरी टेस्ट';

  @override
  String percentOff(String percent) {
    return '$percent% छूट';
  }

  @override
  String paramsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count टेस्ट पैरामीटर्स',
      one: '1 टेस्ट पैरामीटर',
      zero: '0 टेस्ट पैरामीटर',
    );
    return '$_temp0';
  }

  @override
  String get homeSampleCollection => 'घर पर सैंपल पिकअप';

  @override
  String get viewButton => 'देखें';

  @override
  String get addedButton => 'जोड़ा गया';

  @override
  String get addButton => '+ जोड़ें';

  @override
  String get testDetails => 'टेस्ट विवरण';

  @override
  String get testNotFound => 'टेस्ट नहीं मिला';

  @override
  String addedToCart(String title) {
    return '$title कार्ट में जोड़ा गया';
  }

  @override
  String removedFromCart(String title) {
    return '$title कार्ट से हटाया गया';
  }

  @override
  String parametersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पैरामीटर्स',
      one: '1 पैरामीटर',
      zero: '0 पैरामीटर्स',
    );
    return '$_temp0';
  }

  @override
  String saveAmount(String amount) {
    return '₹$amount की बचत';
  }

  @override
  String get nablCertifiedLabs => 'NABL सर्टिफाइड लैब्स';

  @override
  String get freeHomeSamplePickup => 'फ्री होम सैंपल पिकअप';

  @override
  String get twentyFourHoursReport => '24 घंटे में रिपोर्ट';

  @override
  String get aboutThisTest => 'इस टेस्ट के बारे में';

  @override
  String get includes => 'इसमें शामिल है';

  @override
  String get defaultTestDescription =>
      'यह टेस्ट आपके समग्र स्वास्थ्य की जांच करने और किसी भी प्रकार के संक्रमण, खून की कमी (एनीमिया) इत्यादि का पता लगाने में मदद करता है।';

  @override
  String get addToCart => 'कार्ट में जोड़ें';

  @override
  String get addAndBook => 'जोड़ें और बुक करें';

  @override
  String get myCart => 'मेरी कार्ट';

  @override
  String parametersIncluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count टेस्ट शामिल',
      one: '1 टेस्ट शामिल',
      zero: '0 टेस्ट शामिल',
    );
    return '$_temp0';
  }

  @override
  String get addMoreTests => 'और टेस्ट जोड़ें';

  @override
  String get priceSummary => 'कुल बिल विवरण';

  @override
  String get totalMRP => 'कुल MRP';

  @override
  String get youSave => 'कुल बचत';

  @override
  String savingDiscountNotice(String discount) {
    return 'बधाई हो! आप इस ऑर्डर पर $discount% बचा रहे हैं।';
  }

  @override
  String get totalPayable => 'कुल देय राशि';

  @override
  String get proceedToBookSlot => 'स्लॉट बुक करने के लिए आगे बढ़ें';

  @override
  String get yourCartIsEmpty => 'आपकी कार्ट खाली है';

  @override
  String get cartEmptyDesc =>
      'आपने अभी तक कोई टेस्ट नहीं जोड़ा है। शुरू करने के लिए हमारे हेल्थ पैकेज देखें।';

  @override
  String get addTestsAndPackages => 'टेस्ट और पैकेज देखें';

  @override
  String get bookSlotTitle => 'स्लॉट चुनें';

  @override
  String testsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count टेस्ट चुने गए • ',
      one: '1 टेस्ट चुना गया • ',
      zero: 'कोई टेस्ट नहीं चुना ',
    );
    return '$_temp0';
  }

  @override
  String get patientDetails => 'मरीज़ का विवरण';

  @override
  String get samplePickupAddress => 'सैंपल पिकअप का पता';

  @override
  String get selectDateTime => 'तारीख और समय चुनें';

  @override
  String get enterYourFullName => 'पूरा नाम दर्ज करें';

  @override
  String get nameMin3Characters => 'नाम कम से कम 3 अक्षरों का होना चाहिए';

  @override
  String get invalidAge => 'सही उम्र दर्ज करें';

  @override
  String get ageRangeError => 'उम्र 1 से 120 के बीच होनी चाहिए';

  @override
  String get enter10DigitNumber => '10 अंकों का मोबाइल नंबर';

  @override
  String get enterValid10DigitNumber => 'मान्य 10 अंकों का नंबर दर्ज करें';

  @override
  String get useMyCurrentLocation => 'मेरी मौजूदा लोकेशन चुनें';

  @override
  String get fullAddress => 'पूरा पता';

  @override
  String get fullAddressHint => 'मकान नं., गली/मोहल्ला, इलाका, शहर';

  @override
  String get enterAddress => 'पता दर्ज करें';

  @override
  String get addressTooShort => 'पता बहुत छोटा है';

  @override
  String get todaySlotsClosedMessage =>
      'आज के स्लॉट बंद हो चुके हैं। कृपया किसी अन्य दिन का स्लॉट चुनें।';

  @override
  String get morningSlot => 'सुबह का स्लॉट';

  @override
  String get afternoonSlot => 'दोपहर का स्लॉट';

  @override
  String get eveningSlot => 'शाम का स्लॉट';

  @override
  String get totalPrice => 'कुल मूल्य';

  @override
  String get selectTimeSlotValidation => 'कृपया टाइम स्लॉट चुनें';

  @override
  String get bookingFailed => 'बुकिंग नहीं हो सकी';

  @override
  String get confirmAndPay => 'कन्फर्म करें और भुगतान करें';

  @override
  String get labTestBooking => 'लैब टेस्ट बुकिंग';

  @override
  String get myAppointmentsTitle => 'मेरे अपॉइंटमेंट्स';

  @override
  String get trackConsultationsSubtitle =>
      'परामर्श ट्रैक करें और डॉक्टरों को रेटिंग दें।';

  @override
  String appointmentCountText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अपॉइंटमेंट्स',
      one: '1 अपॉइंटमेंट',
      zero: '0 अपॉइंटमेंट्स',
    );
    return '$_temp0';
  }

  @override
  String ratedDoctorSuccess(String doctorName, int rating) {
    return 'धन्यवाद! आपने $doctorName को $rating स्टार दिए।';
  }

  @override
  String get loadingAppointments => 'अपॉइंटमेंट्स लोड हो रहे हैं...';

  @override
  String get noAppointmentHistory => 'कोई अपॉइंटमेंट हिस्ट्री नहीं है';

  @override
  String get bookedAppointmentsAppearHere =>
      'बुक किए गए अपॉइंटमेंट्स यहाँ दिखाई देंगे।';

  @override
  String tokenNumberWithHash(String token) {
    return 'टोकन #$token';
  }

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get tableHeaderDoctor => 'डॉक्टर और विशेषज्ञता';

  @override
  String get tableHeaderDateShift => 'तारीख और समय';

  @override
  String get tableHeaderToken => 'टोकन';

  @override
  String get tableHeaderStatus => 'स्थिति';

  @override
  String get tableHeaderActions => 'कार्रवाई';

  @override
  String tokenWithNumber(String token) {
    return 'टोकन #$token';
  }

  @override
  String get viewPrescription => 'पर्चा (Prescription) देखें';

  @override
  String get tapToViewPrescription => 'परामर्श फाइलें देखने के लिए टैप करें';

  @override
  String get rateYourExperience => 'अपना अनुभव साझा करें';

  @override
  String get shareYourThoughts => 'अपनी राय या सुझाव लिखें';

  @override
  String get reviewSubmittedSuccess => 'रिव्यू सफलतापूर्वक सबमिट हो गया!';

  @override
  String get saveFeedback => 'फीडबैक सबमिट करें';

  @override
  String get maybeLater => 'बाद में';

  @override
  String get prescriptionTitle => 'डॉक्टर का पर्चा';

  @override
  String get instructionsLabel => 'ज़रूरी निर्देश';

  @override
  String get clinicalCareSectionTitle => 'डॉक्टर व क्लिनिक सेवाएं';

  @override
  String get clinicalCareSectionSubtitle =>
      'विशेषज्ञ डॉक्टरों से परामर्श और तुरंत टोकन पाएं';

  @override
  String get doorstepCareSectionTitle => 'घर बैठे स्वास्थ्य सेवाएं';

  @override
  String get doorstepCareSectionSubtitle => 'लैब टेस्ट और घर पर दवाइयां';

  @override
  String get myActivitySectionTitle => 'मेरी गतिविधि और इतिहास';

  @override
  String get myActivitySectionSubtitle =>
      'अपनी सभी नियुक्तियों और देखभाल सेवाओं की स्थिति देखें';

  @override
  String get doctorVisitsHistoryTitle => 'डॉक्टर अपॉइंटमेंट्स';

  @override
  String get doctorVisitsHistorySubtitle => 'क्लिनिक व वीडियो हिस्ट्री';

  @override
  String get homeCareOrdersTitle => 'होम केयर';

  @override
  String get homeCareOrdersSubtitle => 'नर्सिंग व देखभाल सेवाएं';

  @override
  String get appointmentsBadge => 'अपॉइंटमेंट्स';

  @override
  String get careVisitsBadge => 'केयर विज़िट्स';

  @override
  String get viewHistoryAction => 'इतिहास देखें';

  @override
  String get needHelpBookingTitle => 'बुकिंग में सहायता चाहिए?';

  @override
  String get needHelpBookingSubtitle =>
      'सहायता टीम से संपर्क करें या ऑर्डर ट्रैक करें';

  @override
  String get contactSupportBtn => 'संपर्क करें';

  @override
  String get comingSoonBadge => 'जल्द';

  @override
  String get bookNowAction => 'बुक करें';

  @override
  String get scanQrAction => 'स्कैन करें';

  @override
  String get applyNowAction => 'आवेदन करें';

  @override
  String get healthAndFamilySection => 'स्वास्थ्य और रिकॉर्ड्स';

  @override
  String get appPreferencesSection => 'ऐप सेटिंग्स';

  @override
  String get helpAndLegalSection => 'मदद और सपोर्ट';

  @override
  String get accountSection => 'खाता नियंत्रण';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get deleteAccountDesc =>
      'अपना खाता और स्वास्थ्य डेटा हमेशा के लिए हटाएं';

  @override
  String get notificationsTitle => 'सूचनाएं और अलर्ट्स';

  @override
  String get notificationsDesc => 'अपॉइंटमेंट रिमाइंडर और अपडेट्स';

  @override
  String get darkModeTitle => 'डार्क मोड';

  @override
  String get helpSupportTitle => 'मदद और सहायता';

  @override
  String get helpSupportDesc => '२४/७ मरीज सहायता और अक्सर पूछे जाने वाले सवाल';

  @override
  String get privacyTermsTitle => 'गोपनीयता नीति और शर्तें';

  @override
  String get privacyTermsDesc => 'डेटा सुरक्षा और उपयोग के नियम';

  @override
  String get editProfileBtn => 'प्रोफाइल बदलें';

  @override
  String get myHealthcareSection => 'मेरी स्वास्थ्य सेवाएं';

  @override
  String get appointmentsHistory => 'अपॉइंटमेंट इतिहास';

  @override
  String get appointmentsHistorySubtitle =>
      'पिछली, वर्तमान और आगामी अपॉइंटमेंट्स';

  @override
  String get certificateWalletSubtitle =>
      'मेडिकल सर्टिफिकेट देखें, सत्यापित करें और डाउनलोड करें';

  @override
  String get personalDetailsSubtitle =>
      'अपनी व्यक्तिगत जानकारी देखें और अपडेट करें';

  @override
  String get privacyPolicyOnlyTitle => 'गोपनीयता नीति';

  @override
  String get privacyPolicySubtitle =>
      'हम आपके मेडिकल डेटा की सुरक्षा कैसे करते हैं';

  @override
  String get termsOfServiceTitle => 'सेवा की शर्तें';

  @override
  String get termsOfServiceSubtitle => 'उपयोग के नियम और शर्तें';

  @override
  String get supportAndLegalSection => 'सहायता और नीतियां';

  @override
  String get accountAndFamilySection => 'खाता और परिवार';

  @override
  String get logoutAccountSubtitle => 'अपने YoDoctor खाते से लॉग आउट करें';

  @override
  String get doorstepCareBannerTag => 'घर पर स्वास्थ्य सेवा';

  @override
  String get familyMembersSubtitle => 'आश्रितों को जोड़ें और प्रबंधित करें';
}

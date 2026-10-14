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

  @override
  String get certificateWallet => 'प्रमाणपत्र वॉलेट';

  @override
  String get medicalCertificates => 'चिकित्सा प्रमाणपत्र';

  @override
  String get trackRequestsSubtitle =>
      'अनुरोधों को ट्रैक करें और स्वीकृत प्रमाणपत्र डाउनलोड करें।';

  @override
  String certificateCountWithFilter(int count, String filter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रमाणपत्र | $filter',
      one: '1 प्रमाणपत्र | $filter',
      zero: '0 प्रमाणपत्र | $filter',
    );
    return '$_temp0';
  }

  @override
  String get searchByTypeOrDoctor => 'प्रकार या डॉक्टर द्वारा खोजें...';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterPending => 'लंबित';

  @override
  String get filterApproved => 'स्वीकृत';

  @override
  String get filterRejected => 'अस्वीकृत';

  @override
  String get applyCertificate => 'प्रमाणपत्र आवेदन';

  @override
  String get assignedTo => 'सौंपा गया: ';

  @override
  String get viewAndDownloadCertificate => 'प्रमाणपत्र देखें और डाउनलोड करें';

  @override
  String get requestDeclinedNote =>
      'नोट: अपर्याप्त चिकित्सा साक्ष्य के कारण डॉक्टर द्वारा अनुरोध अस्वीकार कर दिया गया।';

  @override
  String get noCertificatesFound => 'कोई प्रमाणपत्र नहीं मिला';

  @override
  String noCertificatesMatchFilter(String filter) {
    return '\"$filter\" फ़िल्टर से कोई प्रमाणपत्र मेल नहीं खाता।';
  }

  @override
  String get selectCertificateDoctor => 'प्रमाणपत्र डॉक्टर चुनें';

  @override
  String get noCertificateDoctorsAvailable =>
      'इस समय कोई प्रमाणपत्र डॉक्टर उपलब्ध नहीं हैं।';

  @override
  String certificateFee(String fee) {
    return 'प्रमाणपत्र शुल्क — ₹$fee';
  }

  @override
  String get applyForCertificate => 'प्रमाणपत्र के लिए आवेदन करें';

  @override
  String requestingFromDoctor(String name, String specialty) {
    return '$name से अनुरोध — $specialty';
  }

  @override
  String get chooseCertificateTypeSubtitle =>
      'प्रमाणपत्र का प्रकार और विवरण चुनें';

  @override
  String get stepType => 'प्रकार';

  @override
  String get stepMedicalInfo => 'चिकित्सा जानकारी';

  @override
  String get stepDocuments => 'दस्तावेज़';

  @override
  String get stepReview => 'समीक्षा';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get back => 'वापस';

  @override
  String get continueButton => 'आगे बढ़ें';

  @override
  String get submitRequest => 'अनुरोध सबमिट करें';

  @override
  String get pleaseSelectCertificateType => 'कृपया प्रमाणपत्र का प्रकार चुनें';

  @override
  String get pleaseUploadRequiredFiles =>
      'कृपया आवश्यक सत्यापन फ़ाइलें अपलोड करें।';

  @override
  String get pleaseConfirmAccuracy =>
      'आगे बढ़ने के लिए कृपया सटीकता सत्यापन की पुष्टि करें।';

  @override
  String get certificateRequestSuccess =>
      'भुगतान पूरा हुआ और प्रमाणपत्र अनुरोध सफलतापूर्वक सबमिट किया गया।';

  @override
  String get certificateRequestFailed =>
      'हम आपका प्रमाणपत्र अनुरोध पूरा नहीं कर सके। कृपया कुछ देर बाद पुनः प्रयास करें।';

  @override
  String get selectCertificateType => 'प्रमाणपत्र का प्रकार चुनें';

  @override
  String get selectCertificateTypeDesc =>
      'अपने आवेदन के लिए उपयुक्त विकल्प चुनें।';

  @override
  String get certMedicalFitness => 'मेडिकल फिटनेस';

  @override
  String get certMedicalFitnessDesc => 'रोजगार या खेल के लिए';

  @override
  String get certVaccination => 'टीकाकरण';

  @override
  String get certVaccinationDesc => 'प्रतिरक्षण रिकॉर्ड';

  @override
  String get certDisability => 'दिव्यांगता';

  @override
  String get certDisabilityDesc => 'आधिकारिक दिव्यांगता प्रमाण';

  @override
  String get certSecondOpinion => 'दूसरी राय';

  @override
  String get certSecondOpinionDesc => 'विशेषज्ञ चिकित्सा समीक्षा';

  @override
  String get certDischargeSummary => 'डिस्चार्ज सारांश';

  @override
  String get certDischargeSummaryDesc => 'अस्पताल डिस्चार्ज का सारांश';

  @override
  String get assignedDoctor => 'असाइन किए गए डॉक्टर';

  @override
  String get purposeOfCertificate => 'प्रमाणपत्र का उद्देश्य';

  @override
  String get selectPurpose => 'उद्देश्य चुनें';

  @override
  String get purposeTravel => 'यात्रा';

  @override
  String get purposeEmployment => 'रोजगार';

  @override
  String get purposeSports => 'खेल';

  @override
  String get purposeSchoolUniversity => 'स्कूल/विश्वविद्यालय';

  @override
  String get purposeInsurance => 'बीमा';

  @override
  String get purposeOther => 'अन्य';

  @override
  String get pleaseSelectPurpose => 'कृपया एक उद्देश्य चुनें';

  @override
  String get additionalNotesForDoctor => 'डॉक्टर के लिए अतिरिक्त नोट्स';

  @override
  String get additionalNotesHint =>
      'विशिष्ट स्थितियों या पृष्ठभूमि विवरणों का वर्णन करें...';

  @override
  String get medicalDetails => 'चिकित्सा विवरण';

  @override
  String get medicalDetailsDesc =>
      'अपने मेडिकल क्लीयरेंस पर प्रदर्शित करने के लिए बुनियादी बायोमेट्रिक्स प्रदान करें।';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get enterFullName => 'पूरा नाम दर्ज करें';

  @override
  String get pleaseEnterName => 'कृपया नाम दर्ज करें';

  @override
  String get nameMinCharacters => 'नाम में कम से कम 2 अक्षर होने चाहिए';

  @override
  String get onlyAlphabetsAllowed => 'केवल अक्षरों की अनुमति है';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get selectDate => 'तिथि चुनें';

  @override
  String get requiredField => 'आवश्यक';

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
  String get bloodGroup => 'रक्त समूह';

  @override
  String get selectBloodGroup => 'रक्त समूह चुनें';

  @override
  String get height => 'ऊंचाई';

  @override
  String get heightHint => 'उदा. 175';

  @override
  String get enterValidNumber => 'एक मान्य संख्या दर्ज करें';

  @override
  String get enterValidHeight => 'एक मान्य ऊंचाई दर्ज करें (1 - 300 सेमी)';

  @override
  String get weight => 'वजन';

  @override
  String get weightHint => 'उदा. 70';

  @override
  String get enterValidWeight => 'एक मान्य वजन दर्ज करें (1 - 500 किग्रा)';

  @override
  String get knownMedicalConditions => 'ज्ञात चिकित्सा स्थितियां';

  @override
  String get medicalConditionsHint => 'उदा., मधुमेह, उच्च रक्तचाप, अस्थमा';

  @override
  String get currentMedications => 'वर्तमान दवाएं';

  @override
  String get medicationsHint =>
      'उदा., मेटफ़ॉर्मिन 500 मिग्रा, दैनिक मल्टीविटामिन';

  @override
  String get uploadSupportingFiles => 'सहायक फ़ाइलें अपलोड करें';

  @override
  String get uploadSupportingFilesDesc =>
      'सत्यापन प्रक्रिया के लिए दस्तावेज़ प्रदान करें।';

  @override
  String get docProfilePhoto => 'प्रोफ़ाइल फ़ोटो';

  @override
  String get docProfilePhotoHint =>
      'अपनी प्रोफ़ाइल तस्वीर अपलोड करें (jpg, png)';

  @override
  String get docGovtId => 'सरकारी पहचान पत्र';

  @override
  String get docGovtIdHint => 'आधिकारिक पहचान दस्तावेज़';

  @override
  String get docMedicalReports => 'मेडिकल रिपोर्ट';

  @override
  String get docMedicalReportsHint => 'पिछली नैदानिक ​​डेटा रिपोर्ट';

  @override
  String get docPrescription => 'डॉक्टर का पर्चा';

  @override
  String get docPrescriptionHint => 'डॉक्टर का अधिकृत पर्चा';

  @override
  String get uploadingDocument => 'दस्तावेज़ अपलोड हो रहा है...';

  @override
  String get documentUploadedSuccess => 'दस्तावेज़ सफलतापूर्वक अपलोड हो गया';

  @override
  String get deleteUploadTooltip => 'अपलोड हटाएं';

  @override
  String get clickToUpload => 'अपलोड करने के लिए क्लिक करें';

  @override
  String get documentRequired => 'यह दस्तावेज़ आवश्यक है!';

  @override
  String get reviewApplication => 'आवेदन की समीक्षा करें';

  @override
  String get reviewApplicationDesc =>
      'मूल्यांकन चैनलों पर सबमिट करने से पहले प्रविष्टियों की सटीकता की पुष्टि करें।';

  @override
  String get certificateBaselineParameters => 'प्रमाणपत्र के बुनियादी पैरामीटर';

  @override
  String get certificateTypeLabel => 'प्रमाणपत्र का प्रकार';

  @override
  String get assignedDoctorLabel => 'असाइन किए गए मेडिकल डॉक्टर';

  @override
  String get medicalSpecialtyLabel => 'मेडिकल विशेषता';

  @override
  String get intendedPurposeLabel => 'अभीष्ट उद्देश्य';

  @override
  String get additionalNotesLabel => 'अतिरिक्त संदर्भ नोट्स';

  @override
  String get noneLabel => 'कोई नहीं';

  @override
  String get notAvailableLabel => 'लागू नहीं';

  @override
  String get patientDiagnosticInformation => 'मरीज़ की नैदानिक ​​जानकारी';

  @override
  String get fullLegalNameLabel => 'पूरा कानूनी नाम';

  @override
  String get dateOfBirthLabel => 'जन्म तिथि';

  @override
  String get biologicalGenderLabel => 'जैविक लिंग';

  @override
  String get bloodGroupStagingLabel => 'रक्त समूह';

  @override
  String get heightMetricLabel => 'ऊंचाई माप';

  @override
  String get weightMetricLabel => 'वजन माप';

  @override
  String get chronicMedicalConditionsLabel => 'पुरानी चिकित्सा स्थितियां';

  @override
  String get activePrescriptionsLabel => 'वर्तमान सक्रिय दवाएं';

  @override
  String get uploadedVerificationMaterials => 'अपलोड की गई सत्यापन सामग्री';

  @override
  String get disclaimerNotice =>
      'इस इलेक्ट्रॉनिक अनुरोध प्रोफ़ाइल को भेजकर, आप स्पष्ट रूप से पुष्टि करते हैं कि सभी बायोमेट्रिक जानकारी सत्यापित व्यक्तिगत चिकित्सा इतिहास से मेल खाती है।';

  @override
  String get disclaimerCheckbox =>
      'मैं कानूनी रूप से सत्यापित करता/करती हूँ कि मेरे द्वारा प्रस्तुत प्रोफ़ाइल फ़ील्ड सटीक हैं।';

  @override
  String get certificateDetails => 'प्रमाणपत्र विवरण';

  @override
  String get certificateNotFound => 'प्रमाणपत्र नहीं मिला';

  @override
  String get certificateLabel => 'प्रमाणपत्र';

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
  String get timelineLabel => 'समयरेखा';

  @override
  String get certificatesTab => 'प्रमाणपत्र';

  @override
  String get certificateDrawerItem => 'प्रमाणपत्र';

  @override
  String get services => 'सेवाएं';

  @override
  String get servicesTab => 'सेवाएं';

  @override
  String get servicesHeaderTitle => 'योडॉक्टर सेवाएं';

  @override
  String get servicesHeaderSubtitle =>
      'त्वरित चिकित्सा सेवा प्राप्त करने के लिए एक सेवा चुनें।';

  @override
  String activeServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय सेवाएं',
      one: '1 सक्रिय सेवा',
      zero: '0 सक्रिय सेवाएं',
    );
    return '$_temp0';
  }

  @override
  String get serviceMedicineDeliveryTitle => 'दवा वितरण';

  @override
  String get serviceMedicineDeliverySubtitle => 'ज़रूरी दवाएं आपके दरवाज़े पर';

  @override
  String get medicineDeliveryComingSoon => 'दवा वितरण सेवा जल्द उपलब्ध होगी';

  @override
  String get serviceLabTestTitle => 'लैब टेस्ट';

  @override
  String get serviceLabTestSubtitle => 'घर बैठे सैंपल पिकअप';

  @override
  String get serviceQrScanTokenTitle => 'QR स्कैन करें और टोकन पाएं';

  @override
  String get serviceQrScanTokenSubtitle => 'स्कैन करें और तुरंत बुक करें';

  @override
  String get serviceOnlineAppointmentTitle => 'ऑनलाइन अपॉइंटमेंट बुकिंग';

  @override
  String get serviceOnlineAppointmentSubtitle => 'कहीं से भी बुक करें';

  @override
  String get serviceMedicalCertificateTitle =>
      'मेडिकल सर्टिफिकेट के लिए आवेदन करें';

  @override
  String get serviceMedicalCertificateSubtitle => 'घर बैठे परामर्श लें';

  @override
  String get serviceHomeNursingCareTitle => 'होम नर्सिंग केयर सेवा बुकिंग';

  @override
  String get serviceHomeNursingCareSubtitle => 'आपके घर पर देखभाल सेवा';

  @override
  String get scanDoctorQr => 'डॉक्टर QR स्कैन करें';

  @override
  String get verifying => 'सत्यापित किया जा रहा है...';

  @override
  String get alignQrCodeWithinFrame => 'QR कोड को फ्रेम के अंदर रखें';

  @override
  String get invalidQrTryAgain => 'अमान्य QR - पुनः प्रयास करें';

  @override
  String get scannerWillResumeShortly => 'स्कैनर शीघ्र पुनः शुरू होगा...';

  @override
  String get scanQrCodeTooltip => 'QR कोड स्कैन करें';

  @override
  String get invalidQrDoctorIdNotFound => 'अमान्य QR: डॉक्टर आईडी नहीं मिली।';

  @override
  String get invalidQrMalformedDoctorId => 'अमान्य QR: गलत डॉक्टर आईडी।';

  @override
  String get invalidQrStructure => 'अमान्य QR संरचना।';
}

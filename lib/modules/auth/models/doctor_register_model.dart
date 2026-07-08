import 'dart:io';

// ─────────────────────────────────────────────
//  FORM DATA MODEL  (mirrors React formData state)
// ─────────────────────────────────────────────
class DoctorFormData {
  // Step 1 – Personal
  String fullName = '';
  String email = '';
  String mobile = '';
  String gender = '';
  List<String> languages = [];
  String bio = '';
  String password = '';
  String confirmPassword = '';

  // Step 2 – Professional
  String qualification = '';
  String specialization = '';
  String experience = '';
  String regNumber = '';
  String stateCouncil = '';
  DateTime? validTill;

  // Step 3 – Clinic
  String clinicName = '';
  String address = '';
  String city = '';
  String state = '';
  String pincode = '';
  String landmark = '';
  String mapsLink = '';

  // Step 4 – Practice
  String practiceType = 'Solo Practice';
  String hospitalName = '';

  // Step 5 – Consultation
  String fee = '';
  String duration = '15 mins';
  List<String> selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  String morningStart = '09:00';
  String morningEnd = '13:00';
  String eveningStart = '';
  String eveningEnd = '';
  bool morningEnabled = true;
  bool eveningEnabled = false;

  // Step 6 – Documents
  File? profileFile;
  File? certificateFile;
  File? idProofFile;
  File? clinicProofFile;

  // Step 7 – Declarations
  bool declAccurate = false;
  bool declDisplay = false;
  bool declPrivacy = false;
  bool declTerms = false;

  void reset() {
    fullName = '';
    email = '';
    mobile = '';
    gender = '';
    languages.clear();
    bio = '';
    password = '';
    confirmPassword = '';

    qualification = '';
    specialization = '';
    experience = '';
    regNumber = '';
    stateCouncil = '';
    validTill = null;

    clinicName = '';
    address = '';
    city = '';
    state = '';
    pincode = '';
    landmark = '';
    mapsLink = '';

    practiceType = 'Solo Practice';
    hospitalName = '';

    fee = '';
    duration = '15 mins';

    selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    morningStart = '';
    morningEnd = '';

    eveningStart = '';
    eveningEnd = '';

    morningEnabled = true;
    eveningEnabled = false;

    profileFile = null;
    certificateFile = null;
    idProofFile = null;
    clinicProofFile = null;

    declAccurate = false;
    declDisplay = false;
    declPrivacy = false;
    declTerms = false;
  }
}

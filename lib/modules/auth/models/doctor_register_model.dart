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
  List<String> selectedDays = ['M', 'T', 'W', 'T2', 'F'];
  String morningStart = '09:00';
  String morningEnd = '13:00';
  String eveningStart = '';
  String eveningEnd = '';

  // Step 6 – Documents
  String? profileFile;
  String? certificateFile;
  String? idProofFile;
  String? clinicProofFile;

  // Step 7 – Declarations
  bool declAccurate = false;
  bool declDisplay = false;
  bool declPrivacy = false;
  bool declTerms = false;
}
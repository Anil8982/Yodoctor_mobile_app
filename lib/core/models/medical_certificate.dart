import 'doctor_profile.dart';

class MedicalCertificate {
  const MedicalCertificate({
    required this.id,
    required this.type,
    required this.patientName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.heightCm,
    required this.weightKg,
    required this.medicalConditions,
    required this.medications,
    required this.doctor,
    required this.purpose,
    required this.additionalNotes,
    required this.status,
    required this.requestDate,
    this.issuedDate,
    required this.documents,
  });

  final String id;
  final String type;
  final String patientName;
  final String dateOfBirth;
  final String gender;
  final String bloodGroup;
  final double heightCm;
  final double weightKg;
  final String medicalConditions;
  final String medications;
  final DoctorProfile doctor;
  final String purpose;
  final String additionalNotes;
  final String status; // 'PENDING', 'APPROVED', 'REJECTED'
  final DateTime requestDate;
  final DateTime? issuedDate;
  final List<String> documents; // Names of uploaded files

  MedicalCertificate copyWith({
    String? id,
    String? type,
    String? patientName,
    String? dateOfBirth,
    String? gender,
    String? bloodGroup,
    double? heightCm,
    double? weightKg,
    String? medicalConditions,
    String? medications,
    DoctorProfile? doctor,
    String? purpose,
    String? additionalNotes,
    String? status,
    DateTime? requestDate,
    DateTime? issuedDate,
    List<String>? documents,
  }) {
    return MedicalCertificate(
      id: id ?? this.id,
      type: type ?? this.type,
      patientName: patientName ?? this.patientName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      medications: medications ?? this.medications,
      doctor: doctor ?? this.doctor,
      purpose: purpose ?? this.purpose,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      issuedDate: issuedDate ?? this.issuedDate,
      documents: documents ?? this.documents,
    );
  }
}

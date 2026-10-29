
class PrescriptionModel {
  final int? prescriptionId;
  final int? appointmentId;
  final List<String> symptoms;
  final List<String> diagnosis;
  final List<PrescriptionMedicine> medicines;
  final List<String> tests;
  final List<String> advice;
  final String? followUpAfter;
  final String? followUpDate;
  final String? followUpNotes;
  final String? uploadedPrescription;
  final String? appointmentDate;
  final String? appointmentSlot;
  final int? tokenNumber;
  final PrescriptionPatient? patient;

  const PrescriptionModel({
    this.prescriptionId,
    this.appointmentId,
    this.symptoms = const [],
    this.diagnosis = const [],
    this.medicines = const [],
    this.tests = const [],
    this.advice = const [],
    this.followUpAfter,
    this.followUpDate,
    this.followUpNotes,
    this.uploadedPrescription,
    this.appointmentDate,
    this.appointmentSlot,
    this.tokenNumber,
    this.patient,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      prescriptionId: _toInt(json['prescription_id']),
      appointmentId: _toInt(json['appointment_id']),
      symptoms: _toStringList(json['symptoms']),
      diagnosis: _toStringList(json['diagnosis']),
      medicines: _toMedicineList(json['medicines']),
      tests: _toStringList(json['tests']),
      advice: _toStringList(json['advice']),
      followUpAfter: json['follow_up_after']?.toString(),
      followUpDate: json['follow_up_date']?.toString(),
      followUpNotes: json['follow_up_notes']?.toString(),
      uploadedPrescription: json['uploaded_prescription']?.toString(),
      appointmentDate: json['appointment_date']?.toString(),
      appointmentSlot: json['appointment_slot']?.toString(),
      tokenNumber: _toInt(json['token_number']),
      patient: json['patient'] is Map
          ? PrescriptionPatient.fromJson(
        Map<String, dynamic>.from(json['patient'] as Map),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (prescriptionId != null) 'prescription_id': prescriptionId,
      if (appointmentId != null) 'appointment_id': appointmentId,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'medicines': medicines.map((e) => e.toJson()).toList(),
      'tests': tests,
      'advice': advice,
      'follow_up_after': followUpAfter,
      'follow_up_date': followUpDate,
      'follow_up_notes': followUpNotes,
      'uploaded_prescription': uploadedPrescription,
      'appointment_date': appointmentDate,
      'appointment_slot': appointmentSlot,
      'token_number': tokenNumber,
      if (patient != null) 'patient': patient!.toJson(),
    };
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((e) => e.toString()).toList();
  }

  static List<PrescriptionMedicine> _toMedicineList(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (e) => PrescriptionMedicine.fromJson(
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
}

class PrescriptionMedicine {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  const PrescriptionMedicine({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });

  factory PrescriptionMedicine.fromJson(Map<String, dynamic> json) {
    return PrescriptionMedicine(
      name: json['name']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
    };
  }
}

class PrescriptionPatient {
  final int? id;
  final String name;
  final int? age;
  final String? gender;
  final String? phone;

  const PrescriptionPatient({
    this.id,
    required this.name,
    this.age,
    this.gender,
    this.phone,
  });

  factory PrescriptionPatient.fromJson(Map<String, dynamic> json) {
    return PrescriptionPatient(
      id: PrescriptionModel._toInt(json['id']),
      name: json['name']?.toString() ?? '',
      age: PrescriptionModel._toInt(json['age']),
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'phone': phone,
    };
  }
}

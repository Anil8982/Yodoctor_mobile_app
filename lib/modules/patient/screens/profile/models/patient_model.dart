class PatientModel {
  final int id;
  final String fullName;
  final String phone;
  final String email;
  final String mobile;
  final String gender;
  final String dob;

  PatientModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.dob,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'] as int;
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString()) ?? 0;
    } else if (json['patient_id'] != null) {
      parsedId = int.tryParse(json['patient_id'].toString()) ?? 0;
    } else if (json['patientId'] != null) {
      parsedId = int.tryParse(json['patientId'].toString()) ?? 0;
    }

    return PatientModel(
      id: parsedId,
      fullName: json['fullName']?.toString() ?? json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? json['phone']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'gender': gender,
      'dob': dob,
    };
  }
}

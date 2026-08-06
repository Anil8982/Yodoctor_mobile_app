class AppointmentModel {
  final int id;
  final String doctorName;
  final String qualification;
  final String specialization;
  final int consultationFee;
  final String city;
  final int experience;
  final double rating;
  final String clinicName;
  final String languages;
  final String address;
  final String? profileImage;

  final String appointmentType;
  final String appointmentDate;
  final String appointmentSlot;
  final int tokenNumber;
  final String status;

  final String? familyName;
  final String? relation;

  AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.qualification,
    required this.specialization,
    required this.consultationFee,
    required this.city,
    required this.experience,
    required this.rating,
    required this.clinicName,
    required this.languages,
    required this.address,
    required this.profileImage,
    required this.appointmentType,
    required this.appointmentDate,
    required this.appointmentSlot,
    required this.tokenNumber,
    required this.status,
    this.familyName,
    this.relation,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json["id"] ?? 0,
      doctorName: json["doctorName"] ?? "",
      qualification: json["qualification"] ?? "",
      specialization: json["specialization"] ?? "",
      consultationFee: int.tryParse(json["consultationFee"].toString()) ?? 0,
      city: json["city"] ?? "",
      experience: int.tryParse(json["experience"].toString()) ?? 0,
      rating: double.tryParse(json["rating"].toString()) ?? 0.0,
      clinicName: json["clinic_name"] ?? json["clinicName"] ?? "",
      languages: json["languages"] is List
          ? (json["languages"] as List).join(", ")
          : json["languages"]?.toString() ?? "",
      address: json["address"] ?? "",
      profileImage: json["profile_image"] ?? json["profileImage"],
      appointmentType: json["appointment_type"] ?? "",
      appointmentDate: _formatDate(json["appointment_date"]),
      appointmentSlot: json["appointment_slot"] ?? "",
      tokenNumber: json["token_number"] ?? 0,
      status: json["status"] ?? "",
      familyName: json["familyName"],
      relation: json["relation"],
    );
  }

  // Helper method to convert "2026-08-06T00:00:00.000Z" to "06 Aug 2026"
  static String _formatDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return "";
    try {
      final dateTime = DateTime.parse(dateStr.toString());
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = _getMonthName(dateTime.month);
      final year = dateTime.year;
      return "$day $month $year"; // Output: "06 Aug 2026"
    } catch (e) {
      return dateStr.toString(); // Fallback if parsing fails
    }
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

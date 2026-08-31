class HomeCareHistoryResponse {
  final bool success;
  final int count;
  final List<HomeCareBookingModel> data;

  const HomeCareHistoryResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory HomeCareHistoryResponse.fromJson(Map<String, dynamic> json) {
    return HomeCareHistoryResponse(
      success: json['success'] == true,
      count: json['count'] as int? ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (item) => HomeCareBookingModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}

class HomeCareBookingDetailsResponse {
  final bool success;
  final HomeCareBookingModel? data;

  const HomeCareBookingDetailsResponse({
    required this.success,
    this.data,
  });

  factory HomeCareBookingDetailsResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return HomeCareBookingDetailsResponse(
      success: json['success'] == true,
      data: json['data'] != null
          ? HomeCareBookingModel.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

class HomeCareBookingModel {
  final int id;
  final int patientId;
  final String fullName;
  final int patientAge;
  final String patientGender;
  final String genderPreference;
  final bool emergencyBooking;
  final String status;
  final String address;
  final double? patientLatitude;
  final double? patientLongitude;
  final String contactNumber;
  final String serviceType;
  final String medicalCondition;
  final String durationType;
  final int numberOfDays;
  final DateTime? preferredDate;
  final String timeSlot;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String bookingId;

  const HomeCareBookingModel({
    required this.id,
    required this.patientId,
    required this.fullName,
    required this.patientAge,
    required this.patientGender,
    required this.genderPreference,
    required this.emergencyBooking,
    required this.status,
    required this.address,
    required this.patientLatitude,
    required this.patientLongitude,
    required this.contactNumber,
    required this.serviceType,
    required this.medicalCondition,
    required this.durationType,
    required this.numberOfDays,
    required this.preferredDate,
    required this.timeSlot,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingId,
  });

  factory HomeCareBookingModel.fromJson(Map<String, dynamic> json) {
    return HomeCareBookingModel(
      id: json['id'] as int? ?? 0,
      patientId: json['patient_id'] as int? ?? 0,
      fullName: json['full_name']?.toString() ?? '',
      patientAge: json['patient_age'] as int? ?? 0,
      patientGender: json['patient_gender']?.toString() ?? '',
      genderPreference: json['gender_preference']?.toString() ?? '',
      emergencyBooking: json['emergency_booking'] == 1 ||
          json['emergency_booking'] == true,
      status: json['status']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      patientLatitude: double.tryParse(
        json['patient_latitude']?.toString() ?? '',
      ),
      patientLongitude: double.tryParse(
        json['patient_longitude']?.toString() ?? '',
      ),
      contactNumber: json['contact_number']?.toString() ?? '',
      serviceType: json['service_type']?.toString() ?? '',
      medicalCondition: json['medical_condition']?.toString() ?? '',
      durationType: json['duration_type']?.toString() ?? '',
      numberOfDays: json['number_of_days'] as int? ?? 0,
      preferredDate: DateTime.tryParse(
        json['preferred_date']?.toString() ?? '',
      ),
      timeSlot: json['time_slot']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      createdAt: DateTime.tryParse(
        json['created_at']?.toString() ?? '',
      ),
      updatedAt: DateTime.tryParse(
        json['updated_at']?.toString() ?? '',
      ),
      bookingId: json['booking_id']?.toString() ?? '',
    );
  }
}
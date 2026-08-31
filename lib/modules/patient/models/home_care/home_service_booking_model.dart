class HomeServiceBookingModel {
  final String fullName;
  final String contactNumber;
  final String patientAge;
  final String patientGender;
  final String address;
  final String preferredCaregiverGender;
  final bool needEmergencyService;
  final String selectedServiceType;
  final String durationType;
  final String numberOfDays;
  final DateTime? startDate;
  final String timePreference;
  final String medicalCondition;
  final String additionalNotes;
  final double? latitude;
  final double? longitude;

  const HomeServiceBookingModel({
    this.fullName = '',
    this.contactNumber = '',
    this.patientAge = '',
    this.patientGender = 'Select Gender',
    this.address = '',
    this.latitude,
    this.longitude,
    this.preferredCaregiverGender = 'No Preference',
    this.needEmergencyService = false,
    this.selectedServiceType = '',
    this.durationType = '1 Day',
    this.numberOfDays = '1',
    this.startDate,
    this.timePreference = '',
    this.medicalCondition = '',
    this.additionalNotes = '',
  });

  HomeServiceBookingModel copyWith({
    String? fullName,
    String? contactNumber,
    String? patientAge,
    String? patientGender,
    String? address,
    double? latitude,
    double? longitude,
    String? preferredCaregiverGender,
    bool? needEmergencyService,
    String? selectedServiceType,
    String? durationType,
    String? numberOfDays,
    DateTime? startDate,
    String? timePreference,
    String? medicalCondition,
    String? additionalNotes,
  }) {
    return HomeServiceBookingModel(
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      preferredCaregiverGender:
      preferredCaregiverGender ?? this.preferredCaregiverGender,
      needEmergencyService:
      needEmergencyService ?? this.needEmergencyService,
      selectedServiceType:
      selectedServiceType ?? this.selectedServiceType,
      durationType: durationType ?? this.durationType,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      startDate: startDate ?? this.startDate,
      timePreference: timePreference ?? this.timePreference,
      medicalCondition:
      medicalCondition ?? this.medicalCondition,
      additionalNotes:
      additionalNotes ?? this.additionalNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'patient_age': int.tryParse(patientAge),
      'patient_gender': patientGender,
      'patient_latitude': latitude,
      'patient_longitude': longitude,
      'gender_preference': preferredCaregiverGender,
      'emergency_booking': needEmergencyService,
      'address': address,
      'contact_number': contactNumber,
      'service_type': selectedServiceType,
      'medical_condition': medicalCondition,
      'duration_type': durationType,
      'number_of_days': int.tryParse(numberOfDays),
      'preferred_date': startDate?.toIso8601String().split('T').first,
      'time_slot': timePreference,
      'notes': additionalNotes,
    };
  }

}

class HomeCareBookingResponse {
  final bool success;
  final String message;
  final HomeCareBookingData? data;

  const HomeCareBookingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory HomeCareBookingResponse.fromJson(Map<String, dynamic> json) {
    return HomeCareBookingResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? HomeCareBookingData.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

class HomeCareBookingData {
  final int id;
  final String bookingId;
  final String status;

  const HomeCareBookingData({
    required this.id,
    required this.bookingId,
    required this.status,
  });

  factory HomeCareBookingData.fromJson(Map<String, dynamic> json) {
    return HomeCareBookingData(
      id: json['id'] as int,
      bookingId: json['booking_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
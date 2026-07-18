class HomeServiceBookingModel {
  final String fullName;
  final String contactNumber;
  final String patientAge;
  final String patientGender;
  final String address;
  final String preferredCaregiverGender;
  final bool needEmergencyService;
  final String selectedServiceType; // General Nursing, Elderly Care etc.
  final String durationType; // 1 Day, Multiple Days, Weekly, Monthly
  final String numberOfDays;
  final DateTime? startDate;
  final String timePreference; // Morning, Afternoon, Evening, Night
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
    this.numberOfDays = '',
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
      needEmergencyService: needEmergencyService ?? this.needEmergencyService,
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      durationType: durationType ?? this.durationType,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      startDate: startDate ?? this.startDate,
      timePreference: timePreference ?? this.timePreference,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }
}

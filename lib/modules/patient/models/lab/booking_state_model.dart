class BookingStateModel {
  final String fullName;
  final String age;
  final String phoneNumber;
  final String gender;

  final String address;

  final double? latitude;

  final double? longitude;

  final DateTime selectedDate;

  final String selectedTimeSlot;

  const BookingStateModel({
    this.fullName = '',
    this.age = '',
    this.phoneNumber = '',
    this.gender = 'Male',
    this.address = '',
    this.latitude,
    this.longitude,
    required this.selectedDate,
    this.selectedTimeSlot = '',
  });

  BookingStateModel copyWith({
    String? fullName,
    String? age,
    String? phoneNumber,
    String? gender,
    String? address,
    double? latitude,
    double? longitude,
    DateTime? selectedDate,
    String? selectedTimeSlot,
  }) {
    return BookingStateModel(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
    );
  }
}

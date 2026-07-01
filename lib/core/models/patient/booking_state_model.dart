
class BookingStateModel {
  final String fullName;
  final String age;
  final String phoneNumber;
  final String gender;
  final String fullAddress;
  final DateTime selectedDate;
  final String selectedTimeSlot;

  const BookingStateModel({
    this.fullName = '',
    this.age = '',
    this.phoneNumber = '',
    this.gender = 'Male',
    this.fullAddress = '',
    required this.selectedDate,
    this.selectedTimeSlot = '',
  });

  BookingStateModel copyWith({
    String? fullName,
    String? age,
    String? phoneNumber,
    String? gender,
    String? fullAddress,
    DateTime? selectedDate,
    String? selectedTimeSlot,
  }) {
    return BookingStateModel(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      fullAddress: fullAddress ?? this.fullAddress,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
    );
  }
}
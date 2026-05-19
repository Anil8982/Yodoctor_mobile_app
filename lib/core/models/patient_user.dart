class PatientUser {
  const PatientUser({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.age,
    required this.bloodGroup,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.gender,
  });

  final String id;
  final String name;
  final String email;
  final String location;
  final int age;
  final String bloodGroup;
  final String mobileNumber;
  final String dateOfBirth;
  final String gender;
}

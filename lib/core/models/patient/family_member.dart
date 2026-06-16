class FamilyMember {
  const FamilyMember({
    required this.name,
    required this.lastVisit,
    required this.relation,
    required this.gender,
    required this.bloodGroup,
    required this.initials,
    required this.dateOfBirth,
    required this.heightCm,
    required this.weightKg,
  });

  final String name;
  final String lastVisit;
  final String relation;
  final String gender;
  final String bloodGroup;
  final String initials;
  final DateTime dateOfBirth;
  final double heightCm;
  final double weightKg;

  String get age {
    final DateTime now = DateTime.now();
    int years = now.year - dateOfBirth.year;

    final bool hasBirthdayPassed =
        now.month > dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day >= dateOfBirth.day);

    if (!hasBirthdayPassed) {
      years -= 1;
    }

    return '$years yrs';
  }
}

class FamilyMemberModel {
  final int id;
  final String fullName;
  final String gender;
  final String dob;
  final int age;
  final String bloodGroup;
  final double heightCm;
  final double weightKg;
  final String relation;
  final String createdAt;

  FamilyMemberModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.age,
    required this.bloodGroup,
    required this.heightCm,
    required this.weightKg,
    required this.relation,
    required this.createdAt,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json["id"] ?? 0,
      fullName: json["full_name"] ?? "",
      gender: json["gender"] ?? "",
      dob: json["dob"] ?? "",
      age: json["age"] ?? 0,
      bloodGroup: json["blood_group"] ?? "",
      heightCm: double.tryParse(json["height_cm"].toString()) ?? 0,
      weightKg: double.tryParse(json["weight_kg"].toString()) ?? 0,
      relation: json["relation"] ?? "",
      createdAt: json["created_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "gender": gender,
      "dob": dob,
      "bloodGroup": bloodGroup,
      "heightCm": heightCm,
      "weightKg": weightKg,
      "relation": relation,
    };
  }

  FamilyMemberModel copyWith({
    int? id,
    String? fullName,
    String? gender,
    String? dob,
    int? age,
    String? bloodGroup,
    double? heightCm,
    double? weightKg,
    String? relation,
    String? createdAt,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      relation: relation ?? this.relation,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get initials =>
      fullName.isEmpty ? "?" : fullName.substring(0, 1).toUpperCase();
}

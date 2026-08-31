class PrescriptionModel {
  final String medicines;
  final String instructions;

  const PrescriptionModel({
    required this.medicines,
    required this.instructions,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      medicines: json["medicines"] ?? "",
      instructions: json["instructions"] ?? "",
    );
  }
}

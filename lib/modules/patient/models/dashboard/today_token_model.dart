class TodayTokenModel {
  final int appointmentId;
  final String type;
  final String slot;
  final int token;

  final String? clinicName;
  final int? nowServing;
  final int? patientsAhead;
  final String? estimatedTime;

  TodayTokenModel({
    required this.appointmentId,
    required this.type,
    required this.slot,
    required this.token,
    this.clinicName,
    this.nowServing,
    this.patientsAhead,
    this.estimatedTime,
  });

  factory TodayTokenModel.fromJson(Map<String, dynamic> json) {
    return TodayTokenModel(
      appointmentId: json["appointmentId"] ?? 0,
      type: json["type"] ?? "",
      slot: json["slot"] ?? "",
      token: json["token"] ?? json["yourToken"] ?? 0,
      clinicName: json["clinicName"],
      nowServing: json["nowServing"],
      patientsAhead: json["patientsAhead"],
      estimatedTime:
          json["estimatedTime"] ?? "${json["estimatedWaitMinutes"] ?? 0} mins",
    );
  }

  TodayTokenModel copyWith({
    int? appointmentId,
    String? type,
    String? slot,
    int? token,
    String? clinicName,
    int? nowServing,
    int? patientsAhead,
    String? estimatedTime,
  }) {
    return TodayTokenModel(
      appointmentId: appointmentId ?? this.appointmentId,
      type: type ?? this.type,
      slot: slot ?? this.slot,
      token: token ?? this.token,
      clinicName: clinicName ?? this.clinicName,
      nowServing: nowServing ?? this.nowServing,
      patientsAhead: patientsAhead ?? this.patientsAhead,
      estimatedTime: estimatedTime ?? this.estimatedTime,
    );
  }
}

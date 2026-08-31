class NotificationModel {
  final int id;
  final String title;
  final String message;
  final int? appointmentId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.appointmentId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"],
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      appointmentId: json["appointment_id"] != null
          ? (json["appointment_id"] is int ? json["appointment_id"] : int.tryParse(json["appointment_id"].toString()))
          : null,
      isRead: (json["is_read"] == 1 || json["is_read"] == true),
      createdAt: DateTime.parse(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "message": message,
      "appointment_id": appointmentId,
      "is_read": isRead ? 1 : 0,
      "created_at": createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    int? appointmentId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      appointmentId: appointmentId ?? this.appointmentId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
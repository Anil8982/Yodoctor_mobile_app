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
      appointmentId: json["appointment_id"],
      isRead: json["is_read"] == 1 || json["is_read"] == true,
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}

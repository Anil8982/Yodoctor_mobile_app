class DoctorStatus {
  final int doctorId;
  final String doctorName;
  final String status; // "APPROVED", "PENDING", "REJECTED"
  final String? rejectionReason;

  DoctorStatus({required this.doctorId, required this.doctorName, required this.status, this.rejectionReason});

  factory DoctorStatus.fromJson(Map<String, dynamic> json) {
    return DoctorStatus(
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      status: json['status'],
      rejectionReason: json['rejectionReason'],
    );
  }
}
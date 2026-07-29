import 'package:yodoctor/core/constants/api_constants.dart';


class DoctorDocumentModel {
  final int id;
  final String fileUrl;
  final DateTime? createdAt;

  const DoctorDocumentModel({
    required this.id,
    required this.fileUrl,
    this.createdAt,
  });

  factory DoctorDocumentModel.fromJson(Map<String, dynamic> json) {
    return DoctorDocumentModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fileUrl: json['file_url']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  String get normalizedUrl => fileUrl.replaceAll('\\', '/');

  String get fileName {
    if (normalizedUrl.isEmpty) return 'Document_$id';
    return normalizedUrl.split('/').last;
  }

  String get fileExtension {
    final name = fileName;
    final parts = name.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool get isPdf => fileExtension == 'pdf';

  bool get isImage => ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(fileExtension);

  String get fullUrl {
    if (normalizedUrl.startsWith('http://') || normalizedUrl.startsWith('https://')) {
      return normalizedUrl;
    }
    return ApiConstants.fileUrl(normalizedUrl);
  }

  String get formattedDate {
    if (createdAt == null) return 'N/A';
    return '${createdAt!.day} ${_monthAbbr(createdAt!.month)} ${createdAt!.year}';
  }

  String _monthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
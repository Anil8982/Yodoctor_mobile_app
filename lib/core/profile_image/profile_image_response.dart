class ProfileImageResponse {
  final bool success;
  final String? imageUrl;

  ProfileImageResponse({required this.success, this.imageUrl});

  factory ProfileImageResponse.fromJson(Map<String, dynamic> json) {
    return ProfileImageResponse(
      success: json['success'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
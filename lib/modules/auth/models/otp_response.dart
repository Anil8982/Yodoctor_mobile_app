class OtpSendResponse {
  final bool success;
  final String message;
  final String? verificationId;
  final int? expiresIn;
  final Map<String, dynamic>? rawData;

  OtpSendResponse({
    required this.success,
    required this.message,
    this.verificationId,
    this.expiresIn,
    this.rawData,
  });

  factory OtpSendResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataRaw = json['data'];
    final Map<String, dynamic> dataMap = (dataRaw is Map<String, dynamic>)
        ? dataRaw
        : (dataRaw is Map ? Map<String, dynamic>.from(dataRaw) : <String, dynamic>{});

    final verificationId = json['verificationId']?.toString() ??
        dataMap['verificationId']?.toString();

    final dynamic expiresRaw = json['expiresIn'] ?? dataMap['expiresIn'];
    int? expiresIn;
    if (expiresRaw is int) {
      expiresIn = expiresRaw;
    } else if (expiresRaw != null) {
      expiresIn = int.tryParse(expiresRaw.toString());
    }

    final bool isSuccess = json['success'] == true ||
        dataMap['success'] == true ||
        (json['success'] == null && verificationId != null);

    return OtpSendResponse(
      success: isSuccess,
      message: json['message']?.toString() ??
          dataMap['message']?.toString() ??
          (isSuccess ? 'OTP sent successfully' : 'Failed to send OTP'),
      verificationId: verificationId,
      expiresIn: expiresIn,
      rawData: json,
    );
  }
}

class OtpVerifyResponse {
  final bool success;
  final String message;
  final String? verificationId;
  final String? email;
  final String? phone;
  final bool verified;
  final Map<String, dynamic>? rawData;

  OtpVerifyResponse({
    required this.success,
    required this.message,
    this.verificationId,
    this.email,
    this.phone,
    this.verified = false,
    this.rawData,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataRaw = json['data'];
    final Map<String, dynamic> dataMap = (dataRaw is Map<String, dynamic>)
        ? dataRaw
        : (dataRaw is Map ? Map<String, dynamic>.from(dataRaw) : <String, dynamic>{});

    final bool isVerified = json['verified'] == true ||
        dataMap['verified'] == true ||
        json['success'] == true ||
        dataMap['success'] == true;

    return OtpVerifyResponse(
      success: isVerified,
      message: json['message']?.toString() ??
          dataMap['message']?.toString() ??
          (isVerified ? 'Verified successfully' : 'Verification failed'),
      verificationId: json['verificationId']?.toString() ??
          dataMap['verificationId']?.toString(),
      email: json['email']?.toString() ?? dataMap['email']?.toString(),
      phone: json['phone']?.toString() ??
          dataMap['phone']?.toString() ??
          json['mobile']?.toString() ??
          dataMap['mobile']?.toString(),
      verified: isVerified,
      rawData: json,
    );
  }
}

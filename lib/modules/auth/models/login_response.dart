class LoginResponse {
  final bool success;
  final String message;
  final String? token;
  final bool requiresOtp;
  final String? verificationId;
  final String? channel;
  final String? mobile;
  final String? email;
  final String? destination;
  final String? maskedDestination;
  final int? expiresIn;
  final Map<String, dynamic>? rawData;

  LoginResponse({
    required this.success,
    required this.message,
    this.token,
    this.requiresOtp = false,
    this.verificationId,
    this.channel,
    this.mobile,
    this.email,
    this.destination,
    this.maskedDestination,
    this.expiresIn,
    this.rawData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataRaw = json['data'];
    final Map<String, dynamic> dataMap = (dataRaw is Map<String, dynamic>)
        ? dataRaw
        : (dataRaw is Map ? Map<String, dynamic>.from(dataRaw) : <String, dynamic>{});

    final token = dataMap['token']?.toString() ?? json['token']?.toString();

    final bool requiresOtp = json['requiresOtp'] == true ||
        json['otpRequired'] == true ||
        json['isOtpRequired'] == true ||
        dataMap['requiresOtp'] == true ||
        dataMap['otpRequired'] == true ||
        dataMap['isOtpRequired'] == true ||
        json['redirect'] == 'otp' ||
        json['status'] == 'OTP_REQUIRED' ||
        (token == null &&
            (json['verificationId'] != null || dataMap['verificationId'] != null));

    final String? verificationId = json['verificationId']?.toString() ??
        dataMap['verificationId']?.toString();

    final String? channel = json['channel']?.toString() ??
        dataMap['channel']?.toString();

    final String? mobile = json['mobile']?.toString() ??
        dataMap['mobile']?.toString() ??
        json['phone']?.toString() ??
        dataMap['phone']?.toString();

    final String? email = json['email']?.toString() ??
        dataMap['email']?.toString();

    final String? destination = json['destination']?.toString() ??
        dataMap['destination']?.toString() ??
        json['maskedEmail']?.toString() ??
        dataMap['maskedEmail']?.toString() ??
        json['maskedMobile']?.toString() ??
        dataMap['maskedMobile']?.toString() ??
        json['maskedDestination']?.toString() ??
        dataMap['maskedDestination']?.toString();

    final String? maskedDestination = destination;

    final int? expiresIn = json['expiresIn'] is int
        ? json['expiresIn'] as int
        : (dataMap['expiresIn'] is int
            ? dataMap['expiresIn'] as int
            : int.tryParse(json['expiresIn']?.toString() ?? dataMap['expiresIn']?.toString() ?? ''));

    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      token: token,
      requiresOtp: requiresOtp,
      verificationId: verificationId,
      channel: channel,
      mobile: mobile,
      email: email,
      destination: destination,
      maskedDestination: maskedDestination,
      expiresIn: expiresIn,
      rawData: json,
    );
  }
}
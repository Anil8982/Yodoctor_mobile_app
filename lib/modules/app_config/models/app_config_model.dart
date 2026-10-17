class AppConfigModel {
  final VersioningConfig versioning;
  final StatusConfig status;
  final LegalAndSupportConfig legalAndSupport;
  final AppLinksConfig appLinks;

  const AppConfigModel({
    required this.versioning,
    required this.status,
    required this.legalAndSupport,
    required this.appLinks,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      versioning: VersioningConfig.fromJson(
        json["versioning"] as Map<String, dynamic>? ?? {},
      ),
      status: StatusConfig.fromJson(
        json["status"] as Map<String, dynamic>? ?? {},
      ),
      legalAndSupport: LegalAndSupportConfig.fromJson(
        json["legal_and_support"] as Map<String, dynamic>? ?? {},
      ),
      appLinks: AppLinksConfig.fromJson(
        json["app_links"] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "versioning": versioning.toJson(),
      "status": status.toJson(),
      "legal_and_support": legalAndSupport.toJson(),
      "app_links": appLinks.toJson(),
    };
  }
}

class VersioningConfig {
  final String minVersion;
  final String latestVersion;
  final String forceUpdateMsg;

  const VersioningConfig({
    required this.minVersion,
    required this.latestVersion,
    required this.forceUpdateMsg,
  });

  factory VersioningConfig.fromJson(Map<String, dynamic> json) {
    return VersioningConfig(
      minVersion: json["min_version"]?.toString() ?? "0.0.0",
      latestVersion: json["latest_version"]?.toString() ?? "0.0.0",
      forceUpdateMsg: json["force_update_msg"]?.toString() ??
          "A new version is available. Please update the app.",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "min_version": minVersion,
      "latest_version": latestVersion,
      "force_update_msg": forceUpdateMsg,
    };
  }
}

class StatusConfig {
  final bool isMaintenanceMode;
  final String maintenanceMsg;

  const StatusConfig({
    required this.isMaintenanceMode,
    required this.maintenanceMsg,
  });

  factory StatusConfig.fromJson(Map<String, dynamic> json) {
    return StatusConfig(
      isMaintenanceMode: json["is_maintenance_mode"] == true,
      maintenanceMsg: json["maintenance_msg"]?.toString() ??
          "We are currently performing maintenance. Please try again later.",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_maintenance_mode": isMaintenanceMode,
      "maintenance_msg": maintenanceMsg,
    };
  }
}

class LegalAndSupportConfig {
  final String privacyPolicyUrl;
  final String termsServiceUrl;
  final String supportEmail;
  final String whatsappNumber;
  final String helpCenterUrl;
  final String feedbackFormUrl;

  const LegalAndSupportConfig({
    required this.privacyPolicyUrl,
    required this.termsServiceUrl,
    required this.supportEmail,
    required this.whatsappNumber,
    required this.helpCenterUrl,
    required this.feedbackFormUrl,
  });

  factory LegalAndSupportConfig.fromJson(Map<String, dynamic> json) {
    return LegalAndSupportConfig(
      privacyPolicyUrl: json["privacy_policy_url"]?.toString() ?? "",
      termsServiceUrl: json["terms_service_url"]?.toString() ?? "",
      supportEmail: json["support_email"]?.toString() ?? "",
      whatsappNumber: json["whatsapp_number"]?.toString() ?? "",
      helpCenterUrl: json["help_center_url"]?.toString() ?? "",
      feedbackFormUrl: json["feedback_form_url"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "privacy_policy_url": privacyPolicyUrl,
      "terms_service_url": termsServiceUrl,
      "support_email": supportEmail,
      "whatsapp_number": whatsappNumber,
      "help_center_url": helpCenterUrl,
      "feedback_form_url": feedbackFormUrl,
    };
  }
}

class AppLinksConfig {
  final String androidPlayStoreUrl;
  final String iosAppStoreUrl;

  const AppLinksConfig({
    required this.androidPlayStoreUrl,
    required this.iosAppStoreUrl,
  });

  factory AppLinksConfig.fromJson(Map<String, dynamic> json) {
    return AppLinksConfig(
      androidPlayStoreUrl: json["android_play_store_url"]?.toString() ?? "",
      iosAppStoreUrl: json["ios_app_store_url"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "android_play_store_url": androidPlayStoreUrl,
      "ios_app_store_url": iosAppStoreUrl,
    };
  }
}
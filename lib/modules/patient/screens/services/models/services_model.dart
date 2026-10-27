import 'package:flutter/material.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../l10n/app_localizations.dart';

enum MedicalServiceType {
  medicineDelivery,
  labTest,
  qrScanToken,
  onlineAppointment,
  medicalCertificate,
  homeNursingCare,
}

class MedicalService {
  final MedicalServiceType type;
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final Color baseColor;
  final bool isQrScanner;
  final String imagePath;
  final String badgeText;

  const MedicalService({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.baseColor,
    this.isQrScanner = false,
    required this.imagePath,
    this.badgeText = '',
  });

  String getLocalizedTitle(AppLocalizations? l10n) {
    if (l10n == null) return title;
    switch (type) {
      case MedicalServiceType.medicineDelivery:
        return l10n.serviceMedicineDeliveryTitle;
      case MedicalServiceType.labTest:
        return l10n.serviceLabTestTitle;
      case MedicalServiceType.qrScanToken:
        return l10n.serviceQrScanTokenTitle;
      case MedicalServiceType.onlineAppointment:
        return l10n.serviceOnlineAppointmentTitle;
      case MedicalServiceType.medicalCertificate:
        return l10n.serviceMedicalCertificateTitle;
      case MedicalServiceType.homeNursingCare:
        return l10n.serviceHomeNursingCareTitle;
    }
  }

  String getLocalizedSubtitle(AppLocalizations? l10n) {
    if (l10n == null) return subtitle;
    switch (type) {
      case MedicalServiceType.medicineDelivery:
        return l10n.serviceMedicineDeliverySubtitle;
      case MedicalServiceType.labTest:
        return l10n.serviceLabTestSubtitle;
      case MedicalServiceType.qrScanToken:
        return l10n.serviceQrScanTokenSubtitle;
      case MedicalServiceType.onlineAppointment:
        return l10n.serviceOnlineAppointmentSubtitle;
      case MedicalServiceType.medicalCertificate:
        return l10n.serviceMedicalCertificateSubtitle;
      case MedicalServiceType.homeNursingCare:
        return l10n.serviceHomeNursingCareSubtitle;
    }
  }

  String getLocalizedAction(AppLocalizations? l10n) {
    if (l10n == null) return 'Book';
    switch (type) {
      case MedicalServiceType.qrScanToken:
        return l10n.scanQrAction;
      case MedicalServiceType.medicalCertificate:
        return l10n.applyNowAction;
      case MedicalServiceType.medicineDelivery:
        return l10n.comingSoonBadge;
      default:
        return l10n.bookNowAction;
    }
  }
}

/// Clinical Consultations (Doctor Search, QR Scan, Medical Certificate)
final List<MedicalService> clinicalServicesList = [
  const MedicalService(
    type: MedicalServiceType.onlineAppointment,
    title: 'Find Doctors',
    subtitle: 'Book clinic & video consults',
    route: AppRoutes.search,
    icon: Icons.calendar_month_rounded,
    baseColor: Color(0xFF5C6BC0), // Indigo
    imagePath: 'assets/images/services/online_appointment_3d.webp',
  ),
  const MedicalService(
    type: MedicalServiceType.qrScanToken,
    title: 'Instant QR Token',
    subtitle: 'Scan desk QR for queue token',
    route: '',
    icon: Icons.qr_code_scanner_rounded,
    baseColor: Color(0xFF00ACC1), // Cyan / Teal
    isQrScanner: true,
    imagePath: 'assets/images/services/qr_appointment_3d.webp',
  ),
  const MedicalService(
    type: MedicalServiceType.medicalCertificate,
    title: 'Medical Certificate',
    subtitle: 'Official certified documents',
    route: AppRoutes.doctorSelection,
    icon: Icons.description_rounded,
    baseColor: Color(0xFFE91E63), // Pink
    imagePath: 'assets/images/services/medical_certificate_3d.webp',
  ),
];

/// Doorstep Services (Lab Tests, Medicine Delivery)
final List<MedicalService> doorstepServicesList = [
  const MedicalService(
    type: MedicalServiceType.labTest,
    title: 'Lab Tests at Home',
    subtitle: 'Sample pickup from your doorstep',
    route: AppRoutes.labTest,
    icon: Icons.science_rounded,
    baseColor: Color(0xFF1E88E5), // Blue
    imagePath: 'assets/images/services/lab_test_3d.webp',
  ),
  const MedicalService(
    type: MedicalServiceType.medicineDelivery,
    title: 'Medicine Delivery',
    subtitle: 'Pharmacy essentials at door',
    route: '#',
    icon: Icons.local_shipping_rounded,
    baseColor: Color(0xFFFB8C00), // Amber / Orange
    imagePath: 'assets/images/services/medicine_delivery_3d.webp',
    badgeText: 'SOON',
  ),
];

/// Full list of services
final List<MedicalService> medicalServicesList = [
  doorstepServicesList[0],
  doorstepServicesList[1],
  clinicalServicesList[0],
  clinicalServicesList[1],
  clinicalServicesList[2],
  const MedicalService(
    type: MedicalServiceType.homeNursingCare,
    title: 'Home Nursing Care',
    subtitle: 'Care at your home',
    route: AppRoutes.homeServiceBooking,
    icon: Icons.home_repair_service_rounded,
    baseColor: Color(0xFF43A047),
    imagePath: 'assets/images/services/home_nursing_3d.webp',
  ),
];

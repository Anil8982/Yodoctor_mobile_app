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

  const MedicalService({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.baseColor,
    this.isQrScanner = false,
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
}

final List<MedicalService> medicalServicesList = [
  const MedicalService(
    type: MedicalServiceType.medicineDelivery,
    title: 'Medicine Delivery',
    subtitle: 'Essentials at your doorstep',
    route: '#',
    icon: Icons.delivery_dining_rounded,
    baseColor: Color(0xFFFFB03A),
  ),
  const MedicalService(
    type: MedicalServiceType.labTest,
    title: 'Lab Test',
    subtitle: 'Sample Pickup at Your Door',
    route: AppRoutes.labTest,
    icon: Icons.science_rounded,
    baseColor: Color(0xFF42A5F5),
  ),
  const MedicalService(
    type: MedicalServiceType.qrScanToken,
    title: 'Scan Qr & get Appointment Token',
    subtitle: 'Scan & Book Instantly',
    route: '',
    icon: Icons.qr_code_scanner_rounded,
    baseColor: Color(0xFF26C6DA),
    isQrScanner: true,
  ),
  const MedicalService(
    type: MedicalServiceType.onlineAppointment,
    title: 'Online Booking Appointment',
    subtitle: 'Book from anywhere',
    route: AppRoutes.search,
    icon: Icons.calendar_month_rounded,
    baseColor: Color(0xFF7E57C2),
  ),
  const MedicalService(
    type: MedicalServiceType.medicalCertificate,
    title: 'Apply for Medical Certificate',
    subtitle: 'Consult from home',
    route: AppRoutes.doctorSelection,
    icon: Icons.description_rounded,
    baseColor: Color(0xFFEC407A),
  ),
  const MedicalService(
    type: MedicalServiceType.homeNursingCare,
    title: 'Home Nursing Care Service booking',
    subtitle: 'Care at your home',
    route: AppRoutes.homeServiceBooking,
    icon: Icons.home_repair_service_rounded,
    baseColor: Color(0xFF66BB6A),
  ),
];

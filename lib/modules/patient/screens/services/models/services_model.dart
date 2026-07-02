import 'package:flutter/material.dart';
import '../../../../../../core/routes/app_routes.dart';

class MedicalService {
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final Color baseColor;
  final bool isQrScanner;

  const MedicalService({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.baseColor,
    this.isQrScanner = false,
  });
}

final List<MedicalService> medicalServicesList = [
  const MedicalService(
    title: 'Medicine Delivery',
    subtitle: 'Essentials at your doorstep',
    route: '#',
    icon: Icons.delivery_dining_rounded,
    baseColor: Color(0xFFFFB03A),
  ),
  const MedicalService(
    title: 'Lab Test',
    subtitle: 'Sample Pickup at Your Door',
    route: AppRoutes.labTest,
    icon: Icons.science_rounded,
    baseColor: Color(0xFF42A5F5),
  ),
  const MedicalService(
    title: 'Scan Qr & get Appointment Token',
    subtitle: 'Scan & Book Instantly',
    route: '',
    icon: Icons.qr_code_scanner_rounded,
    baseColor: Color(0xFF26C6DA),
    isQrScanner: true,
  ),
  const MedicalService(
    title: 'Online Booking Appointment',
    subtitle: 'Book from anywhere',
    route: AppRoutes.search,
    icon: Icons.calendar_month_rounded,
    baseColor: Color(0xFF7E57C2),
  ),
  const MedicalService(
    title: 'Apply for Medical Certificate',
    subtitle: 'Consult from home',
    route: AppRoutes.applyCertificate,
    icon: Icons.description_rounded,
    baseColor: Color(0xFFEC407A),
  ),
  const MedicalService(
    title: 'Home Nursing Care Service booking',
    subtitle: 'Care at your home',
    route: AppRoutes.homeServiceBooking,
    icon: Icons.home_repair_service_rounded,
    baseColor: Color(0xFF66BB6A),
  ),
];

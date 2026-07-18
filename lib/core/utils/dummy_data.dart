export '../models/admin/doctor_profile.dart';
export '../models/admin/patient_appointment.dart';
export '../models/admin/patient_dashboard_data.dart';
export '../models/admin/patient_token.dart';
export '../../modules/auth/models/patient_user.dart';
import 'package:yodoctor/core/models/admin/admin_dashboard_data.dart';
import 'package:yodoctor/core/models/admin/admin_user.dart';
import 'package:yodoctor/core/models/admin/home_care_booking_model.dart';
import 'package:yodoctor/core/models/admin/enquiry_model.dart';

import '../../modules/notifications/models/notification_model.dart';
import '../models/admin/doctor_profile.dart';
import '../models/admin/patient_appointment.dart';

class DummyData {
  const DummyData._();

  // 🎯 Sourced from baseline structure safely to maintain dependencies
  static const List<DoctorProfile> allDoctors = <DoctorProfile>[
    DoctorProfile(
      id: 'DOC-1',
      name: 'Dr. Julian Thorne',
      specialty: 'Cardiologist',
      hospital: 'Heart Care Center',
      experienceYears: 12,
      rating: 4.9,
      reviewCount: 450,
      consultationFee: 800,
      distanceKm: 2.5,
      availableSlot: '11:00 AM',
      languages: <String>['English', 'Hindi'],
      location: 'Mumbai',
    ),
  ];

  static List<PatientAppointment> _appointments() {
    final DateTime now = DateTime.now();
    return <PatientAppointment>[
      PatientAppointment(
        id: 'APT-1',
        doctorName: 'Dr. Julian Thorne',
        specialty: 'Cardiologist',
        hospital: 'Heart Care Center',
        dateTime: DateTime(now.year, now.month, now.day, 14, 30),
        status: 'Today',
        isOnline: false,
        patientName: 'Self',
        appointmentStatus: 'ACCEPTED',
      ),
    ];
  }


  // ================= ADMIN DASHBOARD =================

  static const AdminUser adminUser = AdminUser(
    id: '#1',
    name: 'MeAdmin',
    email: 'admin@gmail.com',
  );

  static final AdminDashboardData _adminDashboardData = AdminDashboardData(
    admin: adminUser,
    totalDoctors: allDoctors.length,
    totalPatients: 34,
    todaysAppointments: _appointments().length,
    pendingApprovals: 0,
    appointments: _appointments(),
    totalAppointments: _appointments().length,
    completedAppointments: 0,
    cancelledAppointments: 0,
    pendingAppointments: 0,
  );

  static Future<AdminDashboardData> getAdminDashboardData() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _adminDashboardData;
  }

  // ================= Enquiry =================
  static final List<EnquiryModel> enquiries = [
    EnquiryModel(
      id: 1,
      name: 'AMIT KUMAR MISHRA',
      mobile: '9770483883',
      email: 'akagnihotri797473@gmail.com',
      concern: 'Lab',
      subConcern: 'Order',
      message: 'Looks better services',
      status: 'Resolved',
      date: '30-05-2026',
    ),
    EnquiryModel(
      id: 2,
      name: 'RAHUL SHARMA',
      mobile: '9876543210',
      email: 'rahul@gmail.com',
      concern: 'Doctor',
      subConcern: 'Appointment',
      message: 'Unable to book appointment',
      status: 'Pending',
      date: '15-06-2026',
    ),
  ];

  static Future<List<EnquiryModel>> getEnquiries() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return List<EnquiryModel>.from(enquiries);
  }

  // ================= HOME CARE BOOKINGS DATA =================
  static final List<HomeCareBookingModel> homeCareBookings = [
    HomeCareBookingModel(
      id: 1,
      patientName: "Ajay Singh",
      contact: "7879518155",
      address: "Bhopal",
      healthIssue: "I am suffering from fever",
      service: "Nurse",
      date: "13/06/2026",
      days: "1 day",
      time: "Evening",
    ),
    HomeCareBookingModel(
      id: 2,
      patientName: "Chandan Kumar",
      contact: "6261715701",
      address: "Jhansi",
      healthIssue: "Bukhar he",
      service: "Nurse",
      date: "29/05/2026",
      days: "1 day",
      time: "Evening",
    ),
  ];

  static Future<List<HomeCareBookingModel>> getHomeCareBookings() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return List<HomeCareBookingModel>.from(homeCareBookings);
  }

  static Future<List<HomeCareBookingModel>> refreshHomeCareBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return List<HomeCareBookingModel>.from(homeCareBookings);
  }
}


class DummyNotifications {
  DummyNotifications._();

  static List<NotificationModel> getNotifications() {
    final now = DateTime.now();

    return [
      // Today - Unread
      NotificationModel(
        id: 1,
        title: 'Appointment Confirmed',
        message: 'Your appointment with Dr. Sharma has been confirmed for tomorrow at 10:30 AM.',
        appointmentId: 120,
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: 2,
        title: 'New Patient Assigned',
        message: 'A new patient Rajesh Kumar has been assigned to your queue.',
        appointmentId: 121,
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),

      // Today - Read
      NotificationModel(
        id: 3,
        title: 'Certificate Approved',
        message: 'Your medical certificate request #45 has been approved.',
        appointmentId: null,
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      NotificationModel(
        id: 4,
        title: 'Profile Updated',
        message: 'Your profile information has been successfully updated.',
        appointmentId: null,
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),

      // Older - Unread
      NotificationModel(
        id: 5,
        title: 'Subscription Expiring',
        message: 'Your premium subscription will expire in 3 days. Renew now to continue.',
        appointmentId: null,
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1, hours: 4)),
      ),
      NotificationModel(
        id: 6,
        title: 'Payment Received',
        message: 'Payment of ₹500 received for appointment #120.',
        appointmentId: 120,
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1, hours: 10)),
      ),

      // Older - Read
      NotificationModel(
        id: 7,
        title: 'System Update',
        message: 'YoDoctor app has been updated to version 2.1.0 with new features.',
        appointmentId: null,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      NotificationModel(
        id: 8,
        title: 'Weekly Report',
        message: 'Your weekly consultation report is now available.',
        appointmentId: null,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      NotificationModel(
        id: 9,
        title: 'Appointment Cancelled',
        message: 'Patient Priya Patel cancelled appointment #115.',
        appointmentId: 115,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      NotificationModel(
        id: 10,
        title: 'New Review',
        message: 'You received a 5-star review from patient Amit Verma.',
        appointmentId: null,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
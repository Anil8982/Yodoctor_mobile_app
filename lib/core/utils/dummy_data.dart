export '../models/admin/doctor_profile.dart';
export '../models/admin/patient_appointment.dart';
export '../models/admin/patient_dashboard_data.dart';
export '../models/admin/patient_token.dart';
export '../../modules/auth/models/patient_user.dart';
import 'package:yodoctor/core/models/admin/admin_dashboard_data.dart';
import 'package:yodoctor/core/models/admin/admin_user.dart';
import 'package:yodoctor/core/models/admin/home_care_booking_model.dart';
import 'package:yodoctor/core/models/admin/enquiry_model.dart';

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
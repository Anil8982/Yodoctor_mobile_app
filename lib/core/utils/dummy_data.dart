export '../models/appointment_history_item.dart';
export '../models/doctor_profile.dart';
export '../models/family_member.dart';
export '../models/patient_appointment.dart';
export '../models/patient_dashboard_data.dart';
export '../models/patient_token.dart';
export '../models/patient_user.dart';
export '../models/doctor_dashboard_data.dart';
export '../../modules/patient/controllers/medical_certificate.dart';

import 'package:yodoctor/core/models/admin_dashboard_data.dart';
import 'package:yodoctor/core/models/admin_user.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/models/enquiry_model.dart';

import '../models/appointment_history_item.dart';
import '../models/doctor_profile.dart';
import '../models/family_member.dart';
import '../models/patient_appointment.dart';
import '../models/patient_dashboard_data.dart';
import '../models/patient_token.dart';
import '../models/patient_user.dart';
import '../models/doctor_dashboard_data.dart';
import '../../modules/patient/controllers/medical_certificate.dart';

class DummyData {
  const DummyData._();

  static const PatientUser currentUser = PatientUser(
    id: '#28',
    name: 'Anil kushwaha',
    email: 'aniljohn1462003@gmail.com',
    location: 'Ahmedabad, Gujarat',
    age: 21,
    bloodGroup: 'B+',
    mobileNumber: '8982840898',
    dateOfBirth: '14 - 06 - 2002',
    gender: 'Male',
  );

  static const PatientToken todayToken = PatientToken(
    tokenNumber: '#12',
    patientsAhead: 3,
    estimatedTime: '20 mins',
    clinicName: 'In-Clinic',
    nowServing: '#9',
  );

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
      PatientAppointment(
        id: 'APT-2',
        doctorName: 'Dr. Priya Sharma',
        specialty: 'Dermatologist',
        hospital: 'Skin Clinic',
        dateTime: now.add(const Duration(days: 1, hours: 2)),
        status: 'Upcoming',
        isOnline: true,
        patientName: 'Meera Patel',
        appointmentStatus: 'PENDING',
      ),
      PatientAppointment(
        id: 'APT-3',
        doctorName: 'Dr. Rahul Mehta',
        specialty: 'Neurologist',
        hospital: 'Brain & Spine',
        dateTime: now.add(const Duration(days: 3, hours: 1)),
        status: 'Upcoming',
        isOnline: false,
        patientName: 'Self',
        appointmentStatus: 'ACCEPTED',
      ),
    ];
  }

  static final List<AppointmentHistoryItem> appointmentHistory =
      <AppointmentHistoryItem>[
        AppointmentHistoryItem(
          id: 'HIS-1',
          doctorName: 'Dr. Praveen Singh',
          specialty: 'Dermatologist',
          patientLabel: 'Ajay (Family)',
          date: DateTime(2026, 5, 6),
          shift: 'EVENING',
          tokenNumber: '#4',
          status: 'COMPLETED',
        ),
        AppointmentHistoryItem(
          id: 'HIS-2',
          doctorName: 'Dr. Praveen Singh',
          specialty: 'Dermatologist',
          patientLabel: 'Vineet Kushwaha (Self)',
          date: DateTime(2026, 5, 6),
          shift: 'EVENING',
          tokenNumber: '#3',
          status: 'COMPLETED',
        ),
        AppointmentHistoryItem(
          id: 'HIS-3',
          doctorName: 'Dr. Praveen Singh',
          specialty: 'Dermatologist',
          patientLabel: 'Ajay (Family)',
          date: DateTime(2026, 4, 28),
          shift: 'EVENING',
          tokenNumber: '#3',
          status: 'COMPLETED',
        ),
        AppointmentHistoryItem(
          id: 'HIS-4',
          doctorName: 'Dr. Praveen Singh',
          specialty: 'Dermatologist',
          patientLabel: 'Ajay (Family)',
          date: DateTime(2026, 4, 28),
          shift: 'EVENING',
          tokenNumber: '#2',
          status: 'COMPLETED',
        ),
        AppointmentHistoryItem(
          id: 'HIS-5',
          doctorName: 'Dr. Praveen Singh',
          specialty: 'Dermatologist',
          patientLabel: 'Vineet Kushwaha (Self)',
          date: DateTime(2026, 4, 28),
          shift: 'EVENING',
          tokenNumber: '#1',
          status: 'COMPLETED',
        ),
      ];

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
    DoctorProfile(
      id: 'DOC-2',
      name: 'Dr. Priya Sharma',
      specialty: 'Dermatologist',
      hospital: 'Skin Clinic',
      experienceYears: 8,
      rating: 4.7,
      reviewCount: 320,
      consultationFee: 600,
      distanceKm: 1.2,
      availableSlot: '12:30 PM',
      languages: <String>['English', 'Hindi'],
      location: 'Delhi',
    ),
    DoctorProfile(
      id: 'DOC-3',
      name: 'Dr. Rahul Mehta',
      specialty: 'Neurologist',
      hospital: 'Brain & Spine',
      experienceYears: 15,
      rating: 4.8,
      reviewCount: 512,
      consultationFee: 1000,
      distanceKm: 4.4,
      availableSlot: '04:45 PM',
      languages: <String>['English', 'Hindi', 'Kannada'],
      location: 'Bangalore',
    ),
  ];

  static final List<MedicalCertificate> dummyCertificates =
      <MedicalCertificate>[
        MedicalCertificate(
          id: 'CERT-1',
          type: 'Medical Fitness',
          patientName: 'Ajay',
          dateOfBirth: '2004-02-12',
          gender: 'Male',
          bloodGroup: 'A+',
          heightCm: 167.0,
          weightKg: 67.0,
          medicalConditions: 'None',
          medications: 'None',
          doctor: allDoctors[0],
          purpose: 'Travel',
          additionalNotes: 'Required for travel clearance.',
          status: 'APPROVED',
          requestDate: DateTime.now().subtract(const Duration(days: 5)),
          issuedDate: DateTime.now().subtract(const Duration(days: 4)),
          documents: const <String>['profile_photo.jpg', 'aadhaar_card.png'],
        ),
        MedicalCertificate(
          id: 'CERT-2',
          type: 'Vaccination',
          patientName: 'Anil kushwaha',
          dateOfBirth: '14-06-2002',
          gender: 'Male',
          bloodGroup: 'B+',
          heightCm: 175.0,
          weightKg: 70.0,
          medicalConditions: 'None',
          medications: 'None',
          doctor: allDoctors[1],
          purpose: 'Employment',
          additionalNotes: 'Need Hepatitis B vaccine certificate.',
          status: 'PENDING',
          requestDate: DateTime.now().subtract(const Duration(days: 1)),
          documents: const <String>['vaccination_card.jpg'],
        ),
        MedicalCertificate(
          id: 'CERT-3',
          type: 'Second Opinion',
          patientName: 'Meera Patel',
          dateOfBirth: '1990-03-14',
          gender: 'Female',
          bloodGroup: 'B+',
          heightCm: 162.0,
          weightKg: 58.0,
          medicalConditions: 'Migraine',
          medications: 'Sumatriptan 50mg',
          doctor: allDoctors[2],
          purpose: 'Treatment Review',
          additionalNotes:
              'Checking neurologist opinion on headache treatment.',
          status: 'REJECTED',
          requestDate: DateTime.now().subtract(const Duration(days: 10)),
          documents: const <String>['mri_brain_report.pdf'],
        ),
      ];

  static const List<String> trendingSpecialties = <String>[
    'Neurologist',
    'Cardiologist',
    'Child Specialist',
    'Dental Care',
  ];

  static final List<FamilyMember> familyMembers = <FamilyMember>[
    FamilyMember(
      name: 'Meera Patel',
      lastVisit: '12 Jan 2025',
      relation: 'Wife',
      gender: 'Female',
      bloodGroup: 'B+',
      initials: 'MP',
      dateOfBirth: DateTime(1990, 3, 14),
      heightCm: 162,
      weightKg: 58,
    ),
    FamilyMember(
      name: 'Arjun Patel',
      lastVisit: '5 Feb 2025',
      relation: 'Son',
      gender: 'Male',
      bloodGroup: 'O+',
      initials: 'AP',
      dateOfBirth: DateTime(2014, 8, 21),
      heightCm: 142,
      weightKg: 36,
    ),
    FamilyMember(
      name: 'Ramesh Patel',
      lastVisit: '20 Dec 2024',
      relation: 'Father',
      gender: 'Male',
      bloodGroup: 'A+',
      initials: 'RP',
      dateOfBirth: DateTime(1956, 11, 5),
      heightCm: 167,
      weightKg: 69,
    ),
  ];

  static Future<PatientDashboardData> getDashboardData({
    String filter = 'All',
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final List<PatientAppointment> appointments = filterAppointments(filter);

    return PatientDashboardData(
      user: currentUser,
      upcomingVisitsCount: 4,
      todayToken: todayToken,
      appointments: appointments,
    );
  }

  static List<PatientAppointment> filterAppointments(String filter) {
    final List<PatientAppointment> allAppointments = _appointments();
    final String normalized = filter.trim().toLowerCase();

    if (normalized.isEmpty || normalized == 'all') {
      return allAppointments;
    }

    if (normalized == 'today') {
      return allAppointments
          .where((PatientAppointment item) => item.status == 'Today')
          .toList();
    }

    if (normalized == 'next 7 days') {
      return allAppointments
          .where((PatientAppointment item) => item.status == 'Upcoming')
          .toList();
    }

    return allAppointments;
  }

  static Future<List<DoctorProfile>> searchDoctors({String query = ''}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final String normalized = query.trim().toLowerCase();

    if (normalized.isEmpty) {
      return List<DoctorProfile>.from(allDoctors);
    }

    return allDoctors.where((DoctorProfile doctor) {
      return doctor.name.toLowerCase().contains(normalized) ||
          doctor.specialty.toLowerCase().contains(normalized) ||
          doctor.hospital.toLowerCase().contains(normalized) ||
          doctor.location.toLowerCase().contains(normalized);
    }).toList();
  }

  static Future<List<String>> getTrendingSpecialties() async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    return List<String>.from(trendingSpecialties);
  }

  static Future<List<AppointmentHistoryItem>> getAppointmentHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return List<AppointmentHistoryItem>.from(appointmentHistory);
  }

  static const DoctorProfile currentDoctor = DoctorProfile(
    id: 'DOC-VERMA',
    name: 'Dr. Rahul Verma',
    specialty: 'Orthopedic',
    hospital: 'Yo Hospital',
    experienceYears: 6,
    rating: 0.0,
    reviewCount: 0,
    consultationFee: 400,
    distanceKm: 0.0,
    availableSlot: 'Available Now',
    languages: <String>['English', 'Hindi'],
    location: 'Bhopal',
  );

  static DoctorDashboardData _doctorDashboardData = DoctorDashboardData(
    doctor: currentDoctor,
    pendingRequests: 0,
    todayQueueCount: 0,
    completedTodayCount: 0,
    isAvailable: true,
  );

  static Future<DoctorDashboardData> getDoctorDashboardData() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _doctorDashboardData;
  }

  static Future<void> toggleDoctorAvailability(bool available) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _doctorDashboardData = _doctorDashboardData.copyWith(
      isAvailable: available,
    );
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
    todaysAppointments: _appointments().where((appointment) {
      final date = appointment.dateTime;
      final now = DateTime.now();

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).length,
    pendingApprovals: 0,
    appointments: _appointments(),
    totalAppointments: _appointments().length,
    completedAppointments: _appointments()
        .where((e) => e.appointmentStatus == 'COMPLETED')
        .length,
    cancelledAppointments: _appointments()
        .where((e) => e.appointmentStatus == 'CANCELLED')
        .length,
    pendingAppointments: _appointments()
        .where((e) => e.appointmentStatus == 'PENDING')
        .length,
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
}

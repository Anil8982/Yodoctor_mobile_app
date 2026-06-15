export '../models/appointment_history_item.dart';
export '../models/doctor_profile.dart';
export '../models/family_member.dart';
export '../models/patient_appointment.dart';
export '../models/patient_dashboard_data.dart';
export '../models/patient_token.dart';
export '../models/patient_user.dart';
export '../models/doctor_dashboard_data.dart';
export '../models/medical_certificate.dart';

import '../models/appointment_history_item.dart';
import '../models/doctor_profile.dart';
import '../models/family_member.dart';
import '../models/patient_appointment.dart';
import '../models/patient_dashboard_data.dart';
import '../models/patient_token.dart';
import '../models/patient_user.dart';
import '../models/doctor_dashboard_data.dart';
import '../models/medical_certificate.dart';

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

  static final List<AppointmentHistoryItem> appointmentHistory = <AppointmentHistoryItem>[
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

  static final List<MedicalCertificate> dummyCertificates = <MedicalCertificate>[
    MedicalCertificate(
      id: 'MC-2026-465850',
      type: 'Medical Fitness',
      patientName: 'Ashok',
      dateOfBirth: '1998-05-20',
      gender: 'Male',
      bloodGroup: 'O+',
      heightCm: 172.0,
      weightKg: 70.0,
      medicalConditions: 'No known conditions',
      medications: 'None',
      doctor: allDoctors[0],
      purpose: 'Employment',
      additionalNotes: 'Required for corporate joining.',
      status: 'APPROVED',
      requestDate: DateTime(2026, 5, 14),
      issuedDate: DateTime(2026, 5, 14),
      documents: const <String>['medical_slip.jpg'],
    ),
    MedicalCertificate(
      id: 'MC-2026-955053',
      type: 'Medical Fitness',
      patientName: 'Ajay',
      dateOfBirth: '2004-02-12',
      gender: 'Male',
      bloodGroup: 'A+',
      heightCm: 167.0,
      weightKg: 67.0,
      medicalConditions: 'No known conditions',
      medications: 'None',
      doctor: allDoctors[0],
      purpose: 'Travel',
      additionalNotes: 'No notes provided.',
      status: 'APPROVED',
      requestDate: DateTime(2026, 5, 11),
      issuedDate: DateTime(2026, 5, 11),
      documents: const <String>['uploads1.png', 'uploads2.png'],
    ),
    MedicalCertificate(
      id: 'MC-2026-626682',
      type: 'Medical Fitness',
      patientName: 'Vikash',
      dateOfBirth: '1995-08-15',
      gender: 'Male',
      bloodGroup: 'AB+',
      heightCm: 180.0,
      weightKg: 82.0,
      medicalConditions: 'None',
      medications: 'None',
      doctor: allDoctors[0],
      purpose: 'Fitness Clearance',
      additionalNotes: 'General checkup.',
      status: 'APPROVED',
      requestDate: DateTime(2026, 5, 11),
      issuedDate: DateTime(2026, 5, 11),
      documents: const <String>['fitness_report.pdf'],
    ),
    MedicalCertificate(
      id: 'MC-2026-477207',
      type: 'Medical Fitness',
      patientName: 'Ankush',
      dateOfBirth: '2001-11-30',
      gender: 'Male',
      bloodGroup: 'B-',
      heightCm: 169.0,
      weightKg: 63.0,
      medicalConditions: 'None',
      medications: 'None',
      doctor: allDoctors[0],
      purpose: 'Sports Event',
      additionalNotes: 'Required for marathon entry.',
      status: 'APPROVED',
      requestDate: DateTime(2026, 5, 11),
      issuedDate: DateTime(2026, 5, 11),
      documents: const <String>['id_proof.jpg'],
    ),
    MedicalCertificate(
      id: 'MC-2026-894870',
      type: 'Medical Fitness',
      patientName: 'Samay',
      dateOfBirth: '1992-04-25',
      gender: 'Male',
      bloodGroup: 'A-',
      heightCm: 175.0,
      weightKg: 74.0,
      medicalConditions: 'Mild Hypertension',
      medications: 'Amlodipine 5mg',
      doctor: allDoctors[0],
      purpose: 'Insurance',
      additionalNotes: 'Policy verification.',
      status: 'APPROVED',
      requestDate: DateTime(2026, 4, 30),
      issuedDate: DateTime(2026, 4, 30),
      documents: const <String>['health_check.jpg'],
    ),
    MedicalCertificate(
      id: '11',
      type: 'Medical Fitness',
      patientName: 'Annu',
      dateOfBirth: '2000-01-01',
      gender: 'Female',
      bloodGroup: 'O-',
      heightCm: 160.0,
      weightKg: 54.0,
      medicalConditions: 'None',
      medications: 'None',
      doctor: allDoctors[0],
      purpose: 'College Admission',
      additionalNotes: 'Need fitness sign.',
      status: 'VERIFICATION',
      requestDate: DateTime(2026, 5, 13),
      documents: const <String>['college_form.pdf'],
    ),
    MedicalCertificate(
      id: '18',
      type: 'Vaccination',
      patientName: 'Ankush',
      dateOfBirth: '2001-11-30',
      gender: 'Male',
      bloodGroup: 'B-',
      heightCm: 169.0,
      weightKg: 63.0,
      medicalConditions: 'None',
      medications: 'None',
      doctor: allDoctors[0],
      purpose: 'Visa Requirement',
      additionalNotes: 'Hepatitis status.',
      status: 'PENDING',
      requestDate: DateTime(2026, 5, 13),
      documents: const <String>['vaccine_history.jpg'],
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
      return allAppointments.where((PatientAppointment item) => item.status == 'Today').toList();
    }

    if (normalized == 'next 7 days') {
      return allAppointments.where((PatientAppointment item) => item.status == 'Upcoming').toList();
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
    _doctorDashboardData = _doctorDashboardData.copyWith(isAvailable: available);
  }
}

export '../models/appointment_history_item.dart';
export '../models/patient/doctor_profile.dart';
export '../models/patient/family_member.dart';
export '../models/patient/patient_appointment.dart';
export '../models/patient/patient_dashboard_data.dart';
export '../models/patient/patient_token.dart';
export '../models/patient/patient_user.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/doctor/review_item.dart';
import 'package:yodoctor/core/models/notification_item.dart';

import '../models/doctor/doctor_dashboard_profile.dart';
import '../models/doctor/doctor_dashboard_data.dart';
import '../models/medical_certificate.dart';

import '../models/appointment_history_item.dart';
import '../models/patient/doctor_profile.dart';
import '../models/patient/family_member.dart';
import '../models/patient/patient_appointment.dart';
import '../models/patient/patient_dashboard_data.dart';
import '../models/patient/patient_token.dart';
import '../models/patient/patient_user.dart';

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
      id: 'HIS-2026-T1',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Aditya Patil (24M)',
      date: DateTime.now(),
      shift: 'Morning Shift',
      status: 'COMPLETED',
      tokenNumber: '01',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T2',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Sakshi Deshmukh (22F)',
      date: DateTime.now(),
      shift: 'Morning Shift',
      status: 'IN PROGRESS',
      tokenNumber: '02',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T3',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Anil Kushwaha (Self)',
      date: DateTime.now(),
      shift: 'Morning Shift',
      status: 'WAITING',
      tokenNumber: '03',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T4',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Sagar Jadhav (30M)',
      date: DateTime.now(),
      shift: 'Morning Shift',
      status: 'WAITING',
      tokenNumber: '04',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T5',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Rohan Shinde (27M)',
      date: DateTime.now(),
      shift: 'Morning Shift',
      status: 'SKIPPED',
      tokenNumber: '05',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T6',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Kiran Pawar (35F)',
      date: DateTime.now(),
      shift: 'Morning Shift',
      status: 'WAITING',
      tokenNumber: '06',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T7',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Vijay Kale (42M)',
      date: DateTime.now(),
      shift: 'Evening Shift',
      status: 'WAITING',
      tokenNumber: '07',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T8',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Sneha Kulkarni (29F)',
      date: DateTime.now(),
      shift: 'Evening Shift',
      status: 'CANCELLED',
      tokenNumber: '08',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T9',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Amol Joshi (50M)',
      date: DateTime.now(),
      shift: 'Evening Shift',
      status: 'WAITING',
      tokenNumber: '09',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2026-T10',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Pooja Rathi (31F)',
      date: DateTime.now(),
      shift: 'Evening Shift',
      status: 'WAITING',
      tokenNumber: '10',
    ),

    AppointmentHistoryItem(
      id: 'HIS-1',
      doctorName: 'Dr. Praveen Singh',
      specialty: 'Dermatologist',
      patientLabel: 'Ajay (Family)',
      date: DateTime(2026, 6, 15),
      shift: 'EVENING',
      tokenNumber: '#4',
      status: 'COMPLETED',
    ),
    AppointmentHistoryItem(
      id: 'HIS-2',
      doctorName: 'Dr. Praveen Singh',
      specialty: 'Dermatologist',
      patientLabel: 'Vineet Kushwaha (Self)',
      date: DateTime(2026, 6, 12),
      shift: 'EVENING',
      tokenNumber: '#3',
      status: 'COMPLETED',
    ),
    AppointmentHistoryItem(
      id: 'HIS-3',
      doctorName: 'Dr. Praveen Singh',
      specialty: 'Dermatologist',
      patientLabel: 'Ajay (Family)',
      date: DateTime(2026, 6, 10),
      shift: 'EVENING',
      tokenNumber: '#3',
      status: 'COMPLETED',
    ),
    AppointmentHistoryItem(
      id: 'HIS-4',
      doctorName: 'Dr. Praveen Singh',
      specialty: 'Dermatologist',
      patientLabel: 'Ajay (Family)',
      date: DateTime(2026, 5, 28),
      shift: 'EVENING',
      tokenNumber: '#2',
      status: 'COMPLETED',
    ),
    AppointmentHistoryItem(
      id: 'HIS-5',
      doctorName: 'Dr. Praveen Singh',
      specialty: 'Dermatologist',
      patientLabel: 'Vineet Kushwaha (Self)',
      date: DateTime(2026, 5, 25),
      shift: 'EVENING',
      tokenNumber: '#1',
      status: 'COMPLETED',
    ),
    AppointmentHistoryItem(
      id: 'HIS-6',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Deepak Chaudhari (38M)',
      date: DateTime(2026, 5, 20),
      shift: 'MORNING',
      tokenNumber: '#7',
      status: 'CANCELLED',
    ),
    AppointmentHistoryItem(
      id: 'HIS-7',
      doctorName: 'Dr. Rahul Verma',
      specialty: 'Orthopedic',
      patientLabel: 'Nisha Sethi (45F)',
      date: DateTime(2026, 5, 18),
      shift: 'EVENING',
      tokenNumber: '#11',
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

  static const DoctorDashboardProfile currentDoctorProfile = DoctorDashboardProfile(
    id: 'DOC-VERMA',
    fullName: 'Dr. Rahul Verma',
    email: 'rahul.verma@yodoctor.com',
    mobile: '9876543210',
    gender: 'Male',
    aboutYou: 'My goal is to provide honest advice, accurate diagnosis, and the best possible treatment. Feel free to consult me for any orthopedic and bone-related health issues.',
    profilePictureUrl: 'assets/images/doctorLogo.jpg',
    primaryQualification: 'MS - Orthopedics',
    specialization: 'Orthopedic',
    experienceYears: 6,
    registrationNumber: 'MCI-78234',
    stateCouncil: 'Madhya Pradesh Medical Council',
    registrationValidTill: '12-12-2032',
    clinicName: 'Yo Hospital',
    city: 'Bhopal',
    state: 'Madhya Pradesh',
    pincode: '462001',
    landmark: 'Near Shahpura Lake',
    googleMapsLink: 'https://maps.google.com/?q=23.2599,77.4126',
    fullAddress: 'Plot No. 42, Yo Hospital, Shahpura, Bhopal, MP',
    practiceType: 'Hospital Attached',
    affiliatedHospitalName: 'Yo Hospital General',
    consultationFee: 400,
    avgDurationMinutes: 20,
    availableDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    shiftTimings: {
      'Mon': {'morning': '09:00 AM - 01:00 PM', 'evening': '05:00 PM - 09:00 PM'},
      'Tue': {'morning': '09:00 AM - 01:00 PM', 'evening': '05:00 PM - 09:00 PM'},
      'Wed': {'morning': '09:00 AM - 01:00 PM', 'evening': '05:00 PM - 09:00 PM'},
      'Thu': {'morning': '09:00 AM - 01:00 PM', 'evening': '05:00 PM - 09:00 PM'},
      'Fri': {'morning': '09:00 AM - 01:00 PM', 'evening': '05:00 PM - 09:00 PM'},
      'Sat': {'morning': '09:00 AM - 01:00 PM', 'evening': '04:00 PM - 07:00 PM'},
    },
    documents: [
      {'type': 'Profile Picture', 'status': 'Uploaded', 'fileName': 'profile_pic.jpg'},
      {'type': 'Medical Registration Certificate', 'status': 'Uploaded', 'fileName': 'mci_cert.pdf'},
      {'type': 'Government ID Proof', 'status': 'Uploaded', 'fileName': 'aadhar.jpg'},
    ],
  );



  static final List<NotificationItem> dummyNotifications = <NotificationItem>[
    NotificationItem(
      id: 'NOTIF-1',
      title: 'New Booking Request',
      description: 'Aditya Patil has booked an appointment for Morning Shift.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      icon: Icons.calendar_today_rounded,
      iconColor: Colors.blue,
    ),
    NotificationItem(
      id: 'NOTIF-2',
      title: 'Emergency Token Alert',
      description: 'Token #04 (Sagar Jadhav) requires immediate priority attention.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      icon: Icons.emergency_rounded,
      iconColor: Colors.red,
    ),
    NotificationItem(
      id: 'NOTIF-3',
      title: 'Certificate Request',
      description: 'Sakshi Deshmukh submitted a medical fitness certificate request.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      icon: Icons.assignment_ind_rounded,
      iconColor: Colors.purple,
    ),
    NotificationItem(
      id: 'NOTIF-4',
      title: 'Subscription Renewed',
      description: 'Your YoDoctor premium plan has been successfully renewed.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.verified_user_rounded,
      iconColor: Colors.green,
      isRead: true,
    ),
    NotificationItem(
      id: 'NOTIF-5',
      title: 'System Update',
      description: 'Version 1.0.4 is now live with enhanced offline capabilities.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      icon: Icons.system_update_rounded,
      iconColor: Colors.orange,
      isRead: true,
    ),
  ];


  static final List<ReviewItem> dummyReviews = <ReviewItem>[
    ReviewItem(
      id: 'REV-1',
      patientName: 'Aditya Patil',
      rating: 5.0,
      comment: 'Excellent doctor! Dr. Verma explained the orthopedic diagnosis very clearly and the treatment plan worked perfectly.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReviewItem(
      id: 'REV-2',
      patientName: 'Sakshi Deshmukh',
      rating: 4.5,
      comment: 'Very professional environment. The live token system helped reduce the waiting time drastically.',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ReviewItem(
      id: 'REV-3',
      patientName: 'Sagar Jadhav',
      rating: 4.0,
      comment: 'Good experience, highly recommended for joint pain issues.',
      date: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  static DoctorDashboardData _doctorDashboardData = DoctorDashboardData(
    doctor: currentDoctorProfile,
    pendingRequests: 3,
    todayQueueCount: 14,
    completedTodayCount: 8,
    isAvailable: true,
  );


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

  static Future<DoctorDashboardData> getDoctorDashboardData() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _doctorDashboardData;
  }

  static Future<void> toggleDoctorAvailability(bool available) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _doctorDashboardData = _doctorDashboardData.copyWith(isAvailable: available);
  }
}
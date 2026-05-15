class PatientUser {
  const PatientUser({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.age,
    required this.bloodGroup,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.gender,
  });

  final String id;
  final String name;
  final String email;
  final String location;
  final int age;
  final String bloodGroup;
  final String mobileNumber;
  final String dateOfBirth;
  final String gender;
}

class PatientToken {
  const PatientToken({
    required this.tokenNumber,
    required this.patientsAhead,
    required this.estimatedTime,
    required this.clinicName,
    required this.nowServing,
  });

  final String tokenNumber;
  final int patientsAhead;
  final String estimatedTime;
  final String clinicName;
  final String nowServing;
}

class PatientAppointment {
  const PatientAppointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.dateTime,
    required this.status,
    required this.isOnline,
    required this.patientName,
    required this.appointmentStatus, // Accepted, Pending
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String hospital;
  final DateTime dateTime;
  final String status; // Today, Upcoming, Completed
  final bool isOnline;
  final String patientName;
  final String appointmentStatus;
}

class AppointmentHistoryItem {
  const AppointmentHistoryItem({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.patientLabel,
    required this.date,
    required this.shift,
    required this.tokenNumber,
    required this.status,
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String patientLabel;
  final DateTime date;
  final String shift;
  final String tokenNumber;
  final String status;
}

class DoctorProfile {
  const DoctorProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.consultationFee,
    required this.distanceKm,
    required this.availableSlot,
    required this.languages,
    required this.location,
  });

  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int consultationFee;
  final double distanceKm;
  final String availableSlot;
  final List<String> languages;
  final String location;
}

class PatientDashboardData {
  const PatientDashboardData({
    required this.user,
    required this.upcomingVisitsCount,
    required this.todayToken,
    required this.appointments,
  });

  final PatientUser user;
  final int upcomingVisitsCount;
  final PatientToken todayToken;
  final List<PatientAppointment> appointments;
}

class FamilyMember {
  const FamilyMember({
    required this.name,
    required this.lastVisit,
    required this.relation,
    required this.gender,
    required this.bloodGroup,
    required this.initials,
    required this.dateOfBirth,
    required this.heightCm,
    required this.weightKg,
  });

  final String name;
  final String lastVisit;
  final String relation;
  final String gender;
  final String bloodGroup;
  final String initials;
  final DateTime dateOfBirth;
  final double heightCm;
  final double weightKg;

  String get age {
    final DateTime now = DateTime.now();
    int years = now.year - dateOfBirth.year;

    final bool hasBirthdayPassed =
        now.month > dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day >= dateOfBirth.day);

    if (!hasBirthdayPassed) {
      years -= 1;
    }

    return '$years yrs';
  }
}

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
      return allAppointments.where((item) => item.status == 'Today').toList();
    }

    if (normalized == 'next 7 days') {
      return allAppointments.where((item) => item.status == 'Upcoming').toList();
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
}

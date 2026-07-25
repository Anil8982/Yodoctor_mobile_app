class AppRoutes {
  const AppRoutes._();

  // Root & Splash
  static const String root = '/';
  static const String landing = root;
  static const String splash = '/splash';

  // Auth
  static const String patientLogin = '/auth/patient/login';
  static const String patientRegister = '/auth/patient/register';
  static const String doctorLogin = '/auth/doctor/login';
  static const String doctorRegister = '/auth/doctor/register';
  static const String waitingApproval = '/auth/waiting-approval';

  // Notifications (Shared)
  static const String notifications = '/notifications';

  // Patient
  static const String dashboard = '/patient/dashboard';
  static const String search = '/patient/search';
  static const String findDoctors = '/patient/doctors';
  static const String doctorDetail = '/patient/doctors/detail';
  static const String profile = '/patient/profile';
  static const String bookAppointment = '/patient/appointments/book';
  static const String history = '/patient/history';
  static const String family = '/patient/family';
  static const String addFamilyMember = '/patient/family/add-member';
  static const String services = '/patient/services';

  // Patient - Certificates
  static const String certificateWallet = '/patient/certificate';
  static const String applyCertificate = '/patient/certificate/apply';
  static const String patientCertificateDetail = '/patient/certificate/detail';

  // Patient - Lab Tests
  static const String labTest = '/patient/lab-test';
  static const String labTestDetails = '/patient/lab-test/lab-test-details';
  static const String labCart = '/patient/lab-test/lab-cart';
  static const String allLabTests = '/patient/lab-test/all-lab-tests';
  static const String labSlotBooking = '/patient/lab-test/lab-cart/lab-slot-booking';

  // Patient - Home Care
  static const String homeServiceBooking = '/patient/home-service-booking';

  // Doctor
  static const String doctorDashboard = '/doctor/dashboard';
  static const String doctorAppointments = '/doctor/appointments';
  static const String doctorLiveQueue = '/doctor/live-queue';
  static const String doctorManualBooking = '/doctor/manual-booking';
  static const String doctorAddPrescription = '/doctor/add-prescription/:id';
  static const String doctorProfile = '/doctor/profile';
  static const String doctorProfileEdit = '/doctor/profile/edit';
  static const String doctorSubscription = '/doctor/subscription';
  static const String doctorSubscriptionVerification = '/doctor/subscription/verify';
  static const String doctorQr = '/doctor/qr';
  static const String doctorReviews = '/doctor/reviews';
  static const String doctorNotifications = '/doctor/notifications';

  // Doctor - Certificates
  static const String doctorCertificates = '/doctor/certificates';
  static const String doctorCertificateReview = '/doctor/certificates/review';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String doctorsManagement = '/admin/doctors-management';
  static const String enquiry = '/admin/enquiry';
  static const String homeCareBooking = '/admin/homecare-bookings';
}
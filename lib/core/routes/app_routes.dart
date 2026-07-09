class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String landing = root;

  static const String patientLogin = '/auth/patient/login';
  static const String patientRegister = '/auth/patient/register';
  static const String doctorLogin = '/auth/doctor/login';
  static const String doctorRegister = '/auth/doctor/register';

  static const String waitingApproval = '/auth/waiting-approval';

  static const String search = '/search';
  static const String findDoctors = '/doctors';
  static const String doctorDetail = '/doctors/detail';
  static const String profile = '/profile';
  static const String addFamilyMember = '/family/add-member';
  static const String bookAppointment = '/appointments/book';
  static const String applyCertificate = '/certificate/apply';

  static const String dashboard = '/dashboard';
  static const String certificateWallet = '/certificate';
  static const String patientCertificateDetail = '/certificate/detail';
  static const String family = '/family';
  static const String history = '/history';
  static const String services = '/services';
  static const String labTest = '/lab-test';
  static const String labTestDetails = '/lab-test/lab-test-details';
  static const String labCart = '/lab-test/lab-cart';
  static const String allLabTests = '/lab-test/all-lab-tests';
  static const String labSlotBooking = '/lab-test/lab-cart/lab-slot-booking';

  static const String notifications = '/notifications';


  static const String homeServiceBooking = '/home-service-booking';

  static const String doctorDashboard = '/doctor/dashboard';
  static const String doctorAppointments = '/doctor/appointments';
  static const String doctorLiveQueue = '/doctor/live-queue';
  static const String doctorManualBooking = '/doctor/manual-booking';
  static const String doctorCertificates = '/doctor/certificates';
  static const String doctorCertificateReview = '/doctor/certificates/review';
  static const String doctorProfile = '/doctor/profile';
  static const String doctorProfileEdit = '/doctor/profile/edit';
  static const String doctorSubscription = '/doctor/subscription';
  static const String doctorAddPrescription = '/doctor/add-prescription/:id';
  static const String doctorNotifications = '/doctor/notifications';
  static const String doctorReviews = '/doctor/reviews';
  static const String doctorQr = '/doctor/qr';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String doctorsManagement = '/doctorsmanagement';
  static const String enquiry = '/enquiry';
  static const String homeCareBooking = '/homecarebookings';
}

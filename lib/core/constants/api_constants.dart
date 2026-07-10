import '../config/env_config.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => EnvConfig.baseUrl;

  static const forgotPassword = '/auth/forgot-password';
  static const verifyReset = '/auth/verify-reset';
  static const resetPassword = '/auth/reset-password';

  // --- Patient Authentication & Registration ---
  static const login = '/auth/login';
  static const patientRegister = '/patient/register';

  // --- Doctor Authentication & Registration ---
  static const String doctorLogin = '/auth/login';
  static const String doctorRegisterStep1 = '/doctor/register';
  static const String doctorRegisterUpdateStep1 = '/doctor/registration/step-1';
  static const String doctorRegisterStep2 = '/doctor/registration/step-2';
  static const String doctorRegisterStep3 = '/doctor/registration/step-3';
  static const String doctorRegisterStep4 = '/doctor/registration/step-4';
  static const String doctorRegisterStep5 = '/doctor/registration/step-5';
  static const String doctorRegisterStep6 = '/doctor/registration/step-6';
  static const String doctorRegisterSubmit = '/doctor/registration/submit';


  //---patient---
  static const String bookAppointment = '/patient/visit/appointments';

  static const createCertificate = '/certificate/create';
  static const uploadCertificateDocuments = '/certificate/upload';
  static const myCertificates = '/certificate/my-requests';
  static const certificateDetail = '/certificate'; // Base for /$id
  static const downloadCertificate = '/certificate/download'; // Base for /$id
  static const allDoctors = '/doctor/alldoctors';

  static const patientDashboard = '/patient/dashboard';
  static const cancelAppointment = '/patient/visit/appointments'; // Base for /$id/cancel
  static const tokenStatus = '/patient/visit/token-status';       // Base for /$id

  static const searchDoctors = '/patient/visit/doctors';
  static const doctorNames = '/patient/doctorname';
  static const cities = '/patient/cities';
  static const diseases = '/patient/diseases';
  static const clinicNames = '/patient/clinicname';
  static const doctorById = '/patient/visit/doctors'; // Base for /$doctorId

  static const getFamily = '/patient/getfamily';
  static const addFamily = '/patient/addfamily';
  static const updateFamily = '/patient/updatefamily'; // Base for /$id
  static const deleteFamily = '/patient/deletefamily'; // Base for /$id

  static const appointmentHistory = '/patient/visit/appointments/history';
  static const submitDoctorReview = '/patient/doctor-feedback';
  static const getPrescription = '/patient/appointments'; // Base for /$id/prescription

  static const getProfile = '/patient/getprofile';
  static const updateProfile = '/patient/updateProfile';

  static const bookHomeCare = '/patient/bookhomecare';
  static const getHomeCareBookings = '/patient/getbookhomecare';

  static const labCategories = '/lab/categories';
  static const labTests = '/patient/lab/tests';
  static const popularLabTests = '/patient/lab/tests/popular';
  static const labPackages = '/patient/lab/packages';
  static const labBookings = '/patient/lab-bookings'; // Base for /$id if needed


  // ---Doctor---

  static const getDoctorByIdForPatient = '/doctor/getDoctorById';


  // appointment
  static const doctorHistory = '/doctor/appointments/history';
  static const todayQueue = '/doctor/appointments/today-queue';
  static const currentToken = '/doctor/appointments/current-token';
  static const nextPatient = '/doctor/appointments/next';
  static const startAppointment = '/doctor/appointments'; // /$id/start
  static const skipAppointment = '/doctor/appointments'; // /$id/skip
  static const nextToken = '/doctor/appointments/next-token';
  static const addPrescription = '/doctor/appointments'; // /$id/prescription
  static const getPrescriptionDoctor = '/doctor/prescription'; // /$id
  static const completeAppointment = '/doctor/appointments'; // /$id/summary
  static const noShow = '/doctor/appointments/noShow';
  static const recallPatient = '/doctor/appointments/recall'; // /$id
  static const incomingAppointments = '/doctor/appointments/incoming';
  static const respondAppointment = '/doctor/respond-appointment'; // /$id
  static const autoAccept = '/doctor/appointments/auto-accept';

  static const addVisitSummary = '/doctor/appointments';

  static const carryForwardAppointments = '/doctor/appointments/carry-forward';
  static const cancelRemainingAppointments = '/doctor/appointments/cancel-remaining';

  static const certificateRequests = '/certificate/requests';
  static const issuedCertificates = '/certificate/issued';
  static const approveCertificate = '/certificate/approve'; // /$id
  static const rejectCertificate = '/certificate/reject';   // /$id
  static const certificateDocuments = '/certificate/documents'; // /$id

  static const String doctorDashboard = '/doctor/dashboard';
  static const String doctorAvailability = '/doctor/availability';

  // --- Doctor Profile ---
  static const String getDoctorProfile = '/doctor/profile';
  static const String updateDoctorProfile = '/doctor/profile';

  // --- Doctor QR ---
  static const String getDoctorQr = '/doctor/my-qr';
  static const String downloadDoctorQr = '/download-qr';

  // --- Doctor Reviews ---
  static const String doctorReviews = '/doctor/reviews';

  // --- Doctor Manual Booking ---
  static const String manualBooking = '/doctor/manualbooking';

  // --- Notifications ---
  static const String notifications = '/notifications';
  static const String unreadNotifications = '/notifications/unread-count';
  static const String readAllNotifications = '/notifications/read-all';

  // --- Doctor Subscription & Billing ---
  static const String activeSubscription = '/subscriptions/active';
  static const String billingHistory = '/billing/history';
  static const String subscriptionPlans = '/plans';
  static const String createSubscription = '/subscriptions/create';
  static const String verifySubscription = '/subscriptions/verify';



}
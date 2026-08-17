import '../config/env_config.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => EnvConfig.baseUrl;
  static String get fileBaseUrl => EnvConfig.fileUrl;

  static String fileUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '$fileBaseUrl/$path';
  }

  static const login = '/auth/login';
  static const googleLogin = '/auth/google-login';
  static const forgotPassword = '/auth/forgot-password';
  static const verifyReset = '/auth/verify-reset';
  static const resetPassword = '/auth/reset-password';

  // --- Profile ---
  static const uploadProfileImage = '/auth/upload-profile-image';
  static const updateProfileImage = '/auth/updateprofile-image';
  static const getProfileImage = '/auth/getprofile-image';
  static const deleteProfileImage = '/auth/deleteprofile-image';

  // --- Patient Authentication & Registration ---
  static const patientRegister = '/patient/register';

  // --- Doctor Authentication & Registration ---
  static const doctorRegisterStep1 = '/doctor/register';
  static const doctorRegisterUpdateStep1 = '/doctor/registration/step-1';
  static const doctorRegisterStep2 = '/doctor/registration/step-2';
  static const doctorRegisterStep3 = '/doctor/registration/step-3';
  static const doctorRegisterStep4 = '/doctor/registration/step-4';
  static const doctorRegisterStep5 = '/doctor/registration/step-5';
  static const doctorRegisterStep6 = '/doctor/registration/step-6';
  static const doctorRegisterSubmit = '/doctor/registration/submit';

  static const doctorVerificationStatus = '/doctor/verification-status';

  //---patient---
  static const bookAppointment = '/patient/visit/appointments';

  static const createCertificate = '/certificate/create';
  static const uploadCertificateDocuments = '/certificate/upload';
  static const myCertificates = '/certificate/my-requests';
  static const certificateDetail = '/certificate'; // Base for /$id
  static const downloadCertificate = '/certificate/download'; // Base for /$id
  static const allDoctors = '/doctor/alldoctors';

  static const patientDashboard = '/patient/dashboard';
  static const cancelAppointment =
      '/patient/visit/appointments'; // Base for /$id/cancel
  static const tokenStatus = '/patient/visit/token-status'; // Base for /$id

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
  static const getPrescription =
      '/patient/appointments'; // Base for /$id/prescription

  static const getProfile = '/patient/getprofile';
  static const updateProfile = '/patient/updateProfile';

  // static const bookHomeCare = '/patient/bookhomecare';
  // static const getHomeCareBookings = '/patient/getbookhomecare';
  static const bookHomeCare = '/patient/bookhomecare';

  static const getHomeCareHistory = '/patient/homecarehistory';
  static String getHomeCareBookingDetails(int bookingId) =>
      '/patient/homecarehistory/$bookingId';
  static String cancelHomeCareBooking(int bookingId) =>
      '/patient/homecarehistory/$bookingId/cancel';

  static const labCategories = '/patient/lab/categories';
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
  static const cancelRemainingAppointments =
      '/doctor/appointments/cancel-remaining';

  static const certificateRequests = '/certificate/requests';
  static const issuedCertificates = '/certificate/issued';
  static const approveCertificate = '/certificate/approve'; // /$id
  static const rejectCertificate = '/certificate/reject'; // /$id
  static const certificateDocuments = '/certificate/documents'; // /$id

  static const doctorDashboard = '/doctor/dashboard';
  static const doctorAvailability = '/doctor/availability';

  // --- Doctor Profile ---
  static const getDoctorProfile = '/doctor/profile';
  static const updateDoctorProfile = '/doctor/profile';

  // --- Doctor QR ---
  static const getDoctorQr = '/doctor/my-qr';
  static const downloadDoctorQr = '/doctor/download-qr';

  // --- Doctor Reviews ---
  static const doctorReviews = '/doctor/reviews';

  // --- Doctor Manual Booking ---
  static const manualBooking = '/doctor/manualbooking';

  // --- Notifications ---
  static const getNotifications = '/notifications';
  static const unreadCount = '/notifications/unread-count';
  static const readNotification = '/notifications/'; // :id/read
  static const readAllNotifications = '/notifications/read-all';

  // --- Doctor Subscription & Billing ---
  static const createSubscription = '/razorpay/subscriptions/create';
  static const verifySubscription = '/razorpay/subscriptions/verify';
  static const activeSubscription = '/razorpay/subscriptions/active';
  static const allSubscriptions = '/razorpay/subscriptions';
  static const subscriptionById = '/razorpay/subscriptions'; // + /:id
  static const cancelSubscription = '/razorpay/subscriptions'; // + /:id/cancel
  static const upgradeSubscription =
      '/razorpay/subscriptions'; // + /:id/upgrade
  static const subscriptionPlans = '/razorpay/plans';
  static const planById = '/razorpay/plans'; // + /:planId
  static const billingHistory = '/razorpay/billing/history';
  static const invoiceDetail = '/razorpay/billing/invoice'; // + /:invoiceId
  static const createPaymentOrder = '/razorpay/payments/create-order';
  static const verifyPayment = '/razorpay/payments/verify';

  // --- Lab Payments (Razorpay) ---
  static const createLabPaymentOrder = '/razorpay/lab/payments/create-order';
  static const verifyLabPayment = '/razorpay/lab/payments/verify';
}

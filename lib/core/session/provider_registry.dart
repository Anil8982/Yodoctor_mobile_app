import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_login_controller.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_status_controller.dart';
import 'package:yodoctor/modules/auth/controllers/patient_auth_controller.dart';
import 'package:yodoctor/modules/auth/controllers/patient_register_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/appointment_history_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_review_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_dashboard_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_qr_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_review_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/incoming_appointment_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/live_queue_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/manual_booking_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/subscription_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/subscription_status_controller.dart';
import 'package:yodoctor/modules/patient/controllers/appointment_history_controller.dart';
import 'package:yodoctor/modules/patient/controllers/book_appointment_controller.dart';
import 'package:yodoctor/modules/patient/controllers/booking_controller.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'package:yodoctor/modules/patient/controllers/doctor_detail_controller.dart';
import 'package:yodoctor/modules/patient/controllers/doctor_listing_controller.dart';
import 'package:yodoctor/modules/patient/controllers/family_controller.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';
import 'package:yodoctor/modules/patient/controllers/lab_test_controller.dart';
import 'package:yodoctor/modules/patient/controllers/patient_dashboard_controller.dart';
import 'package:yodoctor/modules/patient/controllers/patient_search_controller.dart';
import 'package:yodoctor/modules/patient/controllers/profile_controller.dart';
import 'package:yodoctor/modules/patient/controllers/qr_scanner_controller.dart';
import 'package:yodoctor/modules/notifications/controllers/notification_controller.dart';
import 'package:yodoctor/modules/payment/providers.dart';

class ProviderRegistry {
  static void invalidateAll(Ref ref) {

    ref.invalidate(appRoleProvider);

    // Auth
    ref.invalidate(doctorLoginControllerProvider); // Doctor Login
    ref.invalidate(doctorRegisterControllerProvider); // Doctor Registration
    ref.invalidate(patientAuthControllerProvider); // Patient Login
    ref.invalidate(patientRegisterControllerProvider); // Patient Registration

    ref.invalidate(profileImageController); // Profile Image

    // Doctor
    ref.invalidate(doctorStatusProvider); // Doctor Status
    ref.invalidate(subscriptionStatusProvider); // Subscription Status
    ref.invalidate(doctorDashboardProvider); // Dashboard
    ref.invalidate(doctorProfileProvider); // Profile
    ref.invalidate(doctorQrProvider); // QR
    ref.invalidate(manualBookingProvider); // Manual Booking
    ref.invalidate(incomingAppointmentProvider); // Incoming Appointments
    ref.invalidate(appointmentHistoryProvider); // Appointment History
    ref.invalidate(doctorCertificateProvider); // Certificates
    ref.invalidate(doctorCertificateReviewProvider); // Certificate Review
    ref.invalidate(doctorSubscriptionProvider); // Subscription
    ref.invalidate(doctorReviewProvider); // Reviews
    ref.invalidate(liveQueueProvider); // Live Queue

    // Patient
    ref.invalidate(patientDashboardControllerProvider); // Dashboard
    ref.invalidate(profileControllerProvider); // Profile
    ref.invalidate(familyControllerProvider); // Family
    ref.invalidate(doctorListingControllerProvider); // Doctor Listing
    ref.invalidate(doctorDetailControllerProvider); // Doctor Details
    ref.invalidate(patientSearchControllerProvider); // Doctor Search
    ref.invalidate(bookAppointmentControllerProvider); // Appointment Booking
    ref.invalidate(homeServiceBookingProvider); // Home Service Booking
    ref.invalidate(labProvider); // Lab Tests
    ref.invalidate(labBookingProvider); // Lab Booking
    ref.invalidate(certificateProvider); // Certificate
    ref.invalidate(qrScannerControllerProvider); // QR Scanner
    ref.invalidate(appointmentHistoryControllerProvider); // Appointment History

    // Notification
    ref.invalidate(notificationProvider);

    // Razorpay
    ref.invalidate(razorpayControllerProvider);
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_login_screen.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_register_screen.dart';
import 'package:yodoctor/modules/auth/screens/doctor/waiting_approval_screen.dart';
import 'package:yodoctor/modules/auth/screens/landing/landing_screen.dart';
import 'package:yodoctor/modules/auth/screens/patient/patient_login_screen.dart';
import 'package:yodoctor/modules/auth/screens/patient/patient_register_screen.dart';
import 'package:yodoctor/modules/patient/patient_pcaffold_shell.dart';

import '../../modules/patient/screens/appointments/book_appointment_screen.dart';
import '../../modules/patient/screens/dashboard/dashboard_screen.dart';
import '../../modules/patient/screens/doctor_detail/doctor_detail_screen.dart';
import '../../modules/patient/screens/family/add_family_member_screen.dart';
import '../../modules/patient/screens/family/family_members_screen.dart';
import '../../modules/patient/screens/find_doctors/find_doctors_screen.dart';
import '../../modules/patient/screens/history/appointments_history_screen.dart';
import '../../modules/patient/screens/profile/profile_screen.dart';
import '../../modules/patient/screens/search/search_screen.dart';
import '../../modules/patient/models/search/doctor_detail_model.dart';
import '../../modules/patient/models/family/family_member_model.dart';
import '../../modules/doctor/screens/dashboard/doctor_dashboard_screen.dart';
import 'package:yodoctor/modules/doctor/doctor_scaffold_shell.dart';
import 'package:yodoctor/modules/doctor/screens/appointments/doctor_appointment_history_screen.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/doctor_certificate_dashboard_screen.dart';
import 'package:yodoctor/modules/doctor/screens/reviews/doctor_reviews_screen.dart';
import 'package:yodoctor/modules/doctor/screens/profile/doctor_profile_screen.dart';
import 'package:yodoctor/modules/doctor/screens/profile/doctor_profile_edit_screen.dart';
import '../../modules/doctor/screens/qr/doctor_qr_screen.dart';
import '../../modules/doctor/screens/notifications/notification_screen.dart';
import '../../modules/doctor/screens/manual_booking/manual_booking_screen.dart';
import '../../modules/doctor/screens/appointments/live_queue_screen.dart';
import '../../modules/doctor/screens/certificate/certificate_review_screen.dart';
import '../../modules/doctor/screens/certificate/doctor_certificate_dashboard_screen.dart';
import '../../modules/patient/screens/certificates/patient_certificate_detail_screen.dart';
import '../../modules/patient/screens/certificates/apply_certificate_screen.dart';
import '../../modules/patient/screens/certificates/certificate_wallet_screen.dart';
import '../../modules/patient/screens/home_care/home_service_booking_screen.dart';
import '../../modules/patient/screens/lab_tests/all_lab_tests_screen.dart';
import '../../modules/patient/screens/lab_tests/lab_cart_screen.dart';
import '../../modules/patient/screens/lab_tests/lab_slot_booking_screen.dart';
import '../../modules/patient/screens/lab_tests/lab_test_details_screen.dart';
import '../../modules/patient/screens/lab_tests/lab_tests_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String landing = root;

  static const String patientLogin = '/auth/patient/login';
  static const String patientRegister = '/auth/patient/register';
  static const String doctorLogin = '/auth/doctor/login';
  static const String doctorRegister = '/auth/doctor/register';
  static const String waitingApproval = "/doctor/waiting-approval";

  static const String search = '/search';
  static const String dashboard = '/dashboard';
  static const String findDoctors = '/doctors';
  static const String doctorDetail = '/doctors/detail';
  static const String profile = '/profile';
  static const String family = '/family';
  static const String addFamilyMember = '/family/add-member';
  static const String bookAppointment = '/appointments/book';
  static const String history = '/history';

  static const String doctorDashboard = "/doctor/dashboard";
  static const String doctorLiveQueue = "/doctor/live-queue";
  static const String doctorManualBooking = "/doctor/manual-booking";

  static const String doctorAppointments = "/doctor/appointments";

  static const String doctorCertificates = "/doctor/certificates";

  static const String doctorReviews = "/doctor/reviews";

  static const String doctorProfile = "/doctor/profile";

  static const String doctorSubscription = "/doctor/subscription";

  static const String doctorProfileEdit = "/doctor/profile/edit";
  static const String certificateReview = "/doctor/certificate-review";
  static const String doctorQr = "/doctor/qr";
  static const String notifications = "/notifications";
  static const String patientCertificateDetail = "/patient-certificate-detail";
  static const String homeServiceBooking = "/home-service-booking";
  static const String applyCertificate = "/apply-certificate";
  static const String certificateWallet = "/certificate-wallet";
  static const String labTest = "/lab-test";

  static const String labTestDetails = "/lab-test-details";

  static const String labCart = "/lab-cart";

  static const String allLabTests = "/all-lab-tests";

  static const String labSlotBooking = "/lab-slot-booking";
}

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.landing,
    routes: <RouteBase>[
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.landing,
        builder: (context, state) => LandingScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.patientLogin,
        builder: (context, state) => PatientLoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.patientRegister,
        builder: (context, state) => PatientRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorQr,
        builder: (context, state) => const DoctorQrScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorLogin,
        builder: (context, state) => DoctorLoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorProfile,
        builder: (context, state) => const DoctorProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorProfileEdit,
        builder: (context, state) => const DoctorProfileEditScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.labTest,
        builder: (context, state) => const LabTestsScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.labTestDetails,
        builder: (context, state) => const LabTestDetailsScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.labCart,
        builder: (context, state) => const LabCartScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.allLabTests,
        builder: (context, state) => const AllLabTestsScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.labSlotBooking,
        builder: (context, state) => const LabSlotBookingScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.applyCertificate,
        builder: (context, state) => const ApplyCertificateScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.certificateWallet,
        builder: (context, state) => const CertificateWalletScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.homeServiceBooking,
        builder: (context, state) => const HomeServiceBookingScreen(),
      ),

      GoRoute(
        path: AppRoutes.doctorRegister,
        builder: (context, state) {
          final step = state.extra is int ? state.extra as int : 1;

          return DoctorRegisterScreen(initialStep: step);
        },
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.findDoctors,
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return FindDoctorsScreen(initialQuery: query);
        },
      ),

      GoRoute(
        path: AppRoutes.patientCertificateDetail,

        builder: (_, __) => const PatientCertificateDetailScreen(),
      ),

      GoRoute(
        path: AppRoutes.doctorSubscription,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text("Subscription"))),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorManualBooking,
        builder: (context, state) => const ManualBookingScreen(),
      ),

      GoRoute(
        path: AppRoutes.doctorLiveQueue,
        builder: (context, state) => const LiveQueueScreen(),
      ),
      GoRoute(
        path: AppRoutes.waitingApproval,
        builder: (context, state) => const WaitingApprovalScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorDetail,
        builder: (context, state) {
          final doctorId = state.extra as int;

          return DoctorDetailScreen(doctorId: doctorId);
        },
      ),
      GoRoute(
        path: "${AppRoutes.certificateReview}/:id",
        builder: (context, state) {
          final id = int.parse(state.pathParameters["id"]!);

          return CertificateReviewScreen(requestId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.addFamilyMember,
        builder: (context, state) {
          final member = state.extra;
          return AddFamilyMemberScreen(
            initialMember: member is FamilyMemberModel ? member : null,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.bookAppointment,
        builder: (context, state) {
          final doctor = state.extra as DoctorDetailModel;

          return BookAppointmentScreen(doctor: doctor);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return PatientScaffoldShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.family,
                builder: (context, state) => const FamilyMembersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const AppointmentsHistoryScreen(),
              ),
            ],
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DoctorScaffoldShell(navigationShell: navigationShell);
        },
        branches: [
          // Index 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorDashboard,
                builder: (context, state) => const DoctorDashboardScreen(),
              ),
            ],
          ),
          // Index 1: Appointment History
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorAppointments,
                builder: (context, state) =>
                    const DoctorAppointmentHistoryScreen(),
              ),
            ],
          ),
          // Index 2: Certificates Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorCertificates,
                builder: (context, state) =>
                    const DoctorCertificateDashboardScreen(),
              ),
            ],
          ),
          // Index 3: Reviews Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorReviews,
                builder: (context, state) => const DoctorReviewsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:yodoctor/core/utils/dummy_data.dart';
// import 'package:yodoctor/modules/auth/screens/doctor/doctor_login_screen.dart';
// import 'package:yodoctor/modules/auth/screens/doctor/doctor_register_screen.dart';
// import 'package:yodoctor/modules/auth/screens/landing/landing_screen.dart';
// import 'package:yodoctor/modules/auth/screens/patient/patient_login_screen.dart';
// import 'package:yodoctor/modules/auth/screens/patient/patient_register_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/appointments/add_prescription_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/appointments/live_queue_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/certificate/certificate_review_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/notifications/notification_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/profile/doctor_profile_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/subscription/my_subscription_screen.dart';
// import 'package:yodoctor/modules/patient/patient_pcaffold_shell.dart';
// import 'package:yodoctor/modules/doctor/doctor_scaffold_shell.dart';
// import 'package:yodoctor/modules/doctor/screens/manual_booking/manual_booking_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/appointments/doctor_appointment_history_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/dashboard/doctor_dashboard_screen.dart';
// import 'package:yodoctor/modules/patient/screens/dashboard/dashboard_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/certificate/doctor_certificate_dashboard_screen.dart';
// import 'package:yodoctor/modules/doctor/screens/profile/doctor_profile_edit_screen.dart'; // 👈 १. नवीन प्रोफाईल स्क्रीन इम्पोर्ट केली भाऊ
//
// import '../../modules/patient/screens/appointments/book_appointment_screen.dart';
// import '../../modules/patient/screens/doctor_detail/doctor_detail_screen.dart';
// import '../../modules/patient/screens/family/add_family_member_screen.dart';
// import '../../modules/patient/screens/family/family_members_screen.dart';
// import '../../modules/patient/screens/find_doctors/find_doctors_screen.dart';
// import '../../modules/patient/screens/history/appointments_history_screen.dart';
// import '../../modules/patient/screens/profile/profile_screen.dart';
// import '../../modules/patient/screens/search/search_screen.dart';
// import '../../modules/patient/screens/certificates/apply_certificate_screen.dart';
// import '../../modules/patient/screens/certificates/certificate_wallet_screen.dart';
//
// class AppRoutes {
//   const AppRoutes._();
//
//   static const String root = '/';
//   static const String landing = root;
//
//   static const String patientLogin = '/auth/patient/login';
//   static const String patientRegister = '/auth/patient/register';
//   static const String doctorLogin = '/auth/doctor/login';
//   static const String doctorRegister = '/auth/doctor/register';
//
//   static const String search = '/search';
//   static const String findDoctors = '/doctors';
//   static const String doctorDetail = '/doctors/detail';
//   static const String profile = '/profile';
//   static const String addFamilyMember = '/family/add-member';
//   static const String bookAppointment = '/appointments/book';
//   static const String applyCertificate = '/certificate/apply';
//
//   // Patient Shell Sub-routes
//   static const String dashboard = '/dashboard';
//   static const String certificateWallet = '/certificate';
//   static const String family = '/family';
//   static const String history = '/history';
//
//   // Doctor Shell Sub-routes
//   static const String doctorDashboard = '/doctor/dashboard';
//   static const String doctorAppointments = '/doctor/appointments';
//   static const String doctorLiveQueue = '/doctor/live-queue';
//   static const String doctorManualBooking = '/doctor/manual-booking';
//   static const String doctorCertificates = '/doctor/certificates';
//   static const String doctorCertificateReview = '/doctor/certificates/review';
//   static const String doctorProfile = '/doctor/profile';
//   static const String doctorProfileEdit = '/doctor/profile/edit';
//   static const String doctorSubscription = '/doctor/subscription';
//   static const String doctorAddPrescription = '/doctor/add-prescription/:id';
//   static const String doctorNotifications = '/doctor/notifications';
//   static const String doctorReviews = '/doctor/reviews';
//
// }
//
// class AppRouter {
//   const AppRouter._();
//
//   static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
//
//   static final GoRouter router = GoRouter(
//     navigatorKey: _rootNavigatorKey,
//     initialLocation: AppRoutes.landing,
//     routes: <RouteBase>[
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.landing,
//         builder: (context, state) => LandingScreen(),
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.patientLogin,
//         builder: (context, state) => PatientLoginScreen(),
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.patientRegister,
//         builder: (context, state) => PatientRegisterScreen(),
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorLogin,
//         builder: (context, state) => DoctorLoginScreen(),
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorRegister,
//         builder: (context, state) => DoctorRegisterScreen(),
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.search,
//         builder: (context, state) => const SearchScreen(),
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.findDoctors,
//         builder: (context, state) {
//           final query = state.uri.queryParameters['q'] ?? '';
//           return FindDoctorsScreen(initialQuery: query);
//         },
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorDetail,
//         builder: (context, state) {
//           final doctor = state.extra;
//           final DoctorProfile fallbackDoctor = DummyData.allDoctors.first;
//           return DoctorDetailScreen(
//             doctor: doctor is DoctorProfile ? doctor : fallbackDoctor,
//           );
//         },
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.profile,
//         builder: (context, state) => const ProfileScreen(),
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.addFamilyMember,
//         builder: (context, state) {
//           final member = state.extra;
//           return AddFamilyMemberScreen(
//             initialMember: member is FamilyMember ? member : null,
//           );
//         },
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.bookAppointment,
//         builder: (context, state) {
//           final doctor = state.extra;
//           final DoctorProfile fallbackDoctor = DummyData.allDoctors.first;
//           return BookAppointmentScreen(
//             doctor: doctor is DoctorProfile ? doctor : fallbackDoctor,
//           );
//         },
//       ),
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.applyCertificate,
//         builder: (context, state) => const ApplyCertificateScreen(),
//       ),
//
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorCertificateReview,
//         builder: (context, state) => const CertificateReviewScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.doctorManualBooking,
//         builder: (context, state) => const ManualBookingScreen(),
//       ),
//
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorProfile,
//         builder: (context, state) => const DoctorProfileScreen(),
//       ),
//
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorLiveQueue,
//         builder: (context, state) => const LiveQueueScreen(),
//       ),
//
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorProfileEdit,
//         builder: (context, state) => const DoctorProfileEditScreen(),
//       ),
//
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorSubscription,
//         builder: (context, state) => const MySubscriptionScreen(),
//       ),
//
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorAddPrescription,
//         builder: (context, state) {
//           final patientName = state.uri.queryParameters['name'] ?? 'Patient';
//
//           var token = state.uri.queryParameters['token'] ?? '';
//           if (token.isEmpty && state.uri.fragment.isNotEmpty) {
//             token = state.uri.fragment;
//           }
//           if (token.isEmpty) {
//             token = '-';
//           }
//
//           return AddPrescriptionScreen(
//             appointmentId: state.pathParameters['id']!,
//             patientName: patientName,
//             tokenNumber: token,
//           );
//         },
//       ),
//
//
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorAddPrescription,
//         builder: (context, state) {
//           final patientName = state.uri.queryParameters['name'] ?? 'Patient';
//           final token = state.uri.queryParameters['token'] ?? '-';
//           return AddPrescriptionScreen(
//             appointmentId: state.pathParameters['id']!,
//             patientName: patientName,
//             tokenNumber: token,
//           );
//         },
//       ),
//
//       GoRoute(
//         parentNavigatorKey: _rootNavigatorKey,
//         path: AppRoutes.doctorNotifications,
//         builder: (context, state) => const NotificationScreen(),
//       ),
//
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) {
//           return PatientScaffoldShell(navigationShell: navigationShell);
//         },
//         branches: [
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.dashboard,
//                 builder: (context, state) => DashboardScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.certificateWallet,
//                 builder: (context, state) => const CertificateWalletScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.family,
//                 builder: (context, state) => const FamilyMembersScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.history,
//                 builder: (context, state) => const AppointmentsHistoryScreen(),
//               ),
//             ],
//           ),
//         ],
//       ),
//
//       // 2. Doctor Side Shell (Bottom Nav Controller)
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) {
//           return DoctorScaffoldShell(navigationShell: navigationShell);
//         },
//         branches: [
//           // Index 0: Dashboard
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.doctorDashboard,
//                 builder: (context, state) => const DoctorDashboardScreen(),
//               ),
//             ],
//           ),
//           // Index 1: Appointment History
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.doctorAppointments,
//                 builder: (context, state) => const DoctorAppointmentHistoryScreen(),
//               ),
//             ],
//           ),
//           // Index 2: Placeholder for QR Modal action in Tab view
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.doctorManualBooking,
//                 builder: (context, state) => const ManualBookingScreen(),
//               ),
//             ],
//           ),
//           // Index 3: Certificates Dashboard
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.doctorCertificates,
//                 builder: (context, state) => const DoctorCertificateDashboardScreen(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   );
// }




import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_login_screen.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_register_screen.dart';
import 'package:yodoctor/modules/auth/screens/landing/landing_screen.dart';
import 'package:yodoctor/modules/auth/screens/patient/patient_login_screen.dart';
import 'package:yodoctor/modules/auth/screens/patient/patient_register_screen.dart';
import 'package:yodoctor/modules/doctor/screens/appointments/add_prescription_screen.dart';
import 'package:yodoctor/modules/doctor/screens/appointments/live_queue_screen.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/certificate_review_screen.dart';
import 'package:yodoctor/modules/doctor/screens/notifications/notification_screen.dart';
import 'package:yodoctor/modules/doctor/screens/profile/doctor_profile_screen.dart';
import 'package:yodoctor/modules/doctor/screens/subscription/my_subscription_screen.dart';
import 'package:yodoctor/modules/patient/patient_pcaffold_shell.dart';
import 'package:yodoctor/modules/doctor/doctor_scaffold_shell.dart';
import 'package:yodoctor/modules/doctor/screens/manual_booking/manual_booking_screen.dart';
import 'package:yodoctor/modules/doctor/screens/appointments/doctor_appointment_history_screen.dart';
import 'package:yodoctor/modules/doctor/screens/dashboard/doctor_dashboard_screen.dart';
import 'package:yodoctor/modules/patient/screens/dashboard/dashboard_screen.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/doctor_certificate_dashboard_screen.dart';
import 'package:yodoctor/modules/doctor/screens/profile/doctor_profile_edit_screen.dart';
import 'package:yodoctor/modules/doctor/screens/reviews/doctor_reviews_screen.dart';

import '../../modules/patient/screens/appointments/book_appointment_screen.dart';
import '../../modules/patient/screens/doctor_detail/doctor_detail_screen.dart';
import '../../modules/patient/screens/family/add_family_member_screen.dart';
import '../../modules/patient/screens/family/family_members_screen.dart';
import '../../modules/patient/screens/find_doctors/find_doctors_screen.dart';
import '../../modules/patient/screens/history/appointments_history_screen.dart';
import '../../modules/patient/screens/profile/profile_screen.dart';
import '../../modules/patient/screens/search/search_screen.dart';
import '../../modules/patient/screens/certificates/apply_certificate_screen.dart';
import '../../modules/patient/screens/certificates/certificate_wallet_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String landing = root;

  static const String patientLogin = '/auth/patient/login';
  static const String patientRegister = '/auth/patient/register';
  static const String doctorLogin = '/auth/doctor/login';
  static const String doctorRegister = '/auth/doctor/register';

  static const String search = '/search';
  static const String findDoctors = '/doctors';
  static const String doctorDetail = '/doctors/detail';
  static const String profile = '/profile';
  static const String addFamilyMember = '/family/add-member';
  static const String bookAppointment = '/appointments/book';
  static const String applyCertificate = '/certificate/apply';

  static const String dashboard = '/dashboard';
  static const String certificateWallet = '/certificate';
  static const String family = '/family';
  static const String history = '/history';

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
}

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

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
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorLogin,
        builder: (context, state) => DoctorLoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorRegister,
        builder: (context, state) => DoctorRegisterScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
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
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorDetail,
        builder: (context, state) {
          final doctor = state.extra;
          final DoctorProfile fallbackDoctor = DummyData.allDoctors.first;
          return DoctorDetailScreen(
            doctor: doctor is DoctorProfile ? doctor : fallbackDoctor,
          );
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
            initialMember: member is FamilyMember ? member : null,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.bookAppointment,
        builder: (context, state) {
          final doctor = state.extra;
          final DoctorProfile fallbackDoctor = DummyData.allDoctors.first;
          return BookAppointmentScreen(
            doctor: doctor is DoctorProfile ? doctor : fallbackDoctor,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.applyCertificate,
        builder: (context, state) => const ApplyCertificateScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorCertificateReview,
        builder: (context, state) => const CertificateReviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorManualBooking,
        builder: (context, state) => const ManualBookingScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorProfile,
        builder: (context, state) => const DoctorProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorLiveQueue,
        builder: (context, state) => const LiveQueueScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorProfileEdit,
        builder: (context, state) => const DoctorProfileEditScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorSubscription,
        builder: (context, state) => const MySubscriptionScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorAddPrescription,
        builder: (context, state) {
          final patientName = state.uri.queryParameters['name'] ?? 'Patient';
          var token = state.uri.queryParameters['token'] ?? '';
          if (token.isEmpty && state.uri.fragment.isNotEmpty) {
            token = state.uri.fragment;
          }
          if (token.isEmpty) {
            token = '-';
          }
          return AddPrescriptionScreen(
            appointmentId: state.pathParameters['id']!,
            patientName: patientName,
            tokenNumber: token,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorNotifications,
        builder: (context, state) => const NotificationScreen(),
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
                path: AppRoutes.certificateWallet,
                builder: (context, state) => const CertificateWalletScreen(),
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorDashboard,
                builder: (context, state) => const DoctorDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorAppointments,
                builder: (context, state) => const DoctorAppointmentHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorManualBooking,
                builder: (context, state) => const ManualBookingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorCertificates,
                builder: (context, state) => const DoctorCertificateDashboardScreen(),
              ),
            ],
          ),
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
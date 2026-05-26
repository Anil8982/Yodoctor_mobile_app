// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:yodoctor/core/utils/dummy_data.dart';
// import 'package:yodoctor/modules/auth/screens/doctor/doctor_login_screen.dart';
// import 'package:yodoctor/modules/auth/screens/doctor/doctor_register_screen.dart';
// import 'package:yodoctor/modules/auth/screens/landing/landing_screen.dart';
// import 'package:yodoctor/modules/auth/screens/patient/patient_login_screen.dart';
// import 'package:yodoctor/modules/auth/screens/patient/patient_register_screen.dart';
// import 'package:yodoctor/modules/patient/patient_pcaffold_shell.dart';
// import '../../modules/patient/screens/appointments/book_appointment_screen.dart';
// import '../../modules/patient/screens/dashboard/dashboard_screen.dart';
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
//   static const String dashboard = '/dashboard';
//   static const String findDoctors = '/doctors';
//   static const String doctorDetail = '/doctors/detail';
//   static const String profile = '/profile';
//   static const String family = '/family';
//   static const String addFamilyMember = '/family/add-member';
//   static const String bookAppointment = '/appointments/book';
//   static const String history = '/history';
//   static const String certificateWallet = '/certificates';
//   static const String applyCertificate = '/certificates/apply';
// }
//
// class AppRouter {
//   const AppRouter._();
//
//   static final GlobalKey<NavigatorState> _rootNavigatorKey =
//   GlobalKey<NavigatorState>();
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
//
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
//       // StatefulShellRoute
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) {
//           return PatientScaffoldShell(navigationShell: navigationShell);
//         },
//         branches: [
//           // Index 0: Home / Dashboard
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
//           // Index 2: Family
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.family,
//                 builder: (context, state) => const FamilyMembersScreen(),
//               ),
//             ],
//           ),
//           // Index 3: History
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
import 'package:yodoctor/modules/patient/patient_pcaffold_shell.dart';

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
  static const String dashboard = '/dashboard';
  static const String findDoctors = '/doctors';
  static const String doctorDetail = '/doctors/detail';
  static const String profile = '/profile';
  static const String family = '/family';
  static const String addFamilyMember = '/family/add-member';
  static const String bookAppointment = '/appointments/book';
  static const String history = '/history';
  static const String certificateWallet = '/certificates';
  static const String applyCertificate = '/certificates/apply';
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
        path: AppRoutes.dashboard,
        builder: (context, state) => const PatientScaffoldShell(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.certificateWallet,
        builder: (context, state) => const CertificateWalletScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.family,
        builder: (context, state) => const FamilyMembersScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.history,
        builder: (context, state) => const AppointmentsHistoryScreen(),
      ),
    ],
  );
}
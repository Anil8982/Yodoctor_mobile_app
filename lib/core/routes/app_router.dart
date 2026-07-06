import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/models/patient/lab_test_model.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';
import 'package:yodoctor/modules/admin/admin_scaffold_shell.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/doctor_management_screen.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/enquiry_screen.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/home_care_bookings_screen.dart';
import 'package:yodoctor/modules/patient/screens/home_care/home_service_booking_screen.dart';

import 'app_routes.dart';

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
import 'package:yodoctor/modules/patient/screens/lab_tests/all_lab_tests_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/lab_cart_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/lab_slot_booking_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/lab_test_details_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/lab_tests_screen.dart';
import 'package:yodoctor/modules/patient/screens/services/services_screen.dart';

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

      GoRoute(
        path: AppRoutes.family,
        builder: (context, state) => const FamilyMembersScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.labTest,
        builder: (context, state) => const LabTestsScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.labTestDetails,
        builder: (context, state) {
          final package = state.extra as LabPackage;
          return LabTestDetailsScreen(package: package);
        },
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
        path: AppRoutes.homeServiceBooking,
        builder: (context, state) => const HomeServiceBookingScreen(),
      ),


      // Admin

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminScaffoldShell(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.enquiry,
        builder: (context, state) => EnquiryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.homeCareBooking,
        builder: (context, state) => HomeCareBookingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.doctorsManagement,
        builder: (context, state) => DoctorsManagementScreen(),
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
                path: AppRoutes.services,
                builder: (context, state) => const ServicesScreen(),
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
      // 🎯 Doctor Side Shell
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

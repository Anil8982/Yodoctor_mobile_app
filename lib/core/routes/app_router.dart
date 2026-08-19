import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/modules/admin/admin_scaffold_shell.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/doctor_management_screen.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/enquiry_screen.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/home_care_bookings_screen.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_status_controller.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_login_screen.dart';
import 'package:yodoctor/modules/auth/screens/doctor/doctor_register_screen.dart';
import 'package:yodoctor/modules/auth/screens/doctor/verification_status_screen.dart';
import 'package:yodoctor/modules/auth/screens/landing/landing_screen.dart';
import 'package:yodoctor/modules/auth/screens/landing/splash_screen.dart';
import 'package:yodoctor/modules/auth/screens/patient/patient_login_screen.dart';
import 'package:yodoctor/modules/auth/screens/patient/patient_register_screen.dart';
import 'package:yodoctor/modules/doctor/controllers/subscription_status_controller.dart';
import 'package:yodoctor/modules/doctor/doctor_scaffold_shell.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';
import 'package:yodoctor/modules/doctor/screens/appointments/add_prescription_screen.dart';
import 'package:yodoctor/modules/doctor/screens/appointments/doctor_appointment_history_screen.dart';
import 'package:yodoctor/modules/doctor/screens/live_queue/live_queue_screen.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/review_screen/certificate_review_screen.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/dashboard_screen/doctor_certificate_dashboard_screen.dart';
import 'package:yodoctor/modules/doctor/screens/dashboard/doctor_dashboard_screen.dart';
import 'package:yodoctor/modules/doctor/screens/manual_booking/manual_booking_screen.dart';
import 'package:yodoctor/modules/doctor/screens/subscription/subscription_verification_page.dart';
import 'package:yodoctor/modules/notifications/screens/notification_screen.dart';
import 'package:yodoctor/modules/doctor/screens/profile/doctor_profile_edit_screen.dart';
import 'package:yodoctor/modules/doctor/screens/profile/doctor_profile_screen.dart';
import 'package:yodoctor/modules/doctor/screens/qr/doctor_qr_screen.dart';
import 'package:yodoctor/modules/doctor/screens/reviews/doctor_reviews_screen.dart';
import 'package:yodoctor/modules/doctor/screens/subscription/my_subscription_screen.dart';
import 'package:yodoctor/modules/patient/models/certificate/patient_doctor_model.dart';
import 'package:yodoctor/modules/patient/models/family/family_member_model.dart';
import 'package:yodoctor/modules/patient/models/search/doctor_detail_model.dart';
import 'package:yodoctor/modules/patient/patient_pcaffold_shell.dart';
import 'package:yodoctor/modules/patient/screens/appointments/book_appointment_screen.dart';
import 'package:yodoctor/modules/patient/screens/certificates/apply_certificate_screen.dart';
import 'package:yodoctor/modules/patient/screens/certificates/certificate_wallet_screen.dart';
import 'package:yodoctor/modules/patient/screens/certificates/doctor_selection_screen.dart';
import 'package:yodoctor/modules/patient/screens/certificates/patient_certificate_detail_screen.dart';
import 'package:yodoctor/modules/patient/screens/dashboard/dashboard_screen.dart';
import 'package:yodoctor/modules/patient/screens/doctor_detail/doctor_detail_screen.dart';
import 'package:yodoctor/modules/patient/screens/family/add_family_member_screen.dart';
import 'package:yodoctor/modules/patient/screens/family/family_members_screen.dart';
import 'package:yodoctor/modules/patient/screens/history/appointments_history_screen.dart';
import 'package:yodoctor/modules/patient/screens/home_care/home_care_history_screen.dart';
import 'package:yodoctor/modules/patient/screens/home_care/home_service_booking_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/all_lab_tests_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/lab_cart_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/lab_slot_booking_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/lab_test_details_screen.dart';
import 'package:yodoctor/modules/patient/screens/lab_tests/lab_tests_screen.dart';
import 'package:yodoctor/modules/patient/screens/profile/profile_screen.dart';
import 'package:yodoctor/modules/patient/screens/search/search_screen.dart';
import 'package:yodoctor/modules/patient/screens/services/services_screen.dart';
import 'package:yodoctor/modules/payment/screens/invoice_detail_screen.dart';
import 'package:yodoctor/modules/payment/screens/payment_processing_screen.dart';
import 'package:yodoctor/modules/payment/screens/payment_success_screen.dart';
import 'package:yodoctor/modules/widgets/document_viewer_screen.dart';

import 'app_routes.dart';

// Router provider - reacts to both auth and verification state changes
final routerProvider = Provider<GoRouter>((ref) {
  // Single notifier that triggers GoRouter re-evaluation
  final refreshListenable = ValueNotifier<int>(0);

  // Helper to trigger router refresh
  void refreshRouter() {
    refreshListenable.value++;
  }

  // Listen: Login / Logout / Role changes
  ref.listen(appRoleProvider, (_, _) {
    AppLogger.debug(
      'Router: appRoleProvider changed, refreshing',
      tag: LogTags.auth,
      subTag: 'Router',
    );
    refreshRouter();
  });

  // Listen: Doctor verification status changes
  ref.listen(doctorStatusProvider, (_, _) {
    AppLogger.debug(
      'Router: doctorStatusProvider changed, refreshing',
      tag: LogTags.auth,
      subTag: 'Router',
    );
    refreshRouter();
  });

  // Listen: Doctor subscription status changes
  ref.listen(subscriptionStatusProvider, (previous, next) {
    AppLogger.debug(
      'Router: subscriptionStatusProvider changed, refreshing',
      tag: LogTags.auth,
      subTag: 'Router',
    );
    refreshRouter();
  });

  // Cleanup notifier when provider is disposed
  ref.onDispose(refreshListenable.dispose);

  // Helper: detect auth screens
  bool isAuthScreen(String path) {
    return path == AppRoutes.landing ||
        path == AppRoutes.patientLogin ||
        path == AppRoutes.patientRegister ||
        path == AppRoutes.doctorLogin ||
        path == AppRoutes.doctorRegister;
  }

  // Helper: detect doctor protected routes
  bool isDoctorProtectedRoute(String path) {
    return path == '/doctor' || path.startsWith('/doctor/');
  }

  final router = GoRouter(
    navigatorKey: AppRouter.rootNavigatorKey,

    // Always start from splash for proper initialization flow
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,

    redirect: (context, state) {
      final storage = ref.read(storageProvider);
      final token = storage.getToken();
      final role = storage.getRole();
      final isLoggedIn = token != null && token.isNotEmpty;
      final matchedPath = state.matchedLocation;
      final authType = storage.getAuthType();
      final subState = ref.read(subscriptionStatusProvider);

      AppLogger.info(
        'Router → '
        'TOKEN=${token != null ? 'YES' : 'NO'} | '
        'ROLE=$role | '
        'AUTH_TYPE=${authType?.name ?? 'null'} | '
        'DOC_STATUS=${ref.read(doctorStatusProvider).status} | '
        'DOC_RESOLVED=${ref.read(doctorStatusProvider).isResolved} | '
        'SUB_RESOLVED=${subState.isResolved} | '
        'HAS_SUB=${subState.hasSubscription} | '
        'PATH=$matchedPath',
        tag: LogTags.auth,
        subTag: 'Router',
      );

      // ---- Unauthenticated ----
      if (!isLoggedIn) {
        // Redirect everything except auth screens to landing
        if (!isAuthScreen(matchedPath) && matchedPath != AppRoutes.landing) {
          AppLogger.debug(
            'Router: unauthenticated → landing',
            tag: LogTags.auth,
            subTag: 'Router',
          );
          return AppRoutes.landing;
        }
        return null; // Stay on current auth screen
      }

      // ---- Patient ----
      if (role == 'patient') {
        // Redirect from splash/auth to dashboard
        if (matchedPath == AppRoutes.splash || isAuthScreen(matchedPath)) {
          AppLogger.debug(
            'Router: patient → dashboard',
            tag: LogTags.auth,
            subTag: 'Router',
          );
          return AppRoutes.dashboard;
        }
        return null; // Allow all other routes
      }

      // ---- Admin ----
      if (role == 'admin') {
        return null; // Admin can access all routes
      }

      // ---- Doctor ----
      // if (role == 'doctor') {
      //   final doctorState = ref.read(doctorStatusProvider);
      //
      //   // While verification not resolved, stay on splash
      //   if (!doctorState.isResolved) {
      //     if (matchedPath != AppRoutes.splash) {
      //       AppLogger.debug('Router: doctor unresolved → splash',
      //           tag: LogTags.auth, subTag: 'Router');
      //       return AppRoutes.splash;
      //     }
      //     return null; // Stay on splash
      //   }
      //
      //   // APPROVED: redirect from splash/auth/waiting to dashboard
      //   if (doctorState.status == 'APPROVED') {
      //     if (matchedPath == AppRoutes.splash ||
      //         isAuthScreen(matchedPath) ||
      //         matchedPath == AppRoutes.waitingApproval) {
      //       AppLogger.debug('Router: doctor approved → dashboard',
      //           tag: LogTags.auth, subTag: 'Router');
      //       return AppRoutes.doctorDashboard;
      //     }
      //     return null; // Approved doctor can go anywhere
      //   }
      //
      //   // PENDING or REJECTED (or null with error)
      //   // Block doctor protected routes
      //   if (isDoctorProtectedRoute(matchedPath)) {
      //     AppLogger.debug('Router: doctor not approved → waiting',
      //         tag: LogTags.auth, subTag: 'Router');
      //     return AppRoutes.waitingApproval;
      //   }
      //   // Redirect all other routes to waiting
      //   if (matchedPath != AppRoutes.waitingApproval) {
      //     AppLogger.debug('Router: doctor not approved → waiting',
      //         tag: LogTags.auth, subTag: 'Router');
      //     return AppRoutes.waitingApproval;
      //   }
      //   return null; // Stay on waiting approval
      // }

      // ---- Doctor ----
      if (role == 'doctor') {
        final doctorState = ref.read(doctorStatusProvider);
        // final subState = ref.read(subscriptionStatusProvider); // ✅ Direct read for Notifier

        // 1. While verification not resolved, stay on splash
        if (!doctorState.isResolved) {
          if (matchedPath != AppRoutes.splash) {
            return AppRoutes.splash;
          }
          return null;
        }

        // 2. If not approved, redirect to waiting approval
        if (doctorState.status != 'APPROVED') {
          if (isDoctorProtectedRoute(matchedPath) ||
              matchedPath != AppRoutes.waitingApproval) {
            return AppRoutes.waitingApproval;
          }
          return null;
        }

        // 3. If subscription not yet resolved → Verification Page
        if (!subState.isResolved) {
          if (matchedPath != AppRoutes.doctorSubscriptionVerification) {
            AppLogger.debug(
              'Router: subscription status unresolved → verification page',
              tag: LogTags.auth,
              subTag: 'Router',
            );
            return AppRoutes.doctorSubscriptionVerification;
          }
          return null;
        }

        // 4. If approved but NO active subscription → Verification Page with plans
        if (!subState.hasSubscription) {
          if (matchedPath != AppRoutes.doctorSubscriptionVerification) {
            AppLogger.debug(
              'Router: doctor approved but no subscription → verification page',
              tag: LogTags.auth,
              subTag: 'Router',
            );
            return AppRoutes.doctorSubscriptionVerification;
          }
          return null;
        }

        // 5. APPROVED + HAS SUBSCRIPTION:
        // Redirect from splash/auth/waiting/verification pages to dashboard
        if (matchedPath == AppRoutes.splash ||
            isAuthScreen(matchedPath) ||
            matchedPath == AppRoutes.waitingApproval ||
            matchedPath == AppRoutes.doctorSubscriptionVerification) {
          AppLogger.debug(
            'Router: doctor has active subscription → redirecting to dashboard',
            tag: LogTags.auth,
            subTag: 'Router',
          );
          return AppRoutes.doctorDashboard;
        }

        return null; // Allow subscribed doctor to access all routes including MySubscriptionScreen
      }
      return null; // Fallback
    },

    routes: <RouteBase>[
      // ---- Splash ----
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ---- Auth Screens ----
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.landing,
        builder: (context, state) => LandingScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.patientLogin,
        builder: (context, state) => PatientLoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.patientRegister,
        builder: (context, state) => PatientRegisterScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorLogin,
        builder: (context, state) => DoctorLoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorRegister,
        builder: (context, state) {
          final extraStep = state.extra;
          final int targetStep = extraStep is int ? extraStep : 1;
          return DoctorRegisterScreen(initialStep: targetStep);
        },
      ),

      // ---- Verification Status ----
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.waitingApproval,
        builder: (context, state) => const VerificationStatusScreen(),
      ),

      // ---- Patient Shared Routes ----
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: '${AppRoutes.doctorDetail}/:doctorId',
        builder: (context, state) {
          final doctorId =
              int.tryParse(state.pathParameters['doctorId'] ?? '') ?? 0;
          return DoctorDetailScreen(doctorId: doctorId);
        },
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.addFamilyMember,
        builder: (context, state) {
          final member = state.extra;
          return AddFamilyMemberScreen(
            initialMember: member is FamilyMemberModel ? member : null,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.bookAppointment,
        builder: (context, state) {
          final doctor = state.extra;
          if (doctor is! DoctorDetailModel) {
            return const Scaffold(
              body: Center(child: Text('Doctor data not found')),
            );
          }
          return BookAppointmentScreen(doctor: doctor);
        },
      ),
      // GoRoute(
      //   parentNavigatorKey: AppRouter.rootNavigatorKey,
      //   path: AppRoutes.applyCertificate,
      //   builder: (context, state) => const ApplyCertificateScreen(),
      // ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorSelection,
        builder: (context, state) => const DoctorSelectionScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.applyCertificate,
        builder: (context, state) {
          final doctor = state.extra is PatientDoctorModel
              ? state.extra as PatientDoctorModel
              : null;

          return ApplyCertificateScreen(
            initialDoctor: doctor,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.patientCertificateDetail,
        builder: (context, state) => const PatientCertificateDetailScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.family,
        builder: (context, state) => const FamilyMembersScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.labTest,
        builder: (context, state) => const LabTestsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: '${AppRoutes.labTestDetails}/:testId',
        name: 'labTestDetails',
        builder: (context, state) {
          final testId = int.parse(state.pathParameters['testId']!);
          return LabTestDetailsScreen(testId: testId);
        },
      ),

      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.labCart,
        builder: (context, state) => const LabCartScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.allLabTests,
        builder: (context, state) => const AllLabTestsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.labSlotBooking,
        builder: (context, state) => const LabSlotBookingScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.homeServiceBooking,
        builder: (context, state) => const HomeServiceBookingScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeCareHistory,
        name: 'homeCareHistory',
        builder: (context, state) => const HomeCareHistoryScreen(),
      ),

      // ---- Doctor Shared Routes (non-shell) ----

      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorProfile,
        builder: (context, state) => const DoctorProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorQr,
        builder: (context, state) => const DoctorQrScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorLiveQueue,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final tabIndex = extra?['initialIndex'] as int? ?? 0;
          return LiveQueueScreen(initialIndex: tabIndex);
        },
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorProfileEdit,
        builder: (context, state) => const DoctorProfileEditScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorSubscriptionVerification,
        builder: (context, state) => const SubscriptionVerificationPage(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorSubscription,
        builder: (context, state) => const MySubscriptionScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
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
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: '${AppRoutes.doctorCertificateReview}/:requestId',
        builder: (context, state) {
          final requestId =
              int.tryParse(state.pathParameters['requestId'] ?? '') ?? 0;
          return CertificateReviewScreen(requestId: requestId);
        },
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorReviews,
        builder: (context, state) => const DoctorReviewsScreen(),
      ),

      // ---- Admin Routes ----
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminScaffoldShell(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.enquiry,
        builder: (context, state) => EnquiryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.homeCareBooking,
        builder: (context, state) => HomeCareBookingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.doctorsManagement,
        builder: (context, state) => DoctorsManagementScreen(),
      ),

      // ---- Payment Routes ----
      GoRoute(
        path: AppRoutes.paymentSuccess,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return PaymentSuccessScreen(
            paymentId: extra['paymentId'] as String?,
            planName: extra['planName'] as String?,
            nextRoute: extra['nextRoute'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.paymentProcessing,
        builder: (context, state) {
          return PaymentProcessingScreen(
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: AppRoutes.invoiceDetail,
        builder: (context, state) {
          final invoice = state.extra as BillingInvoice;
          return InvoiceDetailScreen(invoice: invoice);
        },
      ),


      // ---- Shared ----
      GoRoute(
        path: AppRoutes.documentViewer,
        name: 'documentViewer',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DocumentViewerScreen(
            fileUrl: extra['fileUrl'],
            fileName: extra['fileName'],
            isImage: extra['isImage'] ?? false,
            isPdf: extra['isPdf'] ?? false,
          );
        },
      ),

      // ---- Patient Shell (Bottom Nav) ----
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

      // ---- Doctor Shell (Bottom Nav) ----
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
                path: AppRoutes.doctorManualBooking,
                builder: (context, state) => const ManualBookingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorCertificates,
                builder: (context, state) =>
                    const DoctorCertificateDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.doctorAppointments,
                builder: (context, state) =>
                const DoctorAppointmentHistoryScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // Dispose router when provider is disposed
  ref.onDispose(router.dispose);

  return router;
});

// Kept for navigator key access across the app
class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  // Always start from splash for proper initialization flow
  static String getInitialLocation(String? token, String? role) {
    return AppRoutes.splash;
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/patient/patient_pcaffold_shell.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';

import '../../modules/patient/screens/dashboard/dashboard_screen.dart';
import '../../modules/patient/screens/find_doctors/find_doctors_screen.dart';
import '../../modules/patient/screens/search/search_screen.dart';
import '../../modules/patient/screens/profile/profile_screen.dart';
import '../../modules/patient/screens/family/family_members_screen.dart';
import '../../modules/patient/screens/family/add_family_member_screen.dart';
import '../../modules/patient/screens/history/appointments_history_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String search = '/search';
  static const String dashboard = '/dashboard';
  static const String findDoctors = '/doctors';
  static const String profile = '/profile';
  static const String family = '/family';
  static const String addFamilyMember = '/family/add-member';
  static const String history = '/history';
}

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
  GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    routes: <RouteBase>[
      // --- FIND DOCTORS (FULL SCREEN) ---
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
    ],
  );
}

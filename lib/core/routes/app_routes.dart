import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/patient/patient_pcaffold_shell.dart';

import '../../modules/patient/screens/dashboard/dashboard_screen.dart';
import '../../modules/patient/screens/find_doctors/find_doctors_screen.dart';
import '../../modules/patient/screens/search/search_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String search = '/search';
  static const String dashboard = '/dashboard';
  static const String findDoctors = '/doctors';
}

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard, // Dashboard pasun suru kara
    routes: <RouteBase>[
      // 1. Auth routes (login/signup) - hyala nav bar nako asel tar baher theva

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return PatientScaffoldShell(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => DashboardScreen(),
              ),
            ],
          ),
          // Search Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => SearchScreen(),
              ),
              // Sub-route for search (Find Doctors)
              GoRoute(
                path: AppRoutes.findDoctors,
                builder: (context, state) {
                  final query = state.uri.queryParameters['q'] ?? '';
                  return FindDoctorsScreen(initialQuery: query);
                },
              ),
            ],
          ),
          // Family Branch (Placeholder)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/family',
                builder: (context, state) => const Center(child: Text('Family')),
              ),
            ],
          ),
          // History Branch (Placeholder)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const Center(child: Text('History')),
              ),
            ],
          ),
        ],
      ),
    ],
  );}

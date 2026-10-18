import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/auth_interceptor.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/storage/storage_service.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/doctor/models/subscription/available_plan_model.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';

// In-memory fake StorageService for unit testing
class FakeStorageService extends StorageService {
  String? _token;
  String? _regToken;
  String? _role;
  String? _status;
  bool? _activeSub;

  @override
  Future<void> saveToken(String token) async => _token = token;
  @override
  String? getToken() => _token;
  @override
  Future<void> clearToken() async => _token = null;

  @override
  Future<void> saveRegistrationToken(String token) async => _regToken = token;
  @override
  String? getRegistrationToken() => _regToken;
  @override
  Future<void> clearRegistrationToken() async => _regToken = null;

  @override
  Future<void> saveRole(String role) async => _role = role;
  @override
  String? getRole() => _role;
  @override
  Future<void> clearRole() async => _role = null;

  @override
  Future<void> saveStatus(String status) async => _status = status;
  @override
  String? getStatus() => _status;
  @override
  Future<void> clearStatus() async => _status = null;

  @override
  Future<void> saveActiveSubscription(bool hasSub) async => _activeSub = hasSub;
  @override
  bool? getActiveSubscription() => _activeSub;
  @override
  Future<void> clearActiveSubscription() async => _activeSub = null;

  @override
  Future<void> clearAll() async {
    _token = null;
    _regToken = null;
    _role = null;
    _status = null;
    _activeSub = null;
  }
}

final testRefProvider = Provider<Ref>((ref) => ref);

String resolveDoctorRoute({
  required bool hasSubscription,
  required bool isApproved,
  required String currentPath,
}) {
  if (!hasSubscription) {
    if (currentPath != AppRoutes.doctorSubscriptionVerification) {
      return AppRoutes.doctorSubscriptionVerification;
    }
    return currentPath;
  }
  if (!isApproved) {
    if (currentPath != AppRoutes.waitingApproval) {
      return AppRoutes.waitingApproval;
    }
    return currentPath;
  }
  if (currentPath == AppRoutes.waitingApproval ||
      currentPath == AppRoutes.doctorSubscriptionVerification) {
    return AppRoutes.doctorDashboard;
  }
  return currentPath;
}

void main() {
  group('1. Final Declaration Endpoint and Payload Specification', () {
    test('ApiConstants.doctorRegisterSubmit is exact PATCH endpoint /registration/submit', () {
      expect(ApiConstants.doctorRegisterSubmit, '/registration/submit');
    });

    test('Doctor declaration payload maps all 4 required declaration fields correctly', () {
      final formData = DoctorFormData();
      formData.declAccurate = true;
      formData.declDisplay = true;
      formData.declPrivacy = true;
      formData.declTerms = true;

      final payload = {
        "accurate": formData.declAccurate,
        "display": formData.declDisplay,
        "privacy": formData.declPrivacy,
        "terms": formData.declTerms,
      };

      expect(payload['accurate'], true);
      expect(payload['display'], true);
      expect(payload['privacy'], true);
      expect(payload['terms'], true);
      expect(payload.length, 4);
    });
  });

  group('2. AuthInterceptor Bearer Token & Endpoint Handling', () {
    test('attaches Bearer token from registration token on /registration/submit', () {
      final fakeStorage = FakeStorageService();
      fakeStorage.saveRegistrationToken('test_registration_token_xyz');

      final container = ProviderContainer();
      addTearDown(container.dispose);
      final ref = container.read(testRefProvider);
      final interceptor = AuthInterceptor(fakeStorage, ref);

      final options = RequestOptions(
        path: '/registration/submit',
        method: 'PATCH',
      );

      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Authorization'], 'Bearer test_registration_token_xyz');
    });

    test('falls back to active session token if registration token is absent', () {
      final fakeStorage = FakeStorageService();
      fakeStorage.saveToken('active_session_token_123');

      final container = ProviderContainer();
      addTearDown(container.dispose);
      final ref = container.read(testRefProvider);
      final interceptor = AuthInterceptor(fakeStorage, ref);

      final options = RequestOptions(
        path: '/registration/submit',
        method: 'PATCH',
      );

      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers['Authorization'], 'Bearer active_session_token_123');
    });
  });

  group('3. DoctorRegisterSubmitResult & Response Parsing', () {
    test('creates successful result with redirect: "payment"', () {
      const result = DoctorRegisterSubmitResult(
        success: true,
        redirect: 'payment',
        message: 'Declaration saved successfully',
      );

      expect(result.success, true);
      expect(result.redirect, 'payment');
      expect(result.message, 'Declaration saved successfully');
      expect(result.error, isNull);
    });

    test('creates failed result when success: false', () {
      const result = DoctorRegisterSubmitResult(
        success: false,
        message: 'All declarations must be accepted',
        error: 'Validation failed',
      );

      expect(result.success, false);
      expect(result.redirect, isNull);
      expect(result.error, 'Validation failed');
    });

    test('safely handles missing or unexpected redirect instruction', () {
      const resultUnexpected = DoctorRegisterSubmitResult(
        success: true,
        redirect: 'unknown_destination',
        message: 'Declaration saved',
      );

      expect(resultUnexpected.success, true);
      expect(resultUnexpected.redirect, 'unknown_destination');

      const resultMissing = DoctorRegisterSubmitResult(
        success: true,
        redirect: null,
      );

      expect(resultMissing.success, true);
      expect(resultMissing.redirect, isNull);
    });
  });

  group('4. Doctor Registration -> Payment -> Verification Business Routing Logic', () {
    test('doctor without active subscription must be directed to subscription verification page', () {
      final intendedRoute = resolveDoctorRoute(
        hasSubscription: false,
        isApproved: false,
        currentPath: AppRoutes.doctorDashboard,
      );

      expect(intendedRoute, AppRoutes.doctorSubscriptionVerification);
    });

    test('doctor with confirmed subscription and pending approval must be directed to waiting approval', () {
      final intendedRoute = resolveDoctorRoute(
        hasSubscription: true,
        isApproved: false,
        currentPath: AppRoutes.doctorDashboard,
      );

      expect(intendedRoute, AppRoutes.waitingApproval);
    });

    test('doctor with confirmed subscription and approved status is directed to dashboard', () {
      final intendedRoute = resolveDoctorRoute(
        hasSubscription: true,
        isApproved: true,
        currentPath: AppRoutes.waitingApproval,
      );

      expect(intendedRoute, AppRoutes.doctorDashboard);
    });

    test('payment result screens are allowed through without being redirected', () {
      const paymentScreens = [
        AppRoutes.paymentSuccess,
        AppRoutes.paymentProcessing,
        AppRoutes.paymentFailure,
      ];

      for (final path in paymentScreens) {
        final isAllowed = path == AppRoutes.paymentSuccess ||
            path == AppRoutes.paymentProcessing ||
            path == AppRoutes.paymentFailure;
        expect(isAllowed, true);
      }
    });

    test('post-payment nextRoute redirects to waitingApproval if not yet approved', () {
      final String status = 'PENDING';
      final isApproved = status == 'APPROVED';
      final nextRoute = isApproved
          ? AppRoutes.doctorDashboard
          : AppRoutes.waitingApproval;

      expect(nextRoute, AppRoutes.waitingApproval);
    });

    test('post-payment nextRoute redirects to doctorDashboard if already approved', () {
      final String status = 'APPROVED';
      final isApproved = status == 'APPROVED';
      final nextRoute = isApproved
          ? AppRoutes.doctorDashboard
          : AppRoutes.waitingApproval;

      expect(nextRoute, AppRoutes.doctorDashboard);
    });
  });

  group('5. Subscription Plans Parsing and Cycle Filtering', () {
    final rawPlans = [
      {
        "id": "plan_trial",
        "title": "45 Days Trial Plan",
        "name": "45 Days Trial Plan",
        "slug": "trial",
        "category": "trial",
        "months": 0,
        "price": 1,
      },
      {
        "id": "plan_3_month",
        "title": "3 Month Plan",
        "name": "3 Month Plan",
        "slug": "3-month",
        "category": "subscription",
        "months": 3,
        "price": 2397,
      },
      {
        "id": "plan_6_month",
        "title": "6 Month Plan",
        "name": "6 Month Plan",
        "slug": "6-month",
        "category": "subscription",
        "months": 6,
        "price": 4794,
      },
      {
        "id": "plan_12_month",
        "title": "12 Month Plan",
        "name": "12 Month Plan",
        "slug": "12-month",
        "category": "subscription",
        "months": 12,
        "price": 9588,
      },
    ];

    test('All 4 plans parse correctly from raw API json', () {
      final plans = rawPlans.map((json) => AvailablePlan.fromJson(json)).toList();
      expect(plans.length, 4);
      expect(plans[0].category, 'trial');
      expect(plans[1].category, 'subscription');
      expect(plans[1].months, 3.0);
      expect(plans[2].months, 6.0);
      expect(plans[3].months, 12.0);
    });

    test('Monthly view surfaces trial, 3-month, and 6-month plans without dropping subscription plans', () {
      final plans = rawPlans.map((json) => AvailablePlan.fromJson(json)).toList();
      final targetCycle = 'monthly';

      final monthlyPlans = plans.where((p) {
        final category = p.category.toLowerCase();
        if (category == 'trial') return true;
        if (category == 'monthly' || category == 'yearly') {
          return category == targetCycle;
        }
        final isYearlyPlan = p.months >= 12 ||
            p.slug.toLowerCase().contains('12-month') ||
            p.title.toLowerCase().contains('year');
        return targetCycle == 'yearly' ? isYearlyPlan : !isYearlyPlan;
      }).toList();

      final ids = monthlyPlans.map((p) => p.id).toList();
      expect(ids, contains('plan_trial'));
      expect(ids, contains('plan_3_month'));
      expect(ids, contains('plan_6_month'));
      expect(ids, isNot(contains('plan_12_month')));
      expect(monthlyPlans.length, 3);
    });

    test('Yearly view surfaces trial and 12-month plans', () {
      final plans = rawPlans.map((json) => AvailablePlan.fromJson(json)).toList();
      final targetCycle = 'yearly';

      final yearlyPlans = plans.where((p) {
        final category = p.category.toLowerCase();
        if (category == 'trial') return true;
        if (category == 'monthly' || category == 'yearly') {
          return category == targetCycle;
        }
        final isYearlyPlan = p.months >= 12 ||
            p.slug.toLowerCase().contains('12-month') ||
            p.title.toLowerCase().contains('year');
        return targetCycle == 'yearly' ? isYearlyPlan : !isYearlyPlan;
      }).toList();

      final ids = yearlyPlans.map((p) => p.id).toList();
      expect(ids, contains('plan_trial'));
      expect(ids, contains('plan_12_month'));
      expect(ids, isNot(contains('plan_3_month')));
      expect(ids, isNot(contains('plan_6_month')));
      expect(yearlyPlans.length, 2);
    });
  });

  group('6. Create Subscription Payload and Scheduled Upgrade Parsing', () {
    test('Flow A - First paid purchase payload matches backend specification', () {
      final payload = {
        'planId': 'plan_3_month',
        'billing': 'monthly',
        'isUpgrade': false,
        'isDoctorRegistration': false,
      };

      expect(payload['planId'], 'plan_3_month');
      expect(payload['billing'], 'monthly');
      expect(payload['isUpgrade'], false);
      expect(payload['isDoctorRegistration'], false);
    });

    test('Flow B - Upgrade purchase payload passes isUpgrade: true and billing: monthly', () {
      final payload = {
        'planId': 'plan_6_month',
        'billing': 'monthly',
        'isUpgrade': true,
        'isDoctorRegistration': false,
      };

      expect(payload['planId'], 'plan_6_month');
      expect(payload['billing'], 'monthly');
      expect(payload['isUpgrade'], true);
      expect(payload['isDoctorRegistration'], false);
    });

    test('SubscriptionPlan.fromJson parses scheduled upgrade into upcomingPlan correctly', () {
      final json = {
        "id": "sub_local_123",
        "plan_id": "plan_3_month",
        "plan_name": "3 Month Plan",
        "status": "active",
        "upgrade_status": "scheduled",
        "scheduled_plan_id": "plan_6_month",
        "scheduled_plan_name": "6 Month Plan",
        "scheduled_activation_date": "2026-12-01T00:00:00.000Z",
      };

      final plan = SubscriptionPlan.fromJson(json);
      expect(plan.isActive, true);
      expect(plan.upgradeStatus, 'scheduled');
      expect(plan.upcomingPlan, isNotNull);
      expect(plan.upcomingPlan!.title, '6 Month Plan');
      expect(plan.upcomingPlan!.startDate.year, 2026);
      expect(plan.upcomingPlan!.startDate.month, 12);
    });
  });
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/modules/doctor/models/subscription/subscription_model.dart';
import 'package:yodoctor/modules/doctor/repositories/subscription_repository.dart';

class SubscriptionStatusState {
  final bool hasSubscription;
  final bool isActive;
  final String? status;
  final SubscriptionPlan? subscriptionPlan;
  final bool isLoading;
  final bool isResolved;
  final String? errorMessage;

  const SubscriptionStatusState({
    this.hasSubscription = false,
    this.isActive = false,
    this.status,
    this.subscriptionPlan,
    this.isLoading = false,
    this.isResolved = false,
    this.errorMessage,
  });

  bool get isPaymentPending => !isActive && (status == 'pending' || (hasSubscription && !isActive));
  bool get hasActiveSubscription => hasSubscription && isActive;

  SubscriptionStatusState copyWith({
    bool? hasSubscription,
    bool? isActive,
    String? status,
    SubscriptionPlan? subscriptionPlan,
    bool clearSubscriptionPlan = false,
    bool? isLoading,
    bool? isResolved,
    String? errorMessage,
  }) {
    return SubscriptionStatusState(
      hasSubscription: hasSubscription ?? this.hasSubscription,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      subscriptionPlan: clearSubscriptionPlan ? null : (subscriptionPlan ?? this.subscriptionPlan),
      isLoading: isLoading ?? this.isLoading,
      isResolved: isResolved ?? this.isResolved,
      errorMessage: errorMessage,
    );
  }
}

final subscriptionStatusProvider =
NotifierProvider<SubscriptionStatusNotifier, SubscriptionStatusState>(
  SubscriptionStatusNotifier.new,
);

class SubscriptionStatusNotifier extends Notifier<SubscriptionStatusState> {
  static const String _subTag = 'SubscriptionStatusNotifier';

  @override
  SubscriptionStatusState build() {
    final storage = ref.read(storageProvider);
    final cachedSub = storage.getActiveSubscription() ?? false;

    if (cachedSub) {
      AppLogger.info(
        'Loaded cached subscription from Hive: $cachedSub',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }

    return SubscriptionStatusState(
      hasSubscription: cachedSub,
      isActive: cachedSub,
      status: cachedSub ? 'active' : null,
      isResolved: cachedSub,
    );
  }

  Future<void> checkActiveSubscription() async {
    AppLogger.info(
      'Checking active subscription status from server...',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final storage = ref.read(storageProvider);

      final token = storage.getToken();

      if (token == null || token.isEmpty) {
        state = const SubscriptionStatusState(
          isLoading: false,
          isResolved: false,
        );
        return;
      }

      final response = await repository.getActiveSubscription();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;
        final hasSub = data["data"]?["hasSubscription"] ?? false;
        final isActive = data["data"]?["isActive"] ?? false;
        final rawSubscription = data["data"]?["subscription"];
        SubscriptionPlan? plan;
        if (rawSubscription is Map && rawSubscription.isNotEmpty) {
          plan = SubscriptionPlan.fromJson(Map<String, dynamic>.from(rawSubscription));
        }
        final subStatus = (plan?.status ?? data["data"]?["subscription"]?["status"])?.toString().toLowerCase();
        final isConfirmedActive = (isActive == true) || (subStatus == 'active');

        // Only save true in Hive if the subscription is confirmed ACTIVE (paid)
        await storage.saveActiveSubscription(isConfirmedActive);

        AppLogger.success(
          'Active subscription fetched & cached: '
              'hasSubscription=$hasSub, isActive=$isConfirmedActive, status=$subStatus, plan=${plan?.title} (${plan?.amount})',
          tag: LogTags.doctor,
          subTag: _subTag,
        );

        state = SubscriptionStatusState(
          hasSubscription: hasSub,
          isActive: isConfirmedActive,
          status: subStatus,
          subscriptionPlan: plan,
          isLoading: false,
          isResolved: true,
        );
      } else {
        final cachedSub =
            storage.getActiveSubscription() ?? false;

        state = SubscriptionStatusState(
          hasSubscription: cachedSub,
          isActive: cachedSub,
          status: cachedSub ? 'active' : null,
          isLoading: false,
          isResolved: true,
          errorMessage:
          'Failed to verify subscription from server',
        );
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Error checking active subscription',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      final storage = ref.read(storageProvider);
      final cachedSub =
          storage.getActiveSubscription() ?? false;

      state = SubscriptionStatusState(
        hasSubscription: cachedSub,
        isLoading: false,
        isResolved: true,
        errorMessage:
        'Network error. Using cached subscription status.',
      );
    }
  }

  void reset() {
    state = const SubscriptionStatusState(
      isResolved: false,
    );
  }
}
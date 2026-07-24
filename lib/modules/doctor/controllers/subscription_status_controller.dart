import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/modules/doctor/repositories/subscription_repository.dart';

class SubscriptionStatusState {
  final bool hasSubscription;
  final bool isLoading;
  final bool isResolved;
  final String? errorMessage;

  const SubscriptionStatusState({
    this.hasSubscription = false,
    this.isLoading = false,
    this.isResolved = false,
    this.errorMessage,
  });

  SubscriptionStatusState copyWith({
    bool? hasSubscription,
    bool? isLoading,
    bool? isResolved,
    String? errorMessage,
  }) {
    return SubscriptionStatusState(
      hasSubscription: hasSubscription ?? this.hasSubscription,
      isLoading: isLoading ?? this.isLoading,
      isResolved: isResolved ?? this.isResolved,
      errorMessage: errorMessage,
    );
  }
}

final subscriptionStatusProvider =
AsyncNotifierProvider<SubscriptionStatusNotifier, SubscriptionStatusState>(
  SubscriptionStatusNotifier.new,
);

class SubscriptionStatusNotifier extends AsyncNotifier<SubscriptionStatusState> {
  static const String _subTag = 'SubscriptionStatusNotifier';

  @override
  FutureOr<SubscriptionStatusState> build() async {
    final storage = ref.read(storageProvider);
    final cachedSub = storage.getActiveSubscription();

    if (cachedSub != null) {
      AppLogger.info('Loaded cached subscription from Hive: $cachedSub', tag: LogTags.doctor, subTag: _subTag);
      return SubscriptionStatusState(
        hasSubscription: cachedSub,
        isResolved: true,
      );
    }

    return const SubscriptionStatusState(isResolved: false);
  }

  Future<void> checkActiveSubscription() async {
    AppLogger.info('Checking active subscription status from server...', tag: LogTags.doctor, subTag: _subTag);

    // Keep current state as loading or retain cache while fetching
    state = AsyncData((state.value ?? const SubscriptionStatusState()).copyWith(isLoading: true));

    try {
      final repository = ref.read(subscriptionRepositoryProvider);
      final storage = ref.read(storageProvider);

      final response = await repository.getActiveSubscription();

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;
        final hasSub = data["data"]?["hasSubscription"] ?? false;

        // 🎯 Save to Hive cache
        await storage.saveActiveSubscription(hasSub);

        AppLogger.success('Active subscription fetched & cached: hasSubscription=$hasSub', tag: LogTags.doctor, subTag: _subTag);

        state = AsyncData(SubscriptionStatusState(
          hasSubscription: hasSub,
          isLoading: false,
          isResolved: true,
        ));
      } else {
        // Fallback to cache if server fails but cache exists
        final cachedSub = storage.getActiveSubscription() ?? false;
        state = AsyncData(SubscriptionStatusState(
          hasSubscription: cachedSub,
          isLoading: false,
          isResolved: true,
          errorMessage: 'Failed to verify subscription from server',
        ));
      }
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Error checking active subscription', tag: LogTags.doctor, subTag: _subTag);

      final storage = ref.read(storageProvider);
      final cachedSub = storage.getActiveSubscription() ?? false;

      state = AsyncData(SubscriptionStatusState(
        hasSubscription: cachedSub,
        isLoading: false,
        isResolved: true,
        errorMessage: 'Network error. Using cached subscription status.',
      ));
    }
  }

  void reset() {
    state = const AsyncData(SubscriptionStatusState(isResolved: false));
  }
}
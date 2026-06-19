import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/subscription_controller.dart';
import 'widgets/main_plan_card.dart';
import 'widgets/billing_history_section.dart';

class MySubscriptionScreen extends ConsumerWidget {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorSubscriptionProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('My Subscription', style: TextStyle(fontWeight: FontWeight.bold)),
        scrolledUnderElevation: 0,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
          ? Center(child: Text(state.errorMessage!))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.currentPlan != null)
                  MainPlanCard(plan: state.currentPlan!),
                const SizedBox(height: 24),
                _buildUpgradeButton(ref),
                const SizedBox(height: 32),
                BillingHistorySection(history: state.billingHistory),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeButton(WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => ref.read(doctorSubscriptionProvider.notifier).upgradePlan(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E60E2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.upgrade_rounded, size: 20),
      label: const Text('Upgrade plan', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodoctor/core/constants/app_assets.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/app_config/controllers/app_config_controller.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_status_controller.dart';
import 'package:yodoctor/modules/doctor/controllers/subscription_status_controller.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import 'package:yodoctor/modules/widgets/logout_dialog.dart';

class VerificationStatusScreen extends ConsumerWidget {
  const VerificationStatusScreen({super.key});

  Future<void> _handleSupport(BuildContext context, WidgetRef ref) async {
    final appConfig = ref.read(appConfigProvider).config;
    final whatsapp = appConfig?.legalAndSupport.whatsappNumber ?? '';
    final email = appConfig?.legalAndSupport.supportEmail ?? '';

    if (whatsapp.isNotEmpty) {
      final cleanNumber = whatsapp.replaceAll(RegExp(r'[^0-9]'), '');
      final whatsappUri = Uri.parse(
        'https://wa.me/$cleanNumber?text=Hello%20YoDoctor%20Support,%20I%20have%20an%20inquiry%20regarding%20my%20doctor%20verification%20status.',
      );
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    if (email.isNotEmpty) {
      final emailUri = Uri.parse(
        'mailto:$email?subject=Doctor%20Verification%20Inquiry',
      );
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        return;
      }
    }

    AppSnackBar.show(
      message: 'Support is currently unavailable. Please try again later.',
      type: AppSnackBarType.info,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(doctorStatusProvider);
    final notifier = ref.read(doctorStatusProvider.notifier);
    final subStatus = ref.watch(subscriptionStatusProvider);

    final isPaymentPending = subStatus.isPaymentPending;
    final isApproved = state.status == 'APPROVED';
    final isRejected = state.status == 'REJECTED';

    if (state.isLoading && !state.isResolved) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    // Determine primary card color & icon based on state
    final Color statusColor = isPaymentPending
        ? const Color(0xFFE65100) // Deep Orange/Amber
        : isApproved
        ? colorScheme.primary
        : isRejected
        ? colorScheme.error
        : const Color(0xFF1565C0); // Blue for Pending Review

    final IconData statusIcon = isPaymentPending
        ? Icons.pending_actions_rounded
        : isApproved
        ? Icons.check_circle_rounded
        : isRejected
        ? Icons.error_outline_rounded
        : Icons.hourglass_top_rounded;

    final String statusBadgeTitle = isPaymentPending
        ? "Payment Pending"
        : isApproved
        ? "Account Approved"
        : isRejected
        ? "Verification Failed"
        : "Under Admin Review";

    final String statusHeadline = isPaymentPending
        ? "Subscription Payment Pending"
        : isApproved
        ? "Congratulations, Doctor!"
        : isRejected
        ? "Application Not Approved"
        : "Application Under Review";

    final String statusDescription = isPaymentPending
        ? "Your subscription payment is incomplete. Please complete your payment before our admin team can verify your credentials."
        : isApproved
        ? "Your credentials and medical documents have been verified and approved. You now have full access to your doctor dashboard."
        : isRejected
        ? (state.rejectionReason ??
            "Your submitted documents could not be verified by our administrative team. Please contact support.")
        : "Our verification team is carefully reviewing your submitted credentials and documents. This typically takes 24 to 48 business hours.";

    final int currentStep = isPaymentPending
        ? 2
        : isApproved
        ? 4
        : 3;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, color: statusColor, size: 20),
            const SizedBox(width: 8),
            Text(
              statusBadgeTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () => LogoutDialog.show(context, ref, role: AppRole.doctor),
            icon: Icon(Icons.logout_rounded, color: colorScheme.error),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            notifier.checkStatus(),
            ref.read(subscriptionStatusProvider.notifier).checkActiveSubscription(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.42,
                child: Image.asset(
                  AppAssets.logo(context),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),

              // Main Status Card
              Card(
                elevation: 4,
                shadowColor: statusColor.transparency(0.18),
                color: colorScheme.surfaceContainerHigh,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                    color: statusColor.transparency(0.25),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: statusColor.transparency(0.12),
                        child: Icon(
                          statusIcon,
                          size: 42,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.transparency(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusBadgeTitle.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        statusHeadline,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        statusDescription,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Stepper (Actual Flow: Registered -> Subscribed -> Review -> Approved)
                      _StatusStepper(
                        currentStep: currentStep,
                        activeColor: statusColor,
                        isRejected: isRejected,
                      ),
                      const SizedBox(height: 24),

                      // Contextual Primary Action Button inside the card
                      if (isPaymentPending) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () => context.go(AppRoutes.doctorSubscriptionVerification),
                            icon: const Icon(Icons.payment_rounded, size: 20),
                            label: const Text(
                              'Complete Payment Now',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFE65100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ] else if (isApproved) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () => context.go(AppRoutes.doctorDashboard),
                            icon: const Icon(Icons.dashboard_rounded, size: 20),
                            label: const Text(
                              'Go to Doctor Dashboard',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ] else if (isRejected) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () => _handleSupport(context, ref),
                            icon: const Icon(Icons.support_agent_rounded, size: 20),
                            label: const Text(
                              'Contact Support for Re-verification',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // PENDING STATE - Check Status Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: state.isLoading
                                ? null
                                : () async {
                                    await Future.wait([
                                      notifier.checkStatus(),
                                      ref
                                          .read(subscriptionStatusProvider.notifier)
                                          .checkActiveSubscription(),
                                    ]);
                                  },
                            icon: state.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.refresh_rounded, size: 20),
                            label: Text(
                              state.isLoading ? 'Checking...' : 'Check Status Now',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: statusColor,
                              side: BorderSide(color: statusColor.transparency(0.5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Actions: Contact Support & Logout
              FilledButton.icon(
                onPressed: () => _handleSupport(context, ref),
                icon: const Icon(Icons.support_agent_rounded, size: 20),
                label: const Text(
                  "Contact Support (WhatsApp / Email)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  foregroundColor: colorScheme.onSurface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => LogoutDialog.show(context, ref, role: AppRole.doctor),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text(
                  "Logout Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: colorScheme.error,
                  side: BorderSide(color: colorScheme.error.transparency(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusStepper extends StatelessWidget {
  final int currentStep;
  final Color activeColor;
  final bool isRejected;

  const _StatusStepper({
    this.currentStep = 3,
    this.activeColor = const Color(0xFF1565C0),
    this.isRejected = false,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = Colors.grey.shade300;

    final steps = [
      _StepData(title: "Registered", stepNum: "1"),
      _StepData(title: "Subscribed", stepNum: "2"),
      _StepData(title: isRejected ? "Review Failed" : "Under Review", stepNum: "3"),
      _StepData(title: "Approved", stepNum: "4"),
    ];

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / steps.length;
                final halfItem = itemWidth / 2;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: halfItem),
                  child: Row(
                    children: List.generate(steps.length - 1, (index) {
                      final isLineActive = index < (currentStep - 1);
                      return Expanded(
                        child: Container(
                          height: 2.5,
                          color: isLineActive ? activeColor : inactiveColor,
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (index) {
              final stepIndex = index + 1;
              final isCompleted = stepIndex < currentStep;
              final isCurrent = stepIndex == currentStep;

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStepIcon(
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                      stepNumber: steps[index].stepNum,
                      activeColor: activeColor,
                      inactiveColor: inactiveColor,
                      isRejected: isRejected && isCurrent,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      steps[index].title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: (isCompleted || isCurrent)
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: (isCompleted || isCurrent)
                            ? activeColor
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon({
    required bool isCompleted,
    required bool isCurrent,
    required String stepNumber,
    required Color activeColor,
    required Color inactiveColor,
    bool isRejected = false,
  }) {
    if (isCompleted) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: activeColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 18, color: Colors.white),
      );
    }

    if (isCurrent) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: activeColor, width: 2.5),
        ),
        child: Icon(
          isRejected ? Icons.close_rounded : Icons.hourglass_top_rounded,
          size: 16,
          color: activeColor,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: inactiveColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          stepNumber,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class _StepData {
  final String title;
  final String stepNum;

  _StepData({required this.title, required this.stepNum});
}
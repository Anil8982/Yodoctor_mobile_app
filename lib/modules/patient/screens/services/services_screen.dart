import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/widgets/patient_app_bar.dart';
import 'package:yodoctor/modules/patient/widgets/patient_bottom_nav.dart';
import 'package:yodoctor/modules/patient/widgets/qr_scanner.dart';
import 'models/services_model.dart';
import 'widgets/featured_home_care_card.dart';
import 'widgets/service_card.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  void _openQRScanner() {
    QrScannerSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PatientAppBar(
        titleText: l10n?.servicesHeaderTitle ?? 'Healthcare Services',
        subtitleText: l10n?.servicesHeaderSubtitle ??
            'Clinical & Doorstep Medical Care',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Featured Top Hero Banner: Home Nursing Care (Kept identical as requested)
            const FeaturedHomeCareCard(),

            const SizedBox(height: 18),

            // 2. Primary Usability Section: Doctor & Clinical Consultations
            _buildSectionHeader(
              context: context,
              icon: Icons.local_hospital_rounded,
              title: l10n?.clinicalCareSectionTitle ?? 'DOCTOR & CLINIC VISITS',
              subtitle: l10n?.clinicalCareSectionSubtitle ??
                  'Consult verified specialists & get queue tokens',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ServiceCard(
                    service: clinicalServicesList[0], // Find Doctors
                    onQrTap: _openQRScanner,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ServiceCard(
                    service: clinicalServicesList[1], // Instant QR Token
                    onQrTap: _openQRScanner,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ServiceCard(
              service: clinicalServicesList[2], // Medical Certificate (Wide Card)
              onQrTap: _openQRScanner,
              isWide: true,
            ),

            const SizedBox(height: 18),

            // 3. Section: Doorstep Care & Diagnostics
            _buildSectionHeader(
              context: context,
              icon: Icons.home_repair_service_rounded,
              title: l10n?.doorstepCareSectionTitle ?? 'DOORSTEP HEALTHCARE',
              subtitle: l10n?.doorstepCareSectionSubtitle ??
                  'Diagnostic sample collection & prescription medicines',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ServiceCard(
                    service: doorstepServicesList[0], // Lab Tests at Home
                    onQrTap: _openQRScanner,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ServiceCard(
                    service: doorstepServicesList[1], // Medicine Delivery
                    onQrTap: _openQRScanner,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 4. Usability Section: My Activity & Booking Trackers
            _buildSectionHeader(
              context: context,
              icon: Icons.history_rounded,
              title: l10n?.myActivitySectionTitle ?? 'MY BOOKINGS & HISTORY',
              subtitle: l10n?.myActivitySectionSubtitle ??
                  'Track consultations and care orders',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildHistoryCard(
                    context: context,
                    colorScheme: colorScheme,
                    icon: Icons.calendar_month_rounded,
                    title: l10n?.doctorVisitsHistoryTitle ?? 'Doctor Visits',
                    subtitle: l10n?.doctorVisitsHistorySubtitle ??
                        'Clinic & video history',
                    badge: l10n?.appointmentsBadge ?? 'Appointments',
                    baseColor: const Color(0xFF5C6BC0),
                    actionLabel: l10n?.viewHistoryAction ?? 'View History',
                    onTap: () => context.push(AppRoutes.history),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildHistoryCard(
                    context: context,
                    colorScheme: colorScheme,
                    icon: Icons.medical_services_rounded,
                    title: l10n?.homeCareOrdersTitle ?? 'Home Care',
                    subtitle: l10n?.homeCareOrdersSubtitle ??
                        'Nursing care orders',
                    badge: l10n?.careVisitsBadge ?? 'Care Visits',
                    baseColor: const Color(0xFF00897B),
                    actionLabel: l10n?.viewHistoryAction ?? 'View History',
                    onTap: () => context.push(AppRoutes.homeCareHistory),
                  ),
                ),
              ],
            ),

            SizedBox(height: PatientBottomNav.floatingNavPadding(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required Color baseColor,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(16);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: borderRadius,
            border: Border.all(
              color: baseColor.withValues(alpha: isDark ? 0.32 : 0.18),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: baseColor.withValues(alpha: isDark ? 0.08 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: baseColor.withValues(alpha: isDark ? 0.20 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: baseColor, size: 17),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.5,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: baseColor.withValues(alpha: isDark ? 0.18 : 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: baseColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 8.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1.5),
              Text(
                subtitle,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    actionLabel,
                    style: TextStyle(
                      color: baseColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 11,
                    color: baseColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                  fontSize: 10.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

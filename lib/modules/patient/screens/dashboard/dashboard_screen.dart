import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/patient/screens/dashboard/widgets/patient_header.dart';
import 'package:yodoctor/modules/patient/widgets/custom_sliver_app_bar.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';

import '../../controllers/patient_dashboard_controller.dart';
import 'widgets/appointment_card.dart';
import 'widgets/certificate_banner.dart';
import 'widgets/token_card.dart';
import 'widgets/search_doctor_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(patientDashboardControllerProvider.notifier)
          .refreshTokenStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final state = ref.watch(patientDashboardControllerProvider);
    final loading = state.isLoading;
    final data = state.dashboardData;

    if (loading && data == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return Container(
        color: theme.scaffoldBackgroundColor,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CustomSliverAppBar(
                titleText: l10n.dashboard,
                expandedHeight: CustomSliverAppBar.defaultExpandedHeight,
                background: const PatientHeader(dashboard: null),
              ),
            ];
          },
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_off_rounded,
                      size: 48,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.dashboardLoadError,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _getLocalizedErrorMessage(state.errorMessage, l10n),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: () {
                      ref
                          .read(patientDashboardControllerProvider.notifier)
                          .loadDashboard();
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: Text(l10n.tryAgain),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final bool mobile = Responsive.isMobile(context);
    final double horizontal = Responsive.horizontalPadding(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CustomSliverAppBar(
              titleText: l10n.dashboard,
              expandedHeight: CustomSliverAppBar.defaultExpandedHeight,
              background: PatientHeader(dashboard: data),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () => ref
              .read(patientDashboardControllerProvider.notifier)
              .loadDashboard(),
          color: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontal,
                  AppSpacing.lg,
                  horizontal,
                  85,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TokenCard(token: data.todayToken),
                    const SizedBox(height: AppSpacing.lg),

                    SearchDoctorCard(isSearch: data.todayToken == null),
                    const SizedBox(height: AppSpacing.lg),

                    const CertificateBanner(),
                    const SizedBox(height: AppSpacing.xl),

                    _buildSectionHeader(
                      context,
                      colorScheme,
                      l10n.upcomingAppointments,
                      onSeeAll: () => context.go(AppRoutes.history),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (loading)
                      LinearProgressIndicator(
                        color: colorScheme.primary,
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    _buildAppointmentsContent(data, mobile),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ColorScheme colorScheme,
    String title, {
    VoidCallback? onSeeAll,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        if (onSeeAll != null)
          InkWell(
            onTap: onSeeAll,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                l10n.viewAll,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAppointmentsContent(dynamic data, bool mobile) {
    if (data.appointments.isEmpty) return const _EmptyAppointments();
    if (mobile) {
      return Column(
        children: data.appointments
            .map<Widget>(
              (appointment) => AppointmentCard(appointment: appointment),
            )
            .toList(),
      );
    }
    return LayoutBuilder(
      builder: (context, c) {
        final double itemWidth = (c.maxWidth - AppSpacing.md) / 3;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: data.appointments
              .map<Widget>(
                (appointment) => SizedBox(
                  width: itemWidth,
                  child: AppointmentCard(appointment: appointment),
                ),
              )
              .toList(),
        );
      },
    );
  }

  String _getLocalizedErrorMessage(String? error, AppLocalizations l10n) {
    if (error == null ||
        error.isEmpty ||
        error == 'Unable to load dashboard' ||
        error == 'Failed to load dashboard') {
      return l10n.dashboardLoadErrorSubtitle;
    }
    return error;
  }
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(
              alpha: isDark ? 0.2 : 0.04,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer.withValues(alpha: 0.4),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              size: 28,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.noAppointments,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: -0.3,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.bookAppointmentSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.search),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(
              l10n.bookAppointment,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

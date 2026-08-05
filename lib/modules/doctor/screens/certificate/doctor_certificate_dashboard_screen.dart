import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_controller.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/widgets/certificate_empty_state.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/widgets/certificate_shimmer.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/widgets/certificate_summary_cards.dart';
import 'package:yodoctor/modules/doctor/screens/certificate/widgets/certificate_toolbar.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../widgets/doctor_drawer.dart';
import '../../widgets/doctor_sliver_app_bar.dart';
import 'widgets/certificate_list_cards.dart';
import '../../controllers/doctor_profile_controller.dart';

class DoctorCertificateDashboardScreen extends ConsumerStatefulWidget {
  const DoctorCertificateDashboardScreen({super.key});

  @override
  ConsumerState<DoctorCertificateDashboardScreen> createState() =>
      _DoctorCertificateDashboardScreenState();
}

class _DoctorCertificateDashboardScreenState
    extends ConsumerState<DoctorCertificateDashboardScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(doctorCertificateProvider.notifier)
            .setTabIndex(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double horizontalPadding = Responsive.horizontalPadding(context);

    final certificateState = ref.watch(doctorCertificateProvider);
    final notifier = ref.read(doctorCertificateProvider.notifier);
    final filteredCerts = notifier.filteredCertificates;
    final profileState = ref.watch(doctorProfileProvider);

    final isLoading = certificateState.loading &&
        certificateState.pendingCertificates.isEmpty &&
        certificateState.issuedCertificates.isEmpty;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.surfaceContainerLow,
      extendBodyBehindAppBar: true,
      drawer: DoctorDrawer(doctor: profileState.profile),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            DoctorSliverAppBar(
              expandedHeight: 140.0,
              background: FlexibleSpaceBar(
                title: Text(
                  'Certificate Requests',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                titlePadding: EdgeInsets.only(
                  left: horizontalPadding + 4,
                  bottom: AppSpacing.lg,
                ),
                centerTitle: false,
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                color: colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  indicatorColor: colorScheme.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                  labelStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: const [
                    Tab(text: 'All Requests'),
                    Tab(text: 'Issued Certs'),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => notifier.refresh(),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          AppSpacing.xl,
                          horizontalPadding,
                          AppSpacing.xxxl,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ Show shimmer on first load
                              if (isLoading)
                                const CertificateDashboardShimmer()
                              else ...[
                                CertificateSummaryCards(
                                  state: certificateState,
                                  notifier: notifier,
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                CertificateToolbar(
                                  searchController: _searchController,
                                  state: certificateState,
                                  notifier: notifier,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                if (filteredCerts.isEmpty)
                                  const CertificateEmptyState()
                                else
                                  CertificateListCards(
                                    certificates: filteredCerts,
                                    isIssuedTab:
                                    certificateState.activeTabIndex == 1,
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
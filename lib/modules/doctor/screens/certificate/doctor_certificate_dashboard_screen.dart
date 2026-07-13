import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_controller.dart';
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
                            _buildSummaryCards(
                              context,
                              certificateState,
                              notifier,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _buildToolbar(context, certificateState, notifier),
                            const SizedBox(height: AppSpacing.lg),
                            if (filteredCerts.isEmpty)
                              const _EmptyHistory()
                            else
                              CertificateListCards(
                                certificates: filteredCerts,
                                isIssuedTab:
                                    certificateState.activeTabIndex == 1,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    CertificateState state,
    DoctorCertificateNotifier notifier,
  ) {
    final isIssuedTab = state.activeTabIndex == 1;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: isIssuedTab
            ? [
                _buildCard(
                  context,
                  'Total Issued',
                  '${notifier.issuedCount}',
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ),
                const SizedBox(width: AppSpacing.md),
                _buildCard(
                  context,
                  'This Month',
                  '${notifier.issuedCount}',
                  colorScheme.secondary,
                  colorScheme.secondaryContainer,
                ),
                const SizedBox(width: AppSpacing.md),
                _buildCard(
                  context,
                  'Expiring Soon',
                  '1',
                  colorScheme.error,
                  colorScheme.errorContainer,
                ),
              ]
            : [
                _buildCard(
                  context,
                  'Pending Requests',
                  '${notifier.pendingCount}',
                  colorScheme.tertiary,
                  colorScheme.tertiaryContainer,
                ),
                const SizedBox(width: AppSpacing.md),
                _buildCard(
                  context,
                  'Total Requests',
                  '${notifier.totalCount}',
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ),
              ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String count,
    Color textColor,
    Color containerColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: containerColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(
    BuildContext context,
    CertificateState state,
    DoctorCertificateNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = Responsive.isMobile(context);

    final searchField = TextField(
      controller: _searchController,
      onChanged: notifier.updateSearchQuery,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: 'Search patient or ID...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colorScheme.primary,
          size: 20,
        ),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );

    final dropdownDecoration = InputDecoration(
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
    );

    final typeDropdown = DropdownButtonFormField<String>(
      initialValue: state.selectedTypeFilter,
      isExpanded: true,
      decoration: dropdownDecoration,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      dropdownColor: colorScheme.surface,
      items: const [
        DropdownMenuItem(value: 'All Types', child: Text('All Types')),
        DropdownMenuItem(
          value: 'Medical Fitness',
          child: Text('Medical Fitness'),
        ),
        DropdownMenuItem(value: 'Vaccination', child: Text('Vaccination')),
      ],
      onChanged: (val) => notifier.updateTypeFilter(val!),
    );

    final statusDropdown = DropdownButtonFormField<String>(
      initialValue: state.selectedStatusFilter,
      decoration: dropdownDecoration,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      dropdownColor: colorScheme.surface,
      items: const [
        DropdownMenuItem(value: "All Status", child: Text("All Status")),
        DropdownMenuItem(value: "PENDING", child: Text("Pending")),
        DropdownMenuItem(value: "APPROVED", child: Text("Approved")),
        DropdownMenuItem(value: "REJECTED", child: Text("Rejected")),
      ],
      onChanged: (val) => notifier.updateStatusFilter(val!),
    );

    if (isMobile) {
      return Column(
        children: [
          searchField,
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: typeDropdown),
              if (state.activeTabIndex == 0) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: statusDropdown),
              ],
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        SizedBox(width: 280, child: searchField),
        const SizedBox(width: AppSpacing.md),
        SizedBox(width: 180, child: typeDropdown),
        if (state.activeTabIndex == 0) ...[
          const SizedBox(width: AppSpacing.md),
          SizedBox(width: 170, child: statusDropdown),
        ],
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 40,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No matching records found',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_controller.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../widgets/doctor_drawer.dart';
import '../../widgets/doctor_sliver_app_bar.dart';
import 'widgets/certificate_list_cards.dart';

class DoctorCertificateDashboardScreen extends StatefulWidget {
  const DoctorCertificateDashboardScreen({super.key});

  @override
  State<DoctorCertificateDashboardScreen> createState() => _DoctorCertificateDashboardScreenState();
}

class _DoctorCertificateDashboardScreenState extends State<DoctorCertificateDashboardScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final DoctorCertificateController _controller = DoctorCertificateController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.setTabIndex(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double horizontalPadding = Responsive.horizontalPadding(context);

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final filteredCerts = _controller.filteredCertificates;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: colorScheme.surfaceContainerLow,
          extendBodyBehindAppBar: true,
          drawer: const DoctorDrawer(doctor: DummyData.currentDoctor),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                DoctorSliverAppBar(
                  expandedHeight: 140.0,
                  scaffoldKey: _scaffoldKey,
                  background: FlexibleSpaceBar(
                    title: Text(
                      'Certificate Requests',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    titlePadding: EdgeInsets.only(left: horizontalPadding + 4, bottom: AppSpacing.lg),
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
                      dividerColor: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      labelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
                          padding: EdgeInsets.fromLTRB(horizontalPadding, AppSpacing.xl, horizontalPadding, AppSpacing.xxxl),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSummaryCards(context),
                                const SizedBox(height: AppSpacing.xl),
                                _buildToolbar(context),
                                const SizedBox(height: AppSpacing.lg),
                                if (filteredCerts.isEmpty)
                                  const _EmptyHistory()
                                else
                                  CertificateListCards(
                                    certificates: filteredCerts,
                                    isIssuedTab: _controller.activeTabIndex == 1,
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
      },
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final isIssuedTab = _controller.activeTabIndex == 1;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: isIssuedTab
            ? [
          _buildCard(context, 'Total Issued', '${_controller.totalIssuedCount}', colorScheme.primary, colorScheme.primaryContainer),
          const SizedBox(width: AppSpacing.md),
          _buildCard(context, 'This Month', '${_controller.thisMonthIssuedCount}', colorScheme.secondary, colorScheme.secondaryContainer),
          const SizedBox(width: AppSpacing.md),
          _buildCard(context, 'Expiring Soon', '1', colorScheme.error, colorScheme.errorContainer),
        ]
            : [
          _buildCard(context, 'Pending Requests', '${_controller.pendingCount}', colorScheme.tertiary, colorScheme.tertiaryContainer),
          const SizedBox(width: AppSpacing.md),
          _buildCard(context, 'Total Requests', '${_controller.totalCount}', colorScheme.primary, colorScheme.primaryContainer),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String count, Color textColor, Color containerColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
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

  Widget _buildToolbar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = Responsive.isMobile(context);

    final searchField = TextField(
      controller: _searchController,
      onChanged: _controller.updateSearchQuery,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: 'Search patient or ID...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
        prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary, size: 20),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
    );

    final typeDropdown = DropdownButtonFormField<String>(
      initialValue: _controller.selectedTypeFilter,
      decoration: dropdownDecoration,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onSurface),
      dropdownColor: colorScheme.surface,
      items: const [
        DropdownMenuItem(value: 'All Types', child: Text('All Types')),
        DropdownMenuItem(value: 'Medical Fitness', child: Text('Medical Fitness')),
        DropdownMenuItem(value: 'Vaccination', child: Text('Vaccination')),
      ],
      onChanged: (val) => _controller.updateTypeFilter(val!),
    );

    final statusDropdown = DropdownButtonFormField<String>(
      initialValue: _controller.selectedStatusFilter,
      decoration: dropdownDecoration,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onSurface),
      dropdownColor: colorScheme.surface,
      items: const [
        DropdownMenuItem(value: 'All Status', child: Text('All Status')),
        DropdownMenuItem(value: 'Verification', child: Text('Verification')),
        DropdownMenuItem(value: 'Pending', child: Text('Pending')),
      ],
      onChanged: (val) => _controller.updateStatusFilter(val!),
    );

    if (isMobile) {
      return Column(
        children: [
          searchField,
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: typeDropdown),
              if (_controller.activeTabIndex == 0) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: statusDropdown),
              ]
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
        if (_controller.activeTabIndex == 0) ...[
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
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open_rounded, size: 40, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
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
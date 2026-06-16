import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../controllers/doctor_profile_controller.dart';
import '../../widgets/doctor_sliver_app_bar.dart';
import 'widgets/clinic_details_tab.dart';
import 'widgets/consultation_timings_tab.dart';
import 'widgets/documents_tab.dart';
import 'widgets/personal_info_tab.dart';
import 'widgets/practice_type_tab.dart';
import 'widgets/professional_info_tab.dart';
import 'widgets/profile_header_section.dart';

class DoctorProfileEditScreen extends StatefulWidget {
  const DoctorProfileEditScreen({super.key});

  @override
  State<DoctorProfileEditScreen> createState() => _DoctorProfileEditScreenState();
}

class _DoctorProfileEditScreenState extends State<DoctorProfileEditScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  final DoctorProfileController _profileController = DoctorProfileController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _profileController.initProfile(DummyData.currentDoctorProfile);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ChangeNotifierProvider<DoctorProfileController>.value(
      value: _profileController,
      child: Consumer<DoctorProfileController>(
        builder: (context, controller, child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: colorScheme.surfaceContainerLow,
            extendBodyBehindAppBar: true,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  DoctorSliverAppBar(
                    expandedHeight: 200.0,
                    scaffoldKey: _scaffoldKey,
                    isNavBar: false,
                    background: ProfileHeaderSection(controller: controller),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverTabBarDelegate(
                      child: Container(
                        color: colorScheme.surface,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelColor: colorScheme.primary,
                          unselectedLabelColor: colorScheme.onSurfaceVariant,
                          indicatorColor: colorScheme.primary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: colorScheme.outlineVariant.withValues(alpha: 0.5),
                          labelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                          unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                          tabs: const [
                            Tab(text: 'Personal'),
                            Tab(text: 'Professional'),
                            Tab(text: 'Clinic Details'),
                            Tab(text: 'Practice Type'),
                            Tab(text: 'Timings'),
                            Tab(text: 'Documents'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: SafeArea(
                top: false,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PersonalInfoTab(controller: controller),
                    ProfessionalInfoTab(controller: controller),
                    ClinicDetailsTab(controller: controller),
                    PracticeTypeTab(controller: controller),
                    ConsultationTimingsTab(controller: controller),
                    DocumentsTab(controller: controller),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final success = await controller.saveProfileChanges();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully! 🚀')),
                  );
                }
              },
              label: const Text('Save Profile', style: TextStyle(fontWeight: FontWeight.w800)),
              icon: const Icon(Icons.check_rounded),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
          );
        },
      ),
    );
  }

  // Widget _buildPlaceholderTab(BuildContext context, String text) {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(AppSpacing.lg),
  //     child: Center(
  //       child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
  //     ),
  //   );
  // }
}



class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Container child;
  _SliverTabBarDelegate({required this.child});

  @override double get minExtent => 48.0;
  @override double get maxExtent => 48.0;

  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;
  @override bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/controllers/doctors_management_controller.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/screens/doctors_details_screen.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/screens/widgets/doctor_overview_widget.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/screens/widgets/doctors_management_header.dart';
import 'package:yodoctor/modules/admin/screens/doctors_management/screens/widgets/empty_doctor_list_widget.dart';
import 'package:yodoctor/modules/admin/widgets/admin_drawer.dart';
import 'package:yodoctor/modules/admin/widgets/admin_sliver_app_bar.dart';
import 'package:yodoctor/modules/patient/screens/find_doctors/widgets/doctor_card.dart';

class DoctorsManagementScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    final adminController = context.watch<AdminDashboardController>();
  final data = adminController.dashboardData;
  
    return Consumer<DoctorsManagementController>(
      builder: (context, controller, child) {
        return Scaffold(
            key: _scaffoldKey,
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          drawer:AdminDrawer(admin:data!.admin),

          body: NestedScrollView(
                 headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    AdminSliverAppBar(
                      expandedHeight: 190,
                      scaffoldKey: _scaffoldKey,
                      background: DoctorsManagementHeader(),
                    ),
                  ];
                },
            body:controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
              onRefresh: controller.refreshDoctors,
              child: 
                  Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
//                         DoctorsOverviewWidget(
//   controller: controller,
// ),
            
                          const SizedBox(height: 24),
            
                          /// Search
                          SizedBox(
                            width: 350,
                            child: TextField(
                              onChanged: controller.searchDoctors,
                              decoration: InputDecoration(
                                hintText: 'Search by name or city',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
            
                          const SizedBox(height: 15),
            SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  physics: const BouncingScrollPhysics(),
  child: Row(
    children: ['All', 'Pending', 'Approved', 'Rejected']
        .map((filter) {
      final isSelected = controller.selectedFilter == filter;

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(filter),
          selected: isSelected,
          onSelected: (_) => controller.setFilter(filter),
          showCheckmark: false,
          selectedColor:
              Theme.of(context).colorScheme.primaryContainer,
          backgroundColor:
              Theme.of(context).colorScheme.surface,
          side: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant,
          ),
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                : Theme.of(context)
                    .colorScheme
                    .onSurface,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 4,
          ),
        ),
      );
    }).toList(),
  ),
),

const SizedBox(height:5),
                          /// Doctors Grid
                      Expanded(
  child: controller.doctors.isEmpty
     ?EmptyDoctorListWidget()
      : ListView.separated(
          itemCount: controller.doctors.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return DoctorCard(
  doctor: controller.doctors[index],
  onViewDetails: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDetailsScreen(
          doctor: controller.doctors[index],
        ),
      ),
    );
  },
);
          },
        ),
),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, child: Icon(icon)),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

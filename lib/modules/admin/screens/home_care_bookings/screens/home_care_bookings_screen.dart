import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/controllers/home_care_bookings_controller.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/screens/widgets/empty_bookings_list_widget.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/screens/widgets/home_care_booking_card.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/screens/widgets/home_care_bookings_header.dart';
import 'package:yodoctor/modules/admin/widgets/admin_drawer.dart';
import 'package:yodoctor/modules/admin/widgets/admin_sliver_app_bar.dart';

class HomeCareBookingsScreen extends StatefulWidget {
  const HomeCareBookingsScreen({super.key});

  @override
  State<HomeCareBookingsScreen> createState() => _HomeCareBookingsScreenState();
}

class _HomeCareBookingsScreenState extends State<HomeCareBookingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adminController = context.watch<AdminDashboardController>();
  final data = adminController.dashboardData;
  
    return Consumer<HomeCareBookingsController>(
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
                      background: HomeCareBookingsHeader(),
                    ),
                  ];
                },
            body: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
              onRefresh: controller.refreshBookings,
              child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        /// SEARCH
                        Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: TapRegion(
                                 onTapOutside: (_) {
    FocusManager.instance.primaryFocus?.unfocus();
  },
                                child: TextField(
                                  onChanged: controller.searchBookings,
                                  decoration: InputDecoration(
                                    hintText: "Search name or service...",
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
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// STATS
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  "Total Bookings",
                                  controller.totalBookings.toString(),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: _statCard(
                                  "This Week",
                                  controller.thisWeekBookings.toString(),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(child: _statCard("Avg. Days", "1.0")),
                              const SizedBox(width: 5),
                              Expanded(
                                child: _statCard(
                                  "Services",
                                  controller.totalServices.toString(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                        if (controller.bookings.isEmpty)
                          EmptyBookingsListWidget()
                        else
                          ...controller.bookings.map(
                            (booking) => HomeCareBookingCard(
                              booking: booking,
                              onDelete: controller.deleteBooking,
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

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
             height: 42,
            child: Text(title, softWrap: true, // Sh
             style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

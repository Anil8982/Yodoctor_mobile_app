import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/controllers/enquiry_controller.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/screens/widgets/empty_enquiry_list_widget.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/screens/widgets/enquiry_card_widget.dart';
import 'package:yodoctor/modules/admin/screens/enquiries/screens/widgets/enquiry_header.dart';
import 'package:yodoctor/modules/admin/widgets/admin_drawer.dart';
import 'package:yodoctor/modules/admin/widgets/admin_sliver_app_bar.dart';

class EnquiryScreen extends StatefulWidget {
  const EnquiryScreen({super.key});

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
final adminController = context.watch<AdminDashboardController>();
  final data = adminController.dashboardData;
  
    return Consumer<EnquiryController>(
      builder: (context, controller, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
drawer:AdminDrawer(admin:data!.admin),
          body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                AdminSliverAppBar(
                  expandedHeight: 190.0,
                  scaffoldKey: _scaffoldKey,
                  background: EnquiryHeader(),
                ),
              ];
            },

            body:  controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  :controller.enquiries.isEmpty
        ? EmptyEnquiryListWidget()
        : RefreshIndicator(
              onRefresh: controller.refreshEnquiries,
              child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                        physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.enquiries.length,
                      itemBuilder: (context, index) {
                        final enquiry = controller.enquiries[index];

                        return EnquiryCard(
                            enquiry: enquiry,
                           isExpanded: controller.isCardExpanded(index),

    onTap: () {
      controller.toggleExpansion(index);
    },

    onDelete: () {
      controller.deleteEnquiry(enquiry.id);
    },
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
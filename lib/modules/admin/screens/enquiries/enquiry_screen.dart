import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:yodoctor/modules/admin/controllers/enquiry_controller.dart';
import 'package:yodoctor/modules/admin/widgets/admin_drawer.dart';
import 'package:yodoctor/modules/admin/widgets/admin_sliver_app_bar.dart';

import 'widgets/empty_enquiry_list_widget.dart';
import 'widgets/enquiry_card_widget.dart';
import 'widgets/enquiry_header.dart';

class EnquiryScreen extends ConsumerWidget {
  EnquiryScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final adminState = ref.watch(adminDashboardProvider);
    final enquiryStateAsync = ref.watch(enquiryProvider);

    return adminState.maybeWhen(
      data: (adminData) {
        final data = adminData.rawData;
        if (data == null) return const SizedBox.shrink();

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          drawer: AdminDrawer(admin: data.admin),
          body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                AdminSliverAppBar(
                  expandedHeight: 190.0,
                  scaffoldKey: _scaffoldKey,
                  background: const EnquiryHeader(),
                ),
              ];
            },
            body: enquiryStateAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(err.toString())),
              data: (enquiryState) {
                if (enquiryState.allEnquiries.isEmpty) {
                  return const EmptyEnquiryListWidget();
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(enquiryProvider.notifier).refreshEnquiries(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: enquiryState.allEnquiries.length,
                    itemBuilder: (context, index) {
                      final enquiry = enquiryState.allEnquiries[index];
                      final isExpanded = enquiryState.expandedIndex == index;

                      return EnquiryCard(
                        enquiry: enquiry,
                        isExpanded: isExpanded,
                        onTap: () {
                          ref.read(enquiryProvider.notifier).toggleExpansion(index);
                        },
                        onResolve: () {
                          ref.read(enquiryProvider.notifier).resolveEnquiry(enquiry.id);
                        },
                        onDelete: () {
                          ref.read(enquiryProvider.notifier).deleteEnquiry(enquiry.id);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
      orElse: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
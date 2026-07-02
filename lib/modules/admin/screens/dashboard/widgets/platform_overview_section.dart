import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/admin_dashboard_data.dart';

class PlatformOverviewWidget extends StatelessWidget {
  const PlatformOverviewWidget({
    super.key,
    required this.data,
  });

  final AdminDashboardData data;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final cards = [
      _OverviewCardData(
        title: 'Total Doctors',
        value: data.totalDoctors.toString(),
        subtitle: '${data.pendingApprovals} Pending',
        icon: Icons.medical_services_outlined,
        color: Colors.blue,
      ),
      _OverviewCardData(
        title: 'Total Patients',
        value: data.totalPatients.toString(),
        subtitle: 'Registered Users',
        icon: Icons.people_outline,
        color: Colors.green,
      ),
      _OverviewCardData(
        title: 'Today Appointments',
        value: data.todaysAppointments.toString(),
        subtitle: 'All Time',
        icon: Icons.calendar_month_outlined,
        color: Colors.purple,
      ),
      _OverviewCardData(
        title: 'Pending Approvals',
        value: data.pendingApprovals.toString(),
        subtitle: 'Awaiting Review',
        icon: Icons.pending_actions_outlined,
        color: Colors.orange,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PLATFORM OVERVIEW',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 2),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 0.95 : 1.25,
          ),
          itemBuilder: (context, index) {
            final item = cards[index];

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                     
                ),
               boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 20,
                    ),
                  ),

                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _OverviewCardData {
  const _OverviewCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
}
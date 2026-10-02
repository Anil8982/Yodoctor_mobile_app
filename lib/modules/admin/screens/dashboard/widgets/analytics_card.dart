import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';

class AnalyticsWidget extends ConsumerWidget {
  const AnalyticsWidget({super.key});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardStateAsync = ref.watch(adminDashboardProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return dashboardStateAsync.maybeWhen(
      data: (state) {
        final totalAppointments = state.filteredAppointments.length;
        final completedAppointments = state.filteredAppointments
            .where((e) => e.appointmentStatus == 'COMPLETED' || e.appointmentStatus == 'ACCEPTED')
            .length;
        final cancelledAppointments = state.filteredAppointments
            .where((e) => e.appointmentStatus == 'CANCELLED')
            .length;
        final pendingAppointments = state.filteredAppointments
            .where((e) => e.appointmentStatus == 'PENDING')
            .length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'APPOINTMENT ANALYTICS',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.filter_alt_outlined, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          'Filter by Date Range',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _dateField(
                            context,
                            label: 'From',
                            value: _formatDate(state.fromDate),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: state.fromDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                ref.read(adminDashboardProvider.notifier).updateDates(from: picked);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _dateField(
                            context,
                            label: 'To',
                            value: _formatDate(state.toDate),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: state.toDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                ref.read(adminDashboardProvider.notifier).updateDates(to: picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => ref.read(adminDashboardProvider.notifier).applyDateFilter(),
                        icon: const Icon(Icons.search),
                        label: const Text('Apply Filter'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (state.filterApplied && state.filteredAppointments.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          'No appointments found for selected date range',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (state.filterApplied && state.filteredAppointments.isNotEmpty)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isMobile ? 2 : 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isMobile ? 1.4 : 1.8,
                        children: [
                          _statCard(
                            title: 'Total',
                            value: totalAppointments,
                            icon: Icons.event_note_outlined,
                            gradientColors: const [Color(0xFF64B5F6), Color(0xFF42A5F5)],
                          ),
                          _statCard(
                            title: 'Completed',
                            value: completedAppointments,
                            icon: Icons.check_circle_outline,
                            gradientColors: const [Color(0xFF66BB6A), Color(0xFF43A047)],
                          ),
                          _statCard(
                            title: 'Cancelled',
                            value: cancelledAppointments,
                            icon: Icons.cancel_outlined,
                            gradientColors: const [Color(0xFFE57373), Color(0xFFD32F2F)],
                          ),
                          _statCard(
                            title: 'Pending',
                            value: pendingAppointments,
                            icon: Icons.schedule_outlined,
                            gradientColors: const [Color(0xFFFFB74D), Color(0xFFFF9800)],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _dateField(BuildContext context, {required String label, required String value, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [BoxShadow(color: Colors.black.transparency(0.05), blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 18, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard({required String title, required int value, required IconData icon, required List<Color> gradientColors}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradientColors),
        boxShadow: [BoxShadow(color: gradientColors.first.transparency(0.25), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white.transparency(0.2), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 5),
              Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
            ],
          ),
          Text(value.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
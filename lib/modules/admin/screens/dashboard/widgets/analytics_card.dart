import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/patient_appointment.dart';

class AnalyticsWidget extends StatefulWidget {
  const AnalyticsWidget({super.key, required this.appointments});

  final List<PatientAppointment> appointments;

  @override
  State<AnalyticsWidget> createState() => AnalyticsWidgetState();
}

class AnalyticsWidgetState extends State<AnalyticsWidget> {
  late DateTime fromDate;
  late DateTime toDate;

  bool _filterApplied = false;

  List<PatientAppointment> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();

    toDate = DateTime.now();
    fromDate = DateTime(toDate.year, toDate.month, 1);
  }

  @override
  void didUpdateWidget(covariant AnalyticsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.appointments != widget.appointments) {
      setState(() {
        _filterApplied = false;
        _filteredAppointments.clear();
      });
    }
  }

 void resetAnalytics() {
    final now = DateTime.now();

    setState(() {
      toDate = now;

      fromDate = DateTime(
        now.year,
        now.month,
        1,
      );

      _filterApplied = false;
      _filteredAppointments.clear();
    });
  }
  Future<void> _pickDate(bool isFrom) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      if (isFrom) {
        fromDate = pickedDate;
      } else {
        toDate = pickedDate;
      }

      // Hide previous result until user applies filter again
      _filterApplied = false;
      _filteredAppointments.clear();
    });
  }

  void _applyFilter() {
    final filtered = widget.appointments.where((appointment) {
      final date = appointment.dateTime;

      return !date.isBefore(
            DateTime(fromDate.year, fromDate.month, fromDate.day),
          ) &&
          !date.isAfter(
            DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59),
          );
    }).toList();

    setState(() {
      _filteredAppointments = filtered;
      _filterApplied = true;
    });
  }

  int get totalAppointments => _filteredAppointments.length;

  int get completedAppointments => _filteredAppointments
      .where(
        (e) =>
            e.appointmentStatus == 'COMPLETED' ||
            e.appointmentStatus == 'ACCEPTED',
      )
      .length;

  int get cancelledAppointments => _filteredAppointments
      .where((e) => e.appointmentStatus == 'CANCELLED')
      .length;

  int get pendingAppointments => _filteredAppointments
      .where((e) => e.appointmentStatus == 'PENDING')
      .length;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

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
                    const Icon(Icons.filter_alt_outlined,color: Colors.grey,),
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
                        label: 'From',
                        value: _formatDate(fromDate),
                        onTap: () => _pickDate(true),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: _dateField(
                        label: 'To',
                        value: _formatDate(toDate),
                        onTap: () => _pickDate(false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _applyFilter,
                    icon: const Icon(Icons.search),
                    label: const Text('Apply Filter'),
                  ),
                ),

                const SizedBox(height: 10),

                if (_filterApplied && _filteredAppointments.isEmpty)
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

                if (_filterApplied && _filteredAppointments.isNotEmpty)
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
  gradientColors: const [
    Color(0xFF64B5F6), // medium blue
    Color(0xFF42A5F5),
  ],
),

_statCard(
  title: 'Completed',
  value: completedAppointments,
  icon: Icons.check_circle_outline,
  gradientColors: const [
    Color(0xFF66BB6A), // medium green
    Color(0xFF43A047),
  ],
),

_statCard(
  title: 'Cancelled',
  value: cancelledAppointments,
  icon: Icons.cancel_outlined,
  gradientColors: const [
    Color(0xFFE57373), // medium red
    Color(0xFFD32F2F),
  ],
),

_statCard(
  title: 'Pending',
  value: pendingAppointments,
  icon: Icons.schedule_outlined,
  gradientColors: const [
    Color(0xFFFFB74D), // medium orange
    Color(0xFFFF9800),
  ],
),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateField({
  required String label,
  required String value,
  required VoidCallback onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 8),

      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100, // 👈 light background added
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: Colors.blueGrey,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

  Widget _statCard({
  required String title,
  required int value,
  required IconData icon,
  required List<Color> gradientColors,
}) {
  return Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ),
      boxShadow: [
        BoxShadow(
          color: gradientColors.first.withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 5),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),


          Text(
            value.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),

  );
}
}

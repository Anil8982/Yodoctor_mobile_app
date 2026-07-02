import 'package:flutter/material.dart';

class HomeCareBookingCard extends StatelessWidget {
  final dynamic booking; // keep dynamic unless you want strict model type
  final void Function(int id) onDelete;

  const HomeCareBookingCard({
    super.key,
    required this.booking,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.purple.shade50,
                child: Text(
                  booking.patientName[0].toUpperCase(),
                  style: TextStyle(
                    color: Color(0xFF8A63B5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      booking.contact,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
             OutlinedButton.icon(
  onPressed: () => _showBookingDetails(context),
  icon: const Icon(
    Icons.visibility_outlined,
    color: Color(0xFF8A63B5),
    size: 16
  ),
  label: const Text(
    "View",
    style: TextStyle(
      color: Color(0xFF8A63B5),
      fontWeight: FontWeight.w600,
    ),
  ),
  style: OutlinedButton.styleFrom(
    side: const BorderSide(
      color: Color(0xFF8A63B5),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
),
            ],
          ),
          /// FOOTER
        ],
      ),
    );
  }

  Widget _detailTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Color(0xFF8A63B5)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Booking Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _detailTile("Service", booking.service, Icons.medical_services),
                const SizedBox(height: 10),

                _detailTile("Address", booking.address, Icons.location_on),
                const SizedBox(height: 10),

               Row(
  children: [
    Expanded(
      child: _detailTile(
        "Date",
        booking.date,
        Icons.calendar_today,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _detailTile(
        "Days",
        booking.days,
        Icons.timelapse,
      ),
    ),
  ],
),
const SizedBox(height: 10),
                _detailTile("Time", booking.time, Icons.access_time),
                const SizedBox(height: 10),

                _detailTile(
                  "Health Issue",
                  booking.healthIssue,
                  Icons.health_and_safety,
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete(booking.id);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                 Expanded(
  child: ElevatedButton(
    onPressed: () => Navigator.pop(context),
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(40), // Default is around 48
      padding: const EdgeInsets.symmetric(vertical: 8),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    child: const Text("Close"),
  ),
),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
}

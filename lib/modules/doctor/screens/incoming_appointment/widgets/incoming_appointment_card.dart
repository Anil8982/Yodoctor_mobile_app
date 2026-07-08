import 'package:flutter/material.dart';
import '../../../../../core/models/doctor/incoming_appointment_model.dart';

class IncomingAppointmentCard extends StatelessWidget {
  final IncomingAppointmentModel appointment;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const IncomingAppointmentCard({
    super.key,
    required this.appointment,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = appointment.status.toUpperCase() == "PENDING";
    final isAccepted = appointment.status.toUpperCase() == "ACCEPTED";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---------------- TOP ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xff0F7898),
                backgroundImage:
                    appointment.profileImage != null &&
                        appointment.profileImage!.isNotEmpty
                    ? NetworkImage(appointment.profileImage!)
                    : null,
                child:
                    appointment.profileImage == null ||
                        appointment.profileImage!.isEmpty
                    ? Text(
                        appointment.patientName.isEmpty
                            ? "?"
                            : appointment.patientName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "${appointment.appointmentSlot} • ${appointment.appointmentDate}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// ---------------- BOTTOM ----------------
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffEAFBFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "#${appointment.tokenNumber}",
                  style: const TextStyle(
                    color: Color(0xff0F7898),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (isPending)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF8E7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "PENDING",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              if (isAccepted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffE9FFF3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "ACCEPTED",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              if (isPending)
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xff16C784),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: onAccept,
                  child: const Text("Accept"),
                ),

              if (isPending)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Color(0xffF3CACA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: onReject,
                  child: const Text("Reject"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

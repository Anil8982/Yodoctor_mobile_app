import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import '../../../../patient/models/appointment/incoming_appointment_model.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.transparency(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Avatar
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
                    appointment.patientName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),

          const SizedBox(width: 18),

          /// Name & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "${appointment.appointmentSlot} • ${appointment.appointmentDate}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /// Token
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

          const SizedBox(width: 12),

          /// Pending
          if (isPending)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          /// Accepted
          if (isAccepted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          if (isPending) ...[
            const SizedBox(width: 15),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xff16C784),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: onAccept,
              child: const Text("Accept"),
            ),

            const SizedBox(width: 10),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Color(0xffF3CACA)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: onReject,
              child: const Text("Reject"),
            ),
          ],
        ],
      ),
    );
  }
}

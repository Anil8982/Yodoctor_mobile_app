import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/screens/incoming_appointment/widgets/right_curve_clipper.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPending = appointment.status.toUpperCase() == "PENDING";
    final isAccepted = appointment.status.toUpperCase() == "ACCEPTED";

    final date = DateFormat(
      "dd MMM yyyy",
    ).format(DateTime.parse(appointment.appointmentDate));

    final isMorning = appointment.appointmentSlot.toUpperCase().contains(
      "MORNING",
    );

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ClipPath(
                      clipper: RightCurveClipper(),
                      child: Container(
                        width: 175,
                        height: 175,
                        color: isAccepted
                            ? Colors.green.shade100
                            : isPending
                            ? Colors.orange.shade100
                            : Colors.blue.shade100,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 18,
                    bottom: 8,
                    child: Icon(
                      isAccepted
                          ? Icons.check_circle_outline_rounded
                          : Icons.access_time_rounded,
                      size: 32,
                      color: isAccepted
                          ? Colors.green.withValues(alpha: .25)
                          : isPending
                          ? Colors.orange.withValues(alpha: .25)
                          : Colors.blue.withValues(alpha: .25),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.shade100,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 25,
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
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(width: 10),

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

                            const SizedBox(height: AppSpacing.xxs),

                            Row(
                              children: [
                                Icon(
                                  isMorning
                                      ? Icons.wb_sunny_outlined
                                      : Icons.nightlight_outlined,
                                  color: isMorning
                                      ? Colors.orange
                                      : Colors.deepPurple,
                                  size: 18,
                                ),

                                const SizedBox(width: AppSpacing.xxs),

                                Text(
                                  appointment.appointmentSlot
                                          .substring(0, 1)
                                          .toUpperCase() +
                                      appointment.appointmentSlot
                                          .substring(1)
                                          .toLowerCase(),
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "|",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),

                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 17,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: AppSpacing.xxs),

                                Text(
                                  date,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// token
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "#${appointment.tokenNumber.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            color: Color(0xff1565C0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    endIndent: 22,
                  ),

                  if (isAccepted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.green,
                          ),

                          SizedBox(width: 6),

                          Text(
                            "ACCEPTED",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (isPending)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: const [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.orange,
                              ),

                              SizedBox(width: 6),

                              Text(
                                "PENDING",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 45, 0),
                          child: Row(
                            children: [
                              FilledButton.icon(
                                onPressed: onAccept,
                                icon: const Icon(Icons.check_circle),
                                label: const Text("Accept"),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xff1BCB7F),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 0,
                                  ),
                                  minimumSize: const Size(80, 28),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              OutlinedButton.icon(
                                onPressed: onReject,
                                icon: const Icon(Icons.cancel),
                                label: const Text("Reject"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 0,
                                  ),
                                  minimumSize: const Size(78, 28),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

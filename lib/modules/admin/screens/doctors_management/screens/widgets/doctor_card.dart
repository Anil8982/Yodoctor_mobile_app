import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/doctor_profile.dart' show DoctorProfile;

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor, required this.onDelete});

  final DoctorProfile doctor;
  final Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(doctor.name),

          IconButton(
            onPressed: () => onDelete(doctor.id),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

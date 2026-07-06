import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/patient/doctor_profile.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onDelete,
    required this.onViewDetails,
  });

  final DoctorProfile doctor;
  final Function(String) onDelete;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(doctor.name),
        subtitle: Text(doctor.specialty),
        trailing: IconButton(
          onPressed: () => onDelete(doctor.id),
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
        onTap: onViewDetails,
      ),
    );
  }
}
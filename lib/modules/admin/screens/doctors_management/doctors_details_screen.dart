import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/admin/doctor_profile.dart';
import 'package:yodoctor/modules/admin/controllers/doctors_management_controller.dart';

class DoctorDetailsScreen extends ConsumerWidget {
  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  final DoctorProfile doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsStateAsync = ref.watch(doctorsManagementProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Details")),
      body: doctorsStateAsync.maybeWhen(
        data: (state) {
          final currentStatus = state.doctorStatuses[doctor.id] ?? 'Pending';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  child: Text(doctor.name[0], style: const TextStyle(fontSize: 30)),
                ),
                const SizedBox(height: 12),
                Text(doctor.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(doctor.specialty, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                const SizedBox(height: 8),

                Chip(
                  label: Text(currentStatus),
                  backgroundColor: currentStatus == 'Approved'
                      ? Colors.green.shade100
                      : currentStatus == 'Rejected' ? Colors.red.shade100 : Colors.orange.shade100,
                  labelStyle: TextStyle(
                      color: currentStatus == 'Approved'
                          ? Colors.green
                          : currentStatus == 'Rejected' ? Colors.red : Colors.orange
                  ),
                ),
                const SizedBox(height: 20),

                Card(
                  child: Column(
                    children: [
                      _tile(Icons.local_hospital, "Hospital", doctor.hospital),
                      _tile(Icons.work, "Experience", "${doctor.experienceYears} Years"),
                      _tile(Icons.currency_rupee, "Consultation Fee", "₹${doctor.consultationFee}"),
                      _tile(Icons.star, "Rating", "${doctor.rating} (${doctor.reviewCount} Reviews)"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      _tile(Icons.location_on, "Location", doctor.location),
                      _tile(Icons.place, "Distance", "${doctor.distanceKm} km"),
                      _tile(Icons.schedule, "Available", doctor.availableSlot),
                      _tile(Icons.language, "Languages", doctor.languages.join(", ")),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          ref.read(doctorsManagementProvider.notifier).updateDoctorStatus(doctor.id, 'Approved');
                        },
                        style: FilledButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("Approve"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          ref.read(doctorsManagementProvider.notifier).updateDoctorStatus(doctor.id, 'Rejected');
                        },
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Reject"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(doctorsManagementProvider.notifier).deleteDoctor(doctor.id);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text("Delete Doctor"),
                  ),
                ),
              ],
            ),
          );
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
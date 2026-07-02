import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/doctor_profile.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  final DoctorProfile doctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 42,
              child: Text(
                doctor.name[0],
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              doctor.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              doctor.specialty,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 8),

            Chip(
              label: const Text("Approved"),
              backgroundColor: Colors.green.shade100,
              labelStyle: const TextStyle(color: Colors.green),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  _tile(Icons.local_hospital, "Hospital", doctor.hospital),
                  _tile(Icons.work, "Experience",
                      "${doctor.experienceYears} Years"),
                  _tile(Icons.currency_rupee, "Consultation Fee",
                      "₹${doctor.consultationFee}"),
                  _tile(Icons.star, "Rating",
                      "${doctor.rating} (${doctor.reviewCount} Reviews)"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  _tile(Icons.location_on, "Location", doctor.location),
                  _tile(Icons.place, "Distance",
                      "${doctor.distanceKm} km"),
                  _tile(Icons.schedule, "Available",
                      doctor.availableSlot),
                  _tile(Icons.language, "Languages",
                      doctor.languages.join(", ")),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Approve"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Reject"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline),
                label: const Text("Delete Doctor"),
              ),
            ),
          ],
        ),
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
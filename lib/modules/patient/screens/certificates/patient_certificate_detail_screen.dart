import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/certificate_request.dart';

class PatientCertificateDetailScreen extends ConsumerWidget {
  const PatientCertificateDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(certificateProvider);

    final certificate = state.selectedCertificate;

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (certificate == null) {
      return const Scaffold(body: Center(child: Text("Certificate not found")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Certificate Detail")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text("Certificate"),
            subtitle: Text(certificate.certificateType),
          ),

          ListTile(
            title: const Text("Doctor"),
            subtitle: Text(certificate.doctorName),
          ),

          ListTile(
            title: const Text("Purpose"),
            subtitle: Text(certificate.purpose),
          ),

          ListTile(
            title: const Text("Status"),
            subtitle: Text(certificate.status),
          ),

          ListTile(
            title: const Text("Patient"),
            subtitle: Text(certificate.fullName),
          ),

          ListTile(
            title: const Text("Medical Conditions"),
            subtitle: Text(certificate.medicalConditions),
          ),

          ListTile(
            title: const Text("Medicines"),
            subtitle: Text(certificate.medications),
          ),

          ListTile(
            title: const Text("Notes"),
            subtitle: Text(certificate.notes),
          ),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            "Timeline",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 10),

          ...state.timeline.map(
            (e) => ListTile(
              leading: Icon(
                e.state == "done"
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
              ),
              title: Text(e.label),
              subtitle: Text(e.state),
            ),
          ),
        ],
      ),
    );
  }
}

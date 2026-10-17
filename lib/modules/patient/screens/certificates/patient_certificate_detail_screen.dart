import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';

import '../../controllers/certificate_request.dart';

class PatientCertificateDetailScreen extends ConsumerWidget {
  const PatientCertificateDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(certificateProvider);

    final certificate = state.selectedCertificate;

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (certificate == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(child: Text(l10n.certificateNotFound)),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(title: l10n.certificateDetails),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text(l10n.certificateLabel),
              subtitle: Text(certificate.certificateType),
            ),

            ListTile(
              title: Text(l10n.doctorLabel),
              subtitle: Text(certificate.doctorName),
            ),

            ListTile(
              title: Text(l10n.purposeLabel),
              subtitle: Text(certificate.purpose),
            ),

            ListTile(
              title: Text(l10n.statusLabel),
              subtitle: Text(certificate.status),
            ),

            ListTile(
              title: Text(l10n.patientInfoLabel),
              subtitle: Text(certificate.fullName),
            ),

            ListTile(
              title: Text(l10n.knownMedicalConditions),
              subtitle: Text(certificate.medicalConditions),
            ),

            ListTile(
              title: Text(l10n.medicinesLabel),
              subtitle: Text(certificate.medications),
            ),

            ListTile(
              title: Text(l10n.notesLabel),
              subtitle: Text(certificate.notes),
            ),

            const Divider(),

            const SizedBox(height: 20),

            Text(
              l10n.timelineLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../controllers/medical_certificate.dart';

class CertificatePreviewDialog extends StatelessWidget {
  const CertificatePreviewDialog({super.key, required this.certificate});

  final MedicalCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateStr = DateFormat('dd MMM yyyy').format(certificate.issuedDate ?? certificate.requestDate);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Certificate Document',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Formal Document Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Hospital / Doctor Header
                    Icon(Icons.health_and_safety, color: colorScheme.primary, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      certificate.doctor.hospital.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Contact: info@yodoctor.com',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const Divider(height: 24, thickness: 1.5),

                    // Document Title
                    Text(
                      '${certificate.type.toUpperCase()} CERTIFICATE',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ref: ${certificate.id}',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 20),

                    // Certificate Text content
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TO WHOM IT MAY CONCERN',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87, height: 1.5),
                        children: [
                          const TextSpan(text: 'This is to certify that '),
                          TextSpan(
                            text: certificate.patientName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ', age/DOB: ${certificate.dateOfBirth}, gender: ${certificate.gender}, '
                                'has been medical examined by me. Based on the evaluation, patient height: ${certificate.heightCm.toInt()} cm, '
                                'weight: ${certificate.weightKg.toInt()} kg, and medical conditions: "${certificate.medicalConditions}", '
                                'the patient is declared to be in ',
                          ),
                          TextSpan(
                            text: 'GOOD HEALTH AND FIT',
                            style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
                          ),
                          TextSpan(
                            text: ' for the purpose of "${certificate.purpose}".',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Signature & Date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date of Issue:',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              dateStr,
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1)),
                              ),
                              child: Center(
                                child: Text(
                                  certificate.doctor.name.split(' ').last,
                                  style: const TextStyle(fontFamily: 'Courier', fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              certificate.doctor.name,
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              certificate.doctor.specialty,
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Certificate PDF downloaded successfully!'),
                        ],
                      ),
                      backgroundColor: colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download PDF'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

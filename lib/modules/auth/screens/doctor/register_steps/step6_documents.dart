import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'shared_widgets.dart';

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  STEP 6 â€” DOCUMENTS
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class Step6Documents extends StatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext, onBack;
  const Step6Documents({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });
  @override
  State<Step6Documents> createState() => _Step6DocumentsState();
}

class _Step6DocumentsState extends State<Step6Documents> {
  void _simulateUpload(String field) => setState(() {
    switch (field) {
      case 'profile':
        widget.data.profileFile = 'profile_photo.jpg';
        break;
      case 'certificate':
        widget.data.certificateFile = 'medical_certificate.pdf';
        break;
      case 'idProof':
        widget.data.idProofFile = 'government_id.pdf';
        break;
      case 'clinicProof':
        widget.data.clinicProofFile = 'clinic_proof.pdf';
        break;
    }
  });

  String? _getFile(String field) {
    switch (field) {
      case 'profile':
        return widget.data.profileFile;
      case 'certificate':
        return widget.data.certificateFile;
      case 'idProof':
        return widget.data.idProofFile;
      case 'clinicProof':
        return widget.data.clinicProofFile;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepCard(
      children: [
         StepTitle(
          icon: Icons.folder_rounded,
          title: 'Upload Documents',
          color: AppTheme.yoBlue,
        ),
        const SizedBox(height: 24),
        UploadBox(
          icon: Icons.camera_alt_rounded,
          label: 'Profile Picture *',
          field: 'profile',
          uploadedFile: _getFile('profile'),
          onTap: () => _simulateUpload('profile'),
        ),
        const SizedBox(height: 14),
        UploadBox(
          icon: Icons.description_rounded,
          label: 'Medical Registration Certificate *',
          field: 'certificate',
          uploadedFile: _getFile('certificate'),
          onTap: () => _simulateUpload('certificate'),
        ),
        const SizedBox(height: 14),
        UploadBox(
          icon: Icons.badge_rounded,
          label: 'Government ID Proof *',
          field: 'idProof',
          uploadedFile: _getFile('idProof'),
          onTap: () => _simulateUpload('idProof'),
        ),
        const SizedBox(height: 14),
        UploadBox(
          icon: Icons.business_rounded,
          label: 'Clinic Establishment Proof (Optional)',
          field: 'clinicProof',
          uploadedFile: _getFile('clinicProof'),
          onTap: () => _simulateUpload('clinicProof'),
        ),
        const SizedBox(height: 20),
        const InfoBox(
          text:
              'All documents are encrypted and stored securely. Access is restricted to admin verification only.',
        ),
        const SizedBox(height: 28),
        NavButtons(
          onBack: widget.onBack,
          onNext: () {
            if (widget.data.profileFile == null ||
                widget.data.certificateFile == null ||
                widget.data.idProofFile == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Please upload all required documents'),
                  backgroundColor: AppTheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              return;
            }
            widget.onNext();
          },
        ),
      ],
    );
  }
}


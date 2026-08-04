import 'dart:io';

import 'package:chroma_kit/chroma_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/info_box.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_card.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_title.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart'; // 👈 AppSnackBar Import

import '../widgets/nav_buttons.dart';

class Step6Documents extends ConsumerStatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step6Documents({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step6Documents> createState() => _Step6DocumentsState();
}

class _Step6DocumentsState extends ConsumerState<Step6Documents> {
  Future<void> _pickFile(String field) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);

    setState(() {
      switch (field) {
        case "profile":
          widget.data.profileFile = file;
          break;
        case "certificate":
          widget.data.certificateFile = file;
          break;
        case "idProof":
          widget.data.idProofFile = file;
          break;
        case "clinicProof":
          widget.data.clinicProofFile = file;
          break;
      }
    });
  }

  void _removeFile(String field) {
    setState(() {
      switch (field) {
        case "profile":
          widget.data.profileFile = null;
          break;
        case "certificate":
          widget.data.certificateFile = null;
          break;
        case "idProof":
          widget.data.idProofFile = null;
          break;
        case "clinicProof":
          widget.data.clinicProofFile = null;
          break;
      }
    });
  }

  String? _getFileName(String field) {
    File? file;
    switch (field) {
      case "profile":
        file = widget.data.profileFile;
        break;
      case "certificate":
        file = widget.data.certificateFile;
        break;
      case "idProof":
        file = widget.data.idProofFile;
        break;
      case "clinicProof":
        file = widget.data.clinicProofFile;
        break;
    }
    if (file == null) return null;
    return file.path.split(Platform.pathSeparator).last;
  }

  Future<void> _handleNext() async {
    if (widget.data.profileFile == null ||
        widget.data.certificateFile == null ||
        widget.data.idProofFile == null) {
      AppSnackBar.show(
        message: 'Please upload all required documents (Profile, Certificate & ID Proof)',
        type: AppSnackBarType.warning,
      );
      return;
    }

    final success = await ref
        .read(doctorRegisterControllerProvider.notifier)
        .saveStep6(widget.data);

    if (!mounted) return;

    if (success) {
      AppSnackBar.show(
        message: 'Documents uploaded successfully!',
        type: AppSnackBarType.success,
      );
      widget.onNext();
    } else {
      final errorMsg = ref.read(doctorRegisterControllerProvider).errorMessage;
      AppSnackBar.show(
        message: errorMsg ?? "Step 6 document upload failed. Try again.",
        type: AppSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final registerState = ref.watch(doctorRegisterControllerProvider);

    return StepCard(
      children: [
        StepTitle(
          icon: Icons.folder_outlined,
          title: 'Upload Documents',
          subtitle: 'Upload required medical credentials and identity proofs',
          color: colorScheme.primary,
        ),
        const SizedBox(height: 24),

        _buildDocumentTile(
          field: 'profile',
          label: 'Profile Picture *',
          icon: Icons.camera_alt_outlined,
          description: 'Clear photo showing face clearly (JPG, PNG)',
        ),
        const SizedBox(height: 14),
        _buildDocumentTile(
          field: 'certificate',
          label: 'Medical Registration Certificate *',
          icon: Icons.verified_outlined,
          description: 'Official degree or state council certificate (PDF, Image)',
        ),
        const SizedBox(height: 14),
        _buildDocumentTile(
          field: 'idProof',
          label: 'Government ID Proof *',
          icon: Icons.badge_outlined,
          description: 'Aadhaar Card, PAN Card, or Passport (PDF, Image)',
        ),
        const SizedBox(height: 14),
        _buildDocumentTile(
          field: 'clinicProof',
          label: 'Clinic Establishment Proof (Optional)',
          icon: Icons.business_outlined,
          description: 'Electricity bill, registration, or lease deed',
        ),

        const SizedBox(height: 24),
        const InfoBox(
          text:
          'All documents are encrypted and stored securely. Access is restricted to official verification admins only.',
        ),
        const SizedBox(height: 28),

        NavButtons(
          onBack: widget.onBack,
          onNext: registerState.isLoading ? null : _handleNext,
        ),
      ],
    );
  }

  Widget _buildDocumentTile({
    required String field,
    required String label,
    required IconData icon,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final fileName = _getFileName(field);
    final isUploaded = fileName != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUploaded
            ? colorScheme.primary.transparency(0.06)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded
              ? colorScheme.primary
              : colorScheme.outlineVariant.transparency(0.5),
          width: isUploaded ? 1.5 : 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUploaded
                  ? colorScheme.primary
                  : colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUploaded ? Icons.check_rounded : icon,
              color: isUploaded
                  ? colorScheme.onPrimary
                  : colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isUploaded ? fileName : description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: isUploaded
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isUploaded ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUploaded)
            IconButton(
              icon: Icon(
                Icons.cancel_rounded,
                color: colorScheme.error.transparency(0.8),
                size: 22,
              ),
              onPressed: () => _removeFile(field),
              tooltip: 'Remove document',
            )
          else
            TextButton(
              onPressed: () => _pickFile(field),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Upload'),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'document_upload_tile.dart';
import 'step_header_helper.dart';

class Step3DocumentUpload extends ConsumerWidget {
  final CertificateNotifier controller;

  const Step3DocumentUpload({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current form state reactively for dynamic uploads and verification errors
    final formState = ref.watch(certificateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(title: 'Upload Supporting Files', desc: 'Provide documentation for validation processing.'),
        const SizedBox(height: 20),
        DocumentUploadTile(
          label: 'Profile Photo',
          hint: 'Upload your profile picture (jpg, png)',
          isRequired: true,
          hasError: formState.showValidationError && formState.uploadedDocs['Profile Photo'] == null,
          uploadedFileName: formState.uploadedDocs['Profile Photo'],
          uploadProgress: formState.uploadProgress['Profile Photo'],
          onUpload: (fileName) => controller.uploadDocument('Profile Photo', fileName),
          onRemove: () => controller.removeDocument('Profile Photo'),
        ),
        DocumentUploadTile(
          label: 'Government ID Proof',
          hint: 'Official Identity Documentation',
          isRequired: true,
          hasError: formState.showValidationError && formState.uploadedDocs['Government ID Proof'] == null,
          uploadedFileName: formState.uploadedDocs['Government ID Proof'],
          uploadProgress: formState.uploadProgress['Government ID Proof'],
          onUpload: (fileName) => controller.uploadDocument('Government ID Proof', fileName),
          onRemove: () => controller.removeDocument('Government ID Proof'),
        ),
        DocumentUploadTile(
          label: 'Medical Reports',
          hint: 'Previous diagnostic data reports',
          uploadedFileName: formState.uploadedDocs['Medical Reports'],
          uploadProgress: formState.uploadProgress['Medical Reports'],
          onUpload: (fileName) => controller.uploadDocument('Medical Reports', fileName),
          onRemove: () => controller.removeDocument('Medical Reports'),
        ),
        DocumentUploadTile(
          label: 'Prescription',
          hint: "Doctor's authorized prescriptions",
          uploadedFileName: formState.uploadedDocs['Prescription'],
          uploadProgress: formState.uploadProgress['Prescription'],
          onUpload: (fileName) => controller.uploadDocument('Prescription', fileName),
          onRemove: () => controller.removeDocument('Prescription'),
        ),
      ],
    );
  }
}
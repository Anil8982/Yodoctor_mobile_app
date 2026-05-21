import 'package:flutter/material.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'document_upload_tile.dart';
import 'step_header_helper.dart';

class Step3DocumentUpload extends StatelessWidget {
  final CertificateController controller;

  const Step3DocumentUpload({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(title: 'Upload Supporting Files', desc: 'Provide documentation for validation processing.'),
        const SizedBox(height: 20),
        DocumentUploadTile(
          label: 'Profile Photo',
          hint: 'Upload your profile picture (jpg, png)',
          isRequired: true,
          uploadedFileName: controller.getUploadedDoc('Profile Photo'),
          uploadProgress: controller.getUploadProgress('Profile Photo'),
          onUpload: (fileName) => controller.uploadDocument('Profile Photo', fileName),
          onRemove: () => controller.removeDocument('Profile Photo'),
        ),
        DocumentUploadTile(
          label: 'Government ID Proof',
          hint: 'Official Identity Documentation',
          isRequired: true,
          uploadedFileName: controller.getUploadedDoc('Government ID Proof'),
          uploadProgress: controller.getUploadProgress('Government ID Proof'),
          onUpload: (fileName) => controller.uploadDocument('Government ID Proof', fileName),
          onRemove: () => controller.removeDocument('Government ID Proof'),
        ),
        DocumentUploadTile(
          label: 'Medical Reports',
          hint: 'Previous diagnostic data reports',
          uploadedFileName: controller.getUploadedDoc('Medical Reports'),
          uploadProgress: controller.getUploadProgress('Medical Reports'),
          onUpload: (fileName) => controller.uploadDocument('Medical Reports', fileName),
          onRemove: () => controller.removeDocument('Medical Reports'),
        ),
        DocumentUploadTile(
          label: 'Prescription',
          hint: "Doctor's authorized prescriptions",
          uploadedFileName: controller.getUploadedDoc('Prescription'),
          uploadProgress: controller.getUploadProgress('Prescription'),
          onUpload: (fileName) => controller.uploadDocument('Prescription', fileName),
          onRemove: () => controller.removeDocument('Prescription'),
        ),
      ],
    );
  }
}
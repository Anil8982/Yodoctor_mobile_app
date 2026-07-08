import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'shared_widgets.dart';

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';

//  STEP 6  DOCUMENTS

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
  Future<void> _pickFile(String field) async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

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

  String? _getFile(String field) {
    switch (field) {
      case "profile":
        return widget.data.profileFile?.path.split("/").last;

      case "certificate":
        return widget.data.certificateFile?.path.split("/").last;

      case "idProof":
        return widget.data.idProofFile?.path.split("/").last;

      case "clinicProof":
        return widget.data.clinicProofFile?.path.split("/").last;
    }

    return null;
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
          onTap: () => _pickFile('profile'),
        ),
        const SizedBox(height: 14),
        UploadBox(
          icon: Icons.description_rounded,
          label: 'Medical Registration Certificate *',
          field: 'certificate',
          uploadedFile: _getFile('certificate'),
          onTap: () => _pickFile('certificate'),
        ),
        const SizedBox(height: 14),
        UploadBox(
          icon: Icons.badge_rounded,
          label: 'Government ID Proof *',
          field: 'idProof',
          uploadedFile: _getFile('idProof'),
          onTap: () => _pickFile('idProof'),
        ),
        const SizedBox(height: 14),
        UploadBox(
          icon: Icons.business_rounded,
          label: 'Clinic Establishment Proof (Optional)',
          field: 'clinicProof',
          uploadedFile: _getFile('clinicProof'),
          onTap: () => _pickFile('clinicProof'),
        ),
        const SizedBox(height: 20),
        const InfoBox(
          text:
              'All documents are encrypted and stored securely. Access is restricted to admin verification only.',
        ),
        const SizedBox(height: 28),
        NavButtons(
          onBack: widget.onBack,
          onNext: () async {
            if (widget.data.profileFile == null ||
                widget.data.certificateFile == null ||
                widget.data.idProofFile == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please upload all required documents"),
                ),
              );
              return;
            }

            final controller = context.read<DoctorRegisterController>();

            final ok = await controller.saveStep6(widget.data);

            if (!mounted) return;

            if (ok) {
              widget.onNext();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(controller.error ?? "Step 6 Failed")),
              );
            }
          },
        ),
      ],
    );
  }
}

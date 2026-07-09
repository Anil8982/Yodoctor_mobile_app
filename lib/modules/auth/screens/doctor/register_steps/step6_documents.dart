import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'nav_buttons.dart';
import 'shared_widgets.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class Step6Documents extends ConsumerStatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext, onBack;

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
    final result = await FilePicker.pickFiles();

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

  // 🎯 NEW: Added explicit doc remove logic to flush selected assets from model memory
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
    final colorScheme = Theme.of(context).colorScheme;
    final registerState = ref.watch(doctorRegisterControllerProvider);

    return StepCard(
      children: [
        StepTitle(
          icon: Icons.folder_rounded,
          title: 'Upload Documents',
          color: colorScheme.primary,
        ),
        const SizedBox(height: 24),

        // 🎯 FIXED UX: Wrapped with conditional layout stacks to support seamless document unlinking safely
        _buildDocumentRow(
          field: 'profile',
          label: 'Profile Picture *',
          icon: Icons.camera_alt_rounded,
        ),
        const SizedBox(height: 14),
        _buildDocumentRow(
          field: 'certificate',
          label: 'Medical Registration Certificate *',
          icon: Icons.description_rounded,
        ),
        const SizedBox(height: 14),
        _buildDocumentRow(
          field: 'idProof',
          label: 'Government ID Proof *',
          icon: Icons.badge_rounded,
        ),
        const SizedBox(height: 14),
        _buildDocumentRow(
          field: 'clinicProof',
          label: 'Clinic Establishment Proof (Optional)',
          icon: Icons.business_rounded,
        ),

        const SizedBox(height: 20),
        const InfoBox(
          text: 'All documents are encrypted and stored securely. Access is restricted to admin verification only.',
        ),
        const SizedBox(height: 28),
        NavButtons(
          onBack: widget.onBack,
          onNext: registerState.isLoading ? null : () async {
            if (widget.data.profileFile == null ||
                widget.data.certificateFile == null ||
                widget.data.idProofFile == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Please upload all required documents", style: TextStyle(fontWeight: FontWeight.w600)),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: colorScheme.error,
                ),
              );
              return;
            }

            final success = await ref
                .read(doctorRegisterControllerProvider.notifier)
                .saveStep6(widget.data);

            if (!context.mounted) return;

            if (success) {
              widget.onNext();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ref.read(doctorRegisterControllerProvider).errorMessage ?? "Step 6 Failed"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  // Helper widget builder to keep layout clean and integrate the removal close action trigger seamlessly
  Widget _buildDocumentRow({
    required String field,
    required String label,
    required IconData icon,
  }) {
    final fileName = _getFile(field);

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        UploadBox(
          icon: icon,
          label: label,
          field: field,
          uploadedFile: fileName,
          onTap: () => _pickFile(field),
        ),
        if (fileName != null)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(Icons.cancel_rounded, color: Theme.of(context).colorScheme.error.transparency(0.8), size: 24),
              onPressed: () => _removeFile(field),
              tooltip: 'Remove document',
            ),
          ),
      ],
    );
  }
}
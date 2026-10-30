import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:yodoctor/core/utils/attachment_utils.dart';
import 'package:yodoctor/modules/doctor/controllers/prescription_controller.dart';
import 'package:yodoctor/modules/doctor/models/appointment/prescription_model.dart';
import 'package:yodoctor/modules/widgets/app_attachment_preview.dart';
import 'package:yodoctor/modules/widgets/app_button.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class ViewPrescriptionScreen extends ConsumerStatefulWidget {
  final String appointmentId;
  final String? patientName;
  final String? tokenNumber;

  const ViewPrescriptionScreen({
    super.key,
    required this.appointmentId,
    this.patientName,
    this.tokenNumber,
  });

  @override
  ConsumerState<ViewPrescriptionScreen> createState() =>
      _ViewPrescriptionScreenState();
}

class _ViewPrescriptionScreenState
    extends ConsumerState<ViewPrescriptionScreen> {
  bool _isLoading = true;
  bool _isUploadingAttachment = false;
  bool _isDownloadingPdf = false;
  String? _errorMessage;
  PrescriptionModel? _prescription;

  File? _selectedLocalAttachment;
  bool _isProcessingAttachment = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchPrescription();
      }
    });
  }

  Future<void> _fetchPrescription() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final controller = ref.read(prescriptionControllerProvider.notifier);
      final rx = await controller.getPrescription(widget.appointmentId);
      if (mounted) {
        setState(() {
          _prescription = rx;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to load prescription. Please check your internet connection and try again.';
        });
      }
    }
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );

      if (result == null || result.paths.isEmpty) return;
      final validPaths = result.paths.whereType<String>().toList();
      if (validPaths.isEmpty) return;

      setState(() {
        _isProcessingAttachment = true;
      });

      if (!mounted) return;
      AppSnackBar.show(
        message: 'Processing and compressing document...',
        type: AppSnackBarType.info,
      );

      final processedFile = await AttachmentUtils.processAttachment(
        validPaths,
        maxFileSizeMb: 1.0,
      );

      if (mounted) {
        setState(() {
          _selectedLocalAttachment = processedFile;
          _isProcessingAttachment = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessingAttachment = false;
        });
        AppSnackBar.show(
          message: 'Unable to process document. Please try again.',
          type: AppSnackBarType.error,
        );
      }
    }
  }

  void _removeLocalAttachment() {
    setState(() {
      _selectedLocalAttachment = null;
    });
  }

  Future<void> _uploadSelectedAttachment() async {
    if (_selectedLocalAttachment == null) return;

    setState(() {
      _isUploadingAttachment = true;
    });

    try {
      final success = await ref
          .read(prescriptionControllerProvider.notifier)
          .uploadPrescription(
            appointmentId: widget.appointmentId,
            filePath: _selectedLocalAttachment!.path,
          );

      if (mounted) {
        if (success) {
          AppSnackBar.show(
            message: 'Attachment uploaded successfully!',
            type: AppSnackBarType.success,
          );
          setState(() {
            _selectedLocalAttachment = null;
          });
          await _fetchPrescription();
        } else {
          AppSnackBar.show(
            message: 'Failed to upload attachment. Please try again.',
            type: AppSnackBarType.error,
          );
        }
      }
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(
          message: 'Unable to upload attachment. Please try again.',
          type: AppSnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAttachment = false;
        });
      }
    }
  }

  Future<void> _downloadAndPreviewPdf() async {
    setState(() {
      _isDownloadingPdf = true;
    });

    try {
      final bytes = await ref
          .read(prescriptionControllerProvider.notifier)
          .downloadPrescription(
            appointmentId: widget.appointmentId,
            format: 'pdf',
          );

      if (bytes != null && bytes.isNotEmpty && mounted) {
        await AppAttachmentPreview.show(
          context,
          bytes: Uint8List.fromList(bytes),
          title: 'Prescription_${widget.appointmentId}.pdf',
        );
      } else if (mounted) {
        AppSnackBar.show(
          message: 'Unable to download prescription PDF.',
          type: AppSnackBarType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          message: 'Unable to download prescription PDF. Please try again.',
          type: AppSnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloadingPdf = false;
        });
      }
    }
  }

  void _previewExistingAttachment(String attachmentUrl) {
    AppAttachmentPreview.show(
      context,
      url: attachmentUrl,
      title: 'Prescription Attachment',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppHeader(
        title: 'Prescription Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _fetchPrescription,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView(colorScheme)
              : _prescription == null
                  ? _buildNotFoundView(colorScheme)
                  : _buildPrescriptionContent(colorScheme),
    );
  }

  Widget _buildErrorView(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load prescription',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _fetchPrescription,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundView(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 56, color: colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'No Prescription Found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prescription details could not be found for this appointment.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionContent(ColorScheme colorScheme) {
    final rx = _prescription!;
    final patientName = rx.patient?.name ?? widget.patientName ?? 'Patient';
    final token = rx.tokenNumber?.toString() ?? widget.tokenNumber ?? '-';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Patient info summary banner
          _buildPatientHeader(patientName, token, colorScheme),
          const SizedBox(height: 16),

          // Symptoms
          if (rx.symptoms.isNotEmpty) ...[
            _buildSectionCard(
              title: 'Symptoms',
              icon: Icons.sick_outlined,
              colorScheme: colorScheme,
              child: _buildChips(rx.symptoms, colorScheme),
            ),
            const SizedBox(height: 14),
          ],

          // Diagnosis
          if (rx.diagnosis.isNotEmpty) ...[
            _buildSectionCard(
              title: 'Diagnosis',
              icon: Icons.biotech_outlined,
              colorScheme: colorScheme,
              child: _buildChips(rx.diagnosis, colorScheme),
            ),
            const SizedBox(height: 14),
          ],

          // Medicines
          _buildMedicinesSection(rx.medicines, colorScheme),
          const SizedBox(height: 14),

          // Tests
          if (rx.tests.isNotEmpty) ...[
            _buildSectionCard(
              title: 'Lab / Diagnostic Tests',
              icon: Icons.science_outlined,
              colorScheme: colorScheme,
              child: _buildChips(rx.tests, colorScheme),
            ),
            const SizedBox(height: 14),
          ],

          // Advice
          if (rx.advice.isNotEmpty) ...[
            _buildSectionCard(
              title: 'Advice / Instructions',
              icon: Icons.lightbulb_outline,
              colorScheme: colorScheme,
              child: _buildChips(rx.advice, colorScheme),
            ),
            const SizedBox(height: 14),
          ],

          // Follow-up
          if ((rx.followUpAfter != null && rx.followUpAfter!.trim().isNotEmpty) ||
              (rx.followUpDate != null && rx.followUpDate!.trim().isNotEmpty) ||
              (rx.followUpNotes != null && rx.followUpNotes!.trim().isNotEmpty)) ...[
            _buildFollowUpCard(rx, colorScheme),
            const SizedBox(height: 14),
          ],

          // Attached Document
          _buildAttachmentCard(rx.uploadedPrescription, colorScheme),
          const SizedBox(height: 24),

          // Action Buttons: Download PDF
          AppButton(
            label: 'Download / View Prescription PDF',
            leading: const Icon(Icons.picture_as_pdf_rounded, size: 20),
            isLoading: _isDownloadingPdf,
            onPressed: _downloadAndPreviewPdf,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPatientHeader(String name, String token, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'P',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Token: $token',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Appt # ${widget.appointmentId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required ColorScheme colorScheme,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildChips(List<String> items, ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicinesSection(
      List<PrescriptionMedicine> medicines, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medication_outlined, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Medicines (${medicines.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (medicines.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No medicines listed in this prescription.',
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicines.length,
                separatorBuilder: (context, index) => const Divider(height: 20),
                itemBuilder: (context, index) {
                  final med = medicines[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    med.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (med.dosage.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      med.dosage,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSecondaryContainer,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                if (med.frequency.isNotEmpty)
                                  _buildTag(
                                    label: 'Freq: ${med.frequency}',
                                    icon: Icons.repeat_rounded,
                                    colorScheme: colorScheme,
                                  ),
                                if (med.duration.isNotEmpty)
                                  _buildTag(
                                    label: 'Duration: ${med.duration}',
                                    icon: Icons.timelapse_rounded,
                                    colorScheme: colorScheme,
                                  ),
                              ],
                            ),
                            if (med.instructions.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                'Note: ${med.instructions}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpCard(PrescriptionModel rx, ColorScheme colorScheme) {
    return _buildSectionCard(
      title: 'Follow-up Details',
      icon: Icons.event_repeat_outlined,
      colorScheme: colorScheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rx.followUpDate != null && rx.followUpDate!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16),
                  const SizedBox(width: 8),
                  Text('Date: ${rx.followUpDate!.trim()}'),
                ],
              ),
            ),
          if (rx.followUpAfter != null && rx.followUpAfter!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.schedule_outlined, size: 16),
                  const SizedBox(width: 8),
                  Text('After: ${rx.followUpAfter!.trim()}'),
                ],
              ),
            ),
          if (rx.followUpNotes != null && rx.followUpNotes!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Notes: ${rx.followUpNotes!.trim()}',
                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttachmentCard(String? attachmentUrl, ColorScheme colorScheme) {
    final hasAttachment = attachmentUrl != null && attachmentUrl.trim().isNotEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: hasAttachment
              ? colorScheme.primary.withValues(alpha: 0.4)
              : colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attachment_rounded,
                  size: 20,
                  color: hasAttachment ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Attachment / Document',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasAttachment && _selectedLocalAttachment == null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      attachmentUrl.toLowerCase().endsWith('.pdf')
                          ? Icons.picture_as_pdf_rounded
                          : Icons.image_rounded,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Prescription Attachment',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            attachmentUrl.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => _previewExistingAttachment(attachmentUrl),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('Preview'),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _isUploadingAttachment || _isProcessingAttachment ? null : _pickAttachment,
                  icon: const Icon(Icons.upload_file_rounded, size: 16),
                  label: const Text('Replace Attachment'),
                ),
              ),
            ] else if (_selectedLocalAttachment != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      p.extension(_selectedLocalAttachment!.path).toLowerCase() == '.pdf'
                          ? Icons.picture_as_pdf_rounded
                          : Icons.image_rounded,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.basename(_selectedLocalAttachment!.path),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            children: [
                              Text(
                                AttachmentUtils.formatFileSize(
                                  _selectedLocalAttachment!.lengthSync(),
                                ),
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Ready to upload",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: "Preview",
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.visibility_outlined,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      onPressed: () => AppAttachmentPreview.show(
                        context,
                        file: _selectedLocalAttachment,
                        title: p.basename(_selectedLocalAttachment!.path),
                      ),
                    ),
                    IconButton(
                      tooltip: "Remove",
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      onPressed: _isUploadingAttachment ? null : _removeLocalAttachment,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isUploadingAttachment ? null : _uploadSelectedAttachment,
                      icon: _isUploadingAttachment
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.cloud_upload_rounded, size: 18),
                      label: Text(
                        _isUploadingAttachment ? "Uploading..." : "Upload Document",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _isUploadingAttachment ? null : _pickAttachment,
                    child: const Text("Change"),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'No prescription document or lab report attached yet.',
                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
              ),
              const SizedBox(height: 14),
              FilledButton.tonalIcon(
                onPressed: _isProcessingAttachment ? null : _pickAttachment,
                icon: _isProcessingAttachment
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(
                  _isProcessingAttachment
                      ? 'Processing Document...'
                      : 'Attach Document / Report',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

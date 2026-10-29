import 'dart:io';
import 'package:chroma_kit/chroma_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/attachment_utils.dart';
import 'package:yodoctor/modules/doctor/controllers/prescription_controller.dart';
import 'package:yodoctor/modules/doctor/models/appointment/prescription_model.dart';
import 'package:yodoctor/modules/widgets/app_button.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

import 'widgets/prescription_attachment_section.dart';
import 'widgets/prescription_medicine_card.dart';
import 'widgets/prescription_patient_card.dart';
import 'widgets/prescription_section_title.dart';
import 'widgets/prescription_tag_input_section.dart';

class AddPrescriptionScreen extends ConsumerStatefulWidget {
  const AddPrescriptionScreen({
    super.key,
    required this.appointmentId,
    required this.patientName,
    required this.tokenNumber,
    this.hasPrescription = false,
  });

  final String appointmentId;
  final String patientName;
  final String tokenNumber;
  final bool hasPrescription;

  @override
  ConsumerState<AddPrescriptionScreen> createState() =>
      _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends ConsumerState<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _symptoms = [];
  final List<String> _diagnosis = [];
  final List<String> _tests = [];
  final List<String> _advice = [];

  final _symptomInputController = TextEditingController();
  final _diagnosisInputController = TextEditingController();
  final _testInputController = TextEditingController();
  final _adviceInputController = TextEditingController();

  final List<MedicineItemControllers> _medicineControllers = [];

  final _followUpAfterController = TextEditingController();
  final _followUpNotesController = TextEditingController();
  DateTime? _selectedFollowUpDate;

  String? _existingAttachmentUrl;
  int? _existingPrescriptionId;
  PrescriptionPatient? _fetchedPatient;

  File? _selectedLocalAttachment;
  bool _isProcessingAttachment = false;
  String _savingStatusText = '';

  @override
  void initState() {
    super.initState();
    if (widget.hasPrescription) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadPrescription());
    } else {
      _addEmptyMedicineRow();
    }
  }

  @override
  void dispose() {
    _symptomInputController.dispose();
    _diagnosisInputController.dispose();
    _testInputController.dispose();
    _adviceInputController.dispose();
    _followUpAfterController.dispose();
    _followUpNotesController.dispose();

    for (final controller in _medicineControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPrescription() async {
    final controller = ref.read(prescriptionControllerProvider.notifier);
    final prescription = await controller.getPrescription(widget.appointmentId);

    if (prescription != null && mounted) {
      setState(() {
        _existingPrescriptionId = prescription.prescriptionId;
        _fetchedPatient = prescription.patient;
        _existingAttachmentUrl = prescription.uploadedPrescription;

        _symptoms
          ..clear()
          ..addAll(prescription.symptoms);
        _diagnosis
          ..clear()
          ..addAll(prescription.diagnosis);
        _tests
          ..clear()
          ..addAll(prescription.tests);
        _advice
          ..clear()
          ..addAll(prescription.advice);

        _followUpAfterController.text = prescription.followUpAfter ?? '';
        _followUpNotesController.text = prescription.followUpNotes ?? '';

        if (prescription.followUpDate != null &&
            prescription.followUpDate!.trim().isNotEmpty) {
          try {
            _selectedFollowUpDate =
                DateFormat('yyyy-MM-dd').parse(prescription.followUpDate!.trim());
          } catch (_) {}
        }

        for (final item in _medicineControllers) {
          item.dispose();
        }
        _medicineControllers.clear();

        if (prescription.medicines.isNotEmpty) {
          for (int i = 0; i < prescription.medicines.length; i++) {
            final med = prescription.medicines[i];
            _medicineControllers.add(
              MedicineItemControllers(
                name: med.name,
                dosage: med.dosage,
                frequency: med.frequency,
                duration: med.duration,
                instructions: med.instructions,
                isExpanded: i == 0,
              ),
            );
          }
        }
      });
    }

    if (_medicineControllers.isEmpty) {
      _addEmptyMedicineRow();
    }
  }

  void _addEmptyMedicineRow() {
    if (_medicineControllers.isNotEmpty &&
        _medicineControllers.last.name.text.trim().isEmpty) {
      AppSnackBar.show(
        message: 'Please fill the current medicine name before adding another',
        type: AppSnackBarType.info,
      );
      setState(() {
        _medicineControllers.last.isExpanded = true;
      });
      return;
    }

    setState(() {
      for (final item in _medicineControllers) {
        item.isExpanded = false;
      }
      _medicineControllers.add(MedicineItemControllers(isExpanded: true));
    });
  }

  void _removeMedicineRow(int index) {
    setState(() {
      final removed = _medicineControllers.removeAt(index);
      removed.dispose();
      if (_medicineControllers.isNotEmpty &&
          !_medicineControllers.any((m) => m.isExpanded)) {
        _medicineControllers.last.isExpanded = true;
      }
    });
  }

  void _addTag({
    required TextEditingController controller,
    required List<String> targetList,
  }) {
    final value = controller.text.trim();
    if (value.isNotEmpty && !targetList.contains(value)) {
      setState(() {
        targetList.add(value);
        controller.clear();
      });
    }
  }

  void _flushPendingTags() {
    _addTag(controller: _symptomInputController, targetList: _symptoms);
    _addTag(controller: _diagnosisInputController, targetList: _diagnosis);
    _addTag(controller: _testInputController, targetList: _tests);
    _addTag(controller: _adviceInputController, targetList: _advice);
  }

  Future<void> _pickAttachment() async {
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

    try {
      final optimizedFile = await AttachmentUtils.processAttachment(
        validPaths,
        maxFileSizeMb: 1.0,
      );

      if (mounted) {
        setState(() {
          _selectedLocalAttachment = optimizedFile;
        });
        final sizeText =
        AttachmentUtils.formatFileSize(await optimizedFile.length());
        AppSnackBar.show(
          message: 'Document ready ($sizeText)',
          type: AppSnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          message: 'Failed to process attachment: $e',
          type: AppSnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingAttachment = false;
        });
      }
    }
  }

  Future<void> _handleSave() async {
    _flushPendingTags();

    if (!_formKey.currentState!.validate()) {
      AppSnackBar.show(
        message: 'Please complete all required fields',
        type: AppSnackBarType.warning,
      );
      return;
    }

    final medicines = _medicineControllers
        .map((c) => PrescriptionMedicine(
      name: c.name.text.trim(),
      dosage: c.dosage.text.trim(),
      frequency: c.frequency.text.trim(),
      duration: c.duration.text.trim(),
      instructions: c.instructions.text.trim(),
    ))
        .where((m) => m.name.isNotEmpty)
        .toList();

    final hasContent = _symptoms.isNotEmpty ||
        _diagnosis.isNotEmpty ||
        medicines.isNotEmpty ||
        _tests.isNotEmpty ||
        _advice.isNotEmpty ||
        _selectedLocalAttachment != null ||
        (_existingAttachmentUrl != null &&
            _existingAttachmentUrl!.isNotEmpty) ||
        _followUpAfterController.text.trim().isNotEmpty ||
        _selectedFollowUpDate != null;

    if (!hasContent) {
      AppSnackBar.show(
        message:
        'Please enter at least one medicine, clinical observation, or attachment',
        type: AppSnackBarType.warning,
      );
      return;
    }

    final prescriptionPayload = PrescriptionModel(
      prescriptionId: _existingPrescriptionId,
      appointmentId: int.tryParse(widget.appointmentId),
      symptoms: List.unmodifiable(_symptoms),
      diagnosis: List.unmodifiable(_diagnosis),
      medicines: List.unmodifiable(medicines),
      tests: List.unmodifiable(_tests),
      advice: List.unmodifiable(_advice),
      followUpAfter: _followUpAfterController.text.trim().isEmpty
          ? null
          : _followUpAfterController.text.trim(),
      followUpDate: _selectedFollowUpDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedFollowUpDate!)
          : null,
      followUpNotes: _followUpNotesController.text.trim().isEmpty
          ? null
          : _followUpNotesController.text.trim(),
      uploadedPrescription: _existingAttachmentUrl,
      tokenNumber: int.tryParse(widget.tokenNumber.replaceAll('#', '')),
    );

    setState(() {
      _savingStatusText = 'Saving prescription...';
    });

    final saveSuccess = await ref
        .read(prescriptionControllerProvider.notifier)
        .savePrescription(
      appointmentId: widget.appointmentId,
      prescription: prescriptionPayload,
    );

    if (!saveSuccess) {
      if (mounted) {
        setState(() {
          _savingStatusText = '';
        });
      }
      return;
    }

    if (_selectedLocalAttachment == null) {
      if (mounted) {
        setState(() {
          _savingStatusText = '';
        });
        AppSnackBar.show(
          message: 'Prescription saved successfully!',
          type: AppSnackBarType.success,
        );
        context.pushReplacement(
          '${AppRoutes.doctorViewPrescription.replaceFirst(':id', widget.appointmentId)}?name=${Uri.encodeComponent(widget.patientName)}&token=${Uri.encodeComponent(widget.tokenNumber)}',
        );
      }
      return;
    }

    if (mounted) {
      AppSnackBar.show(
        message: 'Prescription saved! Now uploading document...',
        type: AppSnackBarType.info,
      );
      setState(() {
        _savingStatusText = 'Uploading document...';
      });
    }

    final uploadSuccess = await ref
        .read(prescriptionControllerProvider.notifier)
        .uploadPrescription(
      appointmentId: widget.appointmentId,
      filePath: _selectedLocalAttachment!.path,
    );

    if (mounted) {
      setState(() {
        _savingStatusText = '';
      });

      if (uploadSuccess) {
        AppSnackBar.show(
          message: 'Prescription and document saved successfully!',
          type: AppSnackBarType.success,
        );
      } else {
        AppSnackBar.show(
          message:
          'Prescription saved successfully, but document upload failed. You can re-upload it from View Rx.',
          type: AppSnackBarType.warning,
        );
      }
      context.pushReplacement(
        '${AppRoutes.doctorViewPrescription.replaceFirst(':id', widget.appointmentId)}?name=${Uri.encodeComponent(widget.patientName)}&token=${Uri.encodeComponent(widget.tokenNumber)}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(prescriptionControllerProvider);

    ref.listen<PrescriptionState>(prescriptionControllerProvider, (_, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        AppSnackBar.show(
          message: next.errorMessage!,
          type: AppSnackBarType.error,
        );
        ref.read(prescriptionControllerProvider.notifier).clearMessages();
      }
    });

    final isBusy = state.saving ||
        state.uploading ||
        state.downloading ||
        _isProcessingAttachment ||
        _savingStatusText.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        title: _existingPrescriptionId != null
            ? "Edit Prescription"
            : "Add Prescription",
      ),
      body: SafeArea(
        child: state.loading
            ? Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: colorScheme.primary,
          ),
        )
            : Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrescriptionPatientCard(
                      appointmentId: widget.appointmentId,
                      patientName: widget.patientName,
                      tokenNumber: widget.tokenNumber,
                      patient: _fetchedPatient,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const PrescriptionSectionTitle(
                      title: "Clinical Observations",
                      subtitle:
                      "Symptoms presented by patient and clinical diagnosis",
                      icon: Icons.monitor_heart_outlined,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrescriptionTagInputSection(
                      label: "Symptoms",
                      hint: "Type symptom (e.g., Fever) and press Add",
                      tags: _symptoms,
                      controller: _symptomInputController,
                      icon: Icons.sick_outlined,
                      onAdd: () => _addTag(
                        controller: _symptomInputController,
                        targetList: _symptoms,
                      ),
                      onRemove: (tag) => setState(() => _symptoms.remove(tag)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrescriptionTagInputSection(
                      label: "Diagnosis",
                      hint: "Type diagnosis (e.g., Viral fever) and press Add",
                      tags: _diagnosis,
                      controller: _diagnosisInputController,
                      icon: Icons.biotech_outlined,
                      onAdd: () => _addTag(
                        controller: _diagnosisInputController,
                        targetList: _diagnosis,
                      ),
                      onRemove: (tag) => setState(() => _diagnosis.remove(tag)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PrescriptionSectionTitle(
                      title: "Medications",
                      subtitle:
                      "Prescribed pharmaceutical drugs, dosage, and schedules",
                      icon: Icons.medication_liquid_rounded,
                      trailing: TextButton.icon(
                        onPressed: isBusy ? null : _addEmptyMedicineRow,
                        icon: const Icon(Icons.add_circle_outline, size: 16),
                        label: const Text("Add Drug"),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (_medicineControllers.isEmpty) ...[
                      _buildEmptyMedicationsNotice(theme, colorScheme, isBusy),
                    ] else ...[
                      ..._medicineControllers.asMap().entries.map(
                            (entry) => PrescriptionMedicineCard(
                          index: entry.key,
                          item: entry.value,
                          isBusy: isBusy,
                          onToggleExpand: () {
                            setState(() {
                              entry.value.isExpanded =
                              !entry.value.isExpanded;
                            });
                          },
                          onRemove: () =>
                              _removeMedicineRow(entry.key),
                          onChanged: () => setState(() {}),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    const PrescriptionSectionTitle(
                      title: "Lab Tests & Medical Advice",
                      subtitle:
                      "Recommended clinical investigations and general care instructions",
                      icon: Icons.assignment_outlined,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrescriptionTagInputSection(
                      label: "Tests & Investigations",
                      hint: "Type test (e.g., CBC) and press Add",
                      tags: _tests,
                      controller: _testInputController,
                      icon: Icons.science_outlined,
                      onAdd: () => _addTag(
                        controller: _testInputController,
                        targetList: _tests,
                      ),
                      onRemove: (tag) => setState(() => _tests.remove(tag)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrescriptionTagInputSection(
                      label: "Patient Advice",
                      hint: "e.g., Drink plenty of fluids, Take adequate rest",
                      tags: _advice,
                      controller: _adviceInputController,
                      icon: Icons.health_and_safety_outlined,
                      onAdd: () => _addTag(
                        controller: _adviceInputController,
                        targetList: _advice,
                      ),
                      onRemove: (tag) => setState(() => _advice.remove(tag)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const PrescriptionSectionTitle(
                      title: "Follow-Up Consultation",
                      subtitle: "Select review date and recurrence guidance",
                      icon: Icons.calendar_month_outlined,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildFollowUpSection(theme, colorScheme, isBusy),
                    const SizedBox(height: AppSpacing.lg),
                    const PrescriptionSectionTitle(
                      title: "Prescription Attachment",
                      subtitle:
                      "Upload printed/handwritten prescription sheet or lab reports",
                      icon: Icons.attachment_rounded,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrescriptionAttachmentSection(
                      existingAttachmentUrl: _existingAttachmentUrl,
                      selectedLocalAttachment: _selectedLocalAttachment,
                      isBusy: isBusy,
                      isProcessing: _isProcessingAttachment,
                      isDownloading: state.downloading,
                      onPick: _pickAttachment,
                      onRemoveLocal: () => setState(() => _selectedLocalAttachment = null),
                      onDownloadExisting: () async {
                        await ref
                            .read(prescriptionControllerProvider.notifier)
                            .downloadPrescription(
                          appointmentId: widget.appointmentId,
                          format: 'original',
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildBottomActionButtons(
                      context,
                      isBusy: isBusy,
                      saving: state.saving,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMedicationsNotice(
      ThemeData theme,
      ColorScheme colorScheme,
      bool isBusy,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.4),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.medication_liquid_outlined,
            size: 32,
            color: colorScheme.onSurfaceVariant.transparency(0.5),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "No medications prescribed",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.tonalIcon(
            onPressed: isBusy ? null : _addEmptyMedicineRow,
            icon: const Icon(Icons.add, size: 16),
            label: const Text("Add Medication"),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpSection(
      ThemeData theme,
      ColorScheme colorScheme,
      bool isBusy,
      ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              final intervalField = AppTextField(
                label: "Follow-up Interval",
                hint: "e.g., 3 days, 1 week",
                icon: Icons.timelapse_outlined,
                controller: _followUpAfterController,
                enabled: !isBusy,
              );
              final datePickerField = AppDatePickerField(
                label: "Follow-up Date",
                hint: "Select Date",
                icon: Icons.event_outlined,
                value: _selectedFollowUpDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                enabled: !isBusy,
                onChanged: (picked) {
                  setState(() {
                    _selectedFollowUpDate = picked;
                  });
                },
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: intervalField),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: datePickerField),
                  ],
                );
              }
              return Column(
                children: [
                  intervalField,
                  const SizedBox(height: AppSpacing.sm),
                  datePickerField,
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: "Follow-up Notes",
            hint: "e.g., Follow up if fever persists",
            icon: Icons.notes_rounded,
            controller: _followUpNotesController,
            enabled: !isBusy,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButtons(
      BuildContext context, {
        required bool isBusy,
        required bool saving,
      }) {
    final isPerformingSave = saving || _savingStatusText.isNotEmpty;
    final saveLabel = _savingStatusText.isNotEmpty
        ? _savingStatusText
        : (_existingPrescriptionId != null
        ? "Update Prescription"
        : "Save Prescription");

    return LayoutBuilder(
      builder: (context, constraints) {
        final isVeryNarrow = constraints.maxWidth < 360;

        if (isVeryNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: saveLabel,
                isLoading: isPerformingSave,
                onPressed: isBusy ? null : _handleSave,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: "Cancel",
                variant: AppButtonVariant.outlined,
                onPressed: isBusy ? null : () => context.pop(),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              label: "Cancel",
              variant: AppButtonVariant.outlined,
              onPressed: isBusy ? null : () => context.pop(),
            ),
            const SizedBox(width: AppSpacing.md),
            AppButton(
              label: saveLabel,
              isLoading: isPerformingSave,
              onPressed: isBusy ? null : _handleSave,
            ),
          ],
        );
      },
    );
  }
}
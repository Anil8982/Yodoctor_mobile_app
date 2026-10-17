import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/app_constants.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';

import '../../../widgets/app_button.dart';
import '../../controllers/family_controller.dart';
import '../../models/family/family_member_model.dart';

class AddFamilyMemberScreen extends ConsumerStatefulWidget {
  const AddFamilyMemberScreen({super.key, this.initialMember});

  final FamilyMemberModel? initialMember;

  @override
  ConsumerState<AddFamilyMemberScreen> createState() =>
      _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends ConsumerState<AddFamilyMemberScreen> {
  static const List<String> _relationOptions = <String>[
    "FATHER",
    "MOTHER",
    "SPOUSE",
    "SON",
    "DAUGHTER",
    "BROTHER",
    "SISTER",
    "OTHER",
  ];

  String _getRelationLabel(AppLocalizations? l10n, String relation) {
    switch (relation.toUpperCase()) {
      case 'FATHER':
        return l10n?.relationFather ?? 'Father';
      case 'MOTHER':
        return l10n?.relationMother ?? 'Mother';
      case 'SPOUSE':
        return l10n?.relationSpouse ?? 'Spouse';
      case 'SON':
        return l10n?.relationSon ?? 'Son';
      case 'DAUGHTER':
        return l10n?.relationDaughter ?? 'Daughter';
      case 'BROTHER':
        return l10n?.relationBrother ?? 'Brother';
      case 'SISTER':
        return l10n?.relationSister ?? 'Sister';
      case 'OTHER':
        return l10n?.relationOther ?? 'Other';
      default:
        return relation;
    }
  }

  String _getGenderLabel(AppLocalizations? l10n, String gender) {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return l10n?.genderMale ?? 'Male';
      case 'FEMALE':
        return l10n?.genderFemale ?? 'Female';
      case 'OTHER':
        return l10n?.genderOther ?? 'Other';
      default:
        return gender;
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _selectedRelation;
  DateTime? _selectedDob;
  bool _isSaving = false;

  bool get _isEditing => widget.initialMember != null;

  @override
  void initState() {
    super.initState();
    _prefillForEditing();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _prefillForEditing() {
    final FamilyMemberModel? member = widget.initialMember;
    if (member == null) return;

    _nameController.text = member.fullName;
    _selectedGender = AppConstants.genderOptions.firstWhere(
          (gender) => gender.toLowerCase() == member.gender.trim().toLowerCase(),
      orElse: () => '',
    );
    _selectedBloodGroup = (member.bloodGroup.isNotEmpty && member.bloodGroup != 'NA')
        ? member.bloodGroup
        : null;
    _selectedRelation = member.relation;
    _dobController.text = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.parse(member.dob));
    _selectedDob = DateTime.tryParse(member.dob);
    if (member.heightCm > 0) {
      _heightController.text = member.heightCm.toString();
    }
    if (member.weightKg > 0) {
      _weightController.text = member.weightKg.toString();
    }
  }

  Future<void> _saveMember() async {
    FocusScope.of(context).unfocus();

    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _selectedDob == null) return;

    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final controller = ref.read(familyControllerProvider.notifier);
    bool success = false;

    if (_isEditing) {
      success = await controller.updateMember(
        id: widget.initialMember!.id,
        fullName: _nameController.text.trim(),
        gender: _selectedGender!,
        dob: _selectedDob!.toIso8601String().split('T').first,
        bloodGroup: _selectedBloodGroup ?? '',
        heightCm: _heightController.text.trim(),
        weightKg: _weightController.text.trim(),
        relation: _selectedRelation!,
      );
    } else {
      success = await controller.addMember(
        fullName: _nameController.text.trim(),
        gender: _selectedGender!,
        dob: _selectedDob!.toIso8601String().split('T').first,
        bloodGroup: _selectedBloodGroup ?? '',
        heightCm: _heightController.text.trim(),
        weightKg: _weightController.text.trim(),
        relation: _selectedRelation!,
      );
    }

    if (mounted && success) {
      context.pop(true);
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppHeader(
        title: _isEditing
            ? (l10n?.updateMember ?? 'Update Member')
            : (l10n?.addNewMember ?? 'Add New Member'),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool isWideLayout = constraints.maxWidth >= 760;
                    final double fieldWidth = isWideLayout
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: <Widget>[
                            SizedBox(
                              width: fieldWidth,
                              child: AppTextField(
                                label: l10n?.fullName ?? 'Full Name',
                                isRequired: true,
                                hint: l10n?.enterFullName ?? 'Enter full name',
                                maxLength: 50,
                                icon: Icons.person_rounded,
                                controller: _nameController,
                                textCapitalization: TextCapitalization.words,
                                validator: (String? value) {
                                  final String name = value?.trim() ?? '';
                                  if (name.isEmpty) {
                                    return l10n?.pleaseEnterFullName ??
                                        'Please enter full name';
                                  }
                                  if (name.length < 2) {
                                    return l10n?.nameMinLengthError ??
                                        'Name should have at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: AppDropdownField<String>(
                                label: l10n?.gender ?? 'Gender',
                                isRequired: true,
                                hint: l10n?.selectGender ?? 'Select gender',
                                icon: Icons.wc_rounded,
                                value: _selectedGender,
                                items: AppConstants.genderOptions,
                                itemLabelBuilder: (gender) =>
                                    _getGenderLabel(l10n, gender),
                                onChanged: (String? value) => setState(
                                      () => _selectedGender = value,
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n?.pleaseSelectGender ??
                                        'Please select gender';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: AppDatePickerField(
                                label: l10n?.dateOfBirth ?? 'Date of Birth',
                                isRequired: true,
                                hint: l10n?.selectDateOfBirth ??
                                    'Select date of birth',
                                icon: Icons.cake_rounded,
                                value: _selectedDob,
                                onChanged: (DateTime? date) {
                                  if (date == null) return;
                                  setState(() {
                                    _selectedDob = date;
                                  });
                                },
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: AppDropdownField<String>(
                                label: l10n?.bloodGroup ?? 'Blood Group',
                                isOptional: true,
                                hint: l10n?.selectBloodGroup ??
                                    'Select blood group',
                                icon: Icons.bloodtype_rounded,
                                value: _selectedBloodGroup,
                                items: AppConstants.bloodGroupOptions,
                                onChanged: (String? value) => setState(
                                      () => _selectedBloodGroup = value,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: AppDropdownField<String>(
                                label: l10n?.relation ?? 'Relation',
                                isRequired: true,
                                hint: l10n?.selectRelation ?? 'Select relation',
                                icon: Icons.people_alt_rounded,
                                value: _selectedRelation,
                                items: _relationOptions,
                                itemLabelBuilder: (relation) =>
                                    _getRelationLabel(l10n, relation),
                                onChanged: (String? value) => setState(
                                      () => _selectedRelation = value,
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n?.pleaseSelectRelation ??
                                        'Please select relation';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: AppTextField(
                                label: l10n?.heightCmLabel ?? 'Height (cm)',
                                isOptional: true,
                                hint: l10n?.heightHint ?? 'e.g. 170',
                                maxLength: 5,
                                icon: Icons.height_rounded,
                                controller: _heightController,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d?$'),
                                  ),
                                ],
                                validator: (String? value) {
                                  final String text = value?.trim() ?? '';
                                  if (text.isEmpty) {
                                    return null;
                                  }
                                  final double? parsed = double.tryParse(text);
                                  if (parsed == null) {
                                    return l10n?.enterValidHeight ??
                                        'Enter a valid height';
                                  }
                                  if (parsed < 30 || parsed > 250) {
                                    return l10n?.heightRangeError ??
                                        'Height should be between 30 and 250 cm';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: AppTextField(
                                label: l10n?.weightKgLabel ?? 'Weight (kg)',
                                isOptional: true,
                                hint: l10n?.weightHint ?? 'e.g. 65',
                                maxLength: 3,
                                icon: Icons.monitor_weight_outlined,
                                controller: _weightController,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d?$'),
                                  ),
                                ],
                                validator: (String? value) {
                                  final String text = value?.trim() ?? '';
                                  if (text.isEmpty) {
                                    return null;
                                  }
                                  final double? parsed = double.tryParse(text);
                                  if (parsed == null) {
                                    return l10n?.enterValidWeight ??
                                        'Enter a valid weight';
                                  }
                                  if (parsed < 2 || parsed > 350) {
                                    return l10n?.weightRangeError ??
                                        'Weight should be between 2 and 350 kg';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            AppButton(
                              label: l10n?.cancel ?? 'Cancel',
                              variant: AppButtonVariant.outlined,
                              onPressed: () => context.pop(false),
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              label: _isEditing
                                  ? (l10n?.saveChanges ?? 'Save Changes')
                                  : (l10n?.saveMember ?? 'Save Member'),
                              leading: Icon(
                                _isEditing
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.person_add_alt_1_rounded,
                              ),
                              isLoading: _isSaving,
                              onPressed: _saveMember,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
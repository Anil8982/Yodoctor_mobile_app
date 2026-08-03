import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';

import '../../../../core/theme/app_theme.dart';
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
  static const List<String> _genderOptions = <String>[
    "MALE",
    "FEMALE",
    "OTHER",
  ];
  static const List<String> _bloodGroupOptions = <String>[
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  static const List<String> _relationOptions = <String>[
    "FATHER",
    "MOTHER",
    "SPOUSE",
    "SON",
    "DAUGHTER",
    "BROTHER",
    "SISTER",
    "GRANDPARENT",
    "OTHER",
  ];

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
    _selectedGender = member.gender;
    _selectedBloodGroup = member.bloodGroup;
    _selectedRelation = member.relation;
    _dobController.text = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.parse(member.dob));
    _selectedDob = DateTime.tryParse(member.dob);
    _heightController.text = member.heightCm.toString();
    _weightController.text = member.weightKg.toString();
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
        bloodGroup: _selectedBloodGroup!,
        heightCm: _heightController.text.trim(),
        weightKg: _weightController.text.trim(),
        relation: _selectedRelation!,
      );
    } else {
      success = await controller.addMember(
        fullName: _nameController.text.trim(),
        gender: _selectedGender!,
        dob: _selectedDob!.toIso8601String().split('T').first,
        bloodGroup: _selectedBloodGroup!,
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppHeader(title: _isEditing ? 'Update Member' : 'Add New Member'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: AppTheme.patientGradient,
                    ),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colorScheme.onPrimary.withValues(
                            alpha: 0.16,
                          ),
                          child: Icon(
                            _isEditing
                                ? Icons.manage_accounts_rounded
                                : Icons.family_restroom_rounded,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _isEditing
                                    ? 'Update Family Health Profile'
                                    : 'Family Health Profile',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isEditing
                                    ? 'Keep family details fresh for faster bookings.'
                                    : 'Add details once and use them for faster appointments.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimary.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            final bool isWideLayout =
                                constraints.maxWidth >= 760;
                            final double fieldWidth = isWideLayout
                                ? (constraints.maxWidth - 16) / 2
                                : constraints.maxWidth;

                            return Column(
                              children: <Widget>[
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: <Widget>[
                                    SizedBox(
                                      width: fieldWidth,
                                      child: AppTextField(
                                        label: 'Full Name',
                                        isRequired: true,
                                        hint: 'Enter full name',
                                        maxLength: 50,
                                        icon: Icons.person_rounded,
                                        controller: _nameController,
                                        textCapitalization:
                                        TextCapitalization.words,
                                        validator: (String? value) {
                                          final String name =
                                              value?.trim() ?? '';
                                          if (name.isEmpty) {
                                            return 'Please enter full name';
                                          }
                                          if (name.length < 2) {
                                            return 'Name should have at least 2 characters';
                                          }
                                          if (!RegExp(
                                            r'^[A-Za-z]+(?: [A-Za-z]+)*$',
                                          ).hasMatch(name)) {
                                            return 'Only alphabets are allowed';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: fieldWidth,
                                      child: AppDropdownField(
                                        label: 'Gender',
                                        isRequired: true,
                                        hint: 'Select gender',
                                        icon: Icons.wc_rounded,
                                        value: _selectedGender,
                                        items: _genderOptions,
                                        onChanged: (String? value) => setState(
                                              () => _selectedGender = value,
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select gender';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: fieldWidth,
                                      child: AppDatePickerField(
                                        label: 'Date of Birth',
                                        isRequired: true,
                                        hint: 'Select date of birth',
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
                                      child: AppDropdownField(
                                        label: 'Blood Group',
                                        isRequired: true,
                                        hint: 'Select blood group',
                                        icon: Icons.bloodtype_rounded,
                                        value: _selectedBloodGroup,
                                        items: _bloodGroupOptions,
                                        onChanged: (String? value) => setState(
                                              () => _selectedBloodGroup = value,
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select blood group';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: fieldWidth,
                                      child: AppDropdownField(
                                        label: 'Relation',
                                        isRequired: true,
                                        hint: 'Select relation',
                                        icon: Icons.people_alt_rounded,
                                        value: _selectedRelation,
                                        items: _relationOptions,
                                        onChanged: (String? value) => setState(
                                              () => _selectedRelation = value,
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select relation';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: fieldWidth,
                                      child: AppTextField(
                                        label: 'Height (cm)',
                                        isRequired: true,
                                        hint: 'e.g. 170',
                                        maxLength: 3,
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
                                          final String text =
                                              value?.trim() ?? '';
                                          if (text.isEmpty) {
                                            return 'Please enter height';
                                          }
                                          final double? parsed =
                                          double.tryParse(text);
                                          if (parsed == null) {
                                            return 'Enter a valid height';
                                          }
                                          if (parsed < 30 || parsed > 250) {
                                            return 'Height should be between 30 and 250 cm';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: fieldWidth,
                                      child: AppTextField(
                                        label: 'Weight (kg)',
                                        isRequired: true,
                                        hint: 'e.g. 65',
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
                                          final String text =
                                              value?.trim() ?? '';
                                          if (text.isEmpty) {
                                            return 'Please enter weight';
                                          }
                                          final double? parsed =
                                          double.tryParse(text);
                                          if (parsed == null) {
                                            return 'Enter a valid weight';
                                          }
                                          if (parsed < 2 || parsed > 350) {
                                            return 'Weight should be between 2 and 350 kg';
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
                                      label: 'Cancel',
                                      variant: AppButtonVariant.outlined,
                                      onPressed: () => context.pop(false),
                                    ),
                                    const SizedBox(width: 12),
                                    AppButton(
                                      label: _isEditing
                                          ? 'Save Changes'
                                          : 'Save Member',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
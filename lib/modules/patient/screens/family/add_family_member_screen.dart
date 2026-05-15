import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dummy_data.dart';
import '../../../../core/widgets/app_button.dart';
import '../../controllers/family_controller.dart';
import 'widgets/member_form_dropdown_field.dart';
import 'widgets/member_form_text_field.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({
    super.key,
    this.initialMember,
  });

  final FamilyMember? initialMember;

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  static const List<String> _genderOptions = <String>[
    'Male',
    'Female',
    'Other',
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
    'Father',
    'Mother',
    'Spouse',
    'Son',
    'Daughter',
    'Brother',
    'Sister',
    'Grandparent',
    'Other',
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
    final FamilyMember? member = widget.initialMember;
    if (member == null) {
      return;
    }

    _nameController.text = member.name;
    _selectedGender = member.gender;
    _selectedBloodGroup = member.bloodGroup;
    _selectedRelation = member.relation;
    _selectedDob = member.dateOfBirth;
    _dobController.text = _formatDate(member.dateOfBirth);
    _heightController.text = _formatNumber(member.heightCm);
    _weightController.text = _formatNumber(member.weightKg);
  }

  Future<void> _pickDateOfBirth() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDob ?? DateTime(now.year - 25, 1, 1);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDob = pickedDate;
      _dobController.text = _formatDate(pickedDate);
    });
  }

  Future<void> _saveMember() async {
    FocusScope.of(context).unfocus();

    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _selectedDob == null) {
      return;
    }

    setState(() => _isSaving = true);

    await Future<void>.delayed(const Duration(milliseconds: 250));

    final String name = _nameController.text.trim();
    final double heightCm = double.parse(_heightController.text.trim());
    final double weightKg = double.parse(_weightController.text.trim());

    final FamilyMember member = FamilyMember(
      name: name,
      lastVisit: widget.initialMember?.lastVisit ?? 'No visits yet',
      relation: _selectedRelation!,
      gender: _selectedGender!,
      bloodGroup: _selectedBloodGroup!,
      initials: _buildInitials(name),
      dateOfBirth: _selectedDob!,
      heightCm: heightCm,
      weightKg: weightKg,
    );

    if (!mounted) {
      return;
    }

    final FamilyController familyController = context.read<FamilyController>();
    if (_isEditing) {
      familyController.updateMember(
        oldMember: widget.initialMember!,
        updatedMember: member,
      );
    } else {
      familyController.addMember(member);
    }

    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _isEditing ? 'Update Member' : 'Add New Member',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: colorScheme.surfaceContainerLowest,
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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          colorScheme.primaryContainer,
                          colorScheme.primaryContainer.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colorScheme.primary.withValues(alpha: 0.13),
                          child: Icon(
                            _isEditing
                                ? Icons.manage_accounts_rounded
                                : Icons.family_restroom_rounded,
                            color: colorScheme.primary,
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
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isEditing
                                    ? 'Keep family details fresh for faster bookings.'
                                    : 'Add details once and use them for faster appointments.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
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
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            final bool isWideLayout = constraints.maxWidth >= 760;
                            final double fieldWidth = isWideLayout
                                ? (constraints.maxWidth - 16) / 2
                                : constraints.maxWidth;

                            return Column(
                              children: <Widget>[
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: <Widget>[
                                    SizedBox(width: fieldWidth, child: _buildNameField()),
                                    SizedBox(width: fieldWidth, child: _buildGenderField()),
                                    SizedBox(width: fieldWidth, child: _buildDobField()),
                                    SizedBox(width: fieldWidth, child: _buildBloodGroupField()),
                                    SizedBox(width: fieldWidth, child: _buildRelationField()),
                                    SizedBox(width: fieldWidth, child: _buildHeightField()),
                                    SizedBox(width: fieldWidth, child: _buildWeightField()),
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
                                      label: _isEditing ? 'Save Changes' : 'Save Member',
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

  Widget _buildNameField() {
    return MemberFormTextField(
      label: 'Full Name',
      hintText: 'Enter full name',
      prefixIcon: Icons.person_rounded,
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      validator: (String? value) {
        final String name = value?.trim() ?? '';
        if (name.isEmpty) {
          return 'Please enter full name';
        }
        if (name.length < 2) {
          return 'Name should have at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildGenderField() {
    return MemberFormDropdownField(
      label: 'Gender',
      hintText: 'Select gender',
      prefixIcon: Icons.wc_rounded,
      value: _selectedGender,
      options: _genderOptions,
      onChanged: (String? value) => setState(() => _selectedGender = value),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please select gender';
        }
        return null;
      },
    );
  }

  Widget _buildDobField() {
    return MemberFormTextField(
      label: 'Date of Birth',
      hintText: 'Select date of birth',
      prefixIcon: Icons.cake_rounded,
      suffixIcon: const Icon(Icons.calendar_month_rounded),
      controller: _dobController,
      readOnly: true,
      onTap: _pickDateOfBirth,
      validator: (String? value) {
        if (_selectedDob == null) {
          return 'Please select date of birth';
        }
        return null;
      },
    );
  }

  Widget _buildBloodGroupField() {
    return MemberFormDropdownField(
      label: 'Blood Group',
      hintText: 'Select blood group',
      prefixIcon: Icons.bloodtype_rounded,
      value: _selectedBloodGroup,
      options: _bloodGroupOptions,
      onChanged: (String? value) => setState(() => _selectedBloodGroup = value),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please select blood group';
        }
        return null;
      },
    );
  }

  Widget _buildRelationField() {
    return MemberFormDropdownField(
      label: 'Relation',
      hintText: 'Select relation',
      prefixIcon: Icons.people_alt_rounded,
      value: _selectedRelation,
      options: _relationOptions,
      onChanged: (String? value) => setState(() => _selectedRelation = value),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please select relation';
        }
        return null;
      },
    );
  }

  Widget _buildHeightField() {
    return MemberFormTextField(
      label: 'Height (cm)',
      hintText: 'e.g. 170',
      prefixIcon: Icons.height_rounded,
      controller: _heightController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$')),
      ],
      validator: (String? value) {
        final String text = value?.trim() ?? '';
        if (text.isEmpty) {
          return 'Please enter height';
        }

        final double? parsed = double.tryParse(text);
        if (parsed == null) {
          return 'Enter a valid height';
        }
        if (parsed < 30 || parsed > 250) {
          return 'Height should be between 30 and 250 cm';
        }
        return null;
      },
    );
  }

  Widget _buildWeightField() {
    return MemberFormTextField(
      label: 'Weight (kg)',
      hintText: 'e.g. 65',
      prefixIcon: Icons.monitor_weight_outlined,
      controller: _weightController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$')),
      ],
      validator: (String? value) {
        final String text = value?.trim() ?? '';
        if (text.isEmpty) {
          return 'Please enter weight';
        }

        final double? parsed = double.tryParse(text);
        if (parsed == null) {
          return 'Enter a valid weight';
        }
        if (parsed < 2 || parsed > 350) {
          return 'Weight should be between 2 and 350 kg';
        }
        return null;
      },
    );
  }

  String _formatDate(DateTime date) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final String day = date.day.toString().padLeft(2, '0');
    return '$day ${months[date.month - 1]} ${date.year}';
  }

  String _buildInitials(String name) {
    final List<String> parts = name
        .split(RegExp(r'\s+'))
        .where((String segment) => segment.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'NA';
    }

    if (parts.length == 1) {
      final String firstWord = parts.first;
      if (firstWord.length == 1) {
        return firstWord.toUpperCase();
      }

      return firstWord.substring(0, 2).toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String _formatNumber(double value) {
    final bool isWhole = value == value.roundToDouble();
    return isWhole ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  }
}

import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/widgets/app_search_select_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/section_label.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_card.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_title.dart';

import '../widgets/nav_buttons.dart';

class Step3Clinic extends ConsumerStatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Clinic({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step3Clinic> createState() => _Step3ClinicState();
}

class _Step3ClinicState extends ConsumerState<Step3Clinic> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _mapsCtrl = TextEditingController();

  String? _selectedState;
  bool _hasAttemptedSubmit = false;

  static const List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.data.clinicName;
    _cityCtrl.text = widget.data.city;
    _addrCtrl.text = widget.data.address;
    _pincodeCtrl.text = widget.data.pincode;
    _landmarkCtrl.text = widget.data.landmark;
    _mapsCtrl.text = widget.data.mapsLink;
    _selectedState = widget.data.state.isEmpty ? null : widget.data.state;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _addrCtrl.dispose();
    _pincodeCtrl.dispose();
    _landmarkCtrl.dispose();
    _mapsCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.data.clinicName = _nameCtrl.text.trim();
    widget.data.city = _cityCtrl.text.trim();
    widget.data.address = _addrCtrl.text.trim();
    widget.data.state = _selectedState ?? '';
    widget.data.pincode = _pincodeCtrl.text.trim();
    widget.data.landmark = _landmarkCtrl.text.trim();
    widget.data.mapsLink = _mapsCtrl.text.trim();
  }

  Future<void> _handleNext() async {
    setState(() => _hasAttemptedSubmit = true);

    if (!_formKey.currentState!.validate() || _selectedState == null) return;

    _save();

    final success = await ref
        .read(doctorRegisterControllerProvider.notifier)
        .registerStep3(widget.data);

    if (!mounted) return;

    if (success) {
      widget.onNext();
    } else {
      final errorMsg = ref.read(doctorRegisterControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? "Step 3 registration failed. Try again."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final registerState = ref.watch(doctorRegisterControllerProvider);

    return Form(
      key: _formKey,
      autovalidateMode: _hasAttemptedSubmit
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: StepCard(
        children: [
          StepTitle(
            icon: Icons.local_hospital_rounded,
            title: 'Clinic Details',
            subtitle: 'Enter clinic location and physical contact information',
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Clinic Name
          AppTextField(
            label: 'Clinic Name',
            isRequired: true,
            hint: 'Enter clinic or hospital name',
            icon: Icons.business_outlined,
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Clinic name required' : null,
          ),
          const SizedBox(height: 16),

          // City
          AppTextField(
            label: 'City',
            isRequired: true,
            hint: 'Enter city',
            icon: Icons.location_city_outlined,
            controller: _cityCtrl,
            textCapitalization: TextCapitalization.words,
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'City required' : null,
          ),
          const SizedBox(height: 16),

          // Full Address
          const SectionLabel(label: 'Full Address', isRequired: true),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addrCtrl,
            maxLines: 3,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Enter street, building, area, or locality details...',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.transparency(0.7),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: Icon(
                  Icons.home_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.transparency(0.5),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 1.8,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.error, width: 1.4),
              ),
            ),
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Address required' : null,
          ),
          const SizedBox(height: 16),

          // State Search Picker
          AppSearchSelectField(
            label: 'State',
            isRequired: true,
            hint: 'Select or search state',
            icon: Icons.map_outlined,
            value: _selectedState,
            items: _states,
            isInvalid: _selectedState == null && _hasAttemptedSubmit,
            errorText: 'Please select a state',
            onChanged: (v) => setState(() => _selectedState = v),
          ),
          const SizedBox(height: 16),

          // Pincode
          AppTextField(
            label: 'Pincode',
            isRequired: true,
            hint: 'Enter 6-digit pincode',
            icon: Icons.pin_drop_outlined,
            controller: _pincodeCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) =>
            (v == null || v.length != 6) ? 'Enter valid 6-digit pincode' : null,
          ),
          const SizedBox(height: 16),

          // Landmark
          AppTextField(
            label: 'Landmark (Optional)',
            hint: 'Enter nearby landmark',
            icon: Icons.place_outlined,
            controller: _landmarkCtrl,
          ),
          const SizedBox(height: 16),

          // Google Maps Link
          AppTextField(
            label: 'Google Maps Link (Optional)',
            hint: 'Paste Google Maps location link',
            icon: Icons.location_on_outlined,
            controller: _mapsCtrl,
            keyboardType: TextInputType.url,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              if (!v.startsWith('http://') && !v.startsWith('https://')) {
                return 'Enter valid URL starting with http:// or https://';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Map Preview Container
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: colorScheme.primary.transparency(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.transparency(0.25),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    color: colorScheme.primary.transparency(0.4),
                    size: 34,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Map Preview will appear here',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary.transparency(0.6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Action Navigation
          NavButtons(
            onBack: widget.onBack,
            onNext: registerState.isLoading ? null : _handleNext,
          ),
        ],
      ),
    );
  }
}
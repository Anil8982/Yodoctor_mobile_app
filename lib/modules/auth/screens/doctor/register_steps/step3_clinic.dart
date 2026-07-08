import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'shared_widgets.dart';
import 'package:provider/provider.dart';
import '../../../controllers/doctor_register_controller.dart';

class Step3Clinic extends StatefulWidget {
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
  State<Step3Clinic> createState() => _Step3ClinicState();
}

class _Step3ClinicState extends State<Step3Clinic> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _mapsCtrl = TextEditingController();
  String? _state;

  final _states = const [
    'Maharashtra',
    'Delhi',
    'Karnataka',
    'Uttar Pradesh',
    'Madhya Pradesh',
    'Rajasthan',
    'Tamil Nadu',
    'Gujarat',
    'West Bengal',
    'Telangana',
    'Andhra Pradesh',
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
    _state = widget.data.state.isEmpty ? null : widget.data.state;
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
    widget.data.clinicName = _nameCtrl.text;
    widget.data.city = _cityCtrl.text;
    widget.data.address = _addrCtrl.text;
    widget.data.state = _state ?? '';
    widget.data.pincode = _pincodeCtrl.text;
    widget.data.landmark = _landmarkCtrl.text;
    widget.data.mapsLink = _mapsCtrl.text;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: _formKey,
      child: StepCard(
        children: [
          StepTitle(
            icon: Icons.local_hospital_rounded,
            title: 'Clinic Details',
            color: AppTheme.yoBlue,
          ),
          const SizedBox(height: 24),
          YoField(
            label: 'Clinic Name *',
            hint: 'e.g. City Health Clinic',
            icon: Icons.business_rounded,
            controller: _nameCtrl,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'City *',
            hint: 'e.g. Mumbai',
            icon: Icons.location_city_rounded,
            controller: _cityCtrl,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          const SectionLabel(label: 'Full Address *'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _addrCtrl,
            maxLines: 3,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            decoration: inputDeco(
              context,
              'Street, Area, District...',
              Icons.home_rounded,
            ),
            validator: (v) => v!.isEmpty ? 'Address required' : null,
          ),
          const SizedBox(height: 16),
          DropdownField(
            label: 'State *',
            icon: Icons.map_rounded,
            value: _state,
            items: _states,
            onChanged: (v) => setState(() => _state = v),
            validator: (v) => v == null ? 'Select state' : null,
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Pincode *',
            hint: '400001',
            icon: Icons.pin_drop_rounded,
            controller: _pincodeCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) =>
                v!.length != 6 ? 'Enter valid 6-digit pincode' : null,
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Landmark (Optional)',
            hint: 'Near XYZ Mall',
            icon: Icons.place_rounded,
            controller: _landmarkCtrl,
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Google Maps Link (Optional)',
            hint: 'https://maps.google.com/...',
            icon: Icons.location_on_rounded,
            controller: _mapsCtrl,
            validator: (v) {
              if (v == null || v.isEmpty) return null;
              if (!v.startsWith('http')) return 'Enter valid URL';
              return null;
            },
          ),
          const SizedBox(height: 20),
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: AppTheme.yoBlueLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.yoBlue.transparency(0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_rounded,
                    color: AppTheme.yoBlue.transparency(0.4),
                    size: 34,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Map Preview will appear here',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppTheme.yoBlue.transparency(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          NavButtons(
            onBack: widget.onBack,
            onNext: () async {
              if (!_formKey.currentState!.validate()) return;

              _save();

              final controller = context.read<DoctorRegisterController>();

              final success = await controller.registerStep3(widget.data);

              if (!mounted) return;

              if (success) {
                widget.onNext();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(controller.error ?? "Step 3 Failed")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

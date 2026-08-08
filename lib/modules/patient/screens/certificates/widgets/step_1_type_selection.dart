import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'certificate_type_card.dart';
import 'step_header_helper.dart';
import '../../../../patient/models/certificate/patient_doctor_model.dart';

class Step1TypeSelection extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final CertificateNotifier controller;
  final AutovalidateMode autovalidateMode;

  Step1TypeSelection({
    super.key,
    required this.formKey,
    required this.controller,
    required this.autovalidateMode,
  });

  final List<Map<String, dynamic>> _certificateTypes = [
    {
      'title': 'Medical Fitness',
      'desc': 'For employment or sports',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'title': 'Vaccination',
      'desc': 'Immunization records',
      'icon': Icons.vaccines_rounded,
    },
    {
      'title': 'Disability',
      'desc': 'Official disability proof',
      'icon': Icons.accessible_rounded,
    },
    {
      'title': 'Second Opinion',
      'desc': 'Expert medical review',
      'icon': Icons.rate_review_rounded,
    },
    {
      'title': 'Discharge Summary',
      'desc': 'Summary of hospital discharge',
      'icon': Icons.article_rounded,
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current form state reactively from provider
    final formState = ref.watch(certificateProvider);
    final selectedDoctor =
        formState.doctors.any(
          (doctor) => doctor.id == formState.assignedDoctor?.id,
        )
        ? formState.doctors.firstWhere(
            (doctor) => doctor.id == formState.assignedDoctor?.id,
          )
        : null;

    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            title: 'Select Certificate Type',
            desc: 'Choose the matching variant for your application.',
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemCount: _certificateTypes.length,
            itemBuilder: (context, idx) {
              final type = _certificateTypes[idx];
              return CertificateTypeCard(
                title: type['title'],
                description: type['desc'],
                icon: type['icon'],
                // Read reactive properties from formState payload safely
                isSelected: formState.selectedType == type['title'],
                onTap: () => controller.setSelectedType(type['title']),
              );
            },
          ),
          const SizedBox(height: 28),

          AppDropdownField<PatientDoctorModel>(
            label: 'Assigned Doctor',
            isRequired: true,
            hint: 'Select Doctor',
            icon: Icons.person_rounded,
            value: selectedDoctor,
            items: formState.doctors,
            itemLabel: (doctor) => '${doctor.name} (${doctor.specialty})',
            onChanged: (value) {
              if (value != null) {
                controller.setAssignedDoctor(value);
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an assigned doctor';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
          AppDropdownField<String>(
            label: 'Purpose of Certificate',
            isRequired: true,
            hint: 'Select purpose',
            icon: Icons.assignment_turned_in_rounded,
            value: formState.purpose,
            items: const [
              'Travel',
              'Employment',
              'Sports',
              'School/University',
              'Insurance',
              'Other',
            ],
            onChanged: (value) {
              if (value != null) {
                controller.setPurpose(value);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a purpose';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Additional Notes For Doctor',
            hint:
                'Describe specific conditions or background details contextually...',
            icon: Icons.note_add_sharp,
            controller: controller.additionalNotesController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'certificate_type_card.dart';
import 'step_header_helper.dart';
import 'custom_text_field.dart'; // Navin text widget import kela

class Step1TypeSelection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CertificateController controller;

  Step1TypeSelection({super.key, required this.formKey, required this.controller});

  final List<Map<String, dynamic>> _certificateTypes = [
    {'title': 'Medical Fitness', 'desc': 'For employment or sports', 'icon': Icons.fitness_center_rounded},
    {'title': 'Vaccination', 'desc': 'Immunization records', 'icon': Icons.vaccines_rounded},
    {'title': 'Disability', 'desc': 'Official disability proof', 'icon': Icons.accessible_rounded},
    {'title': 'Second Opinion', 'desc': 'Expert medical review', 'icon': Icons.rate_review_rounded},
    {'title': 'Discharge Summary', 'desc': 'Summary of hospital discharge', 'icon': Icons.article_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(title: 'Select Certificate Type', desc: 'Choose the matching variant for your application.'),
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
                isSelected: controller.selectedType == type['title'],
                onTap: () => controller.setSelectedType(type['title']),
              );
            },
          ),
          const SizedBox(height: 28),
          DropdownButtonFormField<DoctorProfile>(
            initialValue: controller.assignedDoctor,
            decoration: InputDecoration(
              labelText: 'Assigned Doctor *',
              prefixIcon: const Icon(Icons.person_search_rounded, size: 22),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
              ),
            ),
            validator: (value) => value == null ? 'Please select a doctor' : null,
            items: DummyData.allDoctors.map((doc) {
              return DropdownMenuItem<DoctorProfile>(value: doc, child: Text('${doc.name} (${doc.specialty})'));
            }).toList(),
            onChanged: (value) => value != null ? controller.setAssignedDoctor(value) : null,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: controller.purpose,
            decoration: InputDecoration(
              labelText: 'Purpose of Certificate *',
              prefixIcon: const Icon(Icons.assignment_turned_in_rounded, size: 22),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
              ),
            ),
            validator: (value) => value == null ? 'Please select a purpose' : null,
            items: const ['Travel', 'Employment', 'Sports', 'School/University', 'Insurance', 'Other'].map((p) {
              return DropdownMenuItem<String>(value: p, child: Text(p));
            }).toList(),
            onChanged: (value) => value != null ? controller.setPurpose(value) : null,
          ),
          const SizedBox(height: 20),
          CustomCertificateTextField(
            controller: controller.additionalNotesController,
            labelText: 'Additional Notes For Doctor',
            hintText: 'Describe specific conditions or background details contextually...',
            maxLines: 3,
            alignLabelWithHint: true,
          ),
        ],
      ),
    );
  }
}
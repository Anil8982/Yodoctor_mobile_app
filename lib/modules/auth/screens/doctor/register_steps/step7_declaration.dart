import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_card.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_title.dart';

class Step7Declaration extends ConsumerStatefulWidget {
  final DoctorFormData data;
  final VoidCallback onBack;
  final Future<void> Function() onSubmit;

  const Step7Declaration({
    super.key,
    required this.data,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  ConsumerState<Step7Declaration> createState() => _Step7DeclarationState();
}

class _Step7DeclarationState extends ConsumerState<Step7Declaration> {
  final _declarations = const [
    {
      'key': 'accurate',
      'text': 'I declare that all information provided is accurate and true to my knowledge.',
    },
    {
      'key': 'display',
      'text': 'I authorize Yo Doctor to display my professional credentials publicly for patient booking.',
    },
    {
      'key': 'privacy',
      'text': 'I consent to the processing and secure storage of my personal data as per Privacy Policy.',
    },
    {
      'key': 'terms',
      'text': "I agree to the platform's Terms of Service, Cancellation, and Refund policies.",
    },
  ];

  bool _isChecked(String key) {
    switch (key) {
      case 'accurate':
        return widget.data.declAccurate;
      case 'display':
        return widget.data.declDisplay;
      case 'privacy':
        return widget.data.declPrivacy;
      case 'terms':
        return widget.data.declTerms;
      default:
        return false;
    }
  }

  void _toggleDeclaration(String key) {
    setState(() {
      switch (key) {
        case 'accurate':
          widget.data.declAccurate = !widget.data.declAccurate;
          break;
        case 'display':
          widget.data.declDisplay = !widget.data.declDisplay;
          break;
        case 'privacy':
          widget.data.declPrivacy = !widget.data.declPrivacy;
          break;
        case 'terms':
          widget.data.declTerms = !widget.data.declTerms;
          break;
      }
    });
  }

  bool get _allChecked =>
      widget.data.declAccurate &&
          widget.data.declDisplay &&
          widget.data.declPrivacy &&
          widget.data.declTerms;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final registerState = ref.watch(doctorRegisterControllerProvider);
    final bool isSubmitting = registerState.isLoading;

    return StepCard(
      children: [
        StepTitle(
          icon: Icons.gavel_outlined,
          title: 'Legal Declarations',
          subtitle: 'Please review and accept all terms before final submission',
          color: colorScheme.primary,
        ),
        const SizedBox(height: 20),

        ..._declarations.map((decl) {
          final key = decl['key']!;
          final checked = _isChecked(key);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: isSubmitting ? null : () => _toggleDeclaration(key),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: checked
                        ? colorScheme.primary.transparency(0.06)
                        : colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: checked
                          ? colorScheme.primary
                          : colorScheme.outlineVariant.transparency(0.5),
                      width: checked ? 1.8 : 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: checked ? colorScheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: checked
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant.transparency(0.6),
                            width: 2,
                          ),
                        ),
                        child: checked
                            ? Icon(
                          Icons.check_rounded,
                          color: colorScheme.primary.contrastColor,
                          size: 16,
                        )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          decl['text']!,
                          style: textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                            fontWeight: checked ? FontWeight.w600 : FontWeight.normal,
                            color: checked
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 20),

        // Action Buttons
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton(
            onPressed: (_allChecked && !isSubmitting)
                ? () async {
              await widget.onSubmit();
            }
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: _allChecked
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.transparency(0.4),
              foregroundColor: colorScheme.primary.contrastColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: isSubmitting
                ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: colorScheme.primary.contrastColor,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              'Submit Registration',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: _allChecked
                    ? colorScheme.primary.contrastColor
                    : colorScheme.onSurface.transparency(0.38),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: isSubmitting ? null : widget.onBack,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colorScheme.outlineVariant.transparency(0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Back',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        if (!_allChecked) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.error.transparency(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.error.transparency(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: colorScheme.error, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Please accept all 4 declarations above to submit your application',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
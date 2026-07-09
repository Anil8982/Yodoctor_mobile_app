import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'shared_widgets.dart';

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
      'text': 'I declare that all information provided is accurate.',
    },
    {
      'key': 'display',
      'text': 'I authorize Yo Doctor to display my professional information publicly for patient booking.',
    },
    {
      'key': 'privacy',
      'text': 'I consent to processing and storage of my personal data as per Privacy Policy.',
    },
    {
      'key': 'terms',
      'text': "I agree to the platform's Terms, Cancellation and Refund policies.",
    },
  ];

  bool _get(String key) {
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

  void _toggle(String key) => setState(() {
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
          icon: Icons.gavel_rounded,
          title: 'Legal Declarations',
          color: colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          'Please review and accept all declarations before submitting.',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ..._declarations.map((decl) {
          final checked = _get(decl['key']!);
          return GestureDetector(
            onTap: isSubmitting ? null : () => _toggle(decl['key']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // 🎯 FIXED BY CHROMA_KIT: Modern toggle visual states mapping
                color: checked ? colorScheme.primary.transparency(0.06) : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: checked ? colorScheme.primary : colorScheme.outlineVariant.transparency(0.5),
                  width: checked ? 2 : 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: checked ? colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: checked ? colorScheme.primary : colorScheme.onSurfaceVariant.transparency(0.7),
                        width: 2,
                      ),
                    ),
                    child: checked
                        ? Icon(
                      Icons.check,
                      color: colorScheme.primary.contrastColor,
                      size: 15,
                    )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      decl['text']!,
                      style: textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: checked ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
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
              backgroundColor: _allChecked ? colorScheme.primary : colorScheme.outlineVariant.transparency(0.4),
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
                color: _allChecked ? colorScheme.primary.contrastColor : colorScheme.onSurface.withValues(alpha: 0.38),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: isSubmitting ? null : widget.onBack,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.outlineVariant.transparency(0.5), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              '← Back',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        if (!_allChecked) ...[
          const SizedBox(height: 14),
          // 🎯 FIXED BY CHROMA_KIT: Unified error alert components layout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.error.transparency(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.error.transparency(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: colorScheme.error, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please accept all declarations to submit',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w700,
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
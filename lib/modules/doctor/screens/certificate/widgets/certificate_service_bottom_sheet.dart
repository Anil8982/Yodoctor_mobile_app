import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_service_controller.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class CertificateServiceBottomSheet extends ConsumerStatefulWidget {
  const CertificateServiceBottomSheet({
    super.key,
  });

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CertificateServiceBottomSheet(),
    );
  }

  @override
  ConsumerState<CertificateServiceBottomSheet> createState() =>
      _CertificateServiceBottomSheetState();
}

class _CertificateServiceBottomSheetState
    extends ConsumerState<CertificateServiceBottomSheet> {
  late final TextEditingController _feeController;
  late final TextEditingController _instructionsController;
  final _feeFormKey = GlobalKey<FormState>();
  bool _hasAttemptedLoad = false;

  @override
  void initState() {
    super.initState();

    _feeController = TextEditingController();
    _instructionsController = TextEditingController();

    // Add listeners to update draft state on text changes
    _feeController.addListener(() {
      ref
          .read(doctorCertificateServiceProvider.notifier)
          .updateDraftFee(_feeController.text);
    });

    _instructionsController.addListener(() {
      ref
          .read(doctorCertificateServiceProvider.notifier)
          .updateDraftInstructions(_instructionsController.text);
    });

    Future.microtask(_loadData);
  }

  void _loadData() {
    final state = ref.read(doctorCertificateServiceProvider);

    if (state.hasService) {
      _feeController.text = state.draftFeeText.isNotEmpty
          ? state.draftFeeText
          : state.service!.fee > 0
          ? state.service!.fee.toStringAsFixed(0)
          : '';
      _instructionsController.text = state.draftInstructions.isNotEmpty
          ? state.draftInstructions
          : state.service!.instructions ?? '';
      return;
    }

    _hasAttemptedLoad = true;
    ref
        .read(doctorCertificateServiceProvider.notifier)
        .loadCertificateService();
  }

  @override
  void dispose() {
    _feeController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorCertificateServiceProvider);

    ref.listen<CertificateServiceState>(
      doctorCertificateServiceProvider,
          (previous, next) {
        if (!mounted) return;

        if (next.service != null && previous?.service != next.service) {
          _feeController.text = next.draftFeeText;
          _instructionsController.text = next.draftInstructions;
        }

        if (next.saveMessage != null &&
            previous?.saveMessage != next.saveMessage) {
          context.showSuccessSnackBar(next.saveMessage!);
        }

        if (next.errorMessage != null &&
            previous?.errorMessage != next.errorMessage &&
            next.hasService) {
          context.showErrorSnackBar(next.errorMessage!);
        }
      },
    );

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Certificate Service',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Manage your certificate service settings.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      style: IconButton.styleFrom(
                        foregroundColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Status Banner (only for error/retry states)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStatusBanner(context, state),
                ),

                const SizedBox(height: 16),

                // Always show content
                _buildContent(context, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner(
      BuildContext context,
      CertificateServiceState state,
      ) {
    // Error state (only when no service loaded and after first attempt)
    if (state.errorMessage != null && !state.hasService && _hasAttemptedLoad) {
      return Container(
        key: const ValueKey('error_banner'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                state.errorMessage!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Retry button or loading indicator
            if (state.isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              )
            else
              TextButton.icon(
                onPressed: () {
                  _hasAttemptedLoad = true;
                  ref
                      .read(doctorCertificateServiceProvider.notifier)
                      .retry();
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  'Retry',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
          ],
        ),
      );
    }

    return const SizedBox.shrink(
      key: ValueKey('no_banner'),
    );
  }

  Widget _buildContent(
      BuildContext context,
      CertificateServiceState state,
      ) {
    final isDisabled = state.isLoading || state.isSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusCard(context, state),

        const SizedBox(height: 22),

        Form(
          key: _feeFormKey,
          child: AppTextField(
            label: 'Certificate Fee',
            isRequired: state.isEnabled,
            hint: 'Enter fee amount',
            icon: Icons.currency_rupee,
            controller: _feeController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            enabled: !isDisabled,
            validator: (value) {
              if (!state.isEnabled) return null;
              return ref
                  .read(doctorCertificateServiceProvider.notifier)
                  .validateFee();
            },
          ),
        ),

        const SizedBox(height: 18),

        AppTextField(
          label: 'Instructions for Patients',
          hint: 'e.g. Patient must provide valid medical records...',
          icon: Icons.notes_rounded,
          controller: _instructionsController,
          maxLines: 4,
          enabled: !isDisabled,
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Patients will pay the certificate fee plus the platform fee when submitting an application.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.9),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isDisabled
                    ? null
                    : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: isDisabled ? null : _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: state.isSaving
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                )
                    : Text(
                  state.hasService && state.isEnabled
                      ? 'Save Changes'
                      : 'Save & Enable',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard(
      BuildContext context,
      CertificateServiceState state,
      ) {
    final isDisabled = state.isLoading || state.isSaving;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certificate Service',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Allow patients to request certificates from your profile.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: state.isEnabled,
            onChanged: isDisabled ? null : _toggle,
          ),
        ],
      ),
    );
  }

  void _toggle(bool value) {
    final success = ref
        .read(doctorCertificateServiceProvider.notifier)
        .setLocalEnabled(enabled: value);

    if (!success && mounted) {
      // Trigger form validation to show the error
      _feeFormKey.currentState?.validate();
    }
  }

  Future<void> _save() async {
    final success =
    await ref.read(doctorCertificateServiceProvider.notifier).save();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    }
  }
}
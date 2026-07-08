import 'package:flutter/material.dart';
import '../../../models/history/appointment_history_model.dart';

Future<void> showAppointmentDetailsDialog({
  required BuildContext context,
  required AppointmentHistoryModel appointment,
  required int initialRating,
  required String initialFeedback,
  required Future<void> Function(int rating, String feedback) onSubmitRating,
  required VoidCallback onDownloadPrescription,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0),
    builder: (context) => _AppointmentDetailsSheet(
      appointment: appointment,
      initialRating: initialRating,
      initialFeedback: initialFeedback,
      onSubmitRating: onSubmitRating,
      onDownloadPrescription: onDownloadPrescription,
    ),
  );
}

class _AppointmentDetailsSheet extends StatefulWidget {
  const _AppointmentDetailsSheet({
    required this.appointment,
    required this.initialRating,
    required this.initialFeedback,
    required this.onSubmitRating,
    required this.onDownloadPrescription,
  });

  final AppointmentHistoryModel appointment;
  final int initialRating;
  final String initialFeedback;
  final Future<void> Function(int rating, String feedback) onSubmitRating;
  final VoidCallback onDownloadPrescription;

  @override
  State<_AppointmentDetailsSheet> createState() =>
      _AppointmentDetailsSheetState();
}

class _AppointmentDetailsSheetState extends State<_AppointmentDetailsSheet> {
  late int _selectedRating;
  late final TextEditingController _feedbackController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating;
    _feedbackController = TextEditingController(text: widget.initialFeedback);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.of(context).viewInsets.bottom + 90,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),

          // Doctor Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.appointment.doctorName,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.appointment.appointmentDate} • Token ${widget.appointment.tokenNumber}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: widget.onDownloadPrescription,
                icon: const Icon(Icons.file_download_outlined),
                tooltip: 'Download',
              ),
            ],
          ),

          const SizedBox(height: 32),
          Text(
            "Rate your experience",
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Minimal Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final ratingValue = index + 1;
              final isSelected = ratingValue <= _selectedRating;
              return IconButton(
                onPressed: () => setState(() => _selectedRating = ratingValue),
                icon: Icon(
                  isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isSelected
                      ? colorScheme.secondary
                      : colorScheme.outlineVariant,
                  size: 36,
                ),
              );
            }),
          ),

          const SizedBox(height: 24),
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Share your thoughts (optional)',
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.2,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(20),
            ),
          ),

          const SizedBox(height: 32),

          // Primary Action
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedRating == 0 || _isSubmitting
                      ? null
                      : () async {
                          final nav = Navigator.of(context);
                          setState(() => _isSubmitting = true);
                          await widget.onSubmitRating(
                            _selectedRating,
                            _feedbackController.text.trim(),
                          );
                          if (mounted) nav.pop();
                        },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Save Feedback',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Maybe Later',
                    style: TextStyle(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

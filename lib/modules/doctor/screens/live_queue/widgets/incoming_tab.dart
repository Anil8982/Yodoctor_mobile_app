import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../controllers/incoming_appointment_controller.dart';
import 'incoming_appointment_card.dart';

class IncomingTab extends ConsumerStatefulWidget {
  const IncomingTab({super.key});

  @override
  ConsumerState<IncomingTab> createState() => _IncomingTabState();
}

class _IncomingTabState extends ConsumerState<IncomingTab> {
  int selectedFilter = 0;
  final List<String> filters = ["All", "Today", "Morning", "Evening"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final state = ref.watch(incomingAppointmentProvider);
    final notifier = ref.read(incomingAppointmentProvider.notifier);

    List appointments = state.appointments;

    if (selectedFilter == 1) {
      final today = DateTime.now().toString().substring(0, 10);
      appointments = appointments.where((e) {
        return e.appointmentDate.startsWith(today);
      }).toList();
    }

    if (selectedFilter == 2) {
      appointments = appointments.where((e) {
        return e.appointmentSlot.toUpperCase().contains("MORNING");
      }).toList();
    }

    if (selectedFilter == 3) {
      appointments = appointments.where((e) {
        return e.appointmentSlot.toUpperCase().contains("EVENING");
      }).toList();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await notifier.loadAppointments();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.loading && appointments.isNotEmpty)
                      const LinearProgressIndicator(),

                    /// Filters Chips in Horizontal Slider (Material 3)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(filters.length, (index) {
                          final selected = selectedFilter == index;
                          IconData icon;

                          switch (index) {
                            case 1:
                              icon = Icons.today_rounded;
                              break;
                            case 2:
                              icon = Icons.wb_sunny_outlined;
                              break;
                            case 3:
                              icon = Icons.nightlight_round_outlined;
                              break;
                            default:
                              icon = Icons.grid_view_rounded;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              showCheckmark: false,
                              avatar: Icon(
                                icon,
                                size: 16,
                                color: selected
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurfaceVariant,
                              ),
                              label: Text(
                                index == 0
                                    ? "All (${state.appointments.length})"
                                    : filters[index],
                              ),
                              selected: selected,
                              onSelected: (_) {
                                setState(() {
                                  selectedFilter = index;
                                });
                              },
                              backgroundColor: colorScheme
                                  .surfaceContainerHighest
                                  .transparency(0.5),
                              selectedColor: colorScheme.primaryContainer,
                              side: BorderSide(
                                color: selected
                                    ? AppTheme.transparent
                                    : colorScheme.outlineVariant.transparency(
                                        0.5,
                                      ),
                              ),
                              labelStyle: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: selected
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Auto Accept All Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: state.loading
                            ? null
                            : () async {
                                final ok = await notifier.autoAcceptAll();
                                if (!context.mounted) return;
                                if (ok) {
                                  AppSnackBar.show(
                                    message: 'All appointments auto-accepted',
                                    type: AppSnackBarType.success,
                                  );
                                } else {
                                  AppSnackBar.show(
                                    message: 'Auto-accept failed',
                                    type: AppSnackBarType.error,
                                  );
                                }
                              },
                        icon: const Icon(Icons.done_all_rounded),
                        label: const Text("Auto Accept All"),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Appointments List / Empty State
                    if (appointments.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 60,
                                color: colorScheme.outline,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                "No Incoming Appointments",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                "New appointment requests will appear here.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                onPressed: () async {
                                  await notifier.loadAppointments();
                                },
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text("Refresh"),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appointments.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return IncomingAppointmentCard(
                            appointment: appointment,
                            onAccept: () async {
                              final ok = await notifier.accept(appointment.id);
                              if (!context.mounted) return;
                              AppSnackBar.show(
                                message: ok
                                    ? "Appointment Accepted"
                                    : (state.errorMessage ?? "Action Failed"),
                                type: ok
                                    ? AppSnackBarType.success
                                    : AppSnackBarType.error,
                              );
                            },
                            onReject: () async {
                              final ok = await notifier.reject(appointment.id);
                              if (!context.mounted) return;
                              AppSnackBar.show(
                                message: ok
                                    ? "Appointment Rejected"
                                    : (state.errorMessage ?? "Action Failed"),
                                type: ok
                                    ? AppSnackBarType.success
                                    : AppSnackBarType.error,
                              );
                            },
                          );
                        },
                      ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

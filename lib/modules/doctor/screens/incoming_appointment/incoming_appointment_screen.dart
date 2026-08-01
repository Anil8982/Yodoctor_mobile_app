import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< Updated upstream
import 'package:yodoctor/modules/widgets/app_header.dart';
=======
import 'package:yodoctor/core/utils/app_spacing.dart';
>>>>>>> Stashed changes
import '../../controllers/incoming_appointment_controller.dart';
import '../../../patient/models/appointment/incoming_appointment_model.dart';
import '../incoming_appointment/widgets/incoming_appointment_filter.dart';

class IncomingAppointmentScreen extends ConsumerStatefulWidget {
  const IncomingAppointmentScreen({super.key});

  @override
  ConsumerState<IncomingAppointmentScreen> createState() =>
      _IncomingAppointmentScreenState();
}

class _IncomingAppointmentScreenState
    extends ConsumerState<IncomingAppointmentScreen> {
  int selectedFilter = 0;
  final List<String> filters = ["All", "Today", "Morning", "Evening"];

  @override
  void initState() {
    super.initState();
    // 🎯 FIXED: Removed duplicate Future.microtask execution block from here.
    // Initial sync lifecycle is now handled safely inside Notifier's build loop.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(incomingAppointmentProvider);
    final notifier = ref.read(incomingAppointmentProvider.notifier);

    List<IncomingAppointmentModel> appointments = state.appointments;

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

    return Scaffold(
<<<<<<< Updated upstream
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(title: 'Incoming Appointments'),
      body: state.loading && appointments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (state.loading && appointments.isNotEmpty)
                  LinearProgressIndicator(color: colorScheme.primary),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          children: List.generate(filters.length, (index) {
                            final selected = selectedFilter == index;

                            return ChoiceChip(
=======
      backgroundColor: colorScheme.onPrimary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text(
          "Incoming Appointments",
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: state.loading && appointments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.loading && appointments.isNotEmpty)
                    const LinearProgressIndicator(),

                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .01),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 1,
                          children: List.generate(filters.length, (index) {
                            final selected = selectedFilter == index;

                            IconData icon;

                            switch (index) {
                              case 1:
                                icon = Icons.today;
                                break;

                              case 2:
                                icon = Icons.wb_sunny_outlined;
                                break;

                              case 3:
                                icon = Icons.nightlight_round;
                                break;

                              default:
                                icon = Icons.grid_view;
                            }

                            return ChoiceChip(
                              showCheckmark: false,
                              avatar: Icon(icon, size: 16, color: Colors.black),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                            );
                          }),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: state.loading
                            ? null
                            : () async {
                                final ok = await notifier.autoAcceptAll();
                                if (!context.mounted) return;
                                if (ok) {
                                  _showSnackBar(
                                    context,
                                    "All appointments auto-accepted",
                                    isError: false,
                                  );
                                } else {
                                  _showSnackBar(
                                    context,
                                    state.errorMessage ?? "Auto-accept failed",
                                    isError: true,
                                  );
                                }
                              },
                        icon: const Icon(Icons.done_all),
                        label: const Text("Auto Accept All"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: appointments.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 20),
                              Text("No Incoming Appointments"),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await notifier.loadAppointments();
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            itemCount: appointments.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 18),
                            itemBuilder: (context, index) {
                              final appointment = appointments[index];

                              return IncomingAppointmentCard(
                                appointment: appointment,
                                onAccept: () async {
                                  final ok = await notifier.accept(
                                    appointment.id,
                                  );
                                  if (!context.mounted) return;
                                  if (ok) {
                                    _showSnackBar(
                                      context,
                                      "Appointment Accepted",
                                      isError: false,
                                    );
                                  } else {
                                    _showSnackBar(
                                      context,
                                      state.errorMessage ?? "Action failed",
                                      isError: true,
                                    );
                                  }
                                },
                                onReject: () async {
                                  final ok = await notifier.reject(
                                    appointment.id,
                                  );
                                  if (!context.mounted) return;
                                  if (ok) {
                                    _showSnackBar(
                                      context,
                                      "Appointment Rejected",
                                      isError: true,
                                    );
                                  } else {
                                    _showSnackBar(
                                      context,
                                      state.errorMessage ?? "Action failed",
                                      isError: true,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
=======
                              backgroundColor: const Color(0xffF4F6FA),
                              selectedColor: Colors.blue.shade100,
                              side: BorderSide.none,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: state.loading
                                ? null
                                : () async {
                                    final ok = await notifier.autoAcceptAll();
                                    if (!context.mounted) return;
                                    if (ok) {
                                      _showSnackBar(
                                        context,
                                        "All appointments auto-accepted",
                                        isError: false,
                                      );
                                    } else {
                                      _showSnackBar(
                                        context,
                                        state.errorMessage ??
                                            "Auto-accept failed",
                                        isError: true,
                                      );
                                    }
                                  },
                            icon: const Icon(Icons.done_all),
                            label: const Text("Auto Accept All"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: appointments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 60,
                                  color: Colors.grey,
                                ),

                                const SizedBox(height: AppSpacing.lg),

                                const Text("No Incoming Appointments"),

                                const SizedBox(height: AppSpacing.sm),

                                Text(
                                  "New appointment requests will appear here.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                FilledButton.icon(
                                  onPressed: () async {
                                    await notifier.loadAppointments();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Refresh"),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            color: colorScheme.primary,
                            onRefresh: () => notifier.loadAppointments(),
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              itemCount: appointments.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 18),
                              itemBuilder: (context, index) {
                                final appointment = appointments[index];

                                return IncomingAppointmentCard(
                                  appointment: appointment,

                                  onAccept: () async {
                                    final ok = await notifier.accept(
                                      appointment.id,
                                    );

                                    if (!context.mounted) return;

                                    _showSnackBar(
                                      context,
                                      ok
                                          ? "Appointment Accepted"
                                          : state.errorMessage ??
                                                "Action Failed",
                                      isError: !ok,
                                    );
                                  },

                                  onReject: () async {
                                    final ok = await notifier.reject(
                                      appointment.id,
                                    );

                                    if (!context.mounted) return;

                                    _showSnackBar(
                                      context,
                                      ok
                                          ? "Appointment Rejected"
                                          : state.errorMessage ??
                                                "Action Failed",
                                      isError: !ok,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
>>>>>>> Stashed changes
            ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String msg, {
    required bool isError,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w700)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}

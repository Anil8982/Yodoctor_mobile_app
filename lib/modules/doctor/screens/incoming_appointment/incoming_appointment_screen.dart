import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/incoming_appointment_controller.dart';
import '../../../../core/models/doctor/incoming_appointment_model.dart';
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

    Future.microtask(() {
      ref.read(incomingAppointmentProvider.notifier).loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Incoming Appointments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                            );
                          }),
                        ),
                      ),

                      FilledButton.icon(
                        onPressed: state.loading
                            ? null
                            : () async {
                                await notifier.autoAcceptAll();
                              },
                        icon: const Icon(Icons.done_all),
                        label: const Text("Auto Accept All"),
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 18),
                            itemBuilder: (context, index) {
                              final appointment = appointments[index];

                              return IncomingAppointmentCard(
                                appointment: appointment,

                                onAccept: () async {
                                  await notifier.accept(appointment.id);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Appointment Accepted"),
                                      ),
                                    );
                                  }
                                },

                                onReject: () async {
                                  await notifier.reject(appointment.id);
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yodoctor/modules/doctor/screens/manual_booking/widgets/booking_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../widgets/doctor_sliver_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/manual_booking_controller.dart';
import 'widgets/manual_booking_form.dart';

class ManualBookingScreen extends ConsumerStatefulWidget {
  const ManualBookingScreen({super.key});

  @override
  ConsumerState<ManualBookingScreen> createState() =>
      _ManualBookingScreenState();
}

class _ManualBookingScreenState extends ConsumerState<ManualBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _ageController = TextEditingController();
  bool _submittedOnce = false;

  @override
  void dispose() {
    _patientNameController.dispose();
    _mobileController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double horizontalPadding = Responsive.horizontalPadding(context);
    final state = ref.watch(manualBookingProvider);
    final notifier = ref.read(manualBookingProvider.notifier);

    return Container(
      color: colorScheme.surfaceContainerLow,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            DoctorSliverAppBar(
              titleText: 'Manual Booking',
              expandedHeight: 140.0,
              background: FlexibleSpaceBar(
                title: Text(
                  'Walk-in Registration',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                titlePadding: EdgeInsets.only(
                  left: horizontalPadding + 4,
                  bottom: AppSpacing.lg,
                ),
                centerTitle: false,
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      AppSpacing.xl,
                      horizontalPadding,
                      AppSpacing.xxxl,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const BookingHeader(),
                              const SizedBox(height: AppSpacing.xxl),
                              ManualBookingForm(
                                formKey: _formKey,
                                autovalidateMode: _submittedOnce
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                patientNameController:
                                _patientNameController,
                                mobileController: _mobileController,
                                ageController: _ageController,
                                selectedShift: state.selectedShift,
                                loading: state.loading,
                                onShiftChanged: (value) {
                                  if (value != null) {
                                    notifier.changeShift(value);
                                  }
                                },
                                onSubmit: () async {
                                  setState(() {
                                    _submittedOnce = true;
                                  });
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  final success = await notifier.submit(
                                    patientName:
                                    _patientNameController.text.trim(),
                                    mobile: _mobileController.text.trim(),
                                    age: _ageController.text.trim(),
                                  );

                                  if (!context.mounted) return;

                                  if (success) {
                                    setState(() {
                                      _submittedOnce = false;
                                    });
                                    _patientNameController.clear();
                                    _mobileController.clear();
                                    _ageController.clear();
                                    AppSnackBar.show(
                                      message:
                                      'Patient booked successfully! 🚀',
                                      type: AppSnackBarType.success,
                                    );
                                  } else {
                                    final currentState = ref.read(
                                      manualBookingProvider,
                                    );
                                    AppSnackBar.show(
                                      message:
                                      currentState.errorMessage ??
                                          "Registration failed. Try again.",
                                      type: AppSnackBarType.error,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
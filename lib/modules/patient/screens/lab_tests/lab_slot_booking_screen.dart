import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/patient/controllers/booking_controller.dart';
import 'package:yodoctor/modules/patient/controllers/lab_test_controller.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'widgets/lab_booking_step_container.dart';
import 'widgets/lab_booking_patient_fields.dart';
import 'widgets/lab_booking_address_fields.dart';
import 'widgets/lab_booking_date_time.dart';
import 'widgets/lab_booking_bottom_bar.dart';

class LabSlotBookingScreen extends ConsumerStatefulWidget {
  const LabSlotBookingScreen({super.key});

  @override
  ConsumerState<LabSlotBookingScreen> createState() =>
      _LabSlotBookingScreenState();
}

class _LabSlotBookingScreenState extends ConsumerState<LabSlotBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? validationMessage;
  late final ProviderSubscription<LabState> _labSubscription;

  @override
  void initState() {
    super.initState();

    _labSubscription = ref.listenManual(labProvider, (prev, next) {
      if (prev?.isPaymentLoading == false && next.isPaymentLoading == true) {
        context.push(AppRoutes.paymentProcessing);
        return;
      }

      if (prev?.isPaymentLoading == true && next.isPaymentLoading == false) {
        if (context.canPop()) context.pop();

        if (next.paymentError == null && next.lastBookingId != null) {
          context.push(
            AppRoutes.paymentSuccess,
            extra: {
              "paymentId": next.lastOrderId ?? '',
              "planName": 'Lab Test Booking',
              "nextRoute": AppRoutes.dashboard,
            },
          );
        } else if (next.paymentError != null) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(
              content: Text(next.paymentError!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _labSubscription.close();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bookingState = ref.watch(labBookingProvider);
    final labState = ref.watch(labProvider);
    final cartItems = labState.cart;
    final double totalPayable = cartItems.fold(
      0,
      (sum, item) => sum + item.currentPrice,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(title: 'Book a Slot'),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: colorScheme.primary.withValues(alpha: 0.04),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${cartItems.length} tests selected • ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '₹${totalPayable.toInt()}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LabBookingStepContainer(
                      step: 1,
                      title: 'Patient Details',
                      child: LabBookingPatientFields(
                        nameController: _nameController,
                        ageController: _ageController,
                        phoneController: _phoneController,
                        state: bookingState,
                      ),
                    ),
                    const SizedBox(height: 20),
                    LabBookingStepContainer(
                      step: 2,
                      title: 'Sample Pickup Address',
                      child: LabBookingAddressFields(
                        addressController: _addressController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    LabBookingStepContainer(
                      step: 3,
                      title: 'Select Date & Time',
                      child: LabBookingDateTime(state: bookingState),
                    ),
                  ],
                ),
              ),
            ),
            if (validationMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  validationMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            LabBookingBottomBar(
              state: bookingState,
              totalPayable: totalPayable,
              labState: labState,
              formKey: _formKey,
              validationMessage: validationMessage,
              onValidationChanged: (msg) =>
                  setState(() => validationMessage = msg),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/input_decoration_helper.dart';
import 'package:yodoctor/modules/patient/controllers/booking_controller.dart';

class LabBookingAddressFields extends ConsumerWidget {
  final TextEditingController addressController;

  const LabBookingAddressFields({super.key, required this.addressController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        InkWell(
          onTap: () async => await ref
              .read(labBookingProvider.notifier)
              .fetchCurrentLocation(addressController),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.my_location_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Use My Current Location',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: addressController,
          maxLines: 2,
          decoration: AppInputDecoration.build(
            context,
            label: 'Full Address *',
            prefixIcon: Icons.home_rounded,
          ),
          onChanged: (val) =>
              ref.read(labBookingProvider.notifier).updateAddress(val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Enter address';
            if (value.trim().length < 10) return 'Address is too short';
            return null;
          },
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:yodoctor/core/utils/app_spacing.dart';
// import '../../../../core/utils/app_spacing.dart';
// import 'widgets/manual_booking_form.dart';
//
// class ManualBookingScreen extends StatefulWidget {
//   const ManualBookingScreen({super.key});
//
//   @override
//   State<ManualBookingScreen> createState() => _ManualBookingScreenState();
// }
//
// class _ManualBookingScreenState extends State<ManualBookingScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   String _selectedShift = 'Evening Shift';
//
//   @override
//   void dispose() {
//     _patientNameController.dispose();
//     _mobileController.dispose();
//     _ageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return Scaffold(
//       backgroundColor: colorScheme.surfaceContainerLow,
//       appBar: AppBar(
//         title: const Text(
//           'Manual Booking',
//           style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
//         ),
//         centerTitle: true,
//         backgroundColor: colorScheme.surface,
//         foregroundColor: colorScheme.onSurface,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(AppSpacing.xl),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 480),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       text: 'Walk-in ',
//                       style: theme.textTheme.headlineMedium?.copyWith(
//                         color: colorScheme.onSurface,
//                         fontWeight: FontWeight.w900,
//                         letterSpacing: -0.8,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Registration',
//                           style: TextStyle(color: colorScheme.primary),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     'Directly add patients to your current live tracking queue.',
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: colorScheme.onSurfaceVariant,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: AppSpacing.xl),
//                   ManualBookingForm(
//                     formKey: _formKey,
//                     patientNameController: _patientNameController,
//                     mobileController: _mobileController,
//                     ageController: _ageController,
//                     selectedShift: _selectedShift,
//                     onShiftChanged: (value) {
//                       if (value == null) return;
//                       setState(() => _selectedShift = value);
//                     },
//                     onSubmit: _bookAppointment,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _bookAppointment() {
//     if (!_formKey.currentState!.validate()) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 'Booked successfully for ${_patientNameController.text.trim()}',
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: theme.colorScheme.primary,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//
//     _patientNameController.clear();
//     _mobileController.clear();
//     _ageController.clear();
//     setState(() => _selectedShift = 'Evening Shift');
//   }
// }
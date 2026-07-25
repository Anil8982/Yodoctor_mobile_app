// import 'package:flutter/material.dart';
// import 'package:chroma_kit/chroma_kit.dart';
//
// class NoActivePlanCard extends StatelessWidget {
//   final VoidCallback onUpgradePressed;
//
//   const NoActivePlanCard({super.key, required this.onUpgradePressed});
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFFE65100), Color(0xFFF57C00)], // Warm amber/orange gradient for attention
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFF57C00).transparency(0.25),
//             blurRadius: 24,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Stack(
//           children: [
//             Positioned(
//               right: -40,
//               top: -40,
//               child: CircleAvatar(
//                 radius: 100,
//                 backgroundColor: Colors.white.transparency(0.05),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(28.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'SUBSCRIPTION STATUS',
//                         style: textTheme.labelMedium?.copyWith(
//                           color: Colors.white.transparency(0.75),
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1.5,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 14,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.transparency(0.18),
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                             color: Colors.white.transparency(0.25),
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const CircleAvatar(
//                               radius: 3,
//                               backgroundColor: Color(0xFFFF5252), // Red dot for inactive
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Inactive',
//                               style: textTheme.labelLarge?.copyWith(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w900,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No Active Plan',
//                     style: textTheme.headlineLarge?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w900,
//                       letterSpacing: -0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     'Unlock full access to patient records, appointments, and telemedicine features by activating a plan.',
//                     style: textTheme.bodyMedium?.copyWith(
//                       color: Colors.white.transparency(0.85),
//                       height: 1.4,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     height: 48,
//                     child: ElevatedButton.icon(
//                       onPressed: onUpgradePressed,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: const Color(0xFFE65100),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                       ),
//                       icon: const Icon(Icons.bolt_rounded, size: 20),
//                       label: const Text(
//                         'Explore Plans & Activate',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
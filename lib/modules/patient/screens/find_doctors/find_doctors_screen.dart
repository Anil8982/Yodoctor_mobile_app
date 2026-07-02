// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/theme/app_theme.dart';
// import '../../../../core/utils/app_spacing.dart';
// import '../../../../core/utils/dummy_data.dart';
// import '../../../../core/utils/responsive.dart';
// import '../../controllers/doctor_listing_controller.dart';
// import 'widgets/doctor_card.dart';

// class FindDoctorsScreen extends StatefulWidget {
//   const FindDoctorsScreen({super.key, this.initialQuery = ''});

//   final String initialQuery;

//   @override
//   State<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
// }

// class _FindDoctorsScreenState extends State<FindDoctorsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<DoctorListingController>().loadDoctors(
//         query: widget.initialQuery,
//       );
//     });
//   }

//   @override
//   void didUpdateWidget(covariant FindDoctorsScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.initialQuery != widget.initialQuery) {
//       context.read<DoctorListingController>().loadDoctors(
//         query: widget.initialQuery,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Consumer<DoctorListingController>(
//       builder: (context, controller, child) {
//         final bool mobile = Responsive.isMobile(context);
//         final bool desktop = Responsive.isDesktop(context);
//         final double horizontal = Responsive.horizontalPadding(context);

//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             elevation: 0,
//             scrolledUnderElevation: 0,
//             flexibleSpace: DecoratedBox(
//               decoration: BoxDecoration(gradient: AppTheme.patientGradient),
//             ),
//             centerTitle: false,
//             leadingWidth: 72,
//             leading: Center(child: _buildBackButton(context, colorScheme)),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Find Doctors',
//                   style: theme.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: colorScheme.onPrimary,
//                   ),
//                 ),
//                 if (controller.activeQuery.isNotEmpty)
//                   Text(
//                     'Results for "${controller.activeQuery}"',
//                     style: theme.textTheme.labelSmall?.copyWith(
//                       color: colorScheme.onPrimary.withValues(alpha: 0.8),
//                     ),
//                   ),
//               ],
//             ),
//             actions: [
//               _buildResultCounter(controller, colorScheme),
//               const SizedBox(width: AppSpacing.md),
//             ],
//           ),
//           body: RefreshIndicator(
//             onRefresh: () =>
//                 controller.loadDoctors(query: controller.activeQuery),
//             child: controller.isLoading && controller.doctors.isEmpty
//                 ? const _LoadingView()
//                 : CustomScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     slivers: [
//                       // --- Sticky Filter Section ---
//                       SliverToBoxAdapter(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: horizontal,
//                             vertical: AppSpacing.md,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (controller.activeQuery.trim().isNotEmpty)
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     bottom: AppSpacing.md,
//                                   ),
//                                   child: Text(
//                                     'Results for "${controller.activeQuery}"',
//                                     style: theme.textTheme.bodyMedium?.copyWith(
//                                       color: colorScheme.onSurfaceVariant,
//                                     ),
//                                   ),
//                                 ),
//                               _buildSpecialtyFilters(controller),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // --- Doctor Listing ---
//                       SliverPadding(
//                         padding: EdgeInsets.fromLTRB(
//                           horizontal,
//                           0,
//                           horizontal,
//                           AppSpacing.xxs,
//                         ),
//                         sliver: controller.doctors.isEmpty
//                             ? const SliverToBoxAdapter(
//                                 child: _EmptyDoctorsView(),
//                               )
//                             : _buildDoctorGrid(controller, mobile, desktop),
//                       ),
//                     ],
//                   ),
//           ),
//         );
//       },
//     );
//   }

//   // --- Widgets: Back Button ---
//   Widget _buildBackButton(BuildContext context, ColorScheme colorScheme) {
//     return IconButton(
//       icon: Icon(
//         Icons.arrow_back_rounded,
//         color: colorScheme.onPrimary,
//       ),
//       onPressed: () {
//         if (context.canPop()) {
//           context.pop();
//         } else {
//           context.go(AppRoutes.dashboard);
//         }
//       },
//     );
//   }

//   // --- Widgets: Result Counter ---
//   Widget _buildResultCounter(
//     DoctorListingController controller,
//     ColorScheme colorScheme,
//   ) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: ShapeDecoration(
//           shape: const StadiumBorder(),
//           color: colorScheme.secondaryContainer,
//         ),
//         child: Text(
//           '${controller.foundCount} found',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//             color: colorScheme.onSecondaryContainer,
//           ),
//         ),
//       ),
//     );
//   }

//   // --- Widgets: Filter Row ---
//   Widget _buildSpecialtyFilters(DoctorListingController controller) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       physics: const BouncingScrollPhysics(),
//       child: Row(
//         children: controller.specialties.map((String item) {
//           final isSelected = controller.selectedSpecialty == item;
//           return Padding(
//             padding: const EdgeInsets.only(right: 8),
//             child: FilterChip(
//               label: Text(item),
//               selected: isSelected,
//               onSelected: (_) => controller.setSpecialty(item),
//               showCheckmark: false,
//               labelStyle: TextStyle(
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected
//                     ? Theme.of(context).colorScheme.onPrimary
//                     : null,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   // --- Widgets: Doctor List / Grid ---
//   Widget _buildDoctorGrid(
//     DoctorListingController controller,
//     bool mobile,
//     bool desktop,
//   ) {
//     if (mobile) {
//       return SliverList(
//         delegate: SliverChildBuilderDelegate(
//           (context, index) => DoctorCard(
//             doctor: controller.doctors[index],
//             onProfileTap: () => _openDoctorProfile(context, controller.doctors[index]),
//             onBookTap: () => _openBookAppointment(
//               context,
//               controller.doctors[index],
//             ),
//           ),
//           childCount: controller.doctors.length,
//         ),
//       );
//     }

//     final int columns = desktop ? 3 : 2;
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: columns,
//         mainAxisSpacing: AppSpacing.sm,
//         crossAxisSpacing: AppSpacing.sm,
//         childAspectRatio: desktop ? 1.4 : 1.1,
//       ),
//       delegate: SliverChildBuilderDelegate(
//         (context, index) => DoctorCard(
//           doctor: controller.doctors[index],
//           onProfileTap: () => _openDoctorProfile(context, controller.doctors[index]),
//           onBookTap: () => _openBookAppointment(
//             context,
//             controller.doctors[index],
//           ),
//         ),
//         childCount: controller.doctors.length,
//       ),
//     );
//   }

//   void _openDoctorProfile(BuildContext context, DoctorProfile doctor) {
//     context.push(AppRoutes.doctorDetail, extra: doctor);
//   }

//   void _openBookAppointment(BuildContext context, DoctorProfile doctor) {
//     context.push(AppRoutes.bookAppointment, extra: doctor);
//   }
// }

// // --- Helper Views ---
// class _LoadingView extends StatelessWidget {
//   const _LoadingView();
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: CircularProgressIndicator.adaptive());
//   }
// }

// class _EmptyDoctorsView extends StatelessWidget {
//   const _EmptyDoctorsView();
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 50),
//           Icon(
//             Icons.person_search_outlined,
//             size: 64,
//             color: colorScheme.outline,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No doctors found',
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const Text('Try adjusting your filters or search query'),
//         ],
//       ),
//     );
//   }
// }

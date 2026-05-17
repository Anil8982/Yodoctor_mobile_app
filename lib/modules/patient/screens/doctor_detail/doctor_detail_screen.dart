import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/models/doctor_profile.dart';
import 'widgets/doctor_header_card.dart';
import 'widgets/doctor_info_grid.dart';
import 'widgets/take_action_card.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key, required this.doctor});

  final DoctorProfile doctor;

  void _openBookAppointment(BuildContext context, DoctorProfile doctor) {
    context.push(AppRoutes.bookAppointment, extra: doctor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Doctor Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: AppSpacing.lg,
          ),
          child: ResponsiveContainer(
            child: _buildContent(context, isMobile, isTablet, isDesktop),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, bool isMobile, bool isTablet, bool isDesktop) {
    if (isDesktop || isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorHeaderCard(doctor: doctor),
                const SizedBox(height: AppSpacing.xl),
                DoctorInfoGrid(doctor: doctor),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TakeActionCard(
                  doctor: doctor,
                  onBookPressed: () => _openBookAppointment(context, doctor),
                ),
              ],
            ),
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DoctorHeaderCard(doctor: doctor),
        const SizedBox(height: AppSpacing.xl),
        DoctorInfoGrid(doctor: doctor),
        const SizedBox(height: AppSpacing.xl),
        TakeActionCard(
          doctor: doctor,
          onBookPressed: () => _openBookAppointment(context, doctor),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
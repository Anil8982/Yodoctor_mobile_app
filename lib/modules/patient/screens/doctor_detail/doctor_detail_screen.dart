import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/models/patient/doctor_profile.dart';
import 'widgets/doctor_header_card.dart';
import 'widgets/doctor_info_grid.dart';

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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(gradient: AppTheme.patientGradient),
        ),
        title: Text(
          'Doctor Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onPrimary,
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
      bottomNavigationBar: isMobile
          ? Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.transparency(0.3),
              width: 1,
            ),
          ),
        ),
        child: _buildBookingButton(context),
      )
          : null,
    );
  }

  Widget _buildContent(
      BuildContext context, bool isMobile, bool isTablet, bool isDesktop) {
    if (isDesktop || isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 12,
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
            flex: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.transparency(0.3),
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Consultation Fee',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${doctor.consultationFee.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildBookingButton(context),
                ],
              ),
            ),
          )
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DoctorHeaderCard(doctor: doctor),
        const SizedBox(height: AppSpacing.sm),
        DoctorInfoGrid(doctor: doctor),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _openBookAppointment(context, doctor),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.calendar_month_rounded, size: 20),
        label: const Text(
          'Book Appointment',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        ),
      ),
    );
  }
}
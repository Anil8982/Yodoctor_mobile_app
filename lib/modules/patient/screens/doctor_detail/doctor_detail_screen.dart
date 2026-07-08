import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import 'widgets/doctor_header_card.dart';
import 'widgets/doctor_info_grid.dart';
import '../../models/search/doctor_detail_model.dart';
import 'package:provider/provider.dart';
import '../../controllers/DoctorDetailController.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({super.key, required this.doctorId});

  final int doctorId;

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorDetailController>().loadDoctor(widget.doctorId);
    });
  }

  void _openBookAppointment(BuildContext context, DoctorDetailModel doctor) {
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
      body: Consumer<DoctorDetailController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          if (controller.doctor == null) {
            return const SizedBox();
          }

          final doctor = controller.doctor!;

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
                vertical: AppSpacing.lg,
              ),
              child: ResponsiveContainer(
                child: _buildContent(
                  context,
                  Responsive.isMobile(context),
                  Responsive.isTablet(context),
                  Responsive.isDesktop(context),
                  doctor,
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: isMobile
          ? Consumer<DoctorDetailController>(
              builder: (context, controller, child) {
                if (controller.doctor == null) {
                  return const SizedBox();
                }

                return Container(
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
                  child: _buildBookingButton(context, controller.doctor!),
                );
              },
            )
          : null,
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    DoctorDetailModel doctor,
  ) {
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
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.transparency(0.3),
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildBookingButton(context, doctor),
                ],
              ),
            ),
          ),
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

  Widget _buildBookingButton(BuildContext context, DoctorDetailModel doctor) {
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

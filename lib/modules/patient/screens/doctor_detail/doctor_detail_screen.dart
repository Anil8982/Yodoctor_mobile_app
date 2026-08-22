import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import 'widgets/doctor_header_card.dart';
import 'widgets/doctor_info_grid.dart';
import '../../models/search/doctor_detail_model.dart';
import '../../controllers/doctor_detail_controller.dart';

class DoctorDetailScreen extends ConsumerStatefulWidget {
  const DoctorDetailScreen({super.key, required this.doctorId});

  final int doctorId;

  @override
  ConsumerState<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends ConsumerState<DoctorDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(doctorDetailControllerProvider.notifier)
          .loadDoctor(widget.doctorId);
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

    final doctorState = ref.watch(doctorDetailControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(title: 'Doctor Details'),
      body: () {
        if (doctorState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (doctorState.errorMessage != null) {
          return Center(child: Text(doctorState.errorMessage!));
        }

        if (doctorState.doctor == null) {
          return const SizedBox();
        }

        final doctor = doctorState.doctor!;

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
                isMobile,
                isTablet,
                isDesktop,
                doctor,
              ),
            ),
          ),
        );
      }(),
      bottomNavigationBar: isMobile && doctorState.doctor != null
          ? SafeArea(
              child: Container(
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
                child: _buildBookingButton(context, doctorState.doctor!),
              ),
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
        onPressed: doctor.isAvailable == 1
            ? () => _openBookAppointment(context, doctor)
            : null,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'package:yodoctor/modules/patient/screens/certificates/widgets/doctor_card_widget.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_shimmer.dart';

class DoctorSelectionScreen extends ConsumerStatefulWidget {
  const DoctorSelectionScreen({super.key});

  @override
  ConsumerState<DoctorSelectionScreen> createState() =>
      _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends ConsumerState<DoctorSelectionScreen> {
  static const String _subTag = 'DoctorSelectionScreen';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppLogger.info('Initializing doctor selection screen', tag: LogTags.patient, subTag: _subTag);
      ref.read(certificateProvider.notifier).loadDoctors();
    });
  }

  Future<void> _onRefresh() async {
    AppLogger.info('Refreshing doctor list', tag: LogTags.patient, subTag: _subTag);
    await ref.read(certificateProvider.notifier).loadDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(certificateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use state.isDoctorsLoading to correctly check loading status
    final bool isFetching = state.isDoctorsLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppHeader(
        title: 'Select Certificate Doctor',
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: isFetching
              ? ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _DoctorCardShimmer(),
            ),
          )
              : state.doctors.isEmpty
              ? LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Center(
                  child: Text(
                    'No certificate doctors available at the moment.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          )
              : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: state.doctors.length,
            itemBuilder: (context, index) {
              final doctor = state.doctors[index];
              final isSelected = state.assignedDoctor?.id == doctor.id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DoctorCardWidget(
                  doctor: doctor,
                  isSelected: isSelected,
                  onTap: () {
                    AppLogger.info(
                      'Selected doctor ID: ${doctor.id}, Name: ${doctor.name}',
                      tag: LogTags.patient,
                      subTag: _subTag,
                    );

                    context.push(
                      AppRoutes.applyCertificate,
                      extra: doctor,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DoctorCardShimmer extends StatelessWidget {
  const _DoctorCardShimmer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ShimmerBox(
              width: 60,
              height: 60,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: ShimmerBox(
                          height: 14,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      SizedBox(width: 8),
                      ShimmerBox(
                        width: 40,
                        height: 18,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const ShimmerBox(
                    width: 100,
                    height: 12,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      ShimmerBox(
                        width: 50,
                        height: 12,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      SizedBox(width: 12),
                      ShimmerBox(
                        width: 120,
                        height: 12,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const ShimmerCircle(size: 28),
          ],
        ),
      ),
    );
  }
}
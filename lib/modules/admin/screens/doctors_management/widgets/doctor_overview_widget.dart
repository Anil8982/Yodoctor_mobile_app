import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/admin/controllers/doctors_management_controller.dart'; // तुझ्या कंट्रोलरचा अचूक पाथ टाक

class DoctorsOverviewWidget extends ConsumerWidget {
  const DoctorsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsStateAsync = ref.watch(doctorsManagementProvider);

    return doctorsStateAsync.maybeWhen(
      data: (state) {
        final allDoctors = state.allDoctors;

        final totalDoctors = allDoctors.length;
        final totalSpecialities = allDoctors.map((e) => e.specialty).toSet().length;

        double averageRating = 0.0;
        if (allDoctors.isNotEmpty) {
          final totalRating = allDoctors.fold<double>(0, (sum, doc) => sum + doc.rating);
          averageRating = totalRating / allDoctors.length;
        }

        final totalReviews = allDoctors.fold<int>(0, (sum, doc) => sum + doc.reviewCount);

        final cards = [
          _DoctorOverviewCardData(
            title: 'Total Doctors',
            value: totalDoctors.toString(),
            icon: Icons.people_outline,
            color: Colors.blue,
          ),
          _DoctorOverviewCardData(
            title: 'Pending Review',
            value: totalSpecialities.toString(),
            icon: Icons.medical_services_outlined,
            color: Colors.green,
          ),
          _DoctorOverviewCardData(
            title: 'Average Rating',
            value: averageRating.toStringAsFixed(1),
            icon: Icons.star_outline,
            color: Colors.orange,
          ),
          _DoctorOverviewCardData(
            title: 'Reviews',
            value: totalReviews.toString(),
            icon: Icons.reviews_outlined,
            color: Colors.purple,
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DOCTORS OVERVIEW',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _DoctorOverviewCard(item: cards[0])),
                const SizedBox(width: 16),
                Expanded(child: _DoctorOverviewCard(item: cards[1])),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _DoctorOverviewCard(item: cards[2])),
                const SizedBox(width: 16),
                Expanded(child: _DoctorOverviewCard(item: cards[3])),
              ],
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _DoctorOverviewCard extends StatelessWidget {
  const _DoctorOverviewCard({
    required this.item,
  });

  final _DoctorOverviewCardData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.transparency(.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: item.color.transparency(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 20,
            ),
          ),
          Text(
            item.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorOverviewCardData {
  const _DoctorOverviewCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
}
import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import '../../../models/search/doctor_detail_model.dart';

class DoctorHeaderCard extends StatefulWidget {
  const DoctorHeaderCard({super.key, required this.doctor});

  final DoctorDetailModel doctor;

  @override
  State<DoctorHeaderCard> createState() => _DoctorHeaderCardState();
}

class _DoctorHeaderCardState extends State<DoctorHeaderCard> {
  bool _isAboutExpanded = false;

  // 🎯 HELPER WIDGET BY SATYAM STUDIOS: नावाचं पहिलं आद्यक्षर दाखवण्यासाठी फॉलबॅक विजेट
  Widget _buildInitialAvatar(TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: Text(
        widget.doctor.doctorName.isNotEmpty
            ? widget.doctor.doctorName.replaceAll('Dr. ', '')[0]
            : 'D',
        style: textTheme.headlineMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool hasImage =
        widget.doctor.profileImage.isNotEmpty &&
        widget.doctor.profileImage.startsWith('http');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.transparency(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🎯 IMAGE CONTAINER GUARD
              Container(
                width: 76,
                height: 76,
                clipBehavior: Clip
                    .antiAlias, // इमेज बॉर्डरच्या बाहेर जाऊ नये म्हणून कडक कटिंग
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.transparency(0.35),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colorScheme.primary.transparency(0.5),
                    width: 1.5,
                  ),
                ),
                child: hasImage
                    ? Image.network(
                        widget.doctor.profileImage,
                        fit: BoxFit.cover,
                        // 🎯 SAFE ERROR CATCH: S3 एरर किंवा इंटरनेट बंद असल्यास पहिल्यासारखा बॅकअप रेंडर होईल!
                        errorBuilder: (context, error, stackTrace) {
                          return _buildInitialAvatar(textTheme, colorScheme);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      )
                    : _buildInitialAvatar(textTheme, colorScheme),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.doctorName,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.doctor.specialization,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.work_history_rounded,
                          size: 14,
                          color: colorScheme.onSurface.transparency(0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.doctor.experienceYears} Yrs Exp',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.doctor.qualification,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.transparency(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.transparency(0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.doctor.isAvailable == 1
                      ? 'Available'
                      : 'Not Available',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.amber.transparency(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${widget.doctor.rating}',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.amber[900],
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 0.8),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.primary.transparency(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.transparency(0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.confirmation_num_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Apply Medical Certificate / Voucher',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 0.8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'About Doctor',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAboutExpanded = !_isAboutExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isAboutExpanded ? "Read Less" : "Read More",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        _isAboutExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: colorScheme.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: Text(
              widget.doctor.description.isEmpty
                  ? "No description available."
                  : widget.doctor.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
                fontSize: 13,
              ),
            ),
            secondChild: Text(
              widget.doctor.description.isEmpty
                  ? "No description available."
                  : widget.doctor.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
                fontSize: 13,
              ),
            ),
            crossFadeState: _isAboutExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

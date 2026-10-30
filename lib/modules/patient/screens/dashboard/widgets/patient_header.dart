import 'package:flutter/material.dart';

import '../../../models/dashboard/dashboard_model.dart';

class PatientHeader extends StatelessWidget {
  const PatientHeader({super.key, this.dashboard});

  final DashboardModel? dashboard;

  String _getTimeGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final locale = Localizations.localeOf(context).languageCode;
    if (hour < 12) {
      return locale == 'hi' ? 'शुभ प्रभात' : 'Good morning';
    } else if (hour < 17) {
      return locale == 'hi' ? 'शुभ दोपहर' : 'Good afternoon';
    } else {
      return locale == 'hi' ? 'शुभ संध्या' : 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String rawName = dashboard?.patientName.trim() ?? '';
    final String greeting = _getTimeGreeting(context);
    final String fullGreeting = rawName.isNotEmpty
        ? '$greeting, $rawName'
        : greeting;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            fullGreeting,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

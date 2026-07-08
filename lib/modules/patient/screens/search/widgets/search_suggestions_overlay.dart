import 'package:flutter/material.dart';
import 'package:yodoctor/modules/patient/controllers/patient_search_controller.dart';

class SearchSuggestionsOverlay extends StatelessWidget {
  final PatientSearchController controller;
  final TextEditingController searchController;
  final Function(BuildContext, PatientSearchController) onSearchTap;

  const SearchSuggestionsOverlay({
    super.key,
    required this.controller,
    required this.searchController,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: controller.doctorSuggestions.length,
      separatorBuilder: (context, index) =>
      const Divider(height: 1, indent: 20, endIndent: 20),
      itemBuilder: (context, index) {
        final doc = controller.doctorSuggestions[index];
        final query = controller.query.toLowerCase();

        String displayTitle = '';
        String displaySubtitle = '';
        IconData icon = Icons.person_search_rounded;

        // Contextual Logic for matching fields
        if (doc.name.toLowerCase().contains(query)) {
          displayTitle = doc.name;
          displaySubtitle = "${doc.specialty} • ${doc.hospital}";
          icon = Icons.person_rounded;
        } else if (doc.specialty.toLowerCase().contains(query)) {
          displayTitle = doc.specialty;
          displaySubtitle = "Doctor: ${doc.name} • ${doc.hospital}";
          icon = Icons.medical_services_rounded;
        } else if (doc.hospital.toLowerCase().contains(query)) {
          displayTitle = doc.hospital;
          displaySubtitle = "${doc.specialty} • ${doc.name}";
          icon = Icons.local_hospital_rounded;
        } else {
          displayTitle = doc.name;
          displaySubtitle = doc.specialty;
        }

        return ListTile(
          visualDensity: VisualDensity.compact,
          leading: CircleAvatar(
            backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          title: Text(
            displayTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            displaySubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            Icons.north_west_rounded,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            searchController.text = displayTitle;
            controller.clearSuggestions();
            onSearchTap(context, controller);
          },
        );
      },
    );
  }
}

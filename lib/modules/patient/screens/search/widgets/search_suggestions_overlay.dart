import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/models/search/suggestion_model.dart';

class SearchSuggestionsOverlay extends ConsumerWidget {
  final List<SuggestionModel> suggestions;
  final TextEditingController searchController;
  final Function(SuggestionModel) onSelect;
  final String? searchQuery;

  const SearchSuggestionsOverlay({
    super.key,
    required this.suggestions,
    required this.searchController,
    required this.onSelect,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: suggestions.length,
      separatorBuilder: (context, index) =>
      const Divider(height: 1, indent: 20, endIndent: 20),
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        final icon = _getSuggestionIcon(suggestion);

        return ListTile(
          visualDensity: VisualDensity.compact,
          leading: CircleAvatar(
            backgroundColor: colorScheme.primary.withValues(alpha: 0.08),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          title: _buildHighlightedText(
            suggestion.title,
            searchQuery ?? '',
            theme,
          ),
          subtitle: suggestion.subtitle != null
              ? Text(
            suggestion.subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
              : null,
          trailing: Icon(
            Icons.north_west_rounded,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            searchController.text = suggestion.title;
            onSelect(suggestion);
          },
        );
      },
    );
  }

  IconData _getSuggestionIcon(SuggestionModel suggestion) {
    final subtitle = suggestion.subtitle ?? '';

    if (subtitle.contains('Clinic')) {
      return Icons.local_hospital_rounded;
    }
    if (subtitle.contains('Doctor')) {
      return Icons.person_rounded;
    }
    if (subtitle.contains('Specialty') || subtitle.contains('Specialist')) {
      return Icons.medical_services_rounded;
    }
    if (subtitle.contains('Location') || subtitle.contains('City')) {
      return Icons.location_on_rounded;
    }
    if (suggestion.title.toLowerCase().contains('clinic')) {
      return Icons.local_hospital_rounded;
    }
    if (suggestion.title.toLowerCase().contains('hospital')) {
      return Icons.local_hospital_rounded;
    }
    if (suggestion.title.toLowerCase().contains('dr') ||
        suggestion.title.toLowerCase().contains('doctor')) {
      return Icons.person_rounded;
    }

    return Icons.search_rounded;
  }

  Widget _buildHighlightedText(
      String text,
      String query,
      ThemeData theme,
      ) {
    if (query.isEmpty) {
      return Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final endIndex = startIndex + query.length;
    final before = text.substring(0, startIndex);
    final highlighted = text.substring(startIndex, endIndex);
    final after = text.substring(endIndex);

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
        children: [
          TextSpan(text: before),
          TextSpan(
            text: highlighted,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
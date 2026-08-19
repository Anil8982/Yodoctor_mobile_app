import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/patient/controllers/patient_search_controller.dart';
import 'package:yodoctor/modules/patient/screens/search/widgets/search_suggestions_overlay.dart';
import '../../../../widgets/app_search_field.dart';

class DoctorSearchWidget extends ConsumerStatefulWidget {
  final bool isHero;
  final VoidCallback? onSearchOverride; // 🎯 Optional custom callback for search action

  const DoctorSearchWidget({
    super.key,
    this.isHero = false,
    this.onSearchOverride,
  });

  @override
  ConsumerState<DoctorSearchWidget> createState() => _DoctorSearchWidgetState();
}

class _DoctorSearchWidgetState extends ConsumerState<DoctorSearchWidget>
    with WidgetsBindingObserver {
  late final TextEditingController _locationController;
  late final TextEditingController _searchController;
  final LayerLink _searchLink = LayerLink();
  final LayerLink _locationLink = LayerLink();
  OverlayEntry? _searchOverlayEntry;
  OverlayEntry? _locationOverlayEntry;
  double _lastKeyboardInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final searchState = ref.read(patientSearchControllerProvider);
    _locationController = TextEditingController(
      text: searchState.locationQuery,
    );
    _searchController = TextEditingController(text: searchState.searchQuery);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeOverlays();
    _locationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding
        .instance
        .platformDispatcher
        .views
        .first
        .viewInsets
        .bottom;

    final keyboardWasOpen = _lastKeyboardInset > 0;
    final keyboardIsClosed = bottomInset == 0;

    if (keyboardWasOpen && keyboardIsClosed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        FocusManager.instance.primaryFocus?.unfocus();
      });
    }

    _lastKeyboardInset = bottomInset;
  }

  void _removeOverlays() {
    _searchOverlayEntry?.remove();
    _searchOverlayEntry = null;
    _locationOverlayEntry?.remove();
    _locationOverlayEntry = null;
  }

  void _onSearchTap() {
    _removeOverlays();

    FocusManager.instance.primaryFocus?.unfocus();

    if (widget.onSearchOverride != null) {
      widget.onSearchOverride!();
      return;
    }

    final controller = ref.read(patientSearchControllerProvider.notifier);
    final params = controller.prepareSearch();

    final queryParams = <String, String>{};
    if (params.search.trim().isNotEmpty) {
      queryParams['q'] = params.search.trim();
    }
    if (params.city.trim().isNotEmpty) {
      queryParams['city'] = params.city.trim();
    }

    if (queryParams.isEmpty) {
      context.push(AppRoutes.search);
      return;
    }

    final queryString = queryParams.entries
        .map(
          (e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
    )
        .join('&');

    context.push('${AppRoutes.search}?$queryString');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final searchState = ref.watch(patientSearchControllerProvider);
    final notifier = ref.read(patientSearchControllerProvider.notifier);

    if (_searchController.text != searchState.searchQuery) {
      _searchController.value = _searchController.value.copyWith(
        text: searchState.searchQuery,
        selection: TextSelection.collapsed(
          offset: searchState.searchQuery.length,
        ),
      );
    }
    if (_locationController.text != searchState.locationQuery) {
      _locationController.value = _locationController.value.copyWith(
        text: searchState.locationQuery,
        selection: TextSelection.collapsed(
          offset: searchState.locationQuery.length,
        ),
      );
    }

    final hasSearchSuggestions = searchState.searchSuggestions.isNotEmpty;
    final hasCitySuggestions = searchState.citySuggestions.isNotEmpty;
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOverlays(
        hasSearchSuggestions,
        hasCitySuggestions,
        searchState,
        notifier,
        colorScheme,
        screenWidth,
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CompositedTransformTarget(
          link: _locationLink,
          child: _buildSearchWrapper(
            colorScheme,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _locationController,
              builder: (context, value, child) {
                return AppSearchField(
                  controller: _locationController,
                  hintText: 'Location',
                  onChanged: (val) => notifier.updateLocation(val),
                  prefixIcon: Icon(
                    Icons.location_on_rounded,
                    color: colorScheme.primary,
                  ),
                  suffixIcon: value.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    onPressed: () {
                      _locationController.clear();
                      notifier.updateLocation('');
                      if (widget.onSearchOverride != null) {
                        widget.onSearchOverride!();
                      }
                    },
                  )
                      : null,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: CompositedTransformTarget(
                link: _searchLink,
                child: _buildSearchWrapper(
                  colorScheme,
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, child) {
                      return AppSearchField(
                        controller: _searchController,
                        hintText: 'Search doctors...',
                        onChanged: (val) => notifier.updateSearch(val),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colorScheme.primary,
                        ),
                        suffixIcon: value.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            notifier.updateSearch('');
                            if (widget.onSearchOverride != null) {
                              widget.onSearchOverride!();
                            }
                          },
                        )
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildSearchButton(colorScheme),
          ],
        ),
      ],
    );
  }

  void _updateOverlays(
      bool hasSearchSuggestions,
      bool hasCitySuggestions,
      dynamic searchState,
      dynamic notifier,
      ColorScheme colorScheme,
      double screenWidth,
      ) {
    _removeOverlays();

    // Search field suggestions - always below
    final searchTargetAnchor = Alignment.bottomLeft;
    final searchFollowerAnchor = Alignment.topLeft;
    final searchOffset = const Offset(0, 8);

    // Location field suggestions - depends on isHero
    final locationTargetAnchor =
    widget.isHero ? Alignment.bottomLeft : Alignment.topLeft;
    final locationFollowerAnchor =
    widget.isHero ? Alignment.topLeft : Alignment.bottomLeft;
    final locationOffset =
    widget.isHero ? const Offset(0, 8) : const Offset(0, -8);

    if (hasSearchSuggestions) {
      _searchOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: screenWidth - 64,
          child: CompositedTransformFollower(
            link: _searchLink,
            showWhenUnlinked: false,
            targetAnchor: searchTargetAnchor,
            followerAnchor: searchFollowerAnchor,
            offset: searchOffset,
            child: Material(
              elevation: 24,
              borderRadius: BorderRadius.circular(24),
              color: colorScheme.surface,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 350),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outlineVariant.transparency(0.4),
                  ),
                ),
                child: SearchSuggestionsOverlay(
                  suggestions: searchState.searchSuggestions,
                  searchController: _searchController,
                  searchQuery: searchState.searchQuery,
                  onSelect: (suggestion) {
                    notifier.selectSuggestion(suggestion);
                    _onSearchTap();
                  },
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_searchOverlayEntry!);
    }

    if (hasCitySuggestions) {
      _locationOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: screenWidth - 64,
          child: CompositedTransformFollower(
            link: _locationLink,
            showWhenUnlinked: false,
            targetAnchor: locationTargetAnchor,
            followerAnchor: locationFollowerAnchor,
            offset: locationOffset,
            child: Material(
              elevation: 24,
              borderRadius: BorderRadius.circular(24),
              color: colorScheme.surface,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 350),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outlineVariant.transparency(0.4),
                  ),
                ),
                child: SearchSuggestionsOverlay(
                  suggestions: searchState.citySuggestions,
                  searchController: _locationController,
                  searchQuery: searchState.locationQuery,
                  onSelect: (suggestion) {
                    notifier.selectCity(suggestion);
                    if (widget.onSearchOverride != null) {
                      widget.onSearchOverride!();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_locationOverlayEntry!);
    }
  }

  Widget _buildSearchButton(ColorScheme colorScheme) {
    return InkWell(
      onTap: _onSearchTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: widget.isHero ? colorScheme.primaryContainer : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: widget.isHero
              ? null
              : [
            BoxShadow(
              color: Colors.black.transparency(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: widget.isHero ? colorScheme.onPrimaryContainer : colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSearchWrapper(ColorScheme colorScheme, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
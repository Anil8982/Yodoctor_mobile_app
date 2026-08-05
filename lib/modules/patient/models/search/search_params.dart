// lib/models/search/search_params.dart
class SearchParams {
  final String search;
  final String city;
  final int page;
  final int limit;

  const SearchParams({
    this.search = "",
    this.city = "",
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      "search": search,
      "city": city,
      "page": page,
      "limit": limit,
    };
  }

  SearchParams copyWith({
    String? search,
    String? city,
    int? page,
    int? limit,
  }) {
    return SearchParams(
      search: search ?? this.search,
      city: city ?? this.city,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  String toString() => 'SearchParams(search: $search, city: $city, page: $page, limit: $limit)';
}
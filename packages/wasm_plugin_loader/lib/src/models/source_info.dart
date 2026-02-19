/// A source listing entry from the manifest (source.json).
class SourceListing {
  const SourceListing({required this.id, required this.name, this.kind = 0});
  final String id;
  final String name;
  final int kind; // ListingKind: 0 = Default, 1 = List
}

class SourceInfo {
  const SourceInfo({
    required this.id,
    required this.name,
    required this.version,
    this.languages = const [],
    this.url,
    this.contentRating = 0,
    this.listings = const [],
  });

  final String id;
  final String name;
  final int version;
  final List<String> languages;
  final String? url;
  final int contentRating;

  /// Static listings declared in the source manifest (source.json).
  final List<SourceListing> listings;
}

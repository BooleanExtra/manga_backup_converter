class SourceEntry {
  const SourceEntry({
    required this.id,
    required this.name,
    required this.version,
    required this.iconUrl,
    required this.downloadUrl,
    required this.languages,
    this.contentRating = 0,
    this.baseUrl,
    this.altNames = const [],
  });

  final String id;
  final String name;
  final int version;
  final String iconUrl;
  final String downloadUrl;
  final List<String> languages;

  /// 0 = safe, 1 = moderate, 2 = mature.
  final int contentRating;

  final String? baseUrl;
  final List<String> altNames;

  factory SourceEntry.fromJson(Map<String, dynamic> json) {
    return SourceEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as int,
      iconUrl: json['iconURL'] as String,
      downloadUrl: json['downloadURL'] as String,
      languages: List<String>.from(json['languages'] as List? ?? const []),
      contentRating: json['contentRating'] as int? ?? 0,
      baseUrl: json['baseURL'] as String?,
      altNames: List<String>.from(json['altNames'] as List? ?? const []),
    );
  }
}

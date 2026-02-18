class SourceInfo {
  const SourceInfo({
    required this.id,
    required this.name,
    required this.language,
    this.url,
  });

  final String id;
  final String name;
  final String language;
  final String? url;
}

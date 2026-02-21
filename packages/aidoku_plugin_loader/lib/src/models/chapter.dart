class Chapter {
  const Chapter({
    required this.key,
    this.title,
    this.chapterNumber,
    this.volumeNumber,
    this.dateUploaded,
    this.scanlators = const <String>[],
    this.language,
    this.url,
  });

  final String key;
  final String? title;
  final double? chapterNumber;
  final double? volumeNumber;
  final DateTime? dateUploaded;
  final List<String> scanlators;
  final String? language;
  final String? url;
}

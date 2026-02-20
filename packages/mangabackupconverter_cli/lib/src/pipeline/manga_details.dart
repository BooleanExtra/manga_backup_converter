class MangaSearchDetails {
  const MangaSearchDetails({
    required this.title,
    this.altTitles = const <String>[],
    this.authors = const <String>[],
    this.artists = const <String>[],
    this.tagNames = const <String>[],
    this.description,
    this.chaptersCount,
    this.latestChapterNum,
    this.coverImageUrl,
    this.languages = const <String>[],
  });

  final String title;
  final List<String> altTitles;
  final List<String> authors;
  final List<String> artists;
  final List<String> tagNames;
  final String? description;
  final int? chaptersCount;
  final double? latestChapterNum;
  final String? coverImageUrl;
  final List<String> languages;
}

mixin MangaSearchEntry {
  MangaSearchDetails toMangaSearchDetails();
}

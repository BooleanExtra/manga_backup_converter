import 'package:mangabackupconverter_cli/src/common/fix_double_encoding.dart';

class MangaSearchDetails {
  MangaSearchDetails({
    required String title,
    List<String> altTitles = const <String>[],
    List<String> authors = const <String>[],
    List<String> artists = const <String>[],
    this.tagNames = const <String>[],
    String? description,
    this.chaptersCount,
    this.latestChapterNum,
    this.coverImageUrl,
    this.languages = const <String>[],
  })  : title = fixDoubleEncoding(title),
        altTitles = altTitles.map(fixDoubleEncoding).toList(),
        authors = authors.map(fixDoubleEncoding).toList(),
        artists = artists.map(fixDoubleEncoding).toList(),
        description =
            description != null ? fixDoubleEncoding(description) : null;

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

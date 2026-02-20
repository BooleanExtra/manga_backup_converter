import 'package:wasm_plugin_loader/src/models/chapter.dart';

enum MangaStatus { unknown, ongoing, completed, cancelled, hiatus }

enum ContentRating { safe, suggestive, nsfw }

class Manga {
  const Manga({
    required this.key,
    required this.title,
    this.coverUrl,
    this.authors = const <String>[],
    this.artists = const <String>[],
    this.description,
    this.tags = const <String>[],
    this.status = MangaStatus.unknown,
    this.contentRating = ContentRating.safe,
    this.chapters = const <Chapter>[],
    this.url,
  });

  final String key;
  final String title;
  final String? coverUrl;
  final List<String> authors;
  final List<String> artists;
  final String? description;
  final List<String> tags;
  final MangaStatus status;
  final ContentRating contentRating;
  final List<Chapter> chapters;
  final String? url;
}

class MangaPageResult {
  const MangaPageResult({required this.manga, required this.hasNextPage});

  final List<Manga> manga;
  final bool hasNextPage;
}

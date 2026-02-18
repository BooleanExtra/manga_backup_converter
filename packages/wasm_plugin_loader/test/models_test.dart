import 'package:wasm_plugin_loader/wasm_plugin_loader.dart';
import 'package:test/test.dart';

void main() {
  group('SourceInfo', () {
    test('stores id, name, language', () {
      const info = SourceInfo(
        id: 'multi.mangadex',
        name: 'MangaDex',
        language: 'multi',
        url: 'https://mangadex.org',
      );
      expect(info.id, 'multi.mangadex');
      expect(info.name, 'MangaDex');
      expect(info.language, 'multi');
      expect(info.url, 'https://mangadex.org');
    });

    test('url is optional', () {
      const info = SourceInfo(id: 'en.test', name: 'Test', language: 'en');
      expect(info.url, isNull);
    });
  });

  group('Manga', () {
    test('stores key and title', () {
      const manga = Manga(key: 'abc123', title: 'Test Manga');
      expect(manga.key, 'abc123');
      expect(manga.title, 'Test Manga');
      expect(manga.coverUrl, isNull);
    });

    test('has sensible defaults', () {
      const manga = Manga(key: 'k', title: 't');
      expect(manga.authors, isEmpty);
      expect(manga.artists, isEmpty);
      expect(manga.tags, isEmpty);
      expect(manga.chapters, isEmpty);
      expect(manga.status, MangaStatus.unknown);
      expect(manga.contentRating, ContentRating.safe);
    });
  });

  group('MangaPageResult', () {
    test('stores manga list and hasNextPage', () {
      const result = MangaPageResult(manga: [], hasNextPage: false);
      expect(result.manga, isEmpty);
      expect(result.hasNextPage, isFalse);
    });
  });

  group('Chapter', () {
    test('stores key and optional fields', () {
      const chapter = Chapter(key: 'ch1', title: 'Chapter 1', chapterNumber: 1.0);
      expect(chapter.key, 'ch1');
      expect(chapter.title, 'Chapter 1');
      expect(chapter.chapterNumber, 1.0);
      expect(chapter.scanlators, isEmpty);
    });
  });

  group('FilterValue', () {
    test('stores type, name, and optional value', () {
      const f = FilterValue(type: FilterType.text, name: 'Search', value: 'query');
      expect(f.type, FilterType.text);
      expect(f.name, 'Search');
      expect(f.value, 'query');
    });
  });
}

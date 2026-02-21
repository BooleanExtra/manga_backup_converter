import 'package:aidoku_plugin_loader/aidoku_plugin_loader.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('SourceInfo', () {
    test('stores id, name, languages', () {
      const info = SourceInfo(
        id: 'multi.mangadex',
        name: 'MangaDex',
        version: 1,
        languages: <String>['multi'],
        url: 'https://mangadex.org',
      );
      check(info.id).equals('multi.mangadex');
      check(info.name).equals('MangaDex');
      check(info.languages).deepEquals(<Object?>['multi']);
      check(info.url).equals('https://mangadex.org');
    });

    test('url is optional', () {
      const info = SourceInfo(id: 'en.test', name: 'Test', version: 1);
      check(info.url).isNull();
    });
  });

  group('Manga', () {
    test('stores key and title', () {
      const manga = Manga(key: 'abc123', title: 'Test Manga');
      check(manga.key).equals('abc123');
      check(manga.title).equals('Test Manga');
      check(manga.coverUrl).isNull();
    });

    test('has sensible defaults', () {
      const manga = Manga(key: 'k', title: 't');
      check(manga.authors).isEmpty();
      check(manga.artists).isEmpty();
      check(manga.tags).isEmpty();
      check(manga.chapters).isEmpty();
      check(manga.status).equals(MangaStatus.unknown);
      check(manga.contentRating).equals(ContentRating.safe);
    });
  });

  group('MangaPageResult', () {
    test('stores manga list and hasNextPage', () {
      const result = MangaPageResult(manga: <Manga>[], hasNextPage: false);
      check(result.manga).isEmpty();
      check(result.hasNextPage).isFalse();
    });
  });

  group('Chapter', () {
    test('stores key and optional fields', () {
      const chapter = Chapter(key: 'ch1', title: 'Chapter 1', chapterNumber: 1.0);
      check(chapter.key).equals('ch1');
      check(chapter.title).equals('Chapter 1');
      check(chapter.chapterNumber).equals(1.0);
      check(chapter.scanlators).isEmpty();
    });
  });

  group('FilterValue', () {
    test('stores type, name, and optional value', () {
      const f = FilterValue(type: FilterType.text, name: 'Search', value: 'query');
      check(f.type).equals(FilterType.text);
      check(f.name).equals('Search');
      check(f.value).equals('query');
    });
  });

  group('Page', () {
    test('stores index and optional fields', () {
      const page = Page(
        index: 3,
        url: 'https://example.com/img.jpg',
        base64: 'abc==',
        text: 'caption',
      );
      check(page.index).equals(3);
      check(page.url).equals('https://example.com/img.jpg');
      check(page.base64).equals('abc==');
      check(page.text).equals('caption');
    });

    test('toString includes index', () {
      const page = Page(index: 5);
      check(page.toString()).contains('5');
    });
  });
}

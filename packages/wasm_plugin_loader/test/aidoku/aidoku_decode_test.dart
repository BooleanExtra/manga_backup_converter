import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';
import 'package:wasm_plugin_loader/src/models/filter.dart';
import 'package:wasm_plugin_loader/src/models/manga.dart';

/// Write a minimal manga into [w].
///
/// Chapters are always written as an empty list.
void _writeManga(
  PostcardWriter w, {
  String key = 'k',
  String title = 'T',
  String? author,
  String? artist,
  String? description,
  String? url,
  int status = 0,
  int rating = 0,
  String? cover,
  List<String> tags = const [],
}) {
  w.writeString(key);
  w.writeString(title);
  w.writeOption<String>(author, (v, pw) => pw.writeString(v));
  w.writeOption<String>(artist, (v, pw) => pw.writeString(v));
  w.writeOption<String>(description, (v, pw) => pw.writeString(v));
  w.writeOption<String>(url, (v, pw) => pw.writeString(v));
  w.writeVarInt(status);
  w.writeVarInt(rating);
  w.writeVarInt(0); // viewer (unused in our model)
  w.writeOption<String>(cover, (v, pw) => pw.writeString(v));
  w.writeList(tags, (v, pw) => pw.writeString(v));
  w.writeVarInt(0); // empty chapters list
}

/// Write a chapter into [w].
void _writeChapter(
  PostcardWriter w, {
  String key = 'ch1',
  String? title,
  String? scanlator,
  String? url,
  String lang = 'en',
  double? chapterNum,
  double? volumeNum,
  double? dateSecs,
}) {
  w.writeString(key);
  w.writeOption<String>(title, (v, pw) => pw.writeString(v));
  w.writeOption<String>(scanlator, (v, pw) => pw.writeString(v));
  w.writeOption<String>(url, (v, pw) => pw.writeString(v));
  w.writeString(lang);
  w.writeOption<double>(chapterNum, (v, pw) => pw.writeF32(v));
  w.writeOption<double>(volumeNum, (v, pw) => pw.writeF32(v));
  w.writeOption<double>(dateSecs, (v, pw) => pw.writeF64(v));
}

void main() {
  group('encodeQuery', () {
    test('empty string encodes to empty bytes', () {
      check(encodeQuery('')).isEmpty();
    });

    test('ASCII string encodes to UTF-8 bytes', () {
      check(encodeQuery('hello')).deepEquals(utf8.encode('hello'));
    });

    test('unicode string encodes correctly', () {
      const s = 'こんにちは';
      check(encodeQuery(s)).deepEquals(utf8.encode(s));
    });
  });

  group('encodeFilters', () {
    test('empty list encodes to length-0 postcard list', () {
      final bytes = encodeFilters([]);
      final r = PostcardReader(bytes);
      check(r.readVarInt()).equals(0);
      check(r.isAtEnd).isTrue();
    });

    test('FilterType.text encodes type index and string value', () {
      final bytes = encodeFilters([
        const FilterValue(type: FilterType.text, name: 'Search', value: 'query'),
      ]);
      final r = PostcardReader(bytes);
      check(r.readVarInt()).equals(1); // list length
      check(r.readVarInt()).equals(FilterType.text.index); // 0
      check(r.readString()).equals('Search');
      check(r.readString()).equals('query');
      check(r.isAtEnd).isTrue();
    });

    test('FilterType.check encodes type index and bool value', () {
      final bytes = encodeFilters([
        const FilterValue(type: FilterType.check, name: 'NSFW', value: true),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      check(r.readVarInt()).equals(FilterType.check.index); // 1
      check(r.readString()).equals('NSFW');
      check(r.readBool()).isTrue();
      check(r.isAtEnd).isTrue();
    });

    test('FilterType.sort encodes type index and int value', () {
      final bytes = encodeFilters([
        const FilterValue(type: FilterType.sort, name: 'Sort', value: 2),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      check(r.readVarInt()).equals(FilterType.sort.index); // 2
      check(r.readString()).equals('Sort');
      check(r.readVarInt()).equals(2);
      check(r.isAtEnd).isTrue();
    });

    test('FilterType.select encodes type index 3', () {
      final bytes = encodeFilters([
        const FilterValue(type: FilterType.select, name: 'Lang', value: 0),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      check(r.readVarInt()).equals(FilterType.select.index); // 3
    });

    test('FilterType.range encodes type index 4', () {
      final bytes = encodeFilters([
        const FilterValue(type: FilterType.range, name: 'Year', value: 2020),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      check(r.readVarInt()).equals(FilterType.range.index); // 4
    });

    test('FilterType.group encodes type index 5', () {
      final bytes = encodeFilters([
        const FilterValue(type: FilterType.group, name: 'Genre'),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      check(r.readVarInt()).equals(FilterType.group.index); // 5
    });

    test('null value writes nothing after name', () {
      final bytes = encodeFilters([
        const FilterValue(type: FilterType.sort, name: 'Sort'),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      r.readVarInt(); // type index
      r.readString(); // name
      check(r.isAtEnd).isTrue();
    });
  });

  group('decodeMangaPageResult', () {
    test('empty manga list with hasNextPage false', () {
      final w = PostcardWriter()
        ..writeVarInt(0)
        ..writeBool(false);
      final result = decodeMangaPageResult(PostcardReader(w.bytes));
      check(result.manga).isEmpty();
      check(result.hasNextPage).isFalse();
    });

    test('hasNextPage true', () {
      final w = PostcardWriter()
        ..writeVarInt(0)
        ..writeBool(true);
      final result = decodeMangaPageResult(PostcardReader(w.bytes));
      check(result.hasNextPage).isTrue();
    });

    test('non-empty manga list decodes all entries', () {
      final w = PostcardWriter();
      w.writeVarInt(2); // 2 manga
      _writeManga(w, key: 'k1', title: 'Manga 1');
      _writeManga(w, key: 'k2', title: 'Manga 2');
      w.writeBool(true);
      final result = decodeMangaPageResult(PostcardReader(w.bytes));
      check(result.manga).length.equals(2);
      check(result.manga[0].key).equals('k1');
      check(result.manga[1].key).equals('k2');
      check(result.hasNextPage).isTrue();
    });
  });

  group('decodeManga', () {
    test('required fields only, all optionals absent', () {
      final w = PostcardWriter();
      _writeManga(w, key: 'abc', title: 'My Manga');
      final manga = decodeManga(PostcardReader(w.bytes));
      check(manga.key).equals('abc');
      check(manga.title).equals('My Manga');
      check(manga.authors).isEmpty();
      check(manga.artists).isEmpty();
      check(manga.description).isNull();
      check(manga.url).isNull();
      check(manga.coverUrl).isNull();
      check(manga.tags).isEmpty();
      check(manga.chapters).isEmpty();
    });

    test('all optional string fields present', () {
      final w = PostcardWriter();
      _writeManga(
        w,
        author: 'Author One',
        artist: 'Artist One',
        description: 'Great manga',
        url: 'https://url.com',
        cover: 'https://cover.jpg',
      );
      final manga = decodeManga(PostcardReader(w.bytes));
      check(manga.authors).deepEquals(['Author One']);
      check(manga.artists).deepEquals(['Artist One']);
      check(manga.description).equals('Great manga');
      check(manga.url).equals('https://url.com');
      check(manga.coverUrl).equals('https://cover.jpg');
    });

    test('status: ongoing(1)', () {
      final w = PostcardWriter();
      _writeManga(w, status: 1);
      check(decodeManga(PostcardReader(w.bytes)).status).equals(MangaStatus.ongoing);
    });

    test('status: completed(2)', () {
      final w = PostcardWriter();
      _writeManga(w, status: 2);
      check(decodeManga(PostcardReader(w.bytes)).status).equals(MangaStatus.completed);
    });

    test('status: cancelled(3)', () {
      final w = PostcardWriter();
      _writeManga(w, status: 3);
      check(decodeManga(PostcardReader(w.bytes)).status).equals(MangaStatus.cancelled);
    });

    test('status: hiatus(4)', () {
      final w = PostcardWriter();
      _writeManga(w, status: 4);
      check(decodeManga(PostcardReader(w.bytes)).status).equals(MangaStatus.hiatus);
    });

    test('contentRating: suggestive(1)', () {
      final w = PostcardWriter();
      _writeManga(w, rating: 1);
      check(decodeManga(PostcardReader(w.bytes)).contentRating).equals(ContentRating.suggestive);
    });

    test('contentRating: nsfw(2)', () {
      final w = PostcardWriter();
      _writeManga(w, rating: 2);
      check(decodeManga(PostcardReader(w.bytes)).contentRating).equals(ContentRating.nsfw);
    });

    test('tags list decoded', () {
      final w = PostcardWriter();
      _writeManga(w, tags: ['action', 'comedy', 'drama']);
      check(decodeManga(PostcardReader(w.bytes)).tags).deepEquals(['action', 'comedy', 'drama']);
    });

    test('chapters list decoded', () {
      final w = PostcardWriter();
      // Write manga manually to include an inline chapter.
      w.writeString('k');
      w.writeString('T');
      w.writeOption<String>(null, (v, pw) => pw.writeString(v)); // author
      w.writeOption<String>(null, (v, pw) => pw.writeString(v)); // artist
      w.writeOption<String>(null, (v, pw) => pw.writeString(v)); // description
      w.writeOption<String>(null, (v, pw) => pw.writeString(v)); // url
      w.writeVarInt(0); // status
      w.writeVarInt(0); // rating
      w.writeVarInt(0); // viewer
      w.writeOption<String>(null, (v, pw) => pw.writeString(v)); // cover
      w.writeVarInt(0); // empty tags
      w.writeVarInt(1); // 1 chapter
      _writeChapter(w, key: 'ch001', title: 'Chapter 1', chapterNum: 1.0);
      final manga = decodeManga(PostcardReader(w.bytes));
      check(manga.chapters).length.equals(1);
      check(manga.chapters[0].key).equals('ch001');
      check(manga.chapters[0].title).equals('Chapter 1');
    });
  });

  group('decodeChapter', () {
    test('required fields only, all optionals absent', () {
      final w = PostcardWriter();
      _writeChapter(w);
      final ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.key).equals('ch1');
      check(ch.title).isNull();
      check(ch.scanlators).isEmpty();
      check(ch.url).isNull();
      check(ch.language).equals('en');
      check(ch.chapterNumber).isNull();
      check(ch.volumeNumber).isNull();
      check(ch.dateUploaded).isNull();
    });

    test('optional title and scanlator present', () {
      final w = PostcardWriter();
      _writeChapter(w, title: 'Chapter 5', scanlator: 'GroupX');
      final ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.title).equals('Chapter 5');
      check(ch.scanlators).deepEquals(['GroupX']);
    });

    test('chapterNumber and volumeNumber decoded as f32', () {
      final w = PostcardWriter();
      _writeChapter(w, chapterNum: 12.5, volumeNum: 2.0);
      final ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.chapterNumber).isNotNull().isA<num>().isCloseTo(12.5, 0.001);
      check(ch.volumeNumber).isNotNull().isA<num>().isCloseTo(2.0, 0.001);
    });

    test('dateUploaded converts seconds to DateTime', () {
      final w = PostcardWriter();
      _writeChapter(w, dateSecs: 1700000000.0);
      final ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.dateUploaded).isNotNull();
      check(ch.dateUploaded!.millisecondsSinceEpoch).equals((1700000000.0 * 1000).toInt());
    });

    test('optional url decoded', () {
      final w = PostcardWriter();
      _writeChapter(w, url: 'https://chapter.url/1');
      final ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.url).equals('https://chapter.url/1');
    });
  });

  group('decodePageList', () {
    test('empty list', () {
      final w = PostcardWriter()..writeVarInt(0);
      check(decodePageList(PostcardReader(w.bytes))).isEmpty();
    });

    test('single page with only index', () {
      final w = PostcardWriter();
      w.writeVarInt(1); // 1 page
      w.writeVarInt(0); // index
      w.writeOption<String>(null, (v, pw) => pw.writeString(v)); // url
      w.writeOption<String>(null, (v, pw) => pw.writeString(v)); // base64
      w.writeOption<String>(null, (v, pw) => pw.writeString(v)); // text
      final pages = decodePageList(PostcardReader(w.bytes));
      check(pages).length.equals(1);
      check(pages[0].index).equals(0);
      check(pages[0].url).isNull();
      check(pages[0].base64).isNull();
      check(pages[0].text).isNull();
    });

    test('page with url', () {
      final w = PostcardWriter();
      w.writeVarInt(1);
      w.writeVarInt(3); // index
      w.writeOption('https://img.example.com/page.jpg', (v, pw) => pw.writeString(v));
      w.writeOption<String>(null, (v, pw) => pw.writeString(v));
      w.writeOption<String>(null, (v, pw) => pw.writeString(v));
      final pages = decodePageList(PostcardReader(w.bytes));
      check(pages[0].index).equals(3);
      check(pages[0].url).equals('https://img.example.com/page.jpg');
    });

    test('page with base64', () {
      final w = PostcardWriter();
      w.writeVarInt(1);
      w.writeVarInt(0);
      w.writeOption<String>(null, (v, pw) => pw.writeString(v));
      w.writeOption('abc123=', (v, pw) => pw.writeString(v));
      w.writeOption<String>(null, (v, pw) => pw.writeString(v));
      final pages = decodePageList(PostcardReader(w.bytes));
      check(pages[0].base64).equals('abc123=');
    });

    test('page with text', () {
      final w = PostcardWriter();
      w.writeVarInt(1);
      w.writeVarInt(0);
      w.writeOption<String>(null, (v, pw) => pw.writeString(v));
      w.writeOption<String>(null, (v, pw) => pw.writeString(v));
      w.writeOption('caption', (v, pw) => pw.writeString(v));
      final pages = decodePageList(PostcardReader(w.bytes));
      check(pages[0].text).equals('caption');
    });

    test('multiple pages preserve order and indices', () {
      final w = PostcardWriter();
      w.writeVarInt(3); // 3 pages
      for (var i = 0; i < 3; i++) {
        w.writeVarInt(i);
        w.writeOption<String>(null, (v, pw) => pw.writeString(v));
        w.writeOption<String>(null, (v, pw) => pw.writeString(v));
        w.writeOption<String>(null, (v, pw) => pw.writeString(v));
      }
      final pages = decodePageList(PostcardReader(w.bytes));
      check(pages).length.equals(3);
      check(pages[0].index).equals(0);
      check(pages[1].index).equals(1);
      check(pages[2].index).equals(2);
    });
  });
}

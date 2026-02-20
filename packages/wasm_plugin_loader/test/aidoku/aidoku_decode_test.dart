import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';
import 'package:wasm_plugin_loader/src/models/chapter.dart';
import 'package:wasm_plugin_loader/src/models/filter.dart';
import 'package:wasm_plugin_loader/src/models/manga.dart';
import 'package:wasm_plugin_loader/src/models/page.dart';

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
  List<String> tags = const <String>[],
}) {
  w.writeString(key); // key: String
  w.writeString(title); // title: String
  w.writeOption<String>(cover, (String v, PostcardWriter pw) => pw.writeString(v)); // cover: Option<String>
  w.writeOption<List<String>>(
    // artists: Option<Vec<String>>
    artist == null ? null : <String>[artist],
    (List<String> v, PostcardWriter pw) => pw.writeList(v, (String s, PostcardWriter pw2) => pw2.writeString(s)),
  );
  w.writeOption<List<String>>(
    // authors: Option<Vec<String>>
    author == null ? null : <String>[author],
    (List<String> v, PostcardWriter pw) => pw.writeList(v, (String s, PostcardWriter pw2) => pw2.writeString(s)),
  );
  w.writeOption<String>(description, (String v, PostcardWriter pw) => pw.writeString(v)); // description: Option<String>
  w.writeOption<String>(url, (String v, PostcardWriter pw) => pw.writeString(v)); // url: Option<String>
  w.writeOption<List<String>>(
    // tags: Option<Vec<String>>
    tags.isEmpty ? null : tags,
    (List<String> v, PostcardWriter pw) => pw.writeList(v, (String s, PostcardWriter pw2) => pw2.writeString(s)),
  );
  w.writeVarInt(status); // status: VarInt
  w.writeVarInt(rating); // content_rating: VarInt
  w.writeVarInt(0); // viewer: VarInt
  w.writeVarInt(0); // update_strategy: VarInt
  w.writeU8(0); // next_update_time: None
  w.writeU8(0); // chapters: None
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
  w.writeString(key); // key: String
  w.writeOption<String>(title, (String v, PostcardWriter pw) => pw.writeString(v)); // title: Option<String>
  w.writeOption<double>(chapterNum, (double v, PostcardWriter pw) => pw.writeF32(v)); // chapter_number: Option<f32>
  w.writeOption<double>(volumeNum, (double v, PostcardWriter pw) => pw.writeF32(v)); // volume_number: Option<f32>
  w.writeOption<int>(dateSecs?.toInt(), (int v, PostcardWriter pw) => pw.writeI64(v)); // date_uploaded: Option<i64>
  w.writeOption<List<String>>(
    // scanlators: Option<Vec<String>>
    scanlator == null ? null : <String>[scanlator],
    (List<String> v, PostcardWriter pw) => pw.writeList(v, (String s, PostcardWriter pw2) => pw2.writeString(s)),
  );
  w.writeOption<String>(url, (String v, PostcardWriter pw) => pw.writeString(v)); // url: Option<String>
  w.writeOption<String>(lang, (String v, PostcardWriter pw) => pw.writeString(v)); // language: Option<String>
  w.writeU8(0); // thumbnail: None
  w.writeBool(false); // locked: bool
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
      final Uint8List bytes = encodeFilters(<FilterValue>[]);
      final r = PostcardReader(bytes);
      check(r.readVarInt()).equals(0);
      check(r.isAtEnd).isTrue();
    });

    test('FilterType.text encodes type index and string value', () {
      final Uint8List bytes = encodeFilters(<FilterValue>[
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
      final Uint8List bytes = encodeFilters(<FilterValue>[
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
      final Uint8List bytes = encodeFilters(<FilterValue>[
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
      final Uint8List bytes = encodeFilters(<FilterValue>[
        const FilterValue(type: FilterType.select, name: 'Lang', value: 0),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      check(r.readVarInt()).equals(FilterType.select.index); // 3
    });

    test('FilterType.range encodes type index 4', () {
      final Uint8List bytes = encodeFilters(<FilterValue>[
        const FilterValue(type: FilterType.range, name: 'Year', value: 2020),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      check(r.readVarInt()).equals(FilterType.range.index); // 4
    });

    test('FilterType.group encodes type index 5', () {
      final Uint8List bytes = encodeFilters(<FilterValue>[
        const FilterValue(type: FilterType.group, name: 'Genre'),
      ]);
      final r = PostcardReader(bytes);
      r.readVarInt(); // list length
      check(r.readVarInt()).equals(FilterType.group.index); // 5
    });

    test('null value writes nothing after name', () {
      final Uint8List bytes = encodeFilters(<FilterValue>[
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
      final MangaPageResult result = decodeMangaPageResult(PostcardReader(w.bytes));
      check(result.manga).isEmpty();
      check(result.hasNextPage).isFalse();
    });

    test('hasNextPage true', () {
      final w = PostcardWriter()
        ..writeVarInt(0)
        ..writeBool(true);
      final MangaPageResult result = decodeMangaPageResult(PostcardReader(w.bytes));
      check(result.hasNextPage).isTrue();
    });

    test('non-empty manga list decodes all entries', () {
      final w = PostcardWriter();
      w.writeVarInt(2); // 2 manga
      _writeManga(w, key: 'k1', title: 'Manga 1');
      _writeManga(w, key: 'k2', title: 'Manga 2');
      w.writeBool(true);
      final MangaPageResult result = decodeMangaPageResult(PostcardReader(w.bytes));
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
      final Manga manga = decodeManga(PostcardReader(w.bytes));
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
      final Manga manga = decodeManga(PostcardReader(w.bytes));
      check(manga.authors).deepEquals(<Object?>['Author One']);
      check(manga.artists).deepEquals(<Object?>['Artist One']);
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
      _writeManga(w, tags: <String>['action', 'comedy', 'drama']);
      check(decodeManga(PostcardReader(w.bytes)).tags).deepEquals(<Object?>['action', 'comedy', 'drama']);
    });

    test('chapters list decoded', () {
      final w = PostcardWriter();
      // Write manga manually to include an inline chapter.
      w.writeString('k'); // key
      w.writeString('T'); // title
      w.writeU8(0); // cover: None
      w.writeU8(0); // artists: None
      w.writeU8(0); // authors: None
      w.writeU8(0); // description: None
      w.writeU8(0); // url: None
      w.writeU8(0); // tags: None
      w.writeVarInt(0); // status
      w.writeVarInt(0); // content_rating
      w.writeVarInt(0); // viewer
      w.writeVarInt(0); // update_strategy
      w.writeU8(0); // next_update_time: None
      w.writeU8(1); // chapters: Some
      w.writeVarInt(1); // 1 chapter
      _writeChapter(w, key: 'ch001', title: 'Chapter 1', chapterNum: 1.0);
      final Manga manga = decodeManga(PostcardReader(w.bytes));
      check(manga.chapters).length.equals(1);
      check(manga.chapters[0].key).equals('ch001');
      check(manga.chapters[0].title).equals('Chapter 1');
    });
  });

  group('decodeChapter', () {
    test('required fields only, all optionals absent', () {
      final w = PostcardWriter();
      _writeChapter(w);
      final Chapter ch = decodeChapter(PostcardReader(w.bytes));
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
      final Chapter ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.title).equals('Chapter 5');
      check(ch.scanlators).deepEquals(<Object?>['GroupX']);
    });

    test('chapterNumber and volumeNumber decoded as f32', () {
      final w = PostcardWriter();
      _writeChapter(w, chapterNum: 12.5, volumeNum: 2.0);
      final Chapter ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.chapterNumber).isNotNull().isA<num>().isCloseTo(12.5, 0.001);
      check(ch.volumeNumber).isNotNull().isA<num>().isCloseTo(2.0, 0.001);
    });

    test('dateUploaded converts seconds to DateTime', () {
      final w = PostcardWriter();
      _writeChapter(w, dateSecs: 1700000000.0);
      final Chapter ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.dateUploaded).isNotNull();
      check(ch.dateUploaded?.millisecondsSinceEpoch).equals((1700000000.0 * 1000).toInt());
    });

    test('optional url decoded', () {
      final w = PostcardWriter();
      _writeChapter(w, url: 'https://chapter.url/1');
      final Chapter ch = decodeChapter(PostcardReader(w.bytes));
      check(ch.url).equals('https://chapter.url/1');
    });
  });

  // Helper to write a Page in Aidoku postcard format:
  //   PageContent enum variant + data
  //   Option<String> thumbnail
  //   bool has_description
  //   Option<String> description
  group('decodePageList', () {
    void writePage(
      PostcardWriter w, {
      int variant = 0,
      String? url,
      String? text,
      Map<String, String>? pageContext,
    }) {
      w.writeVarInt(variant);
      switch (variant) {
        case 0: // Url(String, Option<PageContext>)
          w.writeString(url ?? '');
          if (pageContext != null) {
            w.writeU8(1); // Some
            w.writeVarInt(pageContext.length);
            for (final MapEntry<String, String> e in pageContext.entries) {
              w.writeString(e.key);
              w.writeString(e.value);
            }
          } else {
            w.writeU8(0); // None
          }
        case 1: // Text(String)
          w.writeString(text ?? '');
        case 2: // Image — no data
          break;
      }
      w.writeU8(0); // thumbnail: None
      w.writeBool(false); // has_description
      w.writeU8(0); // description: None
    }

    test('empty list', () {
      final w = PostcardWriter()..writeVarInt(0);
      check(decodePageList(PostcardReader(w.bytes))).isEmpty();
    });

    test('single Url page', () {
      final w = PostcardWriter();
      w.writeVarInt(1); // 1 page
      writePage(w, url: 'https://img.example.com/page.jpg');
      final List<Page> pages = decodePageList(PostcardReader(w.bytes));
      check(pages).length.equals(1);
      check(pages[0].index).equals(0);
      check(pages[0].url).equals('https://img.example.com/page.jpg');
      check(pages[0].text).isNull();
    });

    test('Text page', () {
      final w = PostcardWriter();
      w.writeVarInt(1);
      writePage(w, variant: 1, text: 'caption');
      final List<Page> pages = decodePageList(PostcardReader(w.bytes));
      check(pages[0].text).equals('caption');
      check(pages[0].url).isNull();
    });

    test('Image page (variant 2) has no url or text', () {
      final w = PostcardWriter();
      w.writeVarInt(1);
      writePage(w, variant: 2);
      final List<Page> pages = decodePageList(PostcardReader(w.bytes));
      check(pages[0].url).isNull();
      check(pages[0].text).isNull();
    });

    test('Url page with PageContext (HashMap) is skipped correctly', () {
      final w = PostcardWriter();
      w.writeVarInt(1);
      writePage(
        w,
        url: 'https://img.example.com/1.jpg',
        pageContext: <String, String>{
          'Referer': 'https://example.com',
          'User-Agent': 'Test',
        },
      );
      final List<Page> pages = decodePageList(PostcardReader(w.bytes));
      check(pages).length.equals(1);
      check(pages[0].url).equals('https://img.example.com/1.jpg');
    });

    test('multiple pages preserve order', () {
      final w = PostcardWriter();
      w.writeVarInt(3);
      writePage(w, url: 'https://img.example.com/0.jpg');
      writePage(w, url: 'https://img.example.com/1.jpg');
      writePage(w, url: 'https://img.example.com/2.jpg');
      final List<Page> pages = decodePageList(PostcardReader(w.bytes));
      check(pages).length.equals(3);
      check(pages[0].index).equals(0);
      check(pages[1].index).equals(1);
      check(pages[2].index).equals(2);
    });
  });
}

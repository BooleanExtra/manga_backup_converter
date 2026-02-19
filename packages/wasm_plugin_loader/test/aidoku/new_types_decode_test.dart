// Unit tests for new decode/encode functions added in Step 2-3.
import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';
import 'package:wasm_plugin_loader/src/models/page.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

void _writeMinimalManga(PostcardWriter w, {String key = 'k', String title = 'T'}) {
  w.writeString(key);
  w.writeString(title);
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
  w.writeU8(0); // chapters: None
}

void _writeMinimalChapter(PostcardWriter w, {String key = 'ch1'}) {
  w.writeString(key);
  w.writeU8(0); // title: None
  w.writeU8(0); // chapter_number: None
  w.writeU8(0); // volume_number: None
  w.writeU8(0); // date_uploaded: None
  w.writeU8(0); // scanlators: None
  w.writeU8(0); // url: None
  w.writeU8(0); // language: None
  w.writeU8(0); // thumbnail: None
  w.writeBool(false); // locked
}

// ---------------------------------------------------------------------------
// ImageRequest
// ---------------------------------------------------------------------------

void main() {
  group('decodeImageRequest', () {
    test('url=None, empty headers', () {
      final w = PostcardWriter();
      w.writeU8(0); // url: None
      w.writeVarInt(0); // headers: empty HashMap
      final req = decodeImageRequest(PostcardReader(w.bytes));
      check(req.url).isNull();
      check(req.headers).isEmpty();
    });

    test('url=Some, two headers', () {
      final w = PostcardWriter();
      w.writeOption<String>('https://img.example.com/1.jpg', (v, pw) => pw.writeString(v));
      w.writeVarInt(2); // 2 headers
      w.writeString('Referer');
      w.writeString('https://example.com');
      w.writeString('User-Agent');
      w.writeString('Aidoku/1.0');
      final req = decodeImageRequest(PostcardReader(w.bytes));
      check(req.url).equals('https://img.example.com/1.jpg');
      check(req.headers).length.equals(2);
      check(req.headers['Referer']).equals('https://example.com');
      check(req.headers['User-Agent']).equals('Aidoku/1.0');
    });

    test('decodeImageRequestResult returns null for empty bytes', () {
      check(decodeImageRequestResult(Uint8List(0))).isNull();
    });
  });

  group('decodeStringMap', () {
    test('empty map', () {
      final w = PostcardWriter()..writeVarInt(0);
      check(decodeStringMap(PostcardReader(w.bytes))).isEmpty();
    });

    test('three entries round-trip', () {
      final w = PostcardWriter();
      w.writeVarInt(3);
      w.writeString('a');
      w.writeString('1');
      w.writeString('b');
      w.writeString('2');
      w.writeString('c');
      w.writeString('3');
      final m = decodeStringMap(PostcardReader(w.bytes));
      check(m).length.equals(3);
      check(m['a']).equals('1');
      check(m['b']).equals('2');
      check(m['c']).equals('3');
    });
  });

  group('decodeDeepLinkResult', () {
    test('None → null', () {
      final w = PostcardWriter()..writeU8(0);
      check(decodeDeepLinkResult(PostcardReader(w.bytes))).isNull();
    });

    test('Some(0) → MangaDeepLink', () {
      final w = PostcardWriter();
      w.writeU8(1); // Some
      w.writeVarInt(0); // Manga
      w.writeString('manga-abc');
      final result = decodeDeepLinkResult(PostcardReader(w.bytes));
      check(result).isA<MangaDeepLink>();
      check((result! as MangaDeepLink).key).equals('manga-abc');
    });

    test('Some(1) → ChapterDeepLink', () {
      final w = PostcardWriter();
      w.writeU8(1); // Some
      w.writeVarInt(1); // Chapter
      w.writeString('manga-xyz');
      w.writeString('chapter-123');
      final result = decodeDeepLinkResult(PostcardReader(w.bytes));
      check(result).isA<ChapterDeepLink>();
      final ch = result! as ChapterDeepLink;
      check(ch.mangaKey).equals('manga-xyz');
      check(ch.key).equals('chapter-123');
    });

    test('Some(2) → ListingDeepLink', () {
      final w = PostcardWriter();
      w.writeU8(1); // Some
      w.writeVarInt(2); // Listing
      w.writeString('latest');
      w.writeString('Latest');
      w.writeVarInt(0); // kind = Default
      final result = decodeDeepLinkResult(PostcardReader(w.bytes));
      check(result).isA<ListingDeepLink>();
      check((result! as ListingDeepLink).listing.id).equals('latest');
    });

    test('decodeDeepLinkResultFromBytes returns null for empty bytes', () {
      check(decodeDeepLinkResultFromBytes(Uint8List(0))).isNull();
    });
  });

  group('decodeMangaWithChapter', () {
    test('decodes manga and chapter pair', () {
      final w = PostcardWriter();
      _writeMinimalManga(w, key: 'mg1', title: 'Manga One');
      _writeMinimalChapter(w, key: 'ch99');
      final pair = decodeMangaWithChapter(PostcardReader(w.bytes));
      check(pair.manga.key).equals('mg1');
      check(pair.manga.title).equals('Manga One');
      check(pair.chapter.key).equals('ch99');
    });
  });

  group('decodeStringVecResult', () {
    test('empty list', () {
      final w = PostcardWriter()..writeVarInt(0);
      check(decodeStringVecResult(w.bytes)).isEmpty();
    });

    test('three strings', () {
      final w = PostcardWriter();
      w.writeVarInt(3);
      w.writeString('https://cover1.jpg');
      w.writeString('https://cover2.jpg');
      w.writeString('https://cover3.jpg');
      final result = decodeStringVecResult(w.bytes);
      check(result).length.equals(3);
      check(result[0]).equals('https://cover1.jpg');
      check(result[2]).equals('https://cover3.jpg');
    });

    test('empty bytes → empty list', () {
      check(decodeStringVecResult(Uint8List(0))).isEmpty();
    });
  });

  group('decodeStringResult', () {
    test('decodes plain string', () {
      final w = PostcardWriter()..writeString('https://base.example.com');
      check(decodeStringResult(w.bytes)).equals('https://base.example.com');
    });

    test('empty bytes → null', () {
      check(decodeStringResult(Uint8List(0))).isNull();
    });
  });

  group('decodeBoolResult', () {
    test('true', () {
      check(decodeBoolResult(Uint8List.fromList([1]))).isTrue();
    });

    test('false', () {
      check(decodeBoolResult(Uint8List.fromList([0]))).isFalse();
    });

    test('empty bytes → false', () {
      check(decodeBoolResult(Uint8List(0))).isFalse();
    });
  });

  group('encodeStringBytes', () {
    test('ASCII round-trip', () {
      final bytes = encodeStringBytes('hello');
      check(utf8.decode(bytes)).equals('hello');
    });

    test('empty string', () {
      check(encodeStringBytes('')).isEmpty();
    });
  });

  group('encodeImageResponse', () {
    test('wraps bytes in postcard Vec<u8>', () {
      final input = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]); // PNG magic
      final wrapped = encodeImageResponse(input);
      final r = PostcardReader(wrapped);
      final len = r.readVarInt();
      check(len).equals(4);
      check(wrapped.sublist(r.position)).deepEquals(input);
    });

    test('empty input', () {
      final wrapped = encodeImageResponse(Uint8List(0));
      final r = PostcardReader(wrapped);
      check(r.readVarInt()).equals(0);
      check(r.isAtEnd).isTrue();
    });
  });

  group('encodeStringMap', () {
    test('empty map', () {
      final bytes = encodeStringMap({});
      final r = PostcardReader(bytes);
      check(r.readVarInt()).equals(0);
      check(r.isAtEnd).isTrue();
    });

    test('two entries round-trip', () {
      final bytes = encodeStringMap({'key1': 'val1', 'key2': 'val2'});
      final decoded = decodeStringMap(PostcardReader(bytes));
      check(decoded['key1']).equals('val1');
      check(decoded['key2']).equals('val2');
    });
  });

  group('encodeOptionalStringMap', () {
    test('null → [0x00]', () {
      check(encodeOptionalStringMap(null)).deepEquals([0]);
    });

    test('some map → [0x01, ...encodedMap]', () {
      final bytes = encodeOptionalStringMap({'k': 'v'});
      check(bytes[0]).equals(1); // Some tag
      final decoded = decodeStringMap(PostcardReader(bytes.sublist(1)));
      check(decoded['k']).equals('v');
    });
  });

  group('encodePage', () {
    test('URL page encodes as Url variant', () {
      const page = Page(index: 0, url: 'https://img.example.com/1.jpg');
      final bytes = encodePage(page);
      final r = PostcardReader(bytes);
      check(r.readVarInt()).equals(0); // Url variant
      check(r.readString()).equals('https://img.example.com/1.jpg');
      check(r.readU8()).equals(0); // PageContext = None
      check(r.readU8()).equals(0); // thumbnail = None
      check(r.readBool()).isFalse(); // has_description
      check(r.readU8()).equals(0); // description = None
    });

    test('text page encodes as Text variant', () {
      const page = Page(index: 1, text: 'Caption here');
      final bytes = encodePage(page);
      final r = PostcardReader(bytes);
      check(r.readVarInt()).equals(1); // Text variant
      check(r.readString()).equals('Caption here');
    });

    test('page with no url/text encodes as Image variant', () {
      const page = Page(index: 2);
      final bytes = encodePage(page);
      final r = PostcardReader(bytes);
      check(r.readVarInt()).equals(2); // Image variant
    });
  });

  group('decodeEnum', () {
    test('returns correct enum value', () {
      final w = PostcardWriter()..writeVarInt(2);
      check(decodeEnum(PostcardReader(w.bytes), AidokuViewer.values)).equals(AidokuViewer.rtl);
    });

    test('out-of-range clamps to first value', () {
      final w = PostcardWriter()..writeVarInt(99);
      check(decodeEnum(PostcardReader(w.bytes), AidokuViewer.values)).equals(AidokuViewer.unknown);
    });
  });
}

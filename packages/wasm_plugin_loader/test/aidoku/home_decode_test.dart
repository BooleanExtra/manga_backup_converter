// Unit tests for HomeLayout / HomeComponent / HomeComponentValue decoding.
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

void _writeMinimalManga(PostcardWriter w, {String key = 'k', String title = 'T'}) {
  w.writeString(key); // key
  w.writeString(title); // title
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

/// Write a minimal HomeLink: title, subtitle=None, imageUrl=None, value=None.
void _writeMinimalLink(PostcardWriter w, String title) {
  w.writeString(title);
  w.writeU8(0); // subtitle: None
  w.writeU8(0); // imageUrl: None
  w.writeU8(0); // value: None
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('decodeHomeLayout', () {
    test('empty component list', () {
      final w = PostcardWriter()..writeVarInt(0);
      final HomeLayout layout = decodeHomeLayout(PostcardReader(w.bytes));
      check(layout.components).isEmpty();
    });

    test('result-buffer entry point returns null for empty bytes', () {
      check(decodeHomeLayoutResult(Uint8List(0))).isNull();
    });
  });

  group('HomeComponentValue — ImageScroller (discriminant 0)', () {
    test('empty links list', () {
      final w = PostcardWriter();
      w.writeU8(0); // title: None
      w.writeU8(0); // subtitle: None
      w.writeVarInt(0); // discriminant = ImageScroller
      w.writeVarInt(0); // links: empty vec (Vec<Link>)
      w.writeU8(0); // autoScrollInterval: None (Option<f32>)
      w.writeU8(0); // width: None (Option<i32>)
      w.writeU8(0); // height: None (Option<i32>)

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      check(comp.value).isA<ImageScrollerValue>();
      final v = comp.value as ImageScrollerValue;
      check(v.links).isEmpty();
      check(v.autoScrollInterval).isNull();
      check(v.width).isNull();
      check(v.height).isNull();
    });

    test('with one link, scroll interval, width, height', () {
      final w = PostcardWriter();
      w.writeU8(0); // title: None
      w.writeU8(0); // subtitle: None
      w.writeVarInt(0); // discriminant = ImageScroller
      w.writeVarInt(1); // 1 link
      _writeMinimalLink(w, 'cover-link');
      w.writeU8(1); // autoScrollInterval: Some(f32)
      w.writeF32(5.0);
      w.writeU8(1); // width: Some(i32)
      w.writeVarInt(300);
      w.writeU8(1); // height: Some(i32)
      w.writeVarInt(200);

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as ImageScrollerValue;
      check(v.links).length.equals(1);
      check(v.links[0].title).equals('cover-link');
      check(v.autoScrollInterval).isNotNull().isCloseTo(5.0, 0.001);
      check(v.width).equals(300);
      check(v.height).equals(200);
    });
  });

  group('HomeComponentValue — BigScroller (discriminant 1)', () {
    test('two manga items, no autoScrollInterval', () {
      final w = PostcardWriter();
      w.writeU8(0); // title: None
      w.writeU8(0); // subtitle: None
      w.writeVarInt(1); // BigScroller
      w.writeVarInt(2); // 2 items (Vec<Manga>)
      _writeMinimalManga(w, key: 'a');
      _writeMinimalManga(w, key: 'b');
      w.writeU8(0); // autoScrollInterval: None (Option<f32>)

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      check(comp.value).isA<BigScrollerValue>();
      final v = comp.value as BigScrollerValue;
      check(v.items).length.equals(2);
      check(v.items[0].key).equals('a');
      check(v.items[1].key).equals('b');
      check(v.autoScrollInterval).isNull();
    });

    test('with autoScrollInterval', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(1); // BigScroller
      w.writeVarInt(0); // 0 items
      w.writeU8(1); // autoScrollInterval: Some(f32)
      w.writeF32(2.5);

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as BigScrollerValue;
      check(v.autoScrollInterval).isNotNull().isCloseTo(2.5, 0.001);
    });
  });

  group('HomeComponentValue — Scroller (discriminant 2)', () {
    test('empty links, no listing', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(2); // Scroller
      w.writeVarInt(0); // 0 links (Vec<Link>)
      w.writeU8(0); // listing: None

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      check(comp.value).isA<ScrollerValue>();
      final v = comp.value as ScrollerValue;
      check(v.links).isEmpty();
      check(v.listing).isNull();
    });

    test('one link with listing', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(2); // Scroller
      w.writeVarInt(1); // 1 link
      _writeMinimalLink(w, 'link1');
      w.writeU8(1); // listing: Some
      w.writeString('latest');
      w.writeString('Latest');
      w.writeVarInt(0); // kind = Default

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as ScrollerValue;
      check(v.links).length.equals(1);
      check(v.links[0].title).equals('link1');
      check(v.listing).isNotNull();
      check(v.listing?.id).equals('latest');
    });
  });

  group('HomeComponentValue — MangaList (discriminant 3)', () {
    test('unranked, no pageSize, no listing', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(3); // MangaList
      w.writeBool(false); // ranked = false (FIRST in Rust)
      w.writeU8(0); // pageSize: None (SECOND)
      w.writeVarInt(1); // 1 link (THIRD: Vec<Link>)
      _writeMinimalLink(w, 'manga-link');
      w.writeU8(0); // listing: None

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as MangaListValue;
      check(v.ranked).isFalse();
      check(v.pageSize).isNull();
      check(v.listing).isNull();
      check(v.links).length.equals(1);
      check(v.links[0].title).equals('manga-link');
    });

    test('ranked with pageSize', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(3);
      w.writeBool(true); // ranked (FIRST)
      w.writeU8(1); // pageSize: Some (SECOND)
      w.writeVarInt(20);
      w.writeVarInt(0); // 0 links (THIRD)
      w.writeU8(0); // listing: None

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as MangaListValue;
      check(v.ranked).isTrue();
      check(v.pageSize).equals(20);
      check(v.links).isEmpty();
    });
  });

  group('HomeComponentValue — MangaChapterList (discriminant 4)', () {
    test('empty list, no pageSize', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(4); // MangaChapterList
      w.writeU8(0); // pageSize: None (FIRST in Rust)
      w.writeVarInt(0); // 0 items (SECOND)
      w.writeU8(0); // listing: None

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      check(comp.value).isA<MangaChapterListValue>();
      final v = comp.value as MangaChapterListValue;
      check(v.items).isEmpty();
      check(v.pageSize).isNull();
    });

    test('one item with pageSize', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(4); // MangaChapterList
      w.writeU8(1); // pageSize: Some (FIRST)
      w.writeVarInt(10);
      w.writeVarInt(1); // 1 item (SECOND)
      _writeMinimalManga(w, key: 'mg1');
      _writeMinimalChapter(w);
      w.writeU8(0); // listing: None

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as MangaChapterListValue;
      check(v.pageSize).equals(10);
      check(v.items).length.equals(1);
      check(v.items[0].manga.key).equals('mg1');
      check(v.items[0].chapter.key).equals('ch1');
    });
  });

  group('HomeComponentValue — Filters (discriminant 5)', () {
    test('empty filter list', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(5); // Filters
      w.writeVarInt(0); // 0 FilterItems

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      check(comp.value).isA<FiltersValue>();
      final v = comp.value as FiltersValue;
      check(v.filters).isEmpty();
    });

    test('one FilterItem with no filterValues', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(5); // Filters
      w.writeVarInt(1); // 1 FilterItem
      w.writeString('Genre'); // title
      w.writeU8(0); // filterValues: None

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as FiltersValue;
      check(v.filters).length.equals(1);
      check(v.filters[0].title).equals('Genre');
      check(v.filters[0].filterValues).isNull();
    });

    test('one FilterItem with one Text filter value', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(5); // Filters
      w.writeVarInt(1); // 1 FilterItem
      w.writeString('Search'); // title
      w.writeU8(1); // filterValues: Some
      w.writeVarInt(1); // 1 AidokuFilterValue
      w.writeVarInt(0); // discriminant = Text
      w.writeString('filter-id'); // id
      w.writeString('initial-text'); // value: String

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as FiltersValue;
      check(v.filters[0].filterValues).isNotNull();
      check(v.filters[0].filterValues!).length.equals(1);
      final AidokuFilterValue fv = v.filters[0].filterValues![0];
      check(fv.id).equals('filter-id');
      check(fv.discriminant).equals(0);
      check(fv.raw).equals('initial-text');
    });
  });

  group('HomeComponentValue — Links (discriminant 6)', () {
    test('single URL link', () {
      final w = PostcardWriter();
      w.writeU8(0);
      w.writeU8(0);
      w.writeVarInt(6); // Links
      w.writeVarInt(1); // 1 link
      w.writeString('Visit site');
      w.writeU8(0); // subtitle: None
      w.writeU8(0); // imageUrl: None
      w.writeU8(1); // value: Some
      w.writeVarInt(0); // UrlHomeLinkValue
      w.writeString('https://example.com');

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      final v = comp.value as LinksValue;
      check(v.links).length.equals(1);
      check(v.links[0].title).equals('Visit site');
      check(v.links[0].value).isA<UrlHomeLinkValue>();
      check((v.links[0].value! as UrlHomeLinkValue).url).equals('https://example.com');
    });
  });

  group('HomePartialResult', () {
    test('discriminant 0 → HomePartialResultLayout', () {
      final w = PostcardWriter();
      w.writeVarInt(0); // Layout
      w.writeVarInt(0); // empty component list

      final HomePartialResult result = decodeHomePartialResult(PostcardReader(w.bytes));
      check(result).isA<HomePartialResultLayout>();
    });

    test('discriminant 1 → HomePartialResultComponent with Scroller', () {
      final w = PostcardWriter();
      w.writeVarInt(1); // Component
      w.writeU8(0); // title: None
      w.writeU8(0); // subtitle: None
      w.writeVarInt(2); // Scroller discriminant
      w.writeVarInt(0); // 0 links
      w.writeU8(0); // listing: None

      final HomePartialResult result = decodeHomePartialResult(PostcardReader(w.bytes));
      check(result).isA<HomePartialResultComponent>();
    });

    test('decodeHomePartialResultFromBytes returns null for empty bytes', () {
      check(decodeHomePartialResultFromBytes(Uint8List(0))).isNull();
    });
  });

  group('HomeComponent title and subtitle', () {
    test('both title and subtitle present', () {
      final w = PostcardWriter();
      w.writeOption<String>('My Section', (String v, PostcardWriter pw) => pw.writeString(v));
      w.writeOption<String>('Sub', (String v, PostcardWriter pw) => pw.writeString(v));
      w.writeVarInt(2); // Scroller
      w.writeVarInt(0); // 0 links
      w.writeU8(0); // listing: None

      final HomeComponent comp = decodeHomeComponent(PostcardReader(w.bytes));
      check(comp.title).equals('My Section');
      check(comp.subtitle).equals('Sub');
    });
  });
}

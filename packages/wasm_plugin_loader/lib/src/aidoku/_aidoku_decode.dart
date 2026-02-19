// Shared postcard deserialization helpers used by both the native and web
// AidokuPlugin implementations.
// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'dart:typed_data';

import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';
import 'package:wasm_plugin_loader/src/models/chapter.dart';
import 'package:wasm_plugin_loader/src/models/filter.dart';
import 'package:wasm_plugin_loader/src/models/manga.dart';
import 'package:wasm_plugin_loader/src/models/page.dart';

// ---------------------------------------------------------------------------
// Encoding helpers
// ---------------------------------------------------------------------------

/// Encode query as raw UTF-8 bytes (stored as a BytesResource RID).
Uint8List encodeQuery(String query) => Uint8List.fromList(utf8.encode(query));

/// Encode a List<String> as a postcard Vec<String>.
/// Used to seed source languages into WASM defaults.
Uint8List encodeStringList(List<String> values) {
  final w = PostcardWriter();
  w.writeList(values, (s, pw) => pw.writeString(s));
  return w.bytes;
}

/// Encode a minimal Manga struct (postcard) with only the key field set.
/// Used to pass a manga descriptor RID to WASM functions like `get_manga_update`.
/// Field order matches the Rust `Manga` struct in aidoku-rs structs/mod.rs.
Uint8List encodeMangaKey(String key) {
  final w = PostcardWriter();
  w.writeString(key); // key: String
  w.writeString(''); // title: String
  w.writeU8(0); // cover: None (Option<String>)
  w.writeU8(0); // artists: None (Option<Vec<String>>)
  w.writeU8(0); // authors: None (Option<Vec<String>>)
  w.writeU8(0); // description: None (Option<String>)
  w.writeU8(0); // url: None (Option<String>)
  w.writeU8(0); // tags: None (Option<Vec<String>>)
  w.writeVarInt(0); // status: Unknown
  w.writeVarInt(0); // content_rating: Safe
  w.writeVarInt(0); // viewer: Default
  w.writeVarInt(0); // update_strategy: Default
  w.writeU8(0); // next_update_time: None (Option<i64>)
  w.writeU8(0); // chapters: None (Option<Vec<Chapter>>)
  return w.bytes;
}

/// Encode a full Manga struct (postcard) with all fields populated.
/// Used to pass a manga descriptor RID to WASM functions like `get_page_list`.
Uint8List encodeManga(Manga m) {
  final w = PostcardWriter();
  w.writeString(m.key); // key: String
  w.writeString(m.title); // title: String
  w.writeOption(m.coverUrl, (v, pw) => pw.writeString(v)); // cover: Option<String>
  w.writeOption(
    m.artists.isEmpty ? null : m.artists,
    (v, pw) => pw.writeList(v, (s, pw2) => pw2.writeString(s)),
  ); // artists: Option<Vec<String>>
  w.writeOption(
    m.authors.isEmpty ? null : m.authors,
    (v, pw) => pw.writeList(v, (s, pw2) => pw2.writeString(s)),
  ); // authors: Option<Vec<String>>
  w.writeOption(m.description, (v, pw) => pw.writeString(v)); // description: Option<String>
  w.writeOption(m.url, (v, pw) => pw.writeString(v)); // url: Option<String>
  w.writeOption(
    m.tags.isEmpty ? null : m.tags,
    (v, pw) => pw.writeList(v, (s, pw2) => pw2.writeString(s)),
  ); // tags: Option<Vec<String>>
  w.writeVarInt(m.status.index); // status: varint
  w.writeVarInt(m.contentRating.index); // content_rating: varint
  w.writeVarInt(0); // viewer: Default
  w.writeVarInt(0); // update_strategy: Default
  w.writeU8(0); // next_update_time: None (Option<i64>)
  w.writeU8(0); // chapters: None (Option<Vec<Chapter>>) — omit to avoid circular encoding
  return w.bytes;
}

/// Encode a full Chapter struct (postcard) with all fields populated.
/// Used to pass a chapter descriptor RID to WASM functions like `get_page_list`.
Uint8List encodeChapter(Chapter ch) {
  final w = PostcardWriter();
  w.writeString(ch.key); // key: String
  w.writeOption(ch.title, (v, pw) => pw.writeString(v)); // title: Option<String>
  w.writeOption(ch.chapterNumber, (v, pw) => pw.writeF32(v)); // chapter_number: Option<f32>
  w.writeOption(ch.volumeNumber, (v, pw) => pw.writeF32(v)); // volume_number: Option<f32>
  w.writeOption(
    ch.dateUploaded != null ? ch.dateUploaded!.millisecondsSinceEpoch ~/ 1000 : null,
    (v, pw) => pw.writeI64(v),
  ); // date_uploaded: Option<i64> (seconds)
  w.writeOption(
    ch.scanlators.isEmpty ? null : ch.scanlators,
    (v, pw) => pw.writeList(v, (s, pw2) => pw2.writeString(s)),
  ); // scanlators: Option<Vec<String>>
  w.writeOption(ch.url, (v, pw) => pw.writeString(v)); // url: Option<String>
  w.writeOption(ch.language, (v, pw) => pw.writeString(v)); // language: Option<String>
  w.writeU8(0); // thumbnail: None (Option<String>)
  w.writeBool(false); // locked: bool
  return w.bytes;
}

/// Encode a minimal Chapter struct (postcard) with only the key field set.
/// Used to pass a chapter descriptor RID to WASM functions like `get_page_list`.
/// Field order matches the Rust `Chapter` struct in aidoku-rs structs/mod.rs.
Uint8List encodeChapterKey(String key) {
  final w = PostcardWriter();
  w.writeString(key); // key: String
  w.writeU8(0); // title: None (Option<String>)
  w.writeU8(0); // chapter_number: None (Option<f32>)
  w.writeU8(0); // volume_number: None (Option<f32>)
  w.writeU8(0); // date_uploaded: None (Option<i64>)
  w.writeU8(0); // scanlators: None (Option<Vec<String>>)
  w.writeU8(0); // url: None (Option<String>)
  w.writeU8(0); // language: None (Option<String>)
  w.writeU8(0); // thumbnail: None (Option<String>)
  w.writeBool(false); // locked: bool
  return w.bytes;
}

// ---------------------------------------------------------------------------
// Listing struct (used by get_listings / get_manga_list)
// ---------------------------------------------------------------------------

/// An Aidoku source listing (browse category).
class AidokuListing {
  const AidokuListing({required this.id, required this.name, required this.kind});
  final String id;
  final String name;
  final int kind; // 0 = Default, 1 = List
}

/// Decode a postcard Vec<Listing> returned by `get_listings`.
List<AidokuListing> decodeListings(PostcardReader r) {
  return r.readList(() {
    final id = r.readString();
    final name = r.readString();
    final kind = r.readVarInt();
    return AidokuListing(id: id, name: name, kind: kind);
  });
}

/// Encode an [AidokuListing] as postcard bytes for passing as a descriptor RID.
Uint8List encodeListing(AidokuListing listing) {
  final w = PostcardWriter();
  w.writeString(listing.id);
  w.writeString(listing.name);
  w.writeVarInt(listing.kind);
  return w.bytes;
}

/// Encode filter list as postcard bytes.
Uint8List encodeFilters(List<FilterValue> filters) {
  final w = PostcardWriter();
  w.writeList(filters, (f, pw) {
    pw.writeVarInt(f.type.index);
    pw.writeString(f.name);
    final v = f.value;
    if (v is String) {
      pw.writeString(v);
    } else if (v is bool) {
      pw.writeBool(v);
    } else if (v is int) {
      pw.writeVarInt(v);
    }
  });
  return w.bytes;
}

// ---------------------------------------------------------------------------
// Decoding helpers
// ---------------------------------------------------------------------------

MangaPageResult decodeMangaPageResult(PostcardReader r) {
  final manga = r.readList(() => decodeManga(r));
  final hasNextPage = r.readBool();
  return MangaPageResult(manga: manga, hasNextPage: hasNextPage);
}

Manga decodeManga(PostcardReader r) {
  final key = r.readString();
  final title = r.readString();
  final cover = r.readOption(r.readString);
  final artists = r.readOption(() => r.readList(r.readString));
  final authors = r.readOption(() => r.readList(r.readString));
  final description = r.readOption(r.readString);
  final url = r.readOption(r.readString);
  final tags = r.readOption(() => r.readList(r.readString));
  final statusIdx = r.readVarInt();
  final status = MangaStatus.values[statusIdx.clamp(0, MangaStatus.values.length - 1)];
  final ratingIdx = r.readVarInt();
  final rating = ContentRating.values[ratingIdx.clamp(0, ContentRating.values.length - 1)];
  r.readVarInt(); // viewer (not in our model)
  r.readVarInt(); // update_strategy (not in our model)
  r.readOption(r.readI64); // next_update_time (not in our model)
  final chapters = r.readOption(() => r.readList(() => decodeChapter(r))) ?? [];

  return Manga(
    key: key,
    title: title,
    coverUrl: cover,
    authors: authors ?? [],
    artists: artists ?? [],
    description: description,
    tags: tags ?? [],
    status: status,
    contentRating: rating,
    chapters: chapters,
    url: url,
  );
}

Chapter decodeChapter(PostcardReader r) {
  final key = r.readString();
  final title = r.readOption(r.readString);
  final chapterNum = r.readOption(r.readF32);
  final volumeNum = r.readOption(r.readF32);
  final dateUploadedSecs = r.readOption(r.readI64);
  final scanlators = r.readOption(() => r.readList(r.readString));
  final url = r.readOption(r.readString);
  final language = r.readOption(r.readString);
  r.readOption(r.readString); // thumbnail (not in our model)
  r.readBool(); // locked (not in our model)

  return Chapter(
    key: key,
    title: title,
    chapterNumber: chapterNum,
    volumeNumber: volumeNum,
    dateUploaded: dateUploadedSecs != null
        ? DateTime.fromMillisecondsSinceEpoch(dateUploadedSecs * 1000)
        : null,
    scanlators: scanlators ?? [],
    language: language,
    url: url,
  );
}

/// Decode a list of [Page] objects from a postcard result buffer.
///
/// Aidoku Page struct layout (postcard serialization):
///   content: PageContent enum (varint variant index + variant data)
///     0 = Url(String url, Option<PageContext> context)
///     1 = Text(String text)
///     2 = Image(...) — externally managed, not decoded
///     3 = Zip(String url, String path)
///   thumbnail: Option<String>
///   has_description: bool
///   description: Option<String>
///
/// The page index is the position in the Vec (0-based), not a serialized field.
List<Page> decodePageList(PostcardReader r) {
  final pages = r.readList(() {
    // PageContent enum variant
    final variant = r.readVarInt();
    String? url;
    String? base64;
    String? text;
    switch (variant) {
      case 0: // Url(String, Option<PageContext>)
        url = r.readString();
        // Option<PageContext> — skip (read as None/Some + fields if present)
        _skipPageContext(r);
      case 1: // Text(String)
        text = r.readString();
      case 2: // Image — externally managed, no serialized data expected
        break;
      case 3: // Zip(String url, String path)
        url = r.readString();
        r.readString(); // path (discard)
    }
    // thumbnail: Option<String>
    r.readOption(r.readString);
    // has_description: bool
    r.readBool();
    // description: Option<String>
    r.readOption(r.readString);
    return (url: url, base64: base64, text: text);
  });
  return [
    for (var i = 0; i < pages.length; i++)
      Page(index: i, url: pages[i].url, base64: pages[i].base64, text: pages[i].text),
  ];
}

/// Skip an Option<PageContext> field in the postcard stream.
/// PageContext is not used by our model — we just need to advance past it.
void _skipPageContext(PostcardReader r) {
  final tag = r.readU8();
  if (tag == 0) return; // None
  // Some(PageContext) — PageContext fields vary by version; skip conservatively.
  // PageContext typically contains: Option<String> (previous_page), Option<String> (next_page)
  r.readOption(r.readString); // previous page
  r.readOption(r.readString); // next page
}

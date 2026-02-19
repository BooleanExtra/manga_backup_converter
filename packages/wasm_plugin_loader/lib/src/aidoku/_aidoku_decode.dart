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
/// Layout per page: [varint index][option<string> url][option<string> base64][option<string> text]
List<Page> decodePageList(PostcardReader r) {
  return r.readList(() {
    final index = r.readVarInt();
    final url = r.readOption(r.readString);
    final base64 = r.readOption(r.readString);
    final text = r.readOption(r.readString);
    return Page(index: index, url: url, base64: base64, text: text);
  });
}

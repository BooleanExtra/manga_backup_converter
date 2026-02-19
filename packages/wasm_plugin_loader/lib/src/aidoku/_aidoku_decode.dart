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
Uint8List encodeQuery(String query) =>
    Uint8List.fromList(utf8.encode(query));

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
  final author = r.readOption(r.readString);
  final artist = r.readOption(r.readString);
  final description = r.readOption(r.readString);
  final url = r.readOption(r.readString);
  final statusIdx = r.readVarInt();
  final status = MangaStatus.values[statusIdx.clamp(0, MangaStatus.values.length - 1)];
  final ratingIdx = r.readVarInt();
  final rating =
      ContentRating.values[ratingIdx.clamp(0, ContentRating.values.length - 1)];
  r.readVarInt(); // viewer enum (not in our model)
  final cover = r.readOption(r.readString);
  final tags = r.readList(r.readString);
  final chapters = r.readList(() => decodeChapter(r));

  return Manga(
    key: key,
    title: title,
    coverUrl: cover,
    authors: author != null ? [author] : [],
    artists: artist != null ? [artist] : [],
    description: description,
    tags: tags,
    status: status,
    contentRating: rating,
    chapters: chapters,
    url: url,
  );
}

Chapter decodeChapter(PostcardReader r) {
  final key = r.readString();
  final title = r.readOption(r.readString);
  final scanlator = r.readOption(r.readString);
  final url = r.readOption(r.readString);
  final lang = r.readString();
  final chapterNum = r.readOption(r.readF32);
  final volumeNum = r.readOption(r.readF32);
  final dateSecs = r.readOption(r.readF64);

  return Chapter(
    key: key,
    title: title,
    chapterNumber: chapterNum,
    volumeNumber: volumeNum,
    dateUploaded: dateSecs != null
        ? DateTime.fromMillisecondsSinceEpoch((dateSecs * 1000).toInt())
        : null,
    scanlators: scanlator != null ? [scanlator] : [],
    language: lang,
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

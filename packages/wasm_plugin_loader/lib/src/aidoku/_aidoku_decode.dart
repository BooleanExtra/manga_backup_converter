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
import 'package:wasm_plugin_loader/src/models/source_info.dart';

// ---------------------------------------------------------------------------
// Encoding helpers
// ---------------------------------------------------------------------------

/// Encode query as raw UTF-8 bytes (stored as a BytesResource RID).
Uint8List encodeQuery(String query) => Uint8List.fromList(utf8.encode(query));

/// Encode a List<String> as a postcard Vec<String>.
/// Used to seed source languages into WASM defaults.
Uint8List encodeStringList(List<String> values) {
  final w = PostcardWriter();
  w.writeList(values, (String s, PostcardWriter pw) => pw.writeString(s));
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
  w.writeOption(m.coverUrl, (String v, PostcardWriter pw) => pw.writeString(v)); // cover: Option<String>
  w.writeOption(
    m.artists.isEmpty ? null : m.artists,
    (List<String> v, PostcardWriter pw) => pw.writeList(v, (String s, PostcardWriter pw2) => pw2.writeString(s)),
  ); // artists: Option<Vec<String>>
  w.writeOption(
    m.authors.isEmpty ? null : m.authors,
    (List<String> v, PostcardWriter pw) => pw.writeList(v, (String s, PostcardWriter pw2) => pw2.writeString(s)),
  ); // authors: Option<Vec<String>>
  w.writeOption(m.description, (String v, PostcardWriter pw) => pw.writeString(v)); // description: Option<String>
  w.writeOption(m.url, (String v, PostcardWriter pw) => pw.writeString(v)); // url: Option<String>
  w.writeOption(
    m.tags.isEmpty ? null : m.tags,
    (List<String> v, PostcardWriter pw) => pw.writeList(v, (String s, PostcardWriter pw2) => pw2.writeString(s)),
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
  w.writeOption(ch.title, (String v, PostcardWriter pw) => pw.writeString(v)); // title: Option<String>
  w.writeOption(ch.chapterNumber, (double v, PostcardWriter pw) => pw.writeF32(v)); // chapter_number: Option<f32>
  w.writeOption(ch.volumeNumber, (double v, PostcardWriter pw) => pw.writeF32(v)); // volume_number: Option<f32>
  final DateTime? dateUploaded = ch.dateUploaded;
  w.writeOption(
    dateUploaded != null ? dateUploaded.millisecondsSinceEpoch ~/ 1000 : null,
    (int v, PostcardWriter pw) => pw.writeI64(v),
  ); // date_uploaded: Option<i64> (seconds)
  w.writeOption(
    ch.scanlators.isEmpty ? null : ch.scanlators,
    (List<String> v, PostcardWriter pw) => pw.writeList(v, (String s, PostcardWriter pw2) => pw2.writeString(s)),
  ); // scanlators: Option<Vec<String>>
  w.writeOption(ch.url, (String v, PostcardWriter pw) => pw.writeString(v)); // url: Option<String>
  w.writeOption(ch.language, (String v, PostcardWriter pw) => pw.writeString(v)); // language: Option<String>
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
    final String id = r.readString();
    final String name = r.readString();
    final int kind = r.readVarInt();
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
  w.writeList(filters, (FilterValue f, PostcardWriter pw) {
    pw.writeVarInt(f.type.index);
    pw.writeString(f.name);
    final Object? v = f.value;
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
  final List<Manga> manga = r.readList(() => decodeManga(r));
  final bool hasNextPage = r.readBool();
  return MangaPageResult(manga: manga, hasNextPage: hasNextPage);
}

Manga decodeManga(PostcardReader r) {
  final String key = r.readString();
  final String title = r.readString();
  final String? cover = r.readOption(r.readString);
  final List<String>? artists = r.readOption(() => r.readList(r.readString));
  final List<String>? authors = r.readOption(() => r.readList(r.readString));
  final String? description = r.readOption(r.readString);
  final String? url = r.readOption(r.readString);
  final List<String>? tags = r.readOption(() => r.readList(r.readString));
  final int statusIdx = r.readVarInt();
  final MangaStatus status = MangaStatus.values[statusIdx.clamp(0, MangaStatus.values.length - 1)];
  final int ratingIdx = r.readVarInt();
  final ContentRating rating = ContentRating.values[ratingIdx.clamp(0, ContentRating.values.length - 1)];
  r.readVarInt(); // viewer (not in our model)
  r.readVarInt(); // update_strategy (not in our model)
  r.readOption(r.readI64); // next_update_time (not in our model)
  final List<Chapter> chapters = r.readOption(() => r.readList(() => decodeChapter(r))) ?? <Chapter>[];

  return Manga(
    key: key,
    title: title,
    coverUrl: cover,
    authors: authors ?? <String>[],
    artists: artists ?? <String>[],
    description: description,
    tags: tags ?? <String>[],
    status: status,
    contentRating: rating,
    chapters: chapters,
    url: url,
  );
}

Chapter decodeChapter(PostcardReader r) {
  final String key = r.readString();
  final String? title = r.readOption(r.readString);
  final double? chapterNum = r.readOption(r.readF32);
  final double? volumeNum = r.readOption(r.readF32);
  final int? dateUploadedSecs = r.readOption(r.readI64);
  final List<String>? scanlators = r.readOption(() => r.readList(r.readString));
  final String? url = r.readOption(r.readString);
  final String? language = r.readOption(r.readString);
  r.readOption(r.readString); // thumbnail (not in our model)
  r.readBool(); // locked (not in our model)

  return Chapter(
    key: key,
    title: title,
    chapterNumber: chapterNum,
    volumeNumber: volumeNum,
    dateUploaded: dateUploadedSecs != null ? DateTime.fromMillisecondsSinceEpoch(dateUploadedSecs * 1000) : null,
    scanlators: scanlators ?? <String>[],
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
  final List<({String? base64, String? text, String? url})> pages = r.readList(() {
    // PageContent enum variant
    final int variant = r.readVarInt();
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
  return <Page>[
    for (int i = 0; i < pages.length; i++)
      Page(index: i, url: pages[i].url, base64: pages[i].base64, text: pages[i].text),
  ];
}

/// Skip an Option<PageContext> field in the postcard stream.
/// PageContext is HashMap<String, String> in Rust — serialized as varint(len) + pairs.
/// We don't use it, so just advance past it.
void _skipPageContext(PostcardReader r) {
  final int tag = r.readU8();
  if (tag == 0) return; // None
  // Some(HashMap<String, String>) — varint length + key-value pairs
  final int len = r.readVarInt();
  for (var i = 0; i < len; i++) {
    r.readString(); // key
    r.readString(); // value
  }
}

// ---------------------------------------------------------------------------
// Viewer / UpdateStrategy enums
// ---------------------------------------------------------------------------

/// Matches Rust `Viewer` enum in aidoku-rs (serde index order).
enum AidokuViewer { unknown, ltr, rtl, vertical, webtoon }

/// Matches Rust `UpdateStrategy` enum in aidoku-rs (serde index order).
enum AidokuUpdateStrategy { always, never }

/// Read a varint discriminant and return the corresponding enum value.
/// Out-of-range discriminants return the first value (index 0).
T decodeEnum<T>(PostcardReader r, List<T> values) {
  final int idx = r.readVarInt();
  if (idx < 0 || idx >= values.length) return values[0];
  return values[idx];
}

// ---------------------------------------------------------------------------
// HomeLayout model classes
// ---------------------------------------------------------------------------

/// Top-level home screen layout returned by `get_home`.
class HomeLayout {
  const HomeLayout({required this.components});
  final List<HomeComponent> components;
}

/// A single section in the home layout.
class HomeComponent {
  const HomeComponent({required this.value, this.title, this.subtitle});
  final HomeComponentValue value;
  final String? title;
  final String? subtitle;
}

/// Sealed discriminated union for the content of a [HomeComponent].
/// Discriminants match serde index order from the Rust definition:
///   0=ImageScroller, 1=BigScroller, 2=Scroller, 3=MangaList,
///   4=MangaChapterList, 5=Filters, 6=Links
sealed class HomeComponentValue {}

final class ImageScrollerValue extends HomeComponentValue {
  ImageScrollerValue({
    required this.links,
    this.autoScrollInterval,
    this.width,
    this.height,
  });
  final List<HomeLink> links;
  final double? autoScrollInterval;
  final int? width;
  final int? height;
}

final class BigScrollerValue extends HomeComponentValue {
  BigScrollerValue({required this.items, this.autoScrollInterval});
  final List<Manga> items;
  final double? autoScrollInterval;
}

final class ScrollerValue extends HomeComponentValue {
  ScrollerValue({required this.links, this.listing});
  final List<HomeLink> links;
  final SourceListing? listing;
}

final class MangaListValue extends HomeComponentValue {
  MangaListValue({
    required this.links,
    required this.ranked,
    this.pageSize,
    this.listing,
  });
  final List<HomeLink> links;
  final bool ranked;
  final int? pageSize;
  final SourceListing? listing;
}

final class MangaChapterListValue extends HomeComponentValue {
  MangaChapterListValue({required this.items, this.pageSize, this.listing});
  final List<MangaWithChapter> items;
  final int? pageSize;
  final SourceListing? listing;
}

final class FiltersValue extends HomeComponentValue {
  FiltersValue({required this.filters});
  final List<FilterItem> filters;
}

/// A filter item in the Filters home component.
class FilterItem {
  const FilterItem({required this.title, this.filterValues});
  final String title;
  final List<AidokuFilterValue>? filterValues;
}

/// Raw decoded filter value from WASM (distinct from app-level FilterValue model).
class AidokuFilterValue {
  const AidokuFilterValue({required this.id, required this.discriminant, this.raw});
  final String id;
  final int discriminant; // 0=Text,1=Sort,2=Check,3=Select,4=MultiSelect,5=Range
  final Object? raw; // variant data — opaque
}

final class LinksValue extends HomeComponentValue {
  LinksValue({required this.links});
  final List<HomeLink> links;
}

// ---------------------------------------------------------------------------
// HomePartialResult — streamed via partialResults
// ---------------------------------------------------------------------------

sealed class HomePartialResult {}

final class HomePartialResultLayout extends HomePartialResult {
  HomePartialResultLayout({required this.layout});
  final HomeLayout layout;
}

final class HomePartialResultComponent extends HomePartialResult {
  HomePartialResultComponent({required this.component});
  final HomeComponent component;
}

// ---------------------------------------------------------------------------
// Supporting types
// ---------------------------------------------------------------------------

/// A manga + its latest chapter, used in MangaChapterList home components.
class MangaWithChapter {
  const MangaWithChapter({required this.manga, required this.chapter});
  final Manga manga;
  final Chapter chapter;
}

/// A link item in a Links home component.
class HomeLink {
  const HomeLink({required this.title, this.subtitle, this.imageUrl, this.value});
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final HomeLinkValue? value;
}

/// Destination for a [HomeLink].
sealed class HomeLinkValue {}

final class UrlHomeLinkValue extends HomeLinkValue {
  UrlHomeLinkValue({required this.url});
  final String url;
}

final class ListingHomeLinkValue extends HomeLinkValue {
  ListingHomeLinkValue({required this.listing});
  final SourceListing listing;
}

final class MangaHomeLinkValue extends HomeLinkValue {
  MangaHomeLinkValue({required this.manga});
  final Manga manga;
}

// ---------------------------------------------------------------------------
// DeepLinkResult
// ---------------------------------------------------------------------------

sealed class DeepLinkResult {}

final class MangaDeepLink extends DeepLinkResult {
  MangaDeepLink({required this.key});
  final String key;
}

final class ChapterDeepLink extends DeepLinkResult {
  ChapterDeepLink({required this.mangaKey, required this.key});
  final String mangaKey;
  final String key;
}

final class ListingDeepLink extends DeepLinkResult {
  ListingDeepLink({required this.listing});
  final SourceListing listing;
}

// ---------------------------------------------------------------------------
// ImageRequest — returned by get_image_request
// ---------------------------------------------------------------------------

class ImageRequest {
  const ImageRequest({required this.headers, this.url});
  final String? url;
  final Map<String, String> headers;
}

// ---------------------------------------------------------------------------
// New decoders
// ---------------------------------------------------------------------------

/// Decode a full [HomeLayout] from postcard bytes (no result-buffer header).
HomeLayout decodeHomeLayout(PostcardReader r) {
  final List<HomeComponent> components = r.readList(() => decodeHomeComponent(r));
  return HomeLayout(components: components);
}

/// Decode a single [HomeComponent].
HomeComponent decodeHomeComponent(PostcardReader r) {
  final String? title = r.readOption(r.readString);
  final String? subtitle = r.readOption(r.readString);
  final HomeComponentValue value = decodeHomeComponentValue(r);
  return HomeComponent(value: value, title: title, subtitle: subtitle);
}

/// Decode a [HomeComponentValue] variant.
HomeComponentValue decodeHomeComponentValue(PostcardReader r) {
  final int discriminant = r.readVarInt();
  switch (discriminant) {
    case 0: // ImageScroller
      final List<HomeLink> links = r.readList(() => decodeHomeLink(r));
      final double? autoScroll = r.readOption(r.readF32);
      final int? width = r.readOption(r.readVarInt);
      final int? height = r.readOption(r.readVarInt);
      return ImageScrollerValue(
        links: links,
        autoScrollInterval: autoScroll,
        width: width,
        height: height,
      );
    case 1: // BigScroller
      final List<Manga> items = r.readList(() => decodeManga(r));
      final double? autoScroll = r.readOption(r.readF32);
      return BigScrollerValue(items: items, autoScrollInterval: autoScroll);
    case 2: // Scroller
      final List<HomeLink> links = r.readList(() => decodeHomeLink(r));
      final SourceListing? listing = r.readOption(() => _decodeSourceListing(r));
      return ScrollerValue(links: links, listing: listing);
    case 3: // MangaList
      final bool ranked = r.readBool();
      final int? pageSize = r.readOption(r.readVarInt);
      final List<HomeLink> links = r.readList(() => decodeHomeLink(r));
      final SourceListing? listing = r.readOption(() => _decodeSourceListing(r));
      return MangaListValue(
        links: links,
        ranked: ranked,
        pageSize: pageSize,
        listing: listing,
      );
    case 4: // MangaChapterList
      final int? pageSize = r.readOption(r.readVarInt);
      final List<MangaWithChapter> items = r.readList(() => decodeMangaWithChapter(r));
      final SourceListing? listing = r.readOption(() => _decodeSourceListing(r));
      return MangaChapterListValue(items: items, pageSize: pageSize, listing: listing);
    case 5: // Filters
      return FiltersValue(filters: r.readList(() => decodeFilterItem(r)));
    case 6: // Links
      return LinksValue(links: r.readList(() => decodeHomeLink(r)));
    default:
      throw FormatException('Unknown HomeComponentValue discriminant: $discriminant');
  }
}

/// Decode a [HomePartialResult] from postcard bytes (no result-buffer header).
HomePartialResult decodeHomePartialResult(PostcardReader r) {
  final int discriminant = r.readVarInt();
  switch (discriminant) {
    case 0:
      return HomePartialResultLayout(layout: decodeHomeLayout(r));
    case 1:
      return HomePartialResultComponent(component: decodeHomeComponent(r));
    default:
      throw FormatException('Unknown HomePartialResult discriminant: $discriminant');
  }
}

/// Decode a [MangaWithChapter] (manga followed by chapter, both postcard-encoded).
MangaWithChapter decodeMangaWithChapter(PostcardReader r) {
  return MangaWithChapter(manga: decodeManga(r), chapter: decodeChapter(r));
}

/// Decode a [HomeLink].
HomeLink decodeHomeLink(PostcardReader r) {
  final String title = r.readString();
  final String? subtitle = r.readOption(r.readString);
  final String? imageUrl = r.readOption(r.readString);
  final HomeLinkValue? value = r.readOption(() => _decodeHomeLinkValue(r));
  return HomeLink(title: title, subtitle: subtitle, imageUrl: imageUrl, value: value);
}

HomeLinkValue _decodeHomeLinkValue(PostcardReader r) {
  final int discriminant = r.readVarInt();
  switch (discriminant) {
    case 0: // Url
      return UrlHomeLinkValue(url: r.readString());
    case 1: // Listing
      return ListingHomeLinkValue(listing: _decodeSourceListing(r));
    case 2: // Manga
      return MangaHomeLinkValue(manga: decodeManga(r));
    default:
      throw FormatException('Unknown HomeLinkValue discriminant: $discriminant');
  }
}

/// Decode an [ImageRequest] (url: Option<String>, headers: HashMap<String,String>).
ImageRequest decodeImageRequest(PostcardReader r) {
  final String? url = r.readOption(r.readString);
  final Map<String, String> headers = decodeStringMap(r);
  return ImageRequest(url: url, headers: headers);
}

/// Decode a [DeepLinkResult]? (Option<enum> — reads option tag then discriminant).
DeepLinkResult? decodeDeepLinkResult(PostcardReader r) {
  final int tag = r.readU8();
  if (tag == 0) return null; // None
  final int discriminant = r.readVarInt();
  switch (discriminant) {
    case 0: // Manga
      return MangaDeepLink(key: r.readString());
    case 1: // Chapter
      final String mangaKey = r.readString();
      final String key = r.readString();
      return ChapterDeepLink(mangaKey: mangaKey, key: key);
    case 2: // Listing
      return ListingDeepLink(listing: _decodeSourceListing(r));
    default:
      throw FormatException('Unknown DeepLinkResult discriminant: $discriminant');
  }
}

/// Decode a postcard HashMap<String,String>.
Map<String, String> decodeStringMap(PostcardReader r) {
  final int count = r.readVarInt();
  final result = <String, String>{};
  for (var i = 0; i < count; i++) {
    final String key = r.readString();
    final String value = r.readString();
    result[key] = value;
  }
  return result;
}

// Internal: decode a SourceListing (id, name, kind).
SourceListing _decodeSourceListing(PostcardReader r) {
  final String id = r.readString();
  final String name = r.readString();
  final int kind = r.readVarInt();
  return SourceListing(id: id, name: name, kind: kind);
}

/// Decode a [FilterItem] from a Filters home component.
FilterItem decodeFilterItem(PostcardReader r) {
  final String title = r.readString();
  final List<AidokuFilterValue>? values = r.readOption(() => r.readList(() => _decodeAidokuFilterValue(r)));
  return FilterItem(title: title, filterValues: values);
}

AidokuFilterValue _decodeAidokuFilterValue(PostcardReader r) {
  final int discriminant = r.readVarInt();
  final String id = r.readString();
  Object? raw;
  switch (discriminant) {
    case 0: // Text: value: String
      raw = r.readString();
    case 1: // Sort: index: i32, ascending: bool
      raw = (index: r.readVarInt(), ascending: r.readBool());
    case 2: // Check: value: i32
      raw = r.readVarInt();
    case 3: // Select: value: String
      raw = r.readString();
    case 4: // MultiSelect: included: Vec<String>, excluded: Vec<String>
      raw = (included: r.readList(r.readString), excluded: r.readList(r.readString));
    case 5: // Range: from: Option<f32>, to: Option<f32>
      raw = (from: r.readOption(r.readF32), to: r.readOption(r.readF32));
  }
  return AidokuFilterValue(id: id, discriminant: discriminant, raw: raw);
}

// ---------------------------------------------------------------------------
// Result-buffer entry points (strip 8-byte header, then decode)
// ---------------------------------------------------------------------------

/// Decode a `get_home` result payload into a [HomeLayout].
HomeLayout? decodeHomeLayoutResult(Uint8List bytes) {
  if (bytes.isEmpty) return null;
  try {
    return decodeHomeLayout(PostcardReader(bytes));
  } on Object {
    return null;
  }
}

/// Decode a `Vec<String>` result payload.
List<String> decodeStringVecResult(Uint8List bytes) {
  if (bytes.isEmpty) return const <String>[];
  try {
    final r = PostcardReader(bytes);
    return r.readList(r.readString);
  } on Object {
    return const <String>[];
  }
}

/// Decode a `get_image_request` result payload into an [ImageRequest].
ImageRequest? decodeImageRequestResult(Uint8List bytes) {
  if (bytes.isEmpty) return null;
  try {
    return decodeImageRequest(PostcardReader(bytes));
  } on Object {
    return null;
  }
}

/// Decode a `handle_deep_link` result payload into a [DeepLinkResult].
DeepLinkResult? decodeDeepLinkResultFromBytes(Uint8List bytes) {
  if (bytes.isEmpty) return null;
  try {
    return decodeDeepLinkResult(PostcardReader(bytes));
  } on Object {
    return null;
  }
}

/// Decode a plain String result payload.
String? decodeStringResult(Uint8List bytes) {
  if (bytes.isEmpty) return null;
  try {
    return PostcardReader(bytes).readString();
  } on Object {
    return null;
  }
}

/// Decode a bool result payload.
bool decodeBoolResult(Uint8List bytes) {
  if (bytes.isEmpty) return false;
  try {
    return PostcardReader(bytes).readBool();
  } on Object {
    return false;
  }
}

/// Decode a partial result payload into a [HomePartialResult].
HomePartialResult? decodeHomePartialResultFromBytes(Uint8List bytes) {
  if (bytes.isEmpty) return null;
  try {
    return decodeHomePartialResult(PostcardReader(bytes));
  } on Object {
    return null;
  }
}

// ---------------------------------------------------------------------------
// New encoders
// ---------------------------------------------------------------------------

/// Encode a String as raw UTF-8 bytes (no postcard framing).
/// Used for WASM parameters that expect plain UTF-8 via a BytesResource RID.
Uint8List encodeStringBytes(String s) => Uint8List.fromList(utf8.encode(s));

/// Wrap image bytes in a postcard Vec<u8> (varint length + raw bytes).
/// Used for `process_page_image` input encoding.
Uint8List encodeImageResponse(Uint8List bytes) {
  final w = PostcardWriter()..writeVarInt(bytes.length);
  return Uint8List.fromList(<int>[...w.bytes, ...bytes]);
}

/// Encode a Map<String,String> as a postcard HashMap.
Uint8List encodeStringMap(Map<String, String> m) {
  final w = PostcardWriter();
  w.writeVarInt(m.length);
  for (final MapEntry<String, String> e in m.entries) {
    w.writeString(e.key);
    w.writeString(e.value);
  }
  return w.bytes;
}

/// Encode an optional Map<String,String> as postcard Option<HashMap>.
Uint8List encodeOptionalStringMap(Map<String, String>? m) {
  if (m == null) return Uint8List.fromList(<int>[0]);
  return Uint8List.fromList(<int>[1, ...encodeStringMap(m)]);
}

/// Encode a [Page] as postcard bytes for `get_page_description`.
/// Maps to the Rust Page struct: PageContent enum + thumbnail + has_description + description.
Uint8List encodePage(Page p) {
  final w = PostcardWriter();
  if (p.url != null) {
    w.writeVarInt(0); // PageContent::Url
    w.writeString(p.url!);
    w.writeU8(0); // Option<PageContext> = None
  } else if (p.text != null) {
    w.writeVarInt(1); // PageContent::Text
    w.writeString(p.text!);
  } else {
    w.writeVarInt(2); // PageContent::Image — no additional data
  }
  w.writeU8(0); // thumbnail: None (Option<String>)
  w.writeBool(false); // has_description: false
  w.writeU8(0); // description: None (Option<String>)
  return w.bytes;
}

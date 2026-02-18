import 'dart:typed_data';

import 'package:wasm_plugin_loader/src/aidoku/aidoku_host.dart';
import 'package:wasm_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:wasm_plugin_loader/src/aidoku/host_store.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';
import 'package:wasm_plugin_loader/src/models/chapter.dart';
import 'package:wasm_plugin_loader/src/models/filter.dart';
import 'package:wasm_plugin_loader/src/models/manga.dart';
import 'package:wasm_plugin_loader/src/models/source_info.dart';
import 'package:wasm_plugin_loader/src/wasm/wasm_runner.dart';

/// A loaded Aidoku WASM source plugin.
///
/// Wraps a WASM module and exposes high-level manga operations.
/// The WASM ABI is documented in packages/wasm_plugin_loader/WASM_ABI.md.
class AidokuPlugin {
  AidokuPlugin._(this._runner, this._store, this.sourceInfo);

  final WasmRunner _runner;
  final HostStore _store;
  final SourceInfo sourceInfo;

  /// Load a plugin from raw .aix file bytes.
  static Future<AidokuPlugin> fromAix(Uint8List aixBytes) async {
    final bundle = AixParser.parse(aixBytes);
    final store = HostStore();

    // Use a lazy proxy so import closures can reference the runner before it
    // is fully constructed (chicken-and-egg: imports need runner, runner needs
    // imports).
    final lazyRunner = _LazyRunner();
    final imports = buildAidokuHostImports(lazyRunner, store);

    final runner = await WasmRunner.fromBytes(bundle.wasmBytes, imports: imports);
    lazyRunner.delegate = runner;

    // Initialize the source
    try {
      runner.call('start', []);
    } catch (_) {
      // Some sources may not export 'start'
    }

    return AidokuPlugin._(runner, store, bundle.sourceInfo);
  }

  /// Search for manga on this source.
  ///
  /// [query] is the search string. [page] is 1-based.
  Future<MangaPageResult> searchManga(
    String query,
    int page, {
    List<FilterValue> filters = const [],
  }) async {
    final queryRid = _store.addBytes((PostcardWriter()..writeString(query)).bytes);
    final filtersRid = _store.addBytes(_encodeFilters(filters));

    try {
      final ptr = _callInt('get_search_manga_list', [queryRid, page, filtersRid]);
      if (ptr <= 0) return const MangaPageResult(manga: [], hasNextPage: false);

      final data = _readResult(ptr);
      return _decodeMangaPageResult(PostcardReader(data));
    } on Object {
      // Network is stubbed on native (async HTTP not supported in sync WASM
      // callbacks). WASM may return an invalid pointer; treat as empty.
      return const MangaPageResult(manga: [], hasNextPage: false);
    } finally {
      _store.remove(queryRid);
      _store.remove(filtersRid);
    }
  }

  /// Fetch updated details for a manga (including chapters).
  ///
  /// [key] is the manga's source-specific ID.
  Future<Manga?> getMangaDetails(String key) async {
    final mangaRid = _store.addBytes((PostcardWriter()..writeString(key)).bytes);

    try {
      final ptr = _callInt('get_manga_update', [mangaRid, 1, 1]);
      if (ptr <= 0) return null;

      final data = _readResult(ptr);
      return _decodeManga(PostcardReader(data));
    } on Object {
      return null;
    } finally {
      _store.remove(mangaRid);
    }
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  int _callInt(String name, List<Object?> args) => (_runner.call(name, args) as num).toInt();

  /// Read a length-prefixed result buffer from WASM memory and free it.
  /// Convention: [u32 length LE][Postcard bytes]
  Uint8List _readResult(int ptr) {
    final lenBytes = _runner.readMemory(ptr, 4);
    final length = ByteData.sublistView(lenBytes).getUint32(0, Endian.little);
    final data = _runner.readMemory(ptr + 4, length);
    try {
      _runner.call('free_result', [ptr]);
    } catch (_) {}
    return data;
  }

  Uint8List _encodeFilters(List<FilterValue> filters) {
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
  // Postcard deserialization (matches aidoku-rs structs/mod.rs field order)
  // ---------------------------------------------------------------------------

  MangaPageResult _decodeMangaPageResult(PostcardReader r) {
    final manga = r.readList(() => _decodeManga(r));
    final hasNextPage = r.readBool();
    return MangaPageResult(manga: manga, hasNextPage: hasNextPage);
  }

  Manga _decodeManga(PostcardReader r) {
    final key = r.readString();
    final title = r.readString();
    final author = r.readOption(r.readString);
    final artist = r.readOption(r.readString);
    final description = r.readOption(r.readString);
    final url = r.readOption(r.readString);
    final statusIdx = r.readVarInt();
    final status = MangaStatus.values[statusIdx.clamp(0, MangaStatus.values.length - 1)];
    final ratingIdx = r.readVarInt();
    final rating = ContentRating.values[ratingIdx.clamp(0, ContentRating.values.length - 1)];
    r.readVarInt(); // viewer enum (not in our model)
    final cover = r.readOption(r.readString);
    final tags = r.readList(r.readString);
    final chapters = r.readList(() => _decodeChapter(r));

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

  Chapter _decodeChapter(PostcardReader r) {
    final key = r.readString();
    final title = r.readOption(r.readString);
    final scanlator = r.readOption(r.readString);
    final url = r.readOption(r.readString);
    final lang = r.readString();
    final chapterNum = r.readOption(r.readF32);
    final volumeNum = r.readOption(r.readF32);
    final dateMs = r.readOption(r.readF64);

    return Chapter(
      key: key,
      title: title,
      chapterNumber: chapterNum,
      volumeNumber: volumeNum,
      dateUploaded: dateMs != null ? DateTime.fromMillisecondsSinceEpoch(dateMs.toInt()) : null,
      scanlators: scanlator != null ? [scanlator] : [],
      language: lang,
      url: url,
    );
  }
}

/// Proxy that forwards [WasmRunner] calls to a [delegate] once set.
/// Breaks the circular dependency between host import creation and runner init.
class _LazyRunner implements WasmRunner {
  WasmRunner? delegate;

  WasmRunner get _r => delegate ?? (throw StateError('WasmRunner not yet initialized'));

  @override
  dynamic call(String name, List<Object?> args) => _r.call(name, args);

  @override
  Uint8List readMemory(int offset, int length) => _r.readMemory(offset, length);

  @override
  void writeMemory(int offset, Uint8List bytes) => _r.writeMemory(offset, bytes);

  @override
  int get memorySize => _r.memorySize;
}

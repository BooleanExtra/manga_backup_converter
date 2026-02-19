import 'dart:convert';
import 'dart:typed_data';

import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:wasm_plugin_loader/src/aidoku/aidoku_host.dart';
import 'package:wasm_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:wasm_plugin_loader/src/aidoku/host_store.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/models/filter.dart';
import 'package:wasm_plugin_loader/src/models/filter_info.dart';
import 'package:wasm_plugin_loader/src/models/manga.dart';
import 'package:wasm_plugin_loader/src/models/page.dart';
import 'package:wasm_plugin_loader/src/models/setting_item.dart';
import 'package:wasm_plugin_loader/src/models/source_info.dart';
import 'package:wasm_plugin_loader/src/wasm/wasm_runner.dart';

/// A loaded Aidoku WASM source plugin (web implementation).
///
/// WASM executes directly on the main thread. HTTP host imports are stubbed
/// (return -1) because `Atomics.wait()` is not allowed on the main browser
/// thread. Full async HTTP support requires the COOP+COEP Web Worker approach.
class AidokuPlugin {
  AidokuPlugin._(this._runner, this._store, this.sourceInfo, this.settings, this.filterDefinitions);

  final WasmRunner _runner;
  final HostStore _store;
  final SourceInfo sourceInfo;

  /// Parsed settings from `settings.json`.
  final List<SettingItem> settings;

  /// Parsed filter definitions from `filters.json`.
  final List<FilterInfo> filterDefinitions;

  /// Default filters derived from `filters.json` default values.
  List<FilterValue> get defaultFilters => filterDefinitions
      .expand((f) => f.type == 'group' ? f.items : [f])
      .map((f) => f.toDefaultFilterValue())
      .whereType<FilterValue>()
      .toList();

  // ---------------------------------------------------------------------------
  // Factory
  // ---------------------------------------------------------------------------

  /// Load a plugin from raw .aix file bytes.
  static Future<AidokuPlugin> fromAix(Uint8List aixBytes) async {
    final bundle = AixParser.parse(aixBytes);

    final settings = bundle.settings ?? const [];
    final filterDefinitions = bundle.filters ?? const [];
    final initialDefaults = flattenSettingDefaults(settings);

    final store = HostStore();
    // Seed defaults from settings.json before WASM starts.
    store.defaults.addAll(initialDefaults);

    final lazyRunner = _LazyRunner();

    // No asyncHttp/asyncSleep on web — HTTP imports return -1 (stub).
    final imports = buildAidokuHostImports(lazyRunner, store);
    final runner = await WasmRunner.fromBytes(bundle.wasmBytes, imports: imports);
    lazyRunner.delegate = runner;

    try {
      runner.call('start', []);
    } catch (_) {
      // Some sources may not export start.
    }

    return AidokuPlugin._(runner, store, bundle.sourceInfo, settings, filterDefinitions);
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Search for manga on this source. [page] is 1-based.
  Future<MangaPageResult> searchManga(
    String query,
    int page, {
    List<FilterValue> filters = const [],
  }) async {
    final queryRid = _store.addBytes(Uint8List.fromList(utf8.encode(query)));
    final filtersRid = _store.addBytes(encodeFilters(filters));
    try {
      final ptr = _callInt('get_search_manga_list', [queryRid, page, filtersRid]);
      if (ptr <= 0) return const MangaPageResult(manga: [], hasNextPage: false);
      final data = _readResult(ptr);
      return decodeMangaPageResult(PostcardReader(data));
    } on Object {
      return const MangaPageResult(manga: [], hasNextPage: false);
    } finally {
      _store.remove(queryRid);
      _store.remove(filtersRid);
    }
  }

  /// Fetch updated manga details. Returns null on error or no data.
  Future<Manga?> getMangaDetails(String key) async {
    // v2 ABI: get_manga_update(manga_descriptor_rid, needs_details, needs_chapters)
    final mangaRid = _store.addBytes(encodeMangaKey(key));
    try {
      final ptr = _callInt('get_manga_update', [mangaRid, 1, 0]);
      if (ptr <= 0) return null;
      return decodeManga(PostcardReader(_readResult(ptr)));
    } on Object {
      return null;
    } finally {
      _store.remove(mangaRid);
    }
  }

  /// Fetch page image URLs for a chapter.
  Future<List<Page>> getPageList(String key) async {
    // v2 ABI: get_page_list(chapter_descriptor_rid, manga_id_rid); -1 = manga not provided
    final chapterRid = _store.addBytes(encodeChapterKey(key));
    try {
      final ptr = _callInt('get_page_list', [chapterRid, -1]);
      if (ptr <= 0) return [];
      return decodePageList(PostcardReader(_readResult(ptr)));
    } on Object {
      return [];
    } finally {
      _store.remove(chapterRid);
    }
  }

  /// Browse manga listing (page is 1-based, listingIndex selects the source's listing).
  Future<MangaPageResult> getMangaList(int page, {int listingIndex = 0}) async {
    Uint8List? data;

    // Call get_manga_list with the Listing descriptor RID from the manifest.
    if (listingIndex < sourceInfo.listings.length) {
      final sl = sourceInfo.listings[listingIndex];
      final listingRid = _store.addBytes(encodeListing(AidokuListing(id: sl.id, name: sl.name, kind: sl.kind)));
      try {
        final ptr = _callInt('get_manga_list', [listingRid, page]);
        if (ptr > 0) data = _readResult(ptr);
      } on Object {
        // get_manga_list failed; fall through to search fallback.
      } finally {
        _store.remove(listingRid);
      }
    }

    if (data == null) {
      // No listing provided or get_manga_list failed — fall back to empty-query search.
      final queryRid = _store.addBytes(Uint8List(0));
      final filtersRid = _store.addBytes(Uint8List.fromList([0]));
      try {
        final ptr = _callInt('get_search_manga_list', [queryRid, page, filtersRid]);
        if (ptr > 0) data = _readResult(ptr);
      } on Object {
        // fall through
      } finally {
        _store.remove(queryRid);
        _store.remove(filtersRid);
      }
    }

    if (data == null) return const MangaPageResult(manga: [], hasNextPage: false);
    try {
      return decodeMangaPageResult(PostcardReader(data));
    } on Object {
      return const MangaPageResult(manga: [], hasNextPage: false);
    }
  }

  /// Raw postcard bytes from `get_filters`, or null if not supported.
  Future<Uint8List?> getFilters() => _rawGet('get_filters');

  /// Raw postcard bytes from `get_settings`, or null if not supported.
  Future<Uint8List?> getSettings() => _rawGet('get_settings');

  /// Raw postcard bytes from `get_home`, or null if not supported.
  Future<Uint8List?> getHome() => _rawGet('get_home');

  Stream<Uint8List> get partialResults => _store.partialResults;

  void dispose() => _store.dispose();

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  int _callInt(String name, List<Object?> args) => (_runner.call(name, args) as num).toInt();

  /// Read a length-prefixed result buffer from WASM memory and free it.
  ///
  /// Layout written by Rust `__handle_result`:
  ///   bytes[0..4] = (8 + payload_len) as i32 LE  ← total buffer size, signed
  ///   bytes[4..8] = capacity as i32 LE
  ///   bytes[8..]  = postcard payload
  ///
  /// AidokuError::Message returns a positive ptr where bytes[0..4] = -1_i32 LE.
  Uint8List _readResult(int ptr) {
    final lenBytes = _runner.readMemory(ptr, 4);
    final totalLen = ByteData.sublistView(lenBytes).getInt32(0, Endian.little);
    if (totalLen < 0) {
      try {
        _runner.call('free_result', [ptr]);
      } catch (_) {}
      throw const FormatException('AidokuError from WASM result buffer');
    }
    final payloadLen = totalLen - 8;
    final data = _runner.readMemory(ptr + 8, payloadLen);
    try {
      _runner.call('free_result', [ptr]);
    } catch (_) {}
    return data;
  }

  Future<Uint8List?> _rawGet(String funcName) async {
    try {
      final ptr = _callInt(funcName, []);
      if (ptr <= 0) return null;
      return _readResult(ptr);
    } on Object {
      return null;
    }
  }
}

/// Proxy that forwards [WasmRunner] calls to a [delegate] once set.
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

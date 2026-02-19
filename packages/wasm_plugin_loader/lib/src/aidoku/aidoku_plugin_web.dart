import 'dart:convert';
import 'dart:typed_data';

import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:wasm_plugin_loader/src/aidoku/aidoku_host.dart';
import 'package:wasm_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:wasm_plugin_loader/src/aidoku/host_store.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/models/filter.dart';
import 'package:wasm_plugin_loader/src/models/manga.dart';
import 'package:wasm_plugin_loader/src/models/page.dart';
import 'package:wasm_plugin_loader/src/models/source_info.dart';
import 'package:wasm_plugin_loader/src/wasm/wasm_runner.dart';

/// A loaded Aidoku WASM source plugin (web implementation).
///
/// WASM executes directly on the main thread. HTTP host imports are stubbed
/// (return -1) because `Atomics.wait()` is not allowed on the main browser
/// thread. Full async HTTP support requires the COOP+COEP Web Worker approach.
class AidokuPlugin {
  AidokuPlugin._(this._runner, this._store, this.sourceInfo);

  final WasmRunner _runner;
  final HostStore _store;
  final SourceInfo sourceInfo;

  // ---------------------------------------------------------------------------
  // Factory
  // ---------------------------------------------------------------------------

  /// Load a plugin from raw .aix file bytes.
  static Future<AidokuPlugin> fromAix(Uint8List aixBytes) async {
    final bundle = AixParser.parse(aixBytes);
    final store = HostStore();
    final lazyRunner = _LazyRunner();

    // No asyncHttp/asyncSleep on web — HTTP imports return -1 (stub).
    final imports = buildAidokuHostImports(lazyRunner, store);
    final runner = await WasmRunner.fromBytes(bundle.wasmBytes, imports: imports);
    lazyRunner.delegate = runner;

    try {
      runner.call('__start', []);
    } catch (_) {
      // Some sources may not export __start.
    }

    return AidokuPlugin._(runner, store, bundle.sourceInfo);
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
    final queryRid =
        _store.addBytes(Uint8List.fromList(utf8.encode(query)));
    final filtersRid = _store.addBytes(encodeFilters(filters));
    try {
      final ptr = _callInt('__wasm_get_search_manga_list',
          [queryRid, page, filtersRid]);
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
    final keyRid =
        _store.addBytes(Uint8List.fromList(utf8.encode(key)));
    try {
      final ptr = _callInt('__wasm_get_manga_update', [keyRid]);
      if (ptr <= 0) return null;
      return decodeManga(PostcardReader(_readResult(ptr)));
    } on Object {
      return null;
    } finally {
      _store.remove(keyRid);
    }
  }

  /// Fetch page image URLs for a chapter.
  Future<List<Page>> getPageList(String key) async {
    final keyRid =
        _store.addBytes(Uint8List.fromList(utf8.encode(key)));
    try {
      final ptr = _callInt('__wasm_get_page_list', [keyRid]);
      if (ptr <= 0) return [];
      return decodePageList(PostcardReader(_readResult(ptr)));
    } on Object {
      return [];
    } finally {
      _store.remove(keyRid);
    }
  }

  /// Browse manga listing (page is 1-based).
  Future<MangaPageResult> getMangaList(int page) async {
    try {
      final ptr = _callInt('__wasm_get_manga_list', [page]);
      if (ptr <= 0) return const MangaPageResult(manga: [], hasNextPage: false);
      return decodeMangaPageResult(PostcardReader(_readResult(ptr)));
    } on Object {
      return const MangaPageResult(manga: [], hasNextPage: false);
    }
  }

  /// Raw postcard bytes from `__wasm_get_filters`, or null if not supported.
  Future<Uint8List?> getFilters() => _rawGet('__wasm_get_filters');

  /// Raw postcard bytes from `__wasm_get_settings`, or null if not supported.
  Future<Uint8List?> getSettings() => _rawGet('__wasm_get_settings');

  /// Raw postcard bytes from `__wasm_get_home`, or null if not supported.
  Future<Uint8List?> getHome() => _rawGet('__wasm_get_home');

  Stream<Uint8List> get partialResults => _store.partialResults;

  void dispose() => _store.dispose();

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  int _callInt(String name, List<Object?> args) =>
      (_runner.call(name, args) as num).toInt();

  /// Read a length-prefixed result buffer from WASM memory and free it.
  /// Layout: [u32 length LE][u32 capacity LE][<length> bytes postcard]
  Uint8List _readResult(int ptr) {
    final lenBytes = _runner.readMemory(ptr, 4);
    final length =
        ByteData.sublistView(lenBytes).getUint32(0, Endian.little);
    final data = _runner.readMemory(ptr + 8, length);
    try {
      _runner.call('__wasm_free_result', [ptr]);
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
  WasmRunner get _r =>
      delegate ?? (throw StateError('WasmRunner not yet initialized'));

  @override
  dynamic call(String name, List<Object?> args) => _r.call(name, args);

  @override
  Uint8List readMemory(int offset, int length) =>
      _r.readMemory(offset, length);

  @override
  void writeMemory(int offset, Uint8List bytes) =>
      _r.writeMemory(offset, bytes);

  @override
  int get memorySize => _r.memorySize;
}

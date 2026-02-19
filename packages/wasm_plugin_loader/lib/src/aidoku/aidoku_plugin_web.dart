import 'dart:convert';
import 'dart:typed_data';

import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:wasm_plugin_loader/src/aidoku/aidoku_host.dart';
import 'package:wasm_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:wasm_plugin_loader/src/aidoku/host_store.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/models/chapter.dart';
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
  static Future<AidokuPlugin> fromAix(
    Uint8List aixBytes, {
    Map<String, dynamic>? defaults,
  }) async {
    final bundle = AixParser.parse(aixBytes);

    final settings = bundle.settings ?? const [];
    final filterDefinitions = bundle.filters ?? const [];
    final sourceId = bundle.sourceInfo.id;
    final initialDefaults = Map<String, Object>.from(
      flattenSettingDefaults(settings, sourceId: sourceId),
    );
    // Mirror Swift Source.loadSettings() defaultLanguages selection.
    var defaultLanguages = bundle.languageInfos
        .where((l) => l.isDefault ?? false)
        .map((l) => l.effectiveValue)
        .toList();
    if (defaultLanguages.isEmpty && bundle.languageInfos.isNotEmpty) {
      defaultLanguages = [bundle.languageInfos.first.effectiveValue];
    }
    if (bundle.languageSelectType == 'single' && defaultLanguages.length > 1) {
      defaultLanguages = [defaultLanguages.first];
    }
    if (defaultLanguages.isNotEmpty) {
      initialDefaults['$sourceId.languages'] = encodeStringList(defaultLanguages);
    }

    if (defaults != null) {
      for (final entry in defaults.entries) {
        final key = '$sourceId.${entry.key}';
        final value = entry.value;
        if (value == null) {
          // skip
        } else if (value is bool) {
          initialDefaults[key] = value ? 1 : 0;
        } else if (value is int) {
          initialDefaults[key] = value;
        } else if (value is Uint8List) {
          initialDefaults[key] = value;
        } else if (value is String) {
          initialDefaults[key] = Uint8List.fromList(utf8.encode(value));
        } else {
          // double, List, Map → JSON-encoded UTF-8 bytes
          initialDefaults[key] = Uint8List.fromList(utf8.encode(jsonEncode(value)));
        }
      }
    }

    final store = HostStore();
    // Seed defaults from settings.json before WASM starts.
    store.defaults.addAll(initialDefaults);

    final lazyRunner = _LazyRunner();

    // No asyncHttp/asyncSleep on web — HTTP imports return -1 (stub).
    final imports = buildAidokuHostImports(lazyRunner, store, sourceId: sourceId);
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
  Future<List<Page>> getPageList(Manga manga, Chapter chapter) async {
    // ABI: get_page_list(manga_descriptor_rid, chapter_descriptor_rid)
    // Note: manga comes FIRST, chapter comes SECOND.
    final mangaRid = _store.addBytes(encodeManga(manga));
    final chapterRid = _store.addBytes(encodeChapter(chapter));
    try {
      final ptr = _callInt('get_page_list', [mangaRid, chapterRid]);
      if (ptr <= 0) return [];
      return decodePageList(PostcardReader(_readResult(ptr)));
    } on Object {
      return [];
    } finally {
      _store.remove(chapterRid);
      _store.remove(mangaRid);
    }
  }

  /// Browse manga listing (page is 1-based, listing selects the source's listing).
  Future<MangaPageResult> getMangaList(int page, {SourceListing? listing}) async {
    Uint8List? data;

    // Call get_manga_list with the Listing descriptor RID from the manifest.
    if (listing != null) {
      final listingRid = _store.addBytes(
        encodeListing(AidokuListing(id: listing.id, name: listing.name, kind: listing.kind)),
      );
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

  /// Decoded home layout from `get_home`, or null if not supported.
  Future<HomeLayout?> getHome() async {
    final bytes = await _rawGet('get_home');
    return bytes == null ? null : decodeHomeLayoutResult(bytes);
  }

  /// Available source listings from `get_listings`.
  Future<List<AidokuListing>> getListings() async {
    final bytes = await _rawGet('get_listings');
    if (bytes == null) return const [];
    try {
      return decodeListings(PostcardReader(bytes));
    } on Object {
      return const [];
    }
  }

  /// Alternate cover URLs for a manga from `get_alternate_covers`.
  Future<List<String>> getAlternateCovers(Manga manga) async {
    final mangaRid = _store.addBytes(encodeManga(manga));
    try {
      final ptr = _callInt('get_alternate_covers', [mangaRid]);
      if (ptr <= 0) return const [];
      return decodeStringVecResult(_readResult(ptr));
    } on Object {
      return const [];
    } finally {
      _store.remove(mangaRid);
    }
  }

  /// Custom image request for a URL from `get_image_request`.
  Future<ImageRequest?> getImageRequest(String url, {Map<String, String>? context}) async {
    final urlRid = _store.addBytes(encodeStringBytes(url));
    final contextRid = _store.addBytes(encodeOptionalStringMap(context));
    try {
      final ptr = _callInt('get_image_request', [urlRid, contextRid]);
      if (ptr <= 0) return null;
      return decodeImageRequestResult(_readResult(ptr));
    } on Object {
      return null;
    } finally {
      _store.remove(urlRid);
      _store.remove(contextRid);
    }
  }

  /// Source base URL from `get_base_url`.
  Future<String?> getBaseUrl() async {
    final bytes = await _rawGet('get_base_url');
    return bytes == null ? null : decodeStringResult(bytes);
  }

  /// Page description string from `get_page_description`.
  Future<String?> getPageDescription(Page page) async {
    final pageRid = _store.addBytes(encodePage(page));
    try {
      final ptr = _callInt('get_page_description', [pageRid]);
      if (ptr <= 0) return null;
      return decodeStringResult(_readResult(ptr));
    } on Object {
      return null;
    } finally {
      _store.remove(pageRid);
    }
  }

  /// Process a page image (e.g. descramble) via `process_page_image`.
  Future<Uint8List?> processPageImage(Uint8List imageBytes, {Map<String, String>? context}) async {
    final imageRid = _store.addBytes(encodeImageResponse(imageBytes));
    final contextRid = _store.addBytes(encodeOptionalStringMap(context));
    try {
      final ptr = _callInt('process_page_image', [imageRid, contextRid]);
      if (ptr <= 0) return null;
      return _readResult(ptr);
    } on Object {
      return null;
    } finally {
      _store.remove(imageRid);
      _store.remove(contextRid);
    }
  }

  /// Deliver a notification string to the plugin via `handle_notification`.
  Future<void> handleNotification(String notification) async {
    final rid = _store.addBytes(encodeStringBytes(notification));
    try {
      _runner.call('handle_notification', [rid]);
    } on Object {
      // Not implemented or error — ignore.
    } finally {
      _store.remove(rid);
    }
  }

  /// Handle a deep link URL via `handle_deep_link`.
  Future<DeepLinkResult?> handleDeepLink(String url) async {
    final rid = _store.addBytes(encodeStringBytes(url));
    try {
      final ptr = _callInt('handle_deep_link', [rid]);
      if (ptr <= 0) return null;
      return decodeDeepLinkResultFromBytes(_readResult(ptr));
    } on Object {
      return null;
    } finally {
      _store.remove(rid);
    }
  }

  /// Perform basic (username/password) login via `handle_basic_login`.
  Future<bool> handleBasicLogin(String key, String username, String password) async {
    final keyRid = _store.addBytes(encodeStringBytes(key));
    final userRid = _store.addBytes(encodeStringBytes(username));
    final passRid = _store.addBytes(encodeStringBytes(password));
    try {
      final result = _callInt('handle_basic_login', [keyRid, userRid, passRid]);
      return result >= 0;
    } on Object {
      return false;
    } finally {
      _store.remove(keyRid);
      _store.remove(userRid);
      _store.remove(passRid);
    }
  }

  /// Perform web (cookie) login via `handle_web_login`.
  Future<bool> handleWebLogin(String key, Map<String, String> cookies) async {
    final keyRid = _store.addBytes(encodeStringBytes(key));
    final cookiesRid = _store.addBytes(encodeStringMap(cookies));
    try {
      final result = _callInt('handle_web_login', [keyRid, cookiesRid]);
      return result >= 0;
    } on Object {
      return false;
    } finally {
      _store.remove(keyRid);
      _store.remove(cookiesRid);
    }
  }

  /// Migrate a manga key via `handle_key_migration`.
  Future<String?> handleMangaMigration(String key) async {
    final rid = _store.addBytes(encodeStringBytes(key));
    try {
      final ptr = _callInt('handle_key_migration', [rid, -1]);
      if (ptr <= 0) return null;
      return decodeStringResult(_readResult(ptr));
    } on Object {
      return null;
    } finally {
      _store.remove(rid);
    }
  }

  /// Migrate a chapter key via `handle_key_migration`.
  Future<String?> handleChapterMigration(String mangaKey, String chapterKey) async {
    final mangaRid = _store.addBytes(encodeStringBytes(mangaKey));
    final chapterRid = _store.addBytes(encodeStringBytes(chapterKey));
    try {
      final ptr = _callInt('handle_key_migration', [mangaRid, chapterRid]);
      if (ptr <= 0) return null;
      return decodeStringResult(_readResult(ptr));
    } on Object {
      return null;
    } finally {
      _store.remove(mangaRid);
      _store.remove(chapterRid);
    }
  }

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

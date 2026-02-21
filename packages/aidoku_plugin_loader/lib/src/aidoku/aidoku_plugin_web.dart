import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:aidoku_plugin_loader/src/aidoku/aidoku_host.dart';
import 'package:aidoku_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:aidoku_plugin_loader/src/aidoku/host_store.dart';
import 'package:aidoku_plugin_loader/src/codec/postcard_reader.dart';
import 'package:aidoku_plugin_loader/src/models/chapter.dart';
import 'package:aidoku_plugin_loader/src/models/filter.dart';
import 'package:aidoku_plugin_loader/src/models/filter_info.dart';
import 'package:aidoku_plugin_loader/src/models/language_info.dart';
import 'package:aidoku_plugin_loader/src/models/manga.dart';
import 'package:aidoku_plugin_loader/src/models/page.dart';
import 'package:aidoku_plugin_loader/src/models/setting_item.dart';
import 'package:aidoku_plugin_loader/src/models/source_info.dart';
import 'package:aidoku_plugin_loader/src/wasm/wasm_runner.dart';

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
      .expand((FilterInfo f) => f.type == 'group' ? f.items : <FilterInfo>[f])
      .map((FilterInfo f) => f.toDefaultFilterValue())
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
    final AixBundle bundle = AixParser.parse(aixBytes);

    final List<SettingItem> settings = bundle.settings ?? const <SettingItem>[];
    final List<FilterInfo> filterDefinitions = bundle.filters ?? const <FilterInfo>[];
    final String sourceId = bundle.sourceInfo.id;
    final initialDefaults = Map<String, Object>.from(
      flattenSettingDefaults(settings, sourceId: sourceId),
    );
    // Mirror Swift Source.loadSettings() defaultLanguages selection.
    List<String> defaultLanguages = bundle.languageInfos
        .where((LanguageInfo l) => l.isDefault ?? false)
        .map((LanguageInfo l) => l.effectiveValue)
        .toList();
    if (defaultLanguages.isEmpty && bundle.languageInfos.isNotEmpty) {
      defaultLanguages = <String>[bundle.languageInfos.first.effectiveValue];
    }
    if (bundle.languageSelectType == 'single' && defaultLanguages.length > 1) {
      defaultLanguages = <String>[defaultLanguages.first];
    }
    if (defaultLanguages.isNotEmpty) {
      initialDefaults['$sourceId.languages'] = encodeStringList(defaultLanguages);
    }

    if (defaults != null) {
      for (final MapEntry<String, dynamic> entry in defaults.entries) {
        final key = '$sourceId.${entry.key}';
        final Object? value = entry.value;
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
    final Map<String, Map<String, Function>> imports = buildAidokuHostImports(lazyRunner, store, sourceId: sourceId);
    final WasmRunner runner = await WasmRunner.fromBytes(bundle.wasmBytes, imports: imports);
    lazyRunner.delegate = runner;

    runner.call('start', <Object?>[]);

    return AidokuPlugin._(runner, store, bundle.sourceInfo, settings, filterDefinitions);
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Search for manga on this source. [page] is 1-based.
  Future<MangaPageResult> searchManga(
    String query,
    int page, {
    List<FilterValue> filters = const <FilterValue>[],
  }) async {
    final int queryRid = _store.addBytes(Uint8List.fromList(utf8.encode(query)));
    final int filtersRid = _store.addBytes(encodeFilters(filters));
    try {
      final int ptr = _callInt('get_search_manga_list', <Object?>[queryRid, page, filtersRid]);
      if (ptr <= 0) return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
      final Uint8List data = _readResult(ptr);
      return decodeMangaPageResult(PostcardReader(data));
    } on Object {
      return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    } finally {
      _store.remove(queryRid);
      _store.remove(filtersRid);
    }
  }

  /// Fetch updated manga details. Returns null on error or no data.
  Future<Manga?> getMangaDetails(String key) async {
    // v2 ABI: get_manga_update(manga_descriptor_rid, needs_details, needs_chapters)
    final int mangaRid = _store.addBytes(encodeMangaKey(key));
    try {
      final int ptr = _callInt('get_manga_update', <Object?>[mangaRid, 1, 0]);
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
    final int mangaRid = _store.addBytes(encodeManga(manga));
    final int chapterRid = _store.addBytes(encodeChapter(chapter));
    try {
      final int ptr = _callInt('get_page_list', <Object?>[mangaRid, chapterRid]);
      if (ptr <= 0) return <Page>[];
      return decodePageList(PostcardReader(_readResult(ptr)));
    } on Object {
      return <Page>[];
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
      final int listingRid = _store.addBytes(
        encodeListing(AidokuListing(id: listing.id, name: listing.name, kind: listing.kind)),
      );
      try {
        final int ptr = _callInt('get_manga_list', <Object?>[listingRid, page]);
        if (ptr > 0) data = _readResult(ptr);
      } on Object {
        // get_manga_list failed; fall through to search fallback.
      } finally {
        _store.remove(listingRid);
      }
    }

    if (data == null) {
      // No listing provided or get_manga_list failed — fall back to empty-query search.
      final int queryRid = _store.addBytes(Uint8List(0));
      final int filtersRid = _store.addBytes(Uint8List.fromList(<int>[0]));
      try {
        final int ptr = _callInt('get_search_manga_list', <Object?>[queryRid, page, filtersRid]);
        if (ptr > 0) data = _readResult(ptr);
      } on Object {
        // fall through
      } finally {
        _store.remove(queryRid);
        _store.remove(filtersRid);
      }
    }

    if (data == null) return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    try {
      return decodeMangaPageResult(PostcardReader(data));
    } on Object {
      return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    }
  }

  /// Raw postcard bytes from `get_filters`, or null if not supported.
  Future<Uint8List?> getFilters() => _rawGet('get_filters');

  /// Raw postcard bytes from `get_settings`, or null if not supported.
  Future<Uint8List?> getSettings() => _rawGet('get_settings');

  /// Decoded home layout from `get_home`, or null if not supported.
  Future<HomeLayout?> getHome() async {
    final Uint8List? bytes = await _rawGet('get_home');
    return bytes == null ? null : decodeHomeLayoutResult(bytes);
  }

  /// Available source listings from `get_listings`.
  Future<List<AidokuListing>> getListings() async {
    final Uint8List? bytes = await _rawGet('get_listings');
    if (bytes == null) return const <AidokuListing>[];
    try {
      return decodeListings(PostcardReader(bytes));
    } on Object {
      return const <AidokuListing>[];
    }
  }

  /// Alternate cover URLs for a manga from `get_alternate_covers`.
  Future<List<String>> getAlternateCovers(Manga manga) async {
    final int mangaRid = _store.addBytes(encodeManga(manga));
    try {
      final int ptr = _callInt('get_alternate_covers', <Object?>[mangaRid]);
      if (ptr <= 0) return const <String>[];
      return decodeStringVecResult(_readResult(ptr));
    } on Object {
      return const <String>[];
    } finally {
      _store.remove(mangaRid);
    }
  }

  /// Custom image request for a URL from `get_image_request`.
  Future<ImageRequest?> getImageRequest(String url, {Map<String, String>? context}) async {
    final int urlRid = _store.addBytes(encodeStringBytes(url));
    final int contextRid = _store.addBytes(encodeOptionalStringMap(context));
    try {
      final int ptr = _callInt('get_image_request', <Object?>[urlRid, contextRid]);
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
    final Uint8List? bytes = await _rawGet('get_base_url');
    return bytes == null ? null : decodeStringResult(bytes);
  }

  /// Page description string from `get_page_description`.
  Future<String?> getPageDescription(Page page) async {
    final int pageRid = _store.addBytes(encodePage(page));
    try {
      final int ptr = _callInt('get_page_description', <Object?>[pageRid]);
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
    final int imageRid = _store.addBytes(encodeImageResponse(imageBytes));
    final int contextRid = _store.addBytes(encodeOptionalStringMap(context));
    try {
      final int ptr = _callInt('process_page_image', <Object?>[imageRid, contextRid]);
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
    final int rid = _store.addBytes(encodeStringBytes(notification));
    try {
      _runner.call('handle_notification', <Object?>[rid]);
    } on Object {
      // Not implemented or error — ignore.
    } finally {
      _store.remove(rid);
    }
  }

  /// Handle a deep link URL via `handle_deep_link`.
  Future<DeepLinkResult?> handleDeepLink(String url) async {
    final int rid = _store.addBytes(encodeStringBytes(url));
    try {
      final int ptr = _callInt('handle_deep_link', <Object?>[rid]);
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
    final int keyRid = _store.addBytes(encodeStringBytes(key));
    final int userRid = _store.addBytes(encodeStringBytes(username));
    final int passRid = _store.addBytes(encodeStringBytes(password));
    try {
      final int result = _callInt('handle_basic_login', <Object?>[keyRid, userRid, passRid]);
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
    final int keyRid = _store.addBytes(encodeStringBytes(key));
    final int cookiesRid = _store.addBytes(encodeStringMap(cookies));
    try {
      final int result = _callInt('handle_web_login', <Object?>[keyRid, cookiesRid]);
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
    final int rid = _store.addBytes(encodeStringBytes(key));
    try {
      final int ptr = _callInt('handle_key_migration', <Object?>[rid, -1]);
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
    final int mangaRid = _store.addBytes(encodeStringBytes(mangaKey));
    final int chapterRid = _store.addBytes(encodeStringBytes(chapterKey));
    try {
      final int ptr = _callInt('handle_key_migration', <Object?>[mangaRid, chapterRid]);
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
    final Uint8List lenBytes = _runner.readMemory(ptr, 4);
    final int totalLen = ByteData.sublistView(lenBytes).getInt32(0, Endian.little);
    if (totalLen < 0) {
      try {
        _runner.call('free_result', <Object?>[ptr]);
      } on Exception catch (e) {
        // ignore: avoid_print
        print('[aidoku] free_result failed after error result: $e');
      }
      throw const FormatException('AidokuError from WASM result buffer');
    }
    final int payloadLen = totalLen - 8;
    final Uint8List data = _runner.readMemory(ptr + 8, payloadLen);
    try {
      _runner.call('free_result', <Object?>[ptr]);
    } on Exception catch (e) {
      // ignore: avoid_print
      print('[aidoku] free_result failed: $e');
    }
    return data;
  }

  Future<Uint8List?> _rawGet(String funcName) async {
    final int ptr = _callInt(funcName, <Object?>[]);
    if (ptr <= 0) return null;
    return _readResult(ptr);
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

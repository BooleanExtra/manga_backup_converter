import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:aidoku_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/codec/postcard_reader.dart';
import 'package:aidoku_plugin_loader/src/models/chapter.dart';
import 'package:aidoku_plugin_loader/src/models/filter.dart';
import 'package:aidoku_plugin_loader/src/models/filter_info.dart';
import 'package:aidoku_plugin_loader/src/models/language_info.dart';
import 'package:aidoku_plugin_loader/src/models/manga.dart';
import 'package:aidoku_plugin_loader/src/models/page.dart';
import 'package:aidoku_plugin_loader/src/models/setting_item.dart';
import 'package:aidoku_plugin_loader/src/models/source_info.dart';
import 'package:aidoku_plugin_loader/src/native/wasm_isolate.dart';
import 'package:aidoku_plugin_loader/src/native/wasm_semaphore_io.dart';
import 'package:aidoku_plugin_loader/src/native/wasm_shared_state_io.dart';
import 'package:http/http.dart' as http;

/// A loaded Aidoku WASM source plugin (native implementation).
///
/// WASM executes in a long-running background [Isolate]. When a host import
/// requires async work (HTTP, sleep), the WASM isolate thread blocks via a
/// POSIX/Win32 semaphore while the main isolate performs the async operation.
class AidokuPlugin {
  AidokuPlugin._({
    required SendPort wasmCmdPort,
    required ReceivePort asyncPort,
    required WasmSemaphore semaphore,
    required WasmSharedState sharedState,
    required this.sourceInfo,
    required this.settings,
    required this.filterDefinitions,
  }) : _wasmCmdPort = wasmCmdPort,
       _asyncPort = asyncPort,
       _semaphore = semaphore,
       _sharedState = sharedState;

  final SendPort _wasmCmdPort;
  final ReceivePort _asyncPort;
  final WasmSemaphore _semaphore;
  final WasmSharedState _sharedState;

  final StreamController<HomePartialResult> _partialResultsController = StreamController<HomePartialResult>.broadcast();

  final List<String> _recentWarnings = [];

  RateLimiter? _rateLimiter;

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

  /// Returns and clears any host-level warnings accumulated during recent
  /// WASM calls (e.g. unsupported CSS selectors, HTML parse failures).
  List<String> drainWarnings() {
    final result = List<String>.of(_recentWarnings);
    _recentWarnings.clear();
    return result;
  }

  // Shared HTTP client reused for the plugin's lifetime.
  static final http.Client _httpClient = http.Client();

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

    final WasmSemaphore semaphore = WasmSemaphore.create();
    final sharedState = WasmSharedState();

    // asyncPort: receives WasmHttpMsg / WasmSleepMsg from the WASM isolate.
    final asyncPort = ReceivePort();
    // handshakePort: receives the WASM isolate's command port on startup.
    final handshakePort = ReceivePort();

    await Isolate.spawn(
      wasmIsolateMain,
      WasmIsolateInit(
        handshakePort: handshakePort.sendPort,
        asyncPort: asyncPort.sendPort,
        wasmBytes: bundle.wasmBytes,
        semaphoreAddress: semaphore.address,
        resultSlotAddress: sharedState.resultSlotAddress,
        statusSlotAddress: sharedState.statusSlotAddress,
        bufferPtrSlotAddress: sharedState.bufferPtrSlotAddress,
        bufferLenSlotAddress: sharedState.bufferLenSlotAddress,
        sourceId: sourceId,
        initialDefaults: initialDefaults,
      ),
    );

    final wasmCmdPort = await handshakePort.first as SendPort;
    handshakePort.close();

    final plugin = AidokuPlugin._(
      wasmCmdPort: wasmCmdPort,
      asyncPort: asyncPort,
      semaphore: semaphore,
      sharedState: sharedState,
      sourceInfo: bundle.sourceInfo,
      settings: settings,
      filterDefinitions: filterDefinitions,
    );

    asyncPort.listen((Object? msg) async {
      try {
        if (msg is WasmHttpMsg) {
          await plugin._handleHttpMsg(msg);
        } else if (msg is WasmSleepMsg) {
          try {
            await Future<void>.delayed(Duration(seconds: msg.seconds));
          } finally {
            WasmSemaphore.fromAddress(msg.semaphoreAddress).signal();
          }
        } else if (msg is WasmLogMsg) {
          // ignore: avoid_print
          print('[wasm] ${msg.message}\n${msg.stackTrace}');
        } else if (msg is WasmRateLimitMsg) {
          plugin._rateLimiter = RateLimiter(
            RateLimitConfig(permits: msg.permits, periodMs: msg.periodMs),
          );
        } else if (msg is WasmPartialResultMsg) {
          final HomePartialResult? decoded = decodeHomePartialResultFromBytes(msg.data);
          if (decoded != null) plugin._partialResultsController.add(decoded);
        }
      } on Object catch (e, st) {
        // ignore: avoid_print
        print('[wasm/async] unhandled error: $e\n$st');
      }
    });

    return plugin;
  }

  Future<void> _handleHttpMsg(WasmHttpMsg msg) async {
    // Enforce rate limiting if configured by the plugin.
    final RateLimiter? limiter = _rateLimiter;
    if (limiter != null) {
      final Duration wait = limiter.waitDuration();
      if (wait > Duration.zero) {
        await Future<void>.delayed(wait);
      }
      limiter.recordRequest();
    }

    try {
      final Uri uri = Uri.parse(msg.url);
      if (!uri.hasScheme || !uri.hasAuthority) {
        // ignore: avoid_print
        print('[wasm/net] error: relative URL from plugin: ${msg.url}');
        _sharedState.writeError();
        return;
      }
      final String methodStr = msg.method < _httpMethodNames.length ? _httpMethodNames[msg.method] : 'GET';
      // ignore: avoid_print
      print('[wasm/net] $methodStr ${msg.url}');
      final request = http.Request(methodStr, uri);
      request.headers.addAll(msg.headers);
      if (msg.body != null) {
        request.bodyBytes = Uint8List.fromList(msg.body!);
      }
      final int timeoutSeconds = msg.timeout.isFinite ? msg.timeout.toInt() : 30;
      final http.StreamedResponse response = await _httpClient.send(request).timeout(Duration(seconds: timeoutSeconds));
      final Uint8List body = await response.stream.toBytes();
      // ignore: avoid_print
      print('[wasm/net] ${response.statusCode} ${body.length}b');
      _sharedState.writeResponse(statusCode: response.statusCode, body: body);
    } on Object catch (e) {
      // ignore: avoid_print
      print('[wasm/net] error: $e');
      _sharedState.writeError();
    } finally {
      WasmSemaphore.fromAddress(msg.semaphoreAddress).signal();
    }
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Search for manga on this source. [page] is 1-based.
  ///
  /// Throws [Exception] if the WASM plugin encounters a fatal error (e.g. trap).
  Future<MangaPageResult> searchManga(
    String query,
    int page, {
    List<FilterValue> filters = const <FilterValue>[],
  }) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmSearchCmd(
        queryBytes: Uint8List.fromList(utf8.encode(query)),
        page: page,
        filtersBytes: encodeFilters(filters),
        replyPort: port.sendPort,
      ),
    );
    final (Uint8List? data, String? error, List<String> warnings) =
        await port.first as (Uint8List?, String?, List<String>);
    port.close();
    _recentWarnings.addAll(warnings);
    if (error != null) throw Exception(error);
    if (data == null) return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    try {
      return decodeMangaPageResult(PostcardReader(data));
    } on Object {
      return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    }
  }

  /// Fetch updated manga details. Returns null on error or no data.
  Future<Manga?> getMangaDetails(String key, {bool includeChapters = false}) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmMangaDetailsCmd(
        keyBytes: Uint8List.fromList(utf8.encode(key)),
        replyPort: port.sendPort,
        includeChapters: includeChapters,
      ),
    );
    final (Uint8List? data, String? error, List<String> warnings) =
        await port.first as (Uint8List?, String?, List<String>);
    port.close();
    _recentWarnings.addAll(warnings);
    if (error != null) throw Exception(error);
    if (data == null) return null;
    try {
      return decodeManga(PostcardReader(data));
    } on Object {
      return null;
    }
  }

  /// Fetch page image URLs for a chapter.
  Future<List<Page>> getPageList(Manga manga, Chapter chapter) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmPageListCmd(
        mangaBytes: encodeManga(manga),
        chapterBytes: encodeChapter(chapter),
        replyPort: port.sendPort,
      ),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return <Page>[];
    try {
      return decodePageList(PostcardReader(data));
    } on Object {
      return <Page>[];
    }
  }

  /// Browse manga listing (page is 1-based, listing selects the source's listing).
  Future<MangaPageResult> getMangaList(int page, {SourceListing? listing}) async {
    final Uint8List? listingBytes = listing != null
        ? encodeListing(AidokuListing(id: listing.id, name: listing.name, kind: listing.kind))
        : null;
    final port = ReceivePort();
    _wasmCmdPort.send(WasmMangaListCmd(listingBytes: listingBytes, page: page, replyPort: port.sendPort));
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    try {
      return decodeMangaPageResult(PostcardReader(data));
    } on Object {
      return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    }
  }

  /// Decoded filter definitions from the WASM `get_filters` export.
  Future<List<AidokuFilter>?> getFilters() async {
    final Uint8List? bytes = await _rawGet('get_filters');
    if (bytes == null) return null;
    return decodeFilterListResult(bytes);
  }

  /// Decoded settings from the WASM `get_settings` export.
  Future<List<AidokuSetting>?> getSettings() async {
    final Uint8List? bytes = await _rawGet('get_settings');
    if (bytes == null) return null;
    return decodeSettingListResult(bytes);
  }

  /// Decoded home layout from `get_home`, or null if not supported.
  Future<HomeLayout?> getHome() async {
    final Uint8List? bytes = await _rawGet('get_home');
    if (bytes == null) return null;
    return decodeHomeLayoutResult(bytes);
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
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmAlternateCoversCmd(mangaBytes: encodeManga(manga), replyPort: port.sendPort),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return const <String>[];
    return decodeStringVecResult(data);
  }

  /// Custom image request for a URL from `get_image_request`.
  Future<ImageRequest?> getImageRequest(String url, {Map<String, String>? context}) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmImageRequestCmd(
        urlBytes: encodeStringBytes(url),
        contextBytes: encodeOptionalStringMap(context),
        replyPort: port.sendPort,
      ),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return null;
    return decodeImageRequestResult(data);
  }

  /// Source base URL from `get_base_url`.
  Future<String?> getBaseUrl() async {
    final Uint8List? bytes = await _rawGet('get_base_url');
    if (bytes == null) return null;
    return decodeStringResult(bytes);
  }

  /// Page description string from `get_page_description`.
  Future<String?> getPageDescription(Page page) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmPageDescriptionCmd(pageBytes: encodePage(page), replyPort: port.sendPort),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return null;
    return decodeStringResult(data);
  }

  /// Process a page image (e.g. descramble) via `process_page_image`.
  ///
  /// Returns standard image bytes (PNG/JPEG/WebP) usable with `Image.memory()`
  /// or `package:image`.
  Future<Uint8List?> processPageImage(Uint8List imageBytes, {Map<String, String>? context}) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmProcessPageImageCmd(
        imageBytes: encodeImageResponse(imageBytes),
        contextBytes: encodeOptionalStringMap(context),
        replyPort: port.sendPort,
      ),
    );
    final data = await port.first as Uint8List?;
    port.close();
    return data;
  }

  /// Deliver a notification string to the plugin via `handle_notification`.
  Future<void> handleNotification(String notification) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmNotificationCmd(notifBytes: encodeStringBytes(notification), replyPort: port.sendPort),
    );
    await port.first;
    port.close();
  }

  /// Handle a deep link URL via `handle_deep_link`.
  Future<DeepLinkResult?> handleDeepLink(String url) async {
    final port = ReceivePort();
    _wasmCmdPort.send(WasmDeepLinkCmd(urlBytes: encodeStringBytes(url), replyPort: port.sendPort));
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return null;
    return decodeDeepLinkResultFromBytes(data);
  }

  /// Perform basic (username/password) login via `handle_basic_login`.
  Future<bool> handleBasicLogin(String key, String username, String password) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmBasicLoginCmd(
        keyBytes: encodeStringBytes(key),
        usernameBytes: encodeStringBytes(username),
        passwordBytes: encodeStringBytes(password),
        replyPort: port.sendPort,
      ),
    );
    final Object? result = await port.first;
    port.close();
    return result is bool && result;
  }

  /// Perform web (cookie) login via `handle_web_login`.
  Future<bool> handleWebLogin(String key, Map<String, String> cookies) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmWebLoginCmd(
        keyBytes: encodeStringBytes(key),
        cookiesBytes: encodeStringMap(cookies),
        replyPort: port.sendPort,
      ),
    );
    final Object? result = await port.first;
    port.close();
    return result is bool && result;
  }

  /// Migrate a manga key via `handle_key_migration`.
  Future<String?> handleMangaMigration(String key) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmMangaMigrationCmd(keyBytes: encodeStringBytes(key), replyPort: port.sendPort),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return null;
    return decodeStringResult(data);
  }

  /// Migrate a chapter key via `handle_key_migration`.
  Future<String?> handleChapterMigration(String mangaKey, String chapterKey) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmChapterMigrationCmd(
        mangaKeyBytes: encodeStringBytes(mangaKey),
        chapterKeyBytes: encodeStringBytes(chapterKey),
        replyPort: port.sendPort,
      ),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return null;
    return decodeStringResult(data);
  }

  /// Partial results stream — pushed by `env::_send_partial_result` during
  /// `get_home` and other streaming exports.
  Stream<HomePartialResult> get partialResults => _partialResultsController.stream;

  /// Shut down the WASM background isolate and free native resources.
  void dispose() {
    _wasmCmdPort.send(const WasmShutdownCmd());
    _asyncPort.close();
    _semaphore.dispose();
    _sharedState.dispose();
    _partialResultsController.close();
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Future<Uint8List?> _rawGet(String funcName) async {
    final port = ReceivePort();
    _wasmCmdPort.send(WasmRawGetCmd(funcName: funcName, replyPort: port.sendPort));
    final data = await port.first as Uint8List?;
    port.close();
    return data;
  }
}

const List<String> _httpMethodNames = <String>['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'];

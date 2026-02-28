// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:aidoku_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:aidoku_plugin_loader/src/codec/postcard_reader.dart';
import 'package:aidoku_plugin_loader/src/codec/postcard_writer.dart';
import 'package:aidoku_plugin_loader/src/models/chapter.dart';
import 'package:aidoku_plugin_loader/src/models/filter.dart';
import 'package:aidoku_plugin_loader/src/models/filter_info.dart';
import 'package:aidoku_plugin_loader/src/models/language_info.dart';
import 'package:aidoku_plugin_loader/src/models/manga.dart';
import 'package:aidoku_plugin_loader/src/models/page.dart';
import 'package:aidoku_plugin_loader/src/models/setting_item.dart';
import 'package:aidoku_plugin_loader/src/models/source_info.dart';
import 'package:aidoku_plugin_loader/src/web/wasm_worker_isolate.dart';

/// A loaded Aidoku WASM source plugin (web implementation).
///
/// WASM executes in a Dart isolate (web worker) where synchronous XMLHttpRequest
/// is allowed, enabling HTTP host imports (`net::send`) to work. Communication
/// between the main thread and the worker uses [SendPort]/[ReceivePort].
class AidokuPlugin {
  AidokuPlugin._({
    required SendPort cmdPort,
    required ReceivePort mainPort,
    required this.sourceInfo,
    required this.settings,
    required this.filterDefinitions,
  }) : _cmdPort = cmdPort,
       _mainPort = mainPort;

  final SendPort _cmdPort;
  final ReceivePort _mainPort;
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

  /// Accumulated warnings from host import errors during WASM calls.
  final List<String> _warnings = <String>[];

  /// Returns and clears any host-level warnings accumulated during recent
  /// WASM calls.
  List<String> drainWarnings() {
    final result = List<String>.of(_warnings);
    _warnings.clear();
    return result;
  }

  /// Pending call completers, keyed by call ID.
  final Map<int, Completer<_WorkerResult>> _pending = <int, Completer<_WorkerResult>>{};
  int _nextCallId = 1;

  final StreamController<HomePartialResult> _partialResultsController = StreamController<HomePartialResult>.broadcast();

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
          initialDefaults[key] = (PostcardWriter()..writeBool(value)).bytes;
        } else if (value is int) {
          initialDefaults[key] = (PostcardWriter()..writeSignedVarInt(value)).bytes;
        } else if (value is Uint8List) {
          initialDefaults[key] = value;
        } else if (value is String) {
          initialDefaults[key] = (PostcardWriter()..writeString(value)).bytes;
        } else {
          // double, List, Map → JSON-encoded as postcard string
          initialDefaults[key] = (PostcardWriter()..writeString(jsonEncode(value))).bytes;
        }
      }
    }

    // Create the main port for receiving messages from the worker isolate.
    final mainPort = ReceivePort();

    // Spawn the worker isolate with all initialization data.
    await Isolate.spawn(
      wasmWorkerMain,
      <String, Object?>{
        'mainPort': mainPort.sendPort,
        'wasmBytes': bundle.wasmBytes,
        'sourceId': sourceId,
        'defaults': initialDefaults,
      },
    );

    // Wait for the 'ready' message containing the command port.
    final readyCompleter = Completer<SendPort>();

    // Temporary plugin reference for the listener closure.
    late final AidokuPlugin plugin;

    mainPort.listen((Object? rawMsg) {
      final msg = rawMsg! as Map<String, Object?>;
      final type = msg['type']! as String;

      if (type == 'ready') {
        readyCompleter.complete(msg['cmdPort']! as SendPort);
        return;
      }

      if (type == 'error' && !readyCompleter.isCompleted) {
        readyCompleter.completeError(Exception(msg['message'] as String?));
        return;
      }

      if (type == 'result') {
        final id = msg['id']! as int;
        final Completer<_WorkerResult>? completer = plugin._pending.remove(id);
        if (completer == null) return;

        final data = msg['data'] as Uint8List?;
        final int returnValue = (msg['returnValue'] as int?) ?? 0;
        final List<String> warnings = (msg['warnings'] as List<Object?>?)?.cast<String>() ?? const <String>[];
        plugin._warnings.addAll(warnings);

        completer.complete(_WorkerResult(data: data, returnValue: returnValue));
      } else if (type == 'partial_result') {
        final bytes = msg['data'] as Uint8List?;
        if (bytes != null) {
          final HomePartialResult? decoded = decodeHomePartialResultFromBytes(bytes);
          if (decoded != null) plugin._partialResultsController.add(decoded);
        }
      } else if (type == 'log') {
        print(msg['message'] as String? ?? '');
      }
    });

    final SendPort cmdPort = await readyCompleter.future;

    // The listener closure captured `plugin` by reference via `late final`,
    // so messages arriving after this point are handled correctly.
    return plugin = AidokuPlugin._(
      cmdPort: cmdPort,
      mainPort: mainPort,
      sourceInfo: bundle.sourceInfo,
      settings: settings,
      filterDefinitions: filterDefinitions,
    );
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
    final _WorkerResult result = await _call(
      'get_search_manga_list',
      rids: <Uint8List>[
        Uint8List.fromList(utf8.encode(query)),
        encodeFilters(filters),
      ],
      args: <Object?>[null, page, null],
    );
    if (result.data == null) return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    try {
      return decodeMangaPageResult(PostcardReader(result.data!));
    } on Object {
      return const MangaPageResult(manga: <Manga>[], hasNextPage: false);
    }
  }

  /// Fetch updated manga details. Returns null on error or no data.
  Future<Manga?> getMangaDetails(String key, {bool includeChapters = false}) async {
    final _WorkerResult result = await _call(
      'get_manga_update',
      rids: <Uint8List>[encodeMangaKey(key)],
      args: <Object?>[null, 1, if (includeChapters) 1 else 0],
    );
    if (result.data == null) return null;
    try {
      return decodeManga(PostcardReader(result.data!));
    } on Object {
      return null;
    }
  }

  /// Fetch page image URLs for a chapter.
  Future<List<Page>> getPageList(Manga manga, Chapter chapter) async {
    final _WorkerResult result = await _call(
      'get_page_list',
      rids: <Uint8List>[encodeManga(manga), encodeChapter(chapter)],
      args: <Object?>[null, null],
    );
    if (result.data == null) return <Page>[];
    try {
      return decodePageList(PostcardReader(result.data!));
    } on Object {
      return <Page>[];
    }
  }

  /// Browse manga listing (page is 1-based, listing selects the source's listing).
  Future<MangaPageResult> getMangaList(int page, {SourceListing? listing}) async {
    Uint8List? data;

    if (listing != null) {
      final _WorkerResult result = await _call(
        'get_manga_list',
        rids: <Uint8List>[
          encodeListing(AidokuListing(id: listing.id, name: listing.name, kind: listing.kind)),
        ],
        args: <Object?>[null, page],
      );
      data = result.data;
    }

    if (data == null) {
      // No listing provided or get_manga_list failed — fall back to empty-query search.
      final _WorkerResult result = await _call(
        'get_search_manga_list',
        rids: <Uint8List>[
          Uint8List(0),
          Uint8List.fromList(<int>[0]),
        ],
        args: <Object?>[null, page, null],
      );
      data = result.data;
    }

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
    final _WorkerResult result = await _call(
      'get_alternate_covers',
      rids: <Uint8List>[encodeManga(manga)],
      args: <Object?>[null],
    );
    if (result.data == null) return const <String>[];
    return decodeStringVecResult(result.data!);
  }

  /// Custom image request for a URL from `get_image_request`.
  Future<ImageRequest?> getImageRequest(String url, {Map<String, String>? context}) async {
    final _WorkerResult result = await _call(
      'get_image_request',
      rids: <Uint8List>[encodeStringBytes(url), encodeOptionalStringMap(context)],
      args: <Object?>[null, null],
    );
    if (result.data == null) return null;
    return decodeImageRequestResult(result.data!);
  }

  /// Source base URL from `get_base_url`.
  Future<String?> getBaseUrl() async {
    final Uint8List? bytes = await _rawGet('get_base_url');
    return bytes == null ? null : decodeStringResult(bytes);
  }

  /// Page description string from `get_page_description`.
  Future<String?> getPageDescription(Page page) async {
    final _WorkerResult result = await _call(
      'get_page_description',
      rids: <Uint8List>[encodePage(page)],
      args: <Object?>[null],
    );
    if (result.data == null) return null;
    return decodeStringResult(result.data!);
  }

  /// Process a page image (e.g. descramble) via `process_page_image`.
  Future<Uint8List?> processPageImage(Uint8List imageBytes, {Map<String, String>? context}) async {
    final _WorkerResult result = await _call(
      'process_page_image',
      rids: <Uint8List>[encodeImageResponse(imageBytes), encodeOptionalStringMap(context)],
      args: <Object?>[null, null],
    );
    return result.data;
  }

  /// Deliver a notification string to the plugin via `handle_notification`.
  Future<void> handleNotification(String notification) async {
    await _call(
      'handle_notification',
      rids: <Uint8List>[encodeStringBytes(notification)],
      args: <Object?>[null],
      returnType: 'void',
    );
  }

  /// Handle a deep link URL via `handle_deep_link`.
  Future<DeepLinkResult?> handleDeepLink(String url) async {
    final _WorkerResult result = await _call(
      'handle_deep_link',
      rids: <Uint8List>[encodeStringBytes(url)],
      args: <Object?>[null],
    );
    if (result.data == null) return null;
    return decodeDeepLinkResultFromBytes(result.data!);
  }

  /// Perform basic (username/password) login via `handle_basic_login`.
  Future<bool> handleBasicLogin(String key, String username, String password) async {
    final _WorkerResult result = await _call(
      'handle_basic_login',
      rids: <Uint8List>[encodeStringBytes(key), encodeStringBytes(username), encodeStringBytes(password)],
      args: <Object?>[null, null, null],
      returnType: 'bool',
    );
    return result.returnValue >= 0;
  }

  /// Perform web (cookie) login via `handle_web_login`.
  Future<bool> handleWebLogin(String key, Map<String, String> cookies) async {
    final _WorkerResult result = await _call(
      'handle_web_login',
      rids: <Uint8List>[encodeStringBytes(key), encodeStringMap(cookies)],
      args: <Object?>[null, null],
      returnType: 'bool',
    );
    return result.returnValue >= 0;
  }

  /// Migrate a manga key via `handle_key_migration`.
  Future<String?> handleMangaMigration(String key) async {
    final _WorkerResult result = await _call(
      'handle_key_migration',
      rids: <Uint8List>[encodeStringBytes(key)],
      args: <Object?>[null, -1],
    );
    if (result.data == null) return null;
    return decodeStringResult(result.data!);
  }

  /// Migrate a chapter key via `handle_key_migration`.
  Future<String?> handleChapterMigration(String mangaKey, String chapterKey) async {
    final _WorkerResult result = await _call(
      'handle_key_migration',
      rids: <Uint8List>[encodeStringBytes(mangaKey), encodeStringBytes(chapterKey)],
      args: <Object?>[null, null],
    );
    if (result.data == null) return null;
    return decodeStringResult(result.data!);
  }

  /// Partial results stream — pushed by `env::_send_partial_result` during
  /// `get_home` and other streaming exports.
  Stream<HomePartialResult> get partialResults => _partialResultsController.stream;

  /// Shut down the worker isolate.
  void dispose() {
    _cmdPort.send(<String, Object?>{'type': 'shutdown'});
    _mainPort.close();
    _partialResultsController.close();
    // Complete any pending calls with null.
    for (final Completer<_WorkerResult> completer in _pending.values) {
      if (!completer.isCompleted) completer.complete(const _WorkerResult());
    }
    _pending.clear();
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Send a call to the worker isolate and await the result.
  Future<_WorkerResult> _call(
    String exportName, {
    List<Uint8List> rids = const <Uint8List>[],
    List<Object?> args = const <Object?>[],
    String? returnType,
  }) async {
    final int id = _nextCallId++;
    final completer = Completer<_WorkerResult>();
    _pending[id] = completer;

    _cmdPort.send(<String, Object?>{
      'type': 'call',
      'id': id,
      'export': exportName,
      'rids': rids,
      'args': args,
      if (returnType != null) 'returnType': returnType,
    });

    return completer.future;
  }

  Future<Uint8List?> _rawGet(String funcName) async {
    final _WorkerResult result = await _call(funcName);
    return result.data;
  }
}

/// Result from a worker call.
class _WorkerResult {
  const _WorkerResult({this.data, this.returnValue = 0});
  final Uint8List? data;
  final int returnValue;
}

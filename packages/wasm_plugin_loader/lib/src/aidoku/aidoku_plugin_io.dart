import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
import 'package:wasm_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/models/filter.dart';
import 'package:wasm_plugin_loader/src/models/manga.dart';
import 'package:wasm_plugin_loader/src/models/page.dart';
import 'package:wasm_plugin_loader/src/models/source_info.dart';
import 'package:wasm_plugin_loader/src/native/wasm_isolate.dart';
import 'package:wasm_plugin_loader/src/native/wasm_semaphore_io.dart';
import 'package:wasm_plugin_loader/src/native/wasm_shared_state_io.dart';

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
  }) : _wasmCmdPort = wasmCmdPort,
       _asyncPort = asyncPort,
       _semaphore = semaphore,
       _sharedState = sharedState;

  final SendPort _wasmCmdPort;
  final ReceivePort _asyncPort;
  final WasmSemaphore _semaphore;
  final WasmSharedState _sharedState;

  final SourceInfo sourceInfo;

  // Shared HTTP client reused for the plugin's lifetime.
  static final _httpClient = http.Client();

  // ---------------------------------------------------------------------------
  // Factory
  // ---------------------------------------------------------------------------

  /// Load a plugin from raw .aix file bytes.
  static Future<AidokuPlugin> fromAix(Uint8List aixBytes) async {
    final bundle = AixParser.parse(aixBytes);

    final semaphore = WasmSemaphore.create();
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
    );

    asyncPort.listen((msg) async {
      if (msg is WasmHttpMsg) {
        await plugin._handleHttpMsg(msg);
      } else if (msg is WasmSleepMsg) {
        await Future<void>.delayed(Duration(seconds: msg.seconds));
        WasmSemaphore.fromAddress(msg.semaphoreAddress).signal();
      } else if (msg is WasmLogMsg) {
        // ignore: avoid_print
        print('[wasm] ${msg.message}\n${msg.stackTrace}');
      }
    });

    return plugin;
  }

  Future<void> _handleHttpMsg(WasmHttpMsg msg) async {
    try {
      final uri = Uri.parse(msg.url);
      final methodStr = msg.method < _httpMethodNames.length ? _httpMethodNames[msg.method] : 'GET';
      final request = http.Request(methodStr, uri);
      request.headers.addAll(msg.headers);
      if (msg.body != null) {
        request.bodyBytes = Uint8List.fromList(msg.body!);
      }
      final response = await _httpClient.send(request).timeout(Duration(seconds: msg.timeout.toInt()));
      final body = await response.stream.toBytes();
      _sharedState.writeResponse(statusCode: response.statusCode, body: body);
    } catch (_) {
      _sharedState.writeError();
    }
    WasmSemaphore.fromAddress(msg.semaphoreAddress).signal();
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
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmSearchCmd(
        queryBytes: Uint8List.fromList(utf8.encode(query)),
        page: page,
        filtersBytes: encodeFilters(filters),
        replyPort: port.sendPort,
      ),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return const MangaPageResult(manga: [], hasNextPage: false);
    try {
      return decodeMangaPageResult(PostcardReader(data));
    } on Object {
      return const MangaPageResult(manga: [], hasNextPage: false);
    }
  }

  /// Fetch updated manga details. Returns null on error or no data.
  Future<Manga?> getMangaDetails(String key) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmMangaDetailsCmd(
        keyBytes: Uint8List.fromList(utf8.encode(key)),
        replyPort: port.sendPort,
      ),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return null;
    try {
      return decodeManga(PostcardReader(data));
    } on Object {
      return null;
    }
  }

  /// Fetch page image URLs for a chapter.
  Future<List<Page>> getPageList(String key) async {
    final port = ReceivePort();
    _wasmCmdPort.send(
      WasmPageListCmd(
        keyBytes: Uint8List.fromList(utf8.encode(key)),
        replyPort: port.sendPort,
      ),
    );
    final data = await port.first as Uint8List?;
    port.close();
    if (data == null) return [];
    try {
      return decodePageList(PostcardReader(data));
    } on Object {
      return [];
    }
  }

  /// Browse manga listing (page is 1-based).
  Future<MangaPageResult> getMangaList(int page) async {
    final port = ReceivePort();
    _wasmCmdPort.send(WasmMangaListCmd(page: page, replyPort: port.sendPort));
    final data = await port.first as Uint8List?;
    port.close();
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

  /// Partial results stream — pushed by `env::_send_partial_result`.
  // Not plumbed through isolate boundary in this implementation;
  // partial results during WASM execution are streamed inside the isolate.
  // Expose a no-op stream here for API compatibility.
  Stream<Uint8List> get partialResults => const Stream.empty();

  /// Shut down the WASM background isolate and free native resources.
  void dispose() {
    _wasmCmdPort.send(const WasmShutdownCmd());
    _asyncPort.close();
    _semaphore.dispose();
    _sharedState.dispose();
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

const _httpMethodNames = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'];

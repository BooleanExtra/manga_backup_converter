@TestOn('vm')
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/imports/js_imports.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm3/wasm3.dart';

/// Minimal WASM module with 1 page of memory exported as "memory", plus:
/// - `store8(offset: i32, value: i32)` — stores a byte
/// - `load8(offset: i32) -> i32` — loads a byte (unsigned)
final Uint8List _memoryModule = Uint8List.fromList([
  // Header
  0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00,
  // Type section: 2 types
  0x01, 0x0b, 0x02,
  // type 0: (i32, i32) -> ()
  0x60, 0x02, 0x7f, 0x7f, 0x00,
  // type 1: (i32) -> (i32)
  0x60, 0x01, 0x7f, 0x01, 0x7f,
  // Function section: func 0 -> type 0, func 1 -> type 1
  0x03, 0x03, 0x02, 0x00, 0x01,
  // Memory section: 1 memory, min=1 page, no max
  0x05, 0x03, 0x01, 0x00, 0x01,
  // Export section: "memory" (mem 0), "store8" (func 0), "load8" (func 1)
  0x07, 0x1b, 0x03,
  0x06, 0x6d, 0x65, 0x6d, 0x6f, 0x72, 0x79, 0x02, 0x00,
  0x06, 0x73, 0x74, 0x6f, 0x72, 0x65, 0x38, 0x00, 0x00,
  0x05, 0x6c, 0x6f, 0x61, 0x64, 0x38, 0x00, 0x01,
  // Code section: 2 function bodies
  0x0a, 0x13, 0x02,
  // store8: body size 9, 0 locals
  0x09, 0x00, 0x20, 0x00, 0x20, 0x01, 0x3a, 0x00, 0x00, 0x0b,
  // load8: body size 7, 0 locals
  0x07, 0x00, 0x20, 0x00, 0x2d, 0x00, 0x00, 0x0b,
]);

void main() {
  group('js imports', () {
    late HostStore store;
    late Wasm3Runner runner;
    late Map<String, Function> imports;

    setUp(() async {
      store = HostStore();
      runner = await Wasm3Runner.fromBytes(_memoryModule);
      final ctx = ImportContext(
        runner: runner,
        store: store,
        sourceId: 'test',
      );
      imports = buildJsImports(ctx);
    });

    tearDown(() {
      store.dispose();
      runner.dispose();
    });

    /// Write a string to WASM memory at offset 0 and return its byte length.
    int writeString(String s) {
      final List<int> bytes = utf8.encode(s);
      runner.writeMemory(0, Uint8List.fromList(bytes));
      return bytes.length;
    }

    test('context_create returns positive RID', () {
      final int rid = (imports['context_create']! as int Function())();
      check(rid).isGreaterThan(0);
    });

    test('context_eval with invalid RID returns -2', () {
      final fn = imports['context_eval']! as int Function(int, int, int);
      final int len = writeString('1+1');
      check(fn(9999, 0, len)).equals(-2);
    });

    test('context_eval returns string RID on success', () {
      final createFn = imports['context_create']! as int Function();
      final evalFn = imports['context_eval']! as int Function(int, int, int);
      final int ctxRid = createFn();
      final int len = writeString('"hello"');
      final int resultRid = evalFn(ctxRid, 0, len);
      check(resultRid).isGreaterThan(0);
      final BytesResource? res = store.get<BytesResource>(resultRid);
      check(res).isNotNull();
      check(utf8.decode(res!.bytes)).equals('hello');
    });

    test('context_eval returns -1 for undefined result', () {
      final createFn = imports['context_create']! as int Function();
      final evalFn = imports['context_eval']! as int Function(int, int, int);
      final int ctxRid = createFn();
      final int len = writeString('undefined');
      check(evalFn(ctxRid, 0, len)).equals(-1);
    });

    test('context_eval persists state', () {
      final createFn = imports['context_create']! as int Function();
      final evalFn = imports['context_eval']! as int Function(int, int, int);
      final int ctxRid = createFn();
      // Set a variable
      int len = writeString('var x = 42');
      evalFn(ctxRid, 0, len);
      // Read it back
      len = writeString('x');
      final int resultRid = evalFn(ctxRid, 0, len);
      check(resultRid).isGreaterThan(0);
      final BytesResource? res = store.get<BytesResource>(resultRid);
      check(utf8.decode(res!.bytes)).equals('42');
    });

    test('context_get returns variable value', () {
      final createFn = imports['context_create']! as int Function();
      final evalFn = imports['context_eval']! as int Function(int, int, int);
      final getFn = imports['context_get']! as int Function(int, int, int);
      final int ctxRid = createFn();
      // Set a variable
      int len = writeString('var foo = "bar"');
      evalFn(ctxRid, 0, len);
      // Get it
      len = writeString('foo');
      final int resultRid = getFn(ctxRid, 0, len);
      check(resultRid).isGreaterThan(0);
      final BytesResource? res = store.get<BytesResource>(resultRid);
      check(utf8.decode(res!.bytes)).equals('bar');
    });

    test('context_get with missing variable returns -1', () {
      final createFn = imports['context_create']! as int Function();
      final getFn = imports['context_get']! as int Function(int, int, int);
      final int ctxRid = createFn();
      final int len = writeString('nonexistent');
      check(getFn(ctxRid, 0, len)).equals(-1);
    });

    test('context_get with invalid RID returns -2', () {
      final getFn = imports['context_get']! as int Function(int, int, int);
      final int len = writeString('x');
      check(getFn(9999, 0, len)).equals(-2);
    });

    test('webview stubs return -1', () {
      check((imports['webview_create']! as int Function())()).equals(-1);
    });

    test('JsContext disposed on store.remove', () {
      final int rid = (imports['context_create']! as int Function())();
      store.remove(rid);
      check(store.get<JsContextResource>(rid)).isNull();
    });
  });
}

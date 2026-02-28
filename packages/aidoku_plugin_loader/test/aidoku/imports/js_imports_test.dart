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
  group('js evaluation', () {
    late HostStore store;
    late Wasm3Runner runner;
    late int Function(int, int, int) evalFn;
    late int Function(int, int, int) getFn;
    late int ctxRid;

    setUp(() async {
      store = HostStore();
      runner = await Wasm3Runner.fromBytes(_memoryModule);
      final ctx = ImportContext(
        runner: runner,
        store: store,
        sourceId: 'test',
      );
      final Map<String, Function> imports = buildJsImports(ctx);
      evalFn = imports['context_eval']! as int Function(int, int, int);
      getFn = imports['context_get']! as int Function(int, int, int);
      ctxRid = (imports['context_create']! as int Function())();
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

    /// Evaluate [code] and return the decoded string result, or null.
    String? evalJs(String code) {
      final int len = writeString(code);
      final int rid = evalFn(ctxRid, 0, len);
      if (rid <= 0) return null;
      final BytesResource? res = store.get<BytesResource>(rid);
      if (res == null) return null;
      return utf8.decode(res.bytes);
    }

    test('evaluates arithmetic expressions', () {
      check(evalJs('1 + 1')).equals('2');
      check(evalJs('10 * 5 + 3')).equals('53');
      check(evalJs('Math.pow(2, 10)')).equals('1024');
    });

    test('evaluates string expressions', () {
      check(evalJs('"hello"')).equals('hello');
      check(evalJs('"foo" + "bar"')).equals('foobar');
      check(evalJs('"abc".toUpperCase()')).equals('ABC');
    });

    test('returns -1 for undefined result', () {
      final int len = writeString('undefined');
      check(evalFn(ctxRid, 0, len)).equals(-1);
    });

    test('persists variables across evaluations', () {
      evalJs('var x = 42');
      check(evalJs('x')).equals('42');
      evalJs('x = x + 8');
      check(evalJs('x')).equals('50');
    });

    test('retrieves variables via context_get', () {
      evalJs('var foo = "bar"');
      final int len = writeString('foo');
      final int rid = getFn(ctxRid, 0, len);
      check(rid).isGreaterThan(0);
      final BytesResource? res = store.get<BytesResource>(rid);
      check(utf8.decode(res!.bytes)).equals('bar');
    });

    test('evaluates JSON operations', () {
      evalJs('var obj = JSON.parse(\'{"a":1,"b":2}\')');
      check(evalJs('obj.a + obj.b')).equals('3');
      check(evalJs('JSON.stringify(obj)')).equals('{"a":1,"b":2}');
    });

    test('evaluates multi-statement code', () {
      check(evalJs('var a = 5; var b = 10; a + b')).equals('15');
      evalJs('function double(n) { return n * 2; }');
      check(evalJs('double(21)')).equals('42');
    });
  });
}

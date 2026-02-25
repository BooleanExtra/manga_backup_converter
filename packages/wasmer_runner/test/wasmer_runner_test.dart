@TestOn('vm')
library;

import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasmer_runner/wasmer_runner.dart';

// ---------------------------------------------------------------------------
// Hand-crafted minimal WASM modules for testing
// ---------------------------------------------------------------------------

/// Minimal WASM module exporting `add(i32, i32) -> i32`.
///
/// WAT equivalent:
/// ```wat
/// (module
///   (func $add (export "add") (param i32 i32) (result i32)
///     local.get 0
///     local.get 1
///     i32.add))
/// ```
final Uint8List _addModule = Uint8List.fromList([
  // WASM magic + version
  0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00,
  // Type section: 1 type — (i32, i32) -> i32
  0x01, 0x07, 0x01, 0x60, 0x02, 0x7f, 0x7f, 0x01, 0x7f,
  // Function section: 1 function using type 0
  0x03, 0x02, 0x01, 0x00,
  // Export section: export "add" as function 0
  0x07, 0x07, 0x01, 0x03, 0x61, 0x64, 0x64, 0x00, 0x00,
  // Code section: 1 function body
  0x0a, 0x09, 0x01, // section, size, count
  0x07, 0x00, // body size, local count
  0x20, 0x00, // local.get 0
  0x20, 0x01, // local.get 1
  0x6a, // i32.add
  0x0b, // end
]);

/// WASM module with 1 page of memory exported as "memory", plus:
/// - `store8(offset: i32, value: i32)` — stores a byte
/// - `load8(offset: i32) -> i32` — loads a byte (unsigned)
///
/// WAT equivalent:
/// ```wat
/// (module
///   (memory (export "memory") 1)
///   (func (export "store8") (param i32 i32)
///     local.get 0  local.get 1  i32.store8)
///   (func (export "load8") (param i32) (result i32)
///     local.get 0  i32.load8_u))
/// ```
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
  // store8: body size 9, 0 locals, local.get 0, local.get 1, i32.store8, end
  0x09, 0x00, 0x20, 0x00, 0x20, 0x01, 0x3a, 0x00, 0x00, 0x0b,
  // load8: body size 7, 0 locals, local.get 0, i32.load8_u, end
  0x07, 0x00, 0x20, 0x00, 0x2d, 0x00, 0x00, 0x0b,
]);

/// WASM module that imports `env::get_value() -> i32` and exports
/// `call_import() -> i32` which calls the import and returns its result + 10.
///
/// WAT equivalent:
/// ```wat
/// (module
///   (import "env" "get_value" (func $get_value (result i32)))
///   (func (export "call_import") (result i32)
///     call $get_value
///     i32.const 10
///     i32.add))
/// ```
final Uint8List _importModule = Uint8List.fromList([
  // Header
  0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00,
  // Type section: 1 type — () -> (i32)
  0x01, 0x05, 0x01, 0x60, 0x00, 0x01, 0x7f,
  // Import section: env.get_value (func, type 0)
  0x02, 0x11, 0x01, 0x03, 0x65, 0x6e, 0x76, 0x09,
  0x67, 0x65, 0x74, 0x5f, 0x76, 0x61, 0x6c, 0x75,
  0x65, 0x00, 0x00,
  // Function section: 1 local func -> type 0
  0x03, 0x02, 0x01, 0x00,
  // Export section: "call_import" (func 1)
  0x07, 0x0f, 0x01, 0x0b, 0x63, 0x61, 0x6c, 0x6c,
  0x5f, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x00, 0x01,
  // Code section: 1 body — call 0, i32.const 10, i32.add, end
  0x0a, 0x09, 0x01, 0x07, 0x00, 0x10, 0x00, 0x41,
  0x0a, 0x6a, 0x0b,
]);

void main() {
  group('WasmerRunner', () {
    test('add(3, 4) returns 7', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_addModule);
      try {
        final Object? result = runner.call('add', [3, 4]);
        check(result).isA<int>().equals(7);
      } finally {
        runner.dispose();
      }
    });

    test('add(0, 0) returns 0', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_addModule);
      try {
        check(runner.call('add', [0, 0])).isA<int>().equals(0);
      } finally {
        runner.dispose();
      }
    });

    test('add with negative numbers', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_addModule);
      try {
        check(runner.call('add', [-1, 1])).isA<int>().equals(0);
        check(runner.call('add', [-5, -3])).isA<int>().equals(-8);
      } finally {
        runner.dispose();
      }
    });

    test('calling non-existent export throws', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_addModule);
      try {
        check(
          () => runner.call('nonexistent', []),
        ).throws<WasmRuntimeException>();
      } finally {
        runner.dispose();
      }
    });

    test('memory read/write via WASM functions', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_memoryModule);
      try {
        // Store byte 42 at offset 100
        runner.call('store8', [100, 42]);
        final Object? loaded = runner.call('load8', [100]);
        check(loaded).isA<int>().equals(42);
      } finally {
        runner.dispose();
      }
    });

    test('readMemory and writeMemory', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_memoryModule);
      try {
        check(runner.memorySize).isGreaterThan(0);

        // Write bytes via Dart API
        runner.writeMemory(0, Uint8List.fromList([10, 20, 30]));

        // Read back
        final Uint8List bytes = runner.readMemory(0, 3);
        check(bytes).deepEquals([10, 20, 30]);
      } finally {
        runner.dispose();
      }
    });

    test('readMemory out of bounds throws', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_memoryModule);
      try {
        check(
          () => runner.readMemory(runner.memorySize - 1, 10),
        ).throws<WasmRuntimeException>();
      } finally {
        runner.dispose();
      }
    });

    test('host import callback', () async {
      var callCount = 0;
      final WasmerRunner runner = await WasmerRunner.fromBytes(
        _importModule,
        imports: {
          'env': {
            'get_value': () {
              callCount++;
              return 32;
            },
          },
        },
      );
      try {
        // call_import() calls get_value() and adds 10
        final Object? result = runner.call('call_import', []);
        check(result).isA<int>().equals(42);
        check(callCount).equals(1);
      } finally {
        runner.dispose();
      }
    });

    test('unregistered import returns -1 stub', () async {
      // No imports provided — get_value will return -1
      final WasmerRunner runner = await WasmerRunner.fromBytes(_importModule);
      try {
        // -1 + 10 = 9
        final Object? result = runner.call('call_import', []);
        check(result).isA<int>().equals(9);
      } finally {
        runner.dispose();
      }
    });

    test('dispose prevents further calls', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_addModule);
      runner.dispose();
      check(
        () => runner.call('add', [1, 2]),
      ).throws<WasmRuntimeException>();
    });

    test('double dispose is safe', () async {
      final WasmerRunner runner = await WasmerRunner.fromBytes(_addModule);
      runner.dispose();
      runner.dispose(); // Should not throw
    });

    test('invalid WASM binary throws', () async {
      await check(
        WasmerRunner.fromBytes(Uint8List.fromList([0, 1, 2, 3])),
      ).throws<WasmRuntimeException>();
    });
  });
}

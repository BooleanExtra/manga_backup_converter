@TestOn('browser')
library;

import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/wasm/wasm_runner.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

/// Minimal WASM module that exports a single function `add(i32, i32) -> i32`.
///
/// WAT: `(module (func (export "add") (param i32 i32) (result i32)
///   local.get 0 local.get 1 i32.add))`
final Uint8List _addWasm = Uint8List.fromList(<int>[
  0x00, 0x61, 0x73, 0x6d, // magic
  0x01, 0x00, 0x00, 0x00, // version
  0x01, 0x07, 0x01, 0x60, 0x02, 0x7f, 0x7f, 0x01, 0x7f, // type section
  0x03, 0x02, 0x01, 0x00, // function section
  0x07, 0x07, 0x01, 0x03, 0x61, 0x64, 0x64, 0x00, 0x00, // export "add"
  0x0a, 0x09, 0x01, 0x07, 0x00, 0x20, 0x00, 0x20, 0x01, 0x6a, 0x0b, // code
]);

/// Minimal WASM module that imports `env.get_value() -> i32` and exports
/// `call_import() -> i32` which calls and returns the imported value.
final Uint8List _importWasm = Uint8List.fromList(<int>[
  0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00,
  // Type section (id=1, length=5): one type () -> i32
  0x01, 0x05, 0x01, 0x60, 0x00, 0x01, 0x7f,
  // Import section (id=2, length=0x11): env.get_value : type 0
  0x02, 0x11, 0x01,
  0x03, 0x65, 0x6e, 0x76, // "env"
  0x09, 0x67, 0x65, 0x74, 0x5f, 0x76, 0x61, 0x6c, 0x75, 0x65, // "get_value"
  0x00, 0x00, // kind=func, type index=0 → func index 0
  // Function section (id=3, length=2): one func using type 0 → func index 1
  0x03, 0x02, 0x01, 0x00,
  // Export section (id=7, length=0x0f): "call_import" → func 1
  0x07, 0x0f, 0x01,
  0x0b, 0x63, 0x61, 0x6c, 0x6c, 0x5f, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74,
  0x00, 0x01,
  // Code section (id=10, length=6): call func[0]
  0x0a, 0x06, 0x01, 0x04, 0x00, 0x10, 0x00, 0x0b,
]);

/// WASM module with 1 page of memory and `read_zero() -> i32` (i32.load at 0).
final Uint8List _memWasm = Uint8List.fromList(<int>[
  0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00,
  // Type section (id=1, length=5): () -> i32
  0x01, 0x05, 0x01, 0x60, 0x00, 0x01, 0x7f,
  // Function section (id=3, length=2): func index 0, type 0
  0x03, 0x02, 0x01, 0x00,
  // Memory section (id=5, length=3): 1 memory, min=1 page, no max
  0x05, 0x03, 0x01, 0x00, 0x01,
  // Export section (id=7, length=0x16): "memory" (mem 0) + "read_zero" (func 0)
  0x07, 0x16, 0x02,
  0x06, 0x6d, 0x65, 0x6d, 0x6f, 0x72, 0x79, 0x02, 0x00,
  0x09, 0x72, 0x65, 0x61, 0x64, 0x5f, 0x7a, 0x65, 0x72, 0x6f, 0x00, 0x00,
  // Code section (id=10, length=9): i32.const 0, i32.load align=0 offset=0
  0x0a, 0x09, 0x01, 0x07, 0x00, 0x41, 0x00, 0x28, 0x00, 0x00, 0x0b,
]);

void main() {
  group('WasmRunner (web)', () {
    test('fromBytes compiles and runs a simple WASM module', () async {
      final WasmRunner runner = await WasmRunner.fromBytes(_addWasm);
      final Object? result = runner.call('add', <Object?>[3, 4]);
      check(result).isA<int>().equals(7);
    });

    test('call spreads args correctly (not array-as-single-arg)', () async {
      final WasmRunner runner = await WasmRunner.fromBytes(_addWasm);
      // If args were passed as a single array, WASM would see [Array, undefined]
      // and either trap or return garbage. Correct spreading gives 10 + 20 = 30.
      final Object? result = runner.call('add', <Object?>[10, 20]);
      check(result).isA<int>().equals(30);
    });

    test('host imports receive correct Dart types', () async {
      var receivedCall = false;
      final WasmRunner runner = await WasmRunner.fromBytes(
        _importWasm,
        imports: <String, Map<String, Function>>{
          'env': <String, Function>{
            'get_value': () {
              receivedCall = true;
              return 42;
            },
          },
        },
      );
      final Object? result = runner.call('call_import', <Object?>[]);
      check(receivedCall).isTrue();
      check(result).isA<int>().equals(42);
    });

    test('readMemory and writeMemory work', () async {
      final WasmRunner runner = await WasmRunner.fromBytes(_memWasm);

      // Write 4 bytes at offset 0
      runner.writeMemory(0, Uint8List.fromList(<int>[0x2a, 0x00, 0x00, 0x00]));

      // Read them back
      final Uint8List read = runner.readMemory(0, 4);
      check(read[0]).equals(0x2a);

      // Verify WASM sees the written value
      final Object? val = runner.call('read_zero', <Object?>[]);
      check(val).isA<int>().equals(42);
    });

    test('throws on missing export', () async {
      final WasmRunner runner = await WasmRunner.fromBytes(_addWasm);
      check(
        () => runner.call('nonexistent', <Object?>[]),
      ).throws<ArgumentError>();
    });
  });
}

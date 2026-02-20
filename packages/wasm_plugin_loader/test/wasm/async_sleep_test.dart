// test/wasm/async_sleep_test.dart
//
// Verifies that asyncSleep actually blocks the WASM isolate thread for the
// requested duration via the WasmSemaphore mechanism.
//
// No WASM module needed — tests the semaphore round-trip directly by
// spawning a helper isolate that blocks on WasmSemaphore.wait(), while the
// main isolate delays and then signals.
//
// Run: dart test packages/wasm_plugin_loader/test/wasm/async_sleep_test.dart --reporter expanded
import 'dart:async';
import 'dart:isolate';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/native/wasm_semaphore_io.dart';

/// Message sent from helper isolate back to main with timing info.
class _SleepResult {
  const _SleepResult({required this.elapsedMs});
  final int elapsedMs;
}

/// Helper isolate entry point. Mirrors the blocking pattern in
/// `wasm_isolate.dart` asyncSleep():
///   1. Send a "ready" signal (with semaphore address) to main isolate.
///   2. Block on WasmSemaphore.wait().
///   3. Send elapsed time back.
Future<void> _sleepIsolateMain(List<Object> args) async {
  final resultPort = args[0] as SendPort;
  final semaphoreAddress = args[1] as int;

  final semaphore = WasmSemaphore.fromAddress(semaphoreAddress);

  final sw = Stopwatch()..start();
  // Tell main we're about to block.
  resultPort.send('waiting');
  // This blocks the isolate thread — exactly what asyncSleep does.
  semaphore.wait();
  sw.stop();

  resultPort.send(_SleepResult(elapsedMs: sw.elapsedMilliseconds));
}

void main() {
  group('asyncSleep semaphore round-trip', () {
    test('blocks isolate for ~1 second', () async {
      final semaphore = WasmSemaphore.create();
      final resultPort = ReceivePort();

      await Isolate.spawn(
        _sleepIsolateMain,
        [resultPort.sendPort, semaphore.address],
      );

      final stream = resultPort.asBroadcastStream();

      // Wait for the helper isolate to signal it's about to block.
      await stream.firstWhere((msg) => msg == 'waiting');

      // Simulate what aidoku_plugin_io.dart does on WasmSleepMsg:
      await Future<void>.delayed(const Duration(seconds: 1));
      semaphore.signal();

      // Receive the elapsed time from the helper isolate.
      final result = await stream.firstWhere((msg) => msg is _SleepResult) as _SleepResult;
      resultPort.close();
      semaphore.dispose();

      // Should have blocked for roughly 1 second.
      check(result.elapsedMs)
        ..isGreaterOrEqual(900)
        ..isLessOrEqual(2000);
    });

    test('sleep(0) returns near-immediately', () async {
      final semaphore = WasmSemaphore.create();
      final resultPort = ReceivePort();

      await Isolate.spawn(
        _sleepIsolateMain,
        [resultPort.sendPort, semaphore.address],
      );

      final stream = resultPort.asBroadcastStream();
      await stream.firstWhere((msg) => msg == 'waiting');

      // Zero-duration sleep — signal immediately (no delay).
      await Future<void>.delayed(Duration.zero);
      semaphore.signal();

      final result = await stream.firstWhere((msg) => msg is _SleepResult) as _SleepResult;
      resultPort.close();
      semaphore.dispose();

      // Should unblock almost instantly — well under 500ms.
      check(result.elapsedMs).isLessOrEqual(500);
    });

    test('blocks until signal (not time-based)', () async {
      // Proves the isolate stays blocked until signal() is called,
      // not just for some fixed duration.
      final semaphore = WasmSemaphore.create();
      final resultPort = ReceivePort();

      await Isolate.spawn(
        _sleepIsolateMain,
        [resultPort.sendPort, semaphore.address],
      );

      final stream = resultPort.asBroadcastStream();
      await stream.firstWhere((msg) => msg == 'waiting');

      // Wait 2 seconds before signaling — the isolate should be blocked
      // for the full 2 seconds, proving it waits for signal, not a timer.
      await Future<void>.delayed(const Duration(seconds: 2));
      semaphore.signal();

      final result = await stream.firstWhere((msg) => msg is _SleepResult) as _SleepResult;
      resultPort.close();
      semaphore.dispose();

      check(result.elapsedMs)
        ..isGreaterOrEqual(1900)
        ..isLessOrEqual(3000);
    });
  });
}

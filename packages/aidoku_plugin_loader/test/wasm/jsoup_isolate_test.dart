// Diagnostic test — Phase 8: Verify warm-up fix
//
// Root cause: Calling complex JNI functions (FindClass) from a child Dart
// isolate thread that's being JVM-attached for the first time crashes.
// The crash is in the JVM's class loading code running on a freshly-
// attached thread. A trivial JNI call (GetVersion) triggers AttachCurrentThread
// successfully, then subsequent complex calls work.
//
// Fix: Call Jni.env.GetVersion() after Jni.spawnIfNotExists() in child
// isolates to force thread attachment before any complex JNI work.
//
// ignore_for_file: avoid_print
@TestOn('vm')
library;

import 'dart:isolate';

import 'package:checks/checks.dart';
import 'package:jni/jni.dart';
import 'package:jsoup/jsoup.dart';
import 'package:test/scaffolding.dart';

Future<String> _runInIsolate(Future<String> Function(SendPort) testFn) async {
  final port = ReceivePort();
  await Isolate.spawn(
    (SendPort p) async => testFn(p),
    port.sendPort,
  );
  final Object? result = await port.first;
  port.close();
  return result! as String;
}

void main() {
  setUpAll(JreManager.ensureInitialized);

  // The fix: call GetVersion() to force thread attachment, THEN do real work.
  // Run this multiple times to verify consistency.
  for (var i = 0; i < 5; i++) {
    test('Jsoup in child isolate with warm-up (run $i)', () async {
      final result = await _runInIsolate((port) async {
        try {
          JreManager.ensureInitialized();
          // WARM-UP: Force JVM thread attachment with a trivial call.
          Jni.env.GetVersion();
          // Now do real JNI work.
          final jsoup = Jsoup();
          final doc =
              jsoup.parse('<html><body><p>Hello World $i</p></body></html>');
          final text = doc.text;
          jsoup.dispose();
          port.send('OK: $text');
          return 'OK';
        } on Object catch (e, st) {
          port.send('ERROR: $e\n$st');
          return 'ERROR';
        }
      });
      print('[main] run $i: $result');
      check(result).contains('OK');
    });
  }

  // Verify the warm-up also works for JClass.forName and toJString
  test('JClass.forName with warm-up', () async {
    final result = await _runInIsolate((port) async {
      try {
        JreManager.ensureInitialized();
        Jni.env.GetVersion(); // warm-up
        final cls = JClass.forName('java/lang/Object');
        cls.release();
        port.send('OK');
        return 'OK';
      } on Object catch (e) {
        port.send('ERROR: $e');
        return 'ERROR';
      }
    });
    check(result).contains('OK');
  });

  test('toJString with warm-up', () async {
    final result = await _runInIsolate((port) async {
      try {
        JreManager.ensureInitialized();
        Jni.env.GetVersion(); // warm-up
        final js = 'hello'.toJString();
        final dart = js.toDartString();
        js.release();
        port.send('OK: $dart');
        return 'OK';
      } on Object catch (e) {
        port.send('ERROR: $e');
        return 'ERROR';
      }
    });
    check(result).contains('OK');
  });
}

// =============================================================================
// JNI + Dart Isolate Regression Test — Windows (0xC0000005)
// =============================================================================
//
// Verifies that JreManager.ensureInitialized() is safe to call from child
// Dart isolates on Windows. The fix uses GetModuleHandleW to detect that
// jvm.dll is already loaded (by the main isolate) and skips all PEB
// environment access (Platform.environment, SetEnvironmentVariableW) which
// would corrupt the JVM's VEH handler.
//
// ignore_for_file: invalid_use_of_internal_member, avoid_print
@TestOn('vm')
library;

import 'dart:ffi';
import 'dart:isolate';

import 'package:checks/checks.dart';
import 'package:ffi/ffi.dart';
import 'package:jni/jni.dart';
import 'package:jni/src/third_party/global_env_extensions.dart';
import 'package:jni/src/third_party/jni_bindings_generated.dart';
import 'package:jsoup/jsoup.dart';
import 'package:test/scaffolding.dart';

void main() {
  setUpAll(JreManager.ensureInitialized);

  group('JreManager.ensureInitialized safe in child isolate', () {
    test('ensureInitialized in child + FindClass on main', () async {
      await Isolate.run(() {
        JreManager.ensureInitialized();
        return 'OK';
      });
      // Without the _isModuleLoaded fix, this crashes with 0xC0000005.
      final Pointer<Void> cls = _mainFindClass('java/lang/String');
      check(cls).not((it) => it.equals(nullptr));
      Jni.env.DeleteLocalRef(cls);
      print('[fix] JreManager.ensureInitialized in child: OK');
    });

    test('ensureInitialized in child + Jsoup parse on main', () async {
      await Isolate.run(() {
        JreManager.ensureInitialized();
        return 'OK';
      });
      final jsoup = Jsoup();
      final Document doc = jsoup.parse('<p>Hello</p>');
      final String text = doc.select('p').first.text;
      jsoup.dispose();
      check(text).equals('Hello');
      print('[fix] JreManager in child + Jsoup.parse: OK');
    });

    test('3x ensureInitialized in children + FindClass on main', () async {
      for (var i = 0; i < 3; i++) {
        await Isolate.run(() {
          JreManager.ensureInitialized();
          return 'OK';
        });
      }
      final Pointer<Void> cls = _mainFindClass('java/lang/String');
      check(cls).not((it) => it.equals(nullptr));
      Jni.env.DeleteLocalRef(cls);
      print('[fix] 3x JreManager in children: OK');
    });
  });

  group('Baseline: no PEB access in child', () {
    test('Empty child + FindClass on main', () async {
      await Isolate.run(() => 'OK');
      final Pointer<Void> cls = _mainFindClass('java/lang/String');
      check(cls).not((it) => it.equals(nullptr));
      Jni.env.DeleteLocalRef(cls);
      print('[safe] Empty child: OK');
    });

    test('JNI on main only — 20x FindClass', () {
      for (var i = 0; i < 20; i++) {
        final Pointer<Void> cls = _mainFindClass('java/lang/String');
        check(cls).not((it) => it.equals(nullptr));
        Jni.env.DeleteLocalRef(cls);
      }
      print('[safe] 20x FindClass: OK');
    });

    test('Full Jsoup parse on main', () {
      final jsoup = Jsoup();
      final Document doc = jsoup.parse('<div class="m"><a>Title</a></div>');
      final String text = doc.select('div.m a').first.text;
      jsoup.dispose();
      check(text).equals('Title');
      print('[safe] Jsoup.parse: OK');
    });
  });
}

Pointer<Void> _mainFindClass(String name) {
  final GlobalJniEnv env = Jni.env;
  final Pointer<Char> clsName = name.toNativeChars();
  final JClassPtr cls = env.FindClass(clsName);
  calloc.free(clsName);
  return cls;
}

extension on String {
  Pointer<Char> toNativeChars() {
    final List<int> units = codeUnits;
    final Pointer<Char> ptr = calloc<Char>(units.length + 1);
    for (var i = 0; i < units.length; i++) {
      (ptr + i).value = units[i];
    }
    (ptr + units.length).value = 0;
    return ptr;
  }
}

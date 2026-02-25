import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:jni/jni.dart';
import 'package:jsoup/src/jsoup_version.dart';

/// Manages JVM lifecycle for desktop platforms (Windows/Linux).
///
/// On Android, the JVM is already running so this is not needed.
/// Call [ensureInitialized] before any JNI calls on desktop.
class JreManager {
  JreManager._();

  static bool _initialized = false;

  /// Initialize the JVM with the bundled JDK and Jsoup JAR.
  ///
  /// This is idempotent — calling it multiple times is safe.
  /// The Jsoup JAR path is resolved relative to the executable.
  ///
  /// In child Dart isolates on Windows, the JVM is already running and
  /// jvm.dll is already loaded. The full setup is skipped because any PEB
  /// environment access (`Platform.environment`, `SetEnvironmentVariableW`)
  /// from a child isolate corrupts the JVM's VEH handler, causing 0xC0000005
  /// crashes on subsequent `FindClass` calls.
  static void ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    // On Windows, if jvm.dll is already loaded, the main isolate has already
    // set up everything. Skip all setup.
    if (Platform.isWindows && _isModuleLoaded('jvm.dll')) {
      return;
    }

    final String jsoupJarPath = _findJsoupJar();
    final String jvmLibPath = _findJvmLibrary();
    final String jvmDir = File(jvmLibPath).parent.path;

    // dartjni.dll depends on jvm.dll at load time. Pre-load jvm.dll by full
    // path so the OS linker can resolve it when dartjni.dll is opened.
    if (Platform.isWindows) {
      DynamicLibrary.open(jvmLibPath);
    }

    Jni.spawnIfNotExists(
      dylibDir: jvmDir,
      classPath: [jsoupJarPath],
      jvmOptions: ['-Xmx64m'],
    );
  }

  /// Locate the Jsoup JAR file.
  ///
  /// Looks in several locations:
  /// 1. Next to the executable (bundled app)
  /// 2. In the package's `jar/` directory (development)
  /// 3. Upward from working directory for build hook output (development/test)
  static String _findJsoupJar() {
    // Check next to executable.
    final String exeDir = File(Platform.resolvedExecutable).parent.path;
    final candidates = <String>[
      '$exeDir/jsoup.jar',
      '$exeDir/jar/jsoup.jar',
      '$exeDir/../jar/jsoup.jar',
    ];

    for (final path in candidates) {
      if (File(path).existsSync()) return path;
    }

    // Search upward from working directory for build hook output
    // (development/test).
    Directory dir = Directory.current;
    for (var i = 0; i < 10; i++) {
      final jar = File(
        '${dir.path}/.dart_tool/hooks_runner/shared/jsoup/build/'
        'jsoup-$jsoupVersion/jsoup-$jsoupVersion.jar',
      );
      if (jar.existsSync()) return jar.path;
      final Directory parent = dir.parent;
      if (parent.path == dir.path) break; // filesystem root
      dir = parent;
    }

    throw StateError(
      'Could not find jsoup.jar. Place jsoup.jar next to the executable '
      'or ensure the build hook has run.',
    );
  }

  /// Locate the JVM shared library.
  ///
  /// On desktop platforms the JDK is bundled by the build hook.
  static String _findJvmLibrary() {
    final libName = Platform.isWindows ? 'jvm.dll' : 'libjvm.so';
    final serverSubdir =
        Platform.isWindows ? 'bin/server/$libName' : 'lib/server/$libName';

    // Check next to executable (bundled app).
    final String exeDir = File(Platform.resolvedExecutable).parent.path;
    final exeCandidates = <String>[
      '$exeDir/jre/$serverSubdir',
      '$exeDir/../jre/$serverSubdir',
    ];

    for (final path in exeCandidates) {
      if (File(path).existsSync()) return path;
    }

    // Search upward from working directory for build hook output
    // (development/test). The build hook caches the JDK at
    // .dart_tool/hooks_runner/shared/jsoup/build/jdk-17-{os}-{arch}/.
    final os = Platform.isWindows ? 'windows' : 'linux';
    Directory dir = Directory.current;
    for (var i = 0; i < 10; i++) {
      final jdkDir = Directory(
        '${dir.path}/.dart_tool/hooks_runner/shared/jsoup/build/'
        'jdk-17-$os-x64',
      );
      if (jdkDir.existsSync()) {
        for (final FileSystemEntity entry in jdkDir.listSync()) {
          if (entry is Directory) {
            final path = '${entry.path}/$serverSubdir';
            if (File(path).existsSync()) return path;
          }
        }
      }
      final Directory parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }

    throw StateError(
      'Could not find $libName. Ensure a bundled JDK is present.',
    );
  }

  /// Returns true if a DLL with [name] is already loaded in the process.
  ///
  /// Uses `GetModuleHandleW` which queries the loaded modules list without
  /// loading the DLL or accessing the PEB environment block.
  static bool _isModuleLoaded(String name) {
    final kernel32 = DynamicLibrary.open('kernel32.dll');
    final Pointer<Void> Function(Pointer<Utf16>) getModuleHandle =
        kernel32.lookupFunction<
          Pointer<Void> Function(Pointer<Utf16>),
          Pointer<Void> Function(Pointer<Utf16>)
        >('GetModuleHandleW');
    final Pointer<Utf16> namePtr = name.toNativeUtf16();
    final Pointer<Void> handle = getModuleHandle(namePtr);
    malloc.free(namePtr);
    return handle != nullptr;
  }
}

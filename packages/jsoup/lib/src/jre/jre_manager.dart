import 'dart:io';

import 'package:jni/jni.dart';
import 'package:jsoup/src/jsoup_version.dart';

/// Manages JVM lifecycle for desktop platforms (Windows/Linux).
///
/// On Android, the JVM is already running so this is not needed.
/// Call [ensureInitialized] before any JNI calls on desktop.
class JreManager {
  JreManager._();

  static bool _initialized = false;

  /// Initialize the JVM with the bundled JRE and Jsoup JAR.
  ///
  /// This is idempotent — calling it multiple times is safe.
  /// The Jsoup JAR path is resolved relative to the executable.
  static void ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    final String jsoupJarPath = _findJsoupJar();
    final String jvmLibPath = _findJvmLibrary();

    Jni.spawn(
      dylibDir: File(jvmLibPath).parent.path,
      classPath: [jsoupJarPath],
      jvmOptions: ['-Xmx64m'],
    );
  }

  /// Locate the Jsoup JAR file.
  ///
  /// Looks in several locations:
  /// 1. Next to the executable (bundled app)
  /// 2. In the package's `jar/` directory (development)
  /// 3. Via JSOUP_JAR_PATH environment variable
  static String _findJsoupJar() {
    // Check environment variable first.
    final String? envPath = Platform.environment['JSOUP_JAR_PATH'];
    if (envPath != null && File(envPath).existsSync()) {
      return envPath;
    }

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
      'Could not find jsoup.jar. Set JSOUP_JAR_PATH environment variable '
      'or place jsoup.jar next to the executable.',
    );
  }

  /// Locate the JVM shared library.
  ///
  /// On desktop platforms the JRE is bundled by the build hook.
  /// Falls back to JAVA_HOME if no bundled JRE is found.
  static String _findJvmLibrary() {
    final libName = Platform.isWindows ? 'jvm.dll' : 'libjvm.so';
    final serverSubdir = Platform.isWindows ? 'bin/server/$libName' : 'lib/server/$libName';

    // Check environment variable.
    final String? envPath = Platform.environment['JVM_LIB_PATH'];
    if (envPath != null && File(envPath).existsSync()) {
      return envPath;
    }

    // Check next to executable (bundled JRE).
    final String exeDir = File(Platform.resolvedExecutable).parent.path;
    final candidates = <String>[
      '$exeDir/jre/$serverSubdir',
      '$exeDir/../jre/$serverSubdir',
    ];

    for (final path in candidates) {
      if (File(path).existsSync()) return path;
    }

    // Fall back to JAVA_HOME.
    final String? javaHome = Platform.environment['JAVA_HOME'];
    if (javaHome != null) {
      final path = '$javaHome/$serverSubdir';
      if (File(path).existsSync()) return path;
    }

    throw StateError(
      'Could not find $libName. Set JVM_LIB_PATH or JAVA_HOME environment '
      'variable, or ensure a bundled JRE is present.',
    );
  }
}

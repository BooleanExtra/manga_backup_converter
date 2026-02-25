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
  static void ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    final String jsoupJarPath = _findJsoupJar();
    final String jvmLibPath = _findJvmLibrary();
    final String jvmDir = File(jvmLibPath).parent.path;

    // dartjni.dll depends on jvm.dll at load time. On Windows, add the
    // directory containing jvm.dll to the DLL search path so the OS can
    // resolve it when DynamicLibrary.open loads dartjni.dll.
    if (Platform.isWindows) {
      _addDllDirectory(jvmDir);
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
  /// On desktop platforms the JDK is bundled by the build hook.
  /// Falls back to JAVA_HOME if no bundled JDK is found.
  static String _findJvmLibrary() {
    final libName = Platform.isWindows ? 'jvm.dll' : 'libjvm.so';
    final serverSubdir = Platform.isWindows ? 'bin/server/$libName' : 'lib/server/$libName';

    // Check environment variable.
    final String? envPath = Platform.environment['JVM_LIB_PATH'];
    if (envPath != null && File(envPath).existsSync()) {
      return envPath;
    }

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

    // Fall back to JAVA_HOME.
    final String? javaHome = Platform.environment['JAVA_HOME'];
    if (javaHome != null) {
      final path = '$javaHome/$serverSubdir';
      if (File(path).existsSync()) return path;
    }

    throw StateError(
      'Could not find $libName. Set JVM_LIB_PATH or JAVA_HOME environment '
      'variable, or ensure a bundled JDK is present.',
    );
  }

  /// Adds [directory] to the Windows DLL search path via `SetEnvironmentVariableW`.
  ///
  /// Prepends [directory] to the process-level PATH so that when `dartjni.dll`
  /// is loaded, the OS can find `jvm.dll` in the same directory.
  static void _addDllDirectory(String directory) {
    final kernel32 = DynamicLibrary.open('kernel32.dll');

    // DWORD GetEnvironmentVariableW(LPCWSTR name, LPWSTR buffer, DWORD size)
    final int Function(Pointer<Utf16>, Pointer<Utf16>, int) getEnvVar = kernel32
        .lookupFunction<
          Uint32 Function(Pointer<Utf16>, Pointer<Utf16>, Uint32),
          int Function(Pointer<Utf16>, Pointer<Utf16>, int)
        >(
          'GetEnvironmentVariableW',
        );

    // BOOL SetEnvironmentVariableW(LPCWSTR name, LPCWSTR value)
    final int Function(Pointer<Utf16>, Pointer<Utf16>) setEnvVar = kernel32
        .lookupFunction<Int32 Function(Pointer<Utf16>, Pointer<Utf16>), int Function(Pointer<Utf16>, Pointer<Utf16>)>(
          'SetEnvironmentVariableW',
        );

    final Pointer<Utf16> pathName = 'PATH'.toNativeUtf16();

    // Get current PATH length (returns size in chars including null).
    final int needed = getEnvVar(pathName, nullptr, 0);
    final Pointer<Utf16> currentPath = malloc.allocate<Utf16>(needed * sizeOf<Uint16>());
    getEnvVar(pathName, currentPath, needed);

    // Prepend jvmDir to PATH.
    final Pointer<Utf16> newPath = '$directory;${currentPath.toDartString()}'.toNativeUtf16();
    setEnvVar(pathName, newPath);

    malloc.free(pathName);
    malloc.free(currentPath);
    malloc.free(newPath);
  }
}

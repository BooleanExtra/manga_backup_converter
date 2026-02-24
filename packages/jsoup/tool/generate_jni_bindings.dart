// Runs `dart run jnigen --config jnigen.yaml` with the bundled JRE on PATH,
// or runs `dart run jni:setup` with JAVA_HOME pointing to a system JDK.
//
// The build hook downloads an Adoptium JRE 17 into .dart_tool/, but jnigen
// hardcodes `java` as the command. This script finds the downloaded JRE and
// prepends its bin/ directory to PATH before invoking jnigen.
//
// For jni:setup, a full JDK (with include/jni.h) is needed — the bundled JRE
// lacks headers. The script discovers system JDK installations automatically.
//
// Usage:
//   cd packages/jsoup
//   dart run tool/generate_jni_bindings.dart            # run jnigen
//   dart run tool/generate_jni_bindings.dart --jni-setup # run jni:setup

// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) async {
  final bool jniSetup = args.contains('--jni-setup');

  if (jniSetup) {
    await _runJniSetup();
  } else {
    await _runJnigen();
  }
}

Future<void> _runJnigen() async {
  // jnigen's ApiSummarizer needs javadoc, which is only in a full JDK.
  // Prefer a system JDK, fall back to the bundled JRE (will fail at
  // ApiSummarizer but still works for non-summary generation).
  final String? jdkHome = _findJdkHome();
  final String? javaBin = jdkHome != null ? '$jdkHome/bin' : _findJavaBin();
  if (jdkHome != null) {
    print('Using JDK: $jdkHome');
  } else if (javaBin != null) {
    print('Using java from: $javaBin (JRE only — javadoc unavailable)');
  } else {
    print('No JDK or JRE found. Falling back to system PATH.');
  }

  final env = Map<String, String>.of(Platform.environment);
  if (javaBin != null) {
    final separator = Platform.isWindows ? ';' : ':';
    env['PATH'] = '$javaBin$separator${env['PATH'] ?? ''}';
  }
  if (jdkHome != null) {
    env['JAVA_HOME'] = jdkHome;
  }

  print('Running jnigen ...');
  final Process process = await Process.start(
    'dart',
    ['run', 'jnigen', '--config', 'jnigen.yaml'],
    workingDirectory: Directory.current.path,
    environment: env,
    mode: ProcessStartMode.inheritStdio,
  );

  exit(await process.exitCode);
}

Future<void> _runJniSetup() async {
  final String? jdkHome = _findJdkHome();
  if (jdkHome == null) {
    print('Error: No JDK found with include/jni.h.');
    print('');
    print('jni:setup requires a full JDK (not just a JRE).');
    print('Install Adoptium JDK 17: https://adoptium.net/');
    print('');
    print('Or set JAVA_HOME to your JDK installation directory.');
    exit(1);
  }

  print('Using JDK: $jdkHome');

  final env = Map<String, String>.of(Platform.environment);
  // Use MSYS2-compatible paths — CMake chokes on Windows backslash paths.
  env['JAVA_HOME'] = _toCmakePath(jdkHome);

  // jni:setup must run from the monorepo root (it scans package_config.json
  // for dependencies with # jni_native_build directive).
  final String? monorepoRoot = _findMonorepoRoot();
  if (monorepoRoot == null) {
    print(
      'Error: Could not find monorepo root '
      '(looking for pubspec.yaml with workspace:).',
    );
    exit(1);
  }

  // Pass explicit JNI paths via --cmake-args so CMake's FindJNI succeeds
  // even on platforms where JAVA_HOME alone isn't enough (e.g. MSYS2).
  final List<String> cmakeArgs = _buildCmakeArgs(jdkHome);

  print('Running jni:setup from $monorepoRoot ...');
  final Process process = await Process.start(
    'dart',
    ['run', 'jni:setup', ...cmakeArgs],
    workingDirectory: monorepoRoot,
    environment: env,
    mode: ProcessStartMode.inheritStdio,
  );

  final int exitCode = await process.exitCode;

  if (exitCode != 0) {
    // jni:setup on MinGW/MSYS2 crashes after building because it expects
    // MSVC's Debug/ directory layout. Check if the library was actually
    // built in the temp dir and copy it manually.
    if (Platform.isWindows && _rescueMinGWBuild(monorepoRoot)) {
      print('Build rescued from MinGW temp directory.');
    } else {
      exit(exitCode);
    }
  }

  print('jni:setup complete.');
}

/// On MinGW/MSYS2, jni:setup crashes looking for Debug/ but the library
/// was built in the temp dir root. Find it and copy to build/jni_libs/.
bool _rescueMinGWBuild(String monorepoRoot) {
  final jniDir = Directory('$monorepoRoot/.dart_tool/jni');
  if (!jniDir.existsSync()) return false;

  for (final FileSystemEntity tempEntry in jniDir.listSync()) {
    if (tempEntry is! Directory) continue;
    if (!tempEntry.path.contains('jni_native_build_')) continue;

    // Look for the built shared library in the temp dir root.
    for (final FileSystemEntity file in tempEntry.listSync()) {
      if (file is! File) continue;
      final String name = file.uri.pathSegments.last;
      if (name.endsWith('.so') || name.endsWith('.dll')) {
        // Copy to build/jni_libs/.
        final buildDir = Directory('$monorepoRoot/build/jni_libs');
        if (!buildDir.existsSync()) buildDir.createSync(recursive: true);

        // Rename libdartjni.so → dartjni.dll if needed.
        var targetName = name;
        if (name == 'libdartjni.so') targetName = 'dartjni.dll';

        final target = '${buildDir.path}/$targetName';
        print('Copying $name → $target');
        file.copySync(target);

        // Clean up temp dir.
        tempEntry.deleteSync(recursive: true);
        return true;
      }
    }
  }
  return false;
}

/// Finds the root directory of a JDK that has `include/jni.h`.
///
/// Discovery order:
/// 1. JAVA_HOME env var (if it contains include/jni.h)
/// 2. Well-known system JDK paths (prefer JDK 17, accept others)
String? _findJdkHome() {
  // 1. Check JAVA_HOME.
  final String? javaHome = Platform.environment['JAVA_HOME'];
  if (javaHome != null && _isJdk(javaHome)) {
    return javaHome;
  }

  // 2. Scan well-known system directories.
  final candidates = <String>[];
  if (Platform.isWindows) {
    for (final base in [
      r'C:\Program Files\Eclipse Adoptium',
      r'C:\Program Files\Java',
      r'C:\Program Files\Microsoft',
    ]) {
      _addJdkCandidates(base, candidates);
    }
  } else if (Platform.isLinux) {
    _addJdkCandidates('/usr/lib/jvm', candidates);
  } else if (Platform.isMacOS) {
    // macOS: /Library/Java/JavaVirtualMachines/*/Contents/Home
    final vmsDir = Directory('/Library/Java/JavaVirtualMachines');
    if (vmsDir.existsSync()) {
      for (final FileSystemEntity entry in vmsDir.listSync()) {
        if (entry is Directory) {
          final home = '${entry.path}/Contents/Home';
          if (_isJdk(home)) candidates.add(home);
        }
      }
    }
  }

  if (candidates.isEmpty) return null;

  // Prefer JDK 17, then sort by path (higher version numbers sort later).
  candidates.sort((a, b) {
    final bool a17 = a.contains('17');
    final bool b17 = b.contains('17');
    if (a17 && !b17) return -1;
    if (!a17 && b17) return 1;
    return b.compareTo(a); // Higher versions first within same preference.
  });

  return candidates.first;
}

/// Scans [baseDir] for subdirectories that contain `include/jni.h`.
void _addJdkCandidates(String baseDir, List<String> candidates) {
  final dir = Directory(baseDir);
  if (!dir.existsSync()) return;
  for (final FileSystemEntity entry in dir.listSync()) {
    if (entry is Directory && _isJdk(entry.path)) {
      candidates.add(entry.path);
    }
  }
}

/// Returns true if [path] looks like a JDK root (has `include/jni.h`).
bool _isJdk(String path) => File('$path/include/jni.h').existsSync() || File('$path\\include\\jni.h').existsSync();

/// Converts a Windows path to a CMake-compatible path.
///
/// Under MSYS2, CMake needs `/c/...` style paths instead of `C:\...` or
/// `C:/...`. On non-Windows platforms, just normalizes to forward slashes.
String _toCmakePath(String path) {
  String result = path.replaceAll(r'\', '/');
  // Convert drive letter: C:/... → /c/...
  if (result.length >= 2 && result[1] == ':') {
    result = '/${result[0].toLowerCase()}${result.substring(2)}';
  }
  return result;
}

/// Builds `--cmake-args` flags to explicitly tell CMake where JNI lives.
///
/// CMake's FindJNI can fail under MSYS2 or other non-standard environments
/// even when JAVA_HOME is set. Passing the paths explicitly always works.
/// All paths are normalized to forward slashes — CMake under MSYS2 interprets
/// backslashes as escape sequences.
List<String> _buildCmakeArgs(String jdkHome) {
  final String home = _toCmakePath(jdkHome);
  final includePath = '$home/include';
  final platformInclude = Platform.isWindows
      ? '$includePath/win32'
      : Platform.isMacOS
      ? '$includePath/darwin'
      : '$includePath/linux';

  // Find jvm shared library.
  final String? rawJvmLib = _findJvmLib(jdkHome);
  final String? jvmLib = rawJvmLib != null ? _toCmakePath(rawJvmLib) : null;

  return [
    '-m', '-DJAVA_INCLUDE_PATH=$includePath',
    '-m', '-DJAVA_INCLUDE_PATH2=$platformInclude',
    '-m', '-DJAVA_HOME=$home',
    if (jvmLib != null) ...['-m', '-DJAVA_JVM_LIBRARY=$jvmLib'],
    // MinGW needs ole32 for CoTaskMemFree used by dartjni.c.
    if (Platform.isWindows) ...['-m', '-DCMAKE_C_STANDARD_LIBRARIES=-lole32'],
  ];
}

/// Finds the JVM shared library inside the JDK.
String? _findJvmLib(String jdkHome) {
  final candidates = <String>[
    // Windows
    '$jdkHome/lib/jvm.lib',
    '$jdkHome/lib/server/jvm.dll',
    '$jdkHome/bin/server/jvm.dll',
    // Linux
    '$jdkHome/lib/server/libjvm.so',
    '$jdkHome/lib/amd64/server/libjvm.so',
    // macOS
    '$jdkHome/lib/server/libjvm.dylib',
    '$jdkHome/lib/jli/libjli.dylib',
  ];
  for (final path in candidates) {
    if (File(path).existsSync()) return path;
  }
  return null;
}

/// Finds the monorepo root by walking upward looking for a `pubspec.yaml`
/// that contains the `workspace:` key (Dart workspace / melos config).
String? _findMonorepoRoot() {
  Directory dir = Directory.current;
  for (var i = 0; i < 10; i++) {
    final pubspec = File('${dir.path}/pubspec.yaml');
    if (pubspec.existsSync() && pubspec.readAsStringSync().contains('workspace:')) {
      return dir.path;
    }
    final Directory parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  return null;
}

/// Finds the `bin/` directory of the downloaded Adoptium JRE.
///
/// Walks upward from [Directory.current] looking for the build hook's JRE
/// output, then falls back to JAVA_HOME.
String? _findJavaBin() {
  final javaExe = Platform.isWindows ? 'java.exe' : 'java';
  final os = Platform.isWindows ? 'windows' : 'linux';
  final String arch = _arch();

  // Walk upward looking for .dart_tool/hooks_runner/shared/jsoup/build/
  Directory dir = Directory.current;
  for (var i = 0; i < 10; i++) {
    final jreDir = Directory(
      '${dir.path}/.dart_tool/hooks_runner/shared/jsoup/build/'
      'jre-17-$os-$arch',
    );
    if (jreDir.existsSync()) {
      // JRE extracts to a subdirectory like `jdk-17.0.x+y-jre/`.
      for (final FileSystemEntity entry in jreDir.listSync()) {
        if (entry is Directory) {
          final bin = Directory('${entry.path}/bin');
          if (File('${bin.path}/$javaExe').existsSync()) {
            return bin.path;
          }
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
    final bin = '$javaHome/bin';
    if (File('$bin/$javaExe').existsSync()) return bin;
  }

  return null;
}

String _arch() {
  // Dart doesn't expose architecture directly; use a heuristic based on
  // the resolved executable path or default to x64.
  final String exe = Platform.resolvedExecutable.toLowerCase();
  if (exe.contains('arm64') || exe.contains('aarch64')) return 'aarch64';
  return 'x64';
}

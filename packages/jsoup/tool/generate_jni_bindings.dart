// Runs `dart run jnigen --config jnigen.yaml` or `dart run jni:setup` using
// the JDK downloaded by the build hook.
//
// The build hook downloads an Adoptium JDK 17 into .dart_tool/. This script
// finds it and uses it for both jnigen (needs javadoc) and jni:setup (needs
// include/jni.h).
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
  final String? jdkHome = _findBundledJdk();
  if (jdkHome == null) {
    print('No bundled JDK found. Run a build first to trigger the build hook,');
    print('or run: dart run tool/generate_jni_bindings.dart --jni-setup');
    exit(1);
  }

  print('Using bundled JDK: $jdkHome');

  final env = Map<String, String>.of(Platform.environment);
  final javaBin = '$jdkHome/bin';
  final separator = Platform.isWindows ? ';' : ':';
  env['PATH'] = '$javaBin$separator${env['PATH'] ?? ''}';
  env['JAVA_HOME'] = jdkHome;

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
  final String? jdkHome = _findBundledJdk();
  if (jdkHome == null) {
    print('No bundled JDK found. Run a build first to trigger the build hook.');
    print('');
    print('For example:');
    print('  cd <monorepo_root>');
    print('  dart run --define=JSOUP_TRIGGER=1 packages/jsoup/hook/build.dart');
    exit(1);
  }

  print('Using bundled JDK: $jdkHome');

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

  // Copy dartjni.dll next to jvm.dll in the bundled JDK — JreManager sets
  // dylibDir to the directory containing jvm.dll.
  _installDartJni(monorepoRoot, jdkHome);

  print('jni:setup complete.');
}

/// Copies dartjni.dll from build/jni_libs/ to the bundled JDK's server dir.
void _installDartJni(String monorepoRoot, String jdkHome) {
  final libName = Platform.isWindows ? 'dartjni.dll' : 'libdartjni.so';
  final source = File('$monorepoRoot/build/jni_libs/$libName');
  if (!source.existsSync()) {
    print('Warning: $libName not found in build/jni_libs/, skipping install.');
    return;
  }

  final serverDir = Platform.isWindows ? '$jdkHome/bin/server' : '$jdkHome/lib/server';
  if (!Directory(serverDir).existsSync()) {
    print('Warning: Server directory not found at $serverDir');
    return;
  }

  final target = '$serverDir/$libName';
  try {
    source.copySync(target);
    print('Installed $libName → $target');
  } on FileSystemException catch (e) {
    print('Warning: Could not copy to $target: ${e.message}');
  }
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

/// Finds the root directory of the bundled Adoptium JDK.
///
/// Walks upward from [Directory.current] looking for the build hook's JDK
/// output at `.dart_tool/hooks_runner/shared/jsoup/build/jdk-17-{os}-{arch}/`.
String? _findBundledJdk() {
  final os = Platform.isWindows ? 'windows' : 'linux';
  final String arch = _arch();

  Directory dir = Directory.current;
  for (var i = 0; i < 10; i++) {
    final jdkDir = Directory(
      '${dir.path}/.dart_tool/hooks_runner/shared/jsoup/build/'
      'jdk-17-$os-$arch',
    );
    if (jdkDir.existsSync()) {
      // JDK extracts to a subdirectory like `jdk-17.0.x+y/`.
      for (final FileSystemEntity entry in jdkDir.listSync()) {
        if (entry is Directory) {
          // Verify it has include/jni.h (confirms it's a full JDK).
          if (File('${entry.path}/include/jni.h').existsSync()) {
            return entry.path;
          }
        }
      }
    }
    final Directory parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }

  // Fall back to JAVA_HOME if it's a full JDK.
  final String? javaHome = Platform.environment['JAVA_HOME'];
  if (javaHome != null && File('$javaHome/include/jni.h').existsSync()) {
    return javaHome;
  }

  return null;
}

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

String _arch() {
  // Dart doesn't expose architecture directly; use a heuristic based on
  // the resolved executable path or default to x64.
  final String exe = Platform.resolvedExecutable.toLowerCase();
  if (exe.contains('arm64') || exe.contains('aarch64')) return 'aarch64';
  return 'x64';
}

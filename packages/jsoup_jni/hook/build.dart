// Build hook that downloads a JDK and Jsoup JAR for desktop platforms.
// On Android the JVM is already available; on iOS/macOS SwiftSoup is used.
//
// Downloads:
// 1. Adoptium JDK 17 (Windows x64, Linux x64/arm64)
// 2. Jsoup 1.18.3 JAR from Maven Central
//
// The JVM library is registered as a CodeAsset. The Jsoup JAR is placed in the
// shared output directory where JreManager finds it at runtime.
//
// A full JDK (not just a JRE) is used so that jnigen (needs javadoc) and
// jni:setup (needs include/jni.h) can use the same bundled installation.
// ignore_for_file: avoid_print
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:http/http.dart' as http;
import 'package:jsoup_jni/src/jre_manager.dart' show JreManager;
import 'package:jsoup_jni/src/jsoup_version.dart';

const _jdkVersion = '17';

const _jsoupMavenUrl = 'https://repo1.maven.org/maven2/org/jsoup/jsoup/$jsoupVersion/jsoup-$jsoupVersion.jar';

/// Maps (OS, Architecture) to JDK download info from Adoptium.
const _jdkDownloadInfo = <(OS, Architecture), ({String os, String arch, String jvmLibPath, bool isZip})>{
  (OS.windows, Architecture.x64): (
    os: 'windows',
    arch: 'x64',
    jvmLibPath: 'bin/server/jvm.dll',
    isZip: true,
  ),
  (OS.linux, Architecture.x64): (
    os: 'linux',
    arch: 'x64',
    jvmLibPath: 'lib/server/libjvm.so',
    isZip: false,
  ),
  (OS.linux, Architecture.arm64): (
    os: 'linux',
    arch: 'aarch64',
    jvmLibPath: 'lib/server/libjvm.so',
    isZip: false,
  ),
};

void main(List<String> args) async {
  await build(args, (input, output) async {
    // We only need to bundle assets for native builds.
    if (!input.config.buildCodeAssets) return;

    final CodeConfig codeConfig = input.config.code;
    final (OS, Architecture) key = (
      codeConfig.targetOS,
      codeConfig.targetArchitecture,
    );

    // Windows/Linux/Android now use Rust scraper (packages/scraper/).
    // iOS/macOS use SwiftSoup — nothing to bundle here.
    // The JDK/JVM is only needed for JNI on Android (platform JVM)
    // and for jnigen/jni:setup tooling.
    if (codeConfig.targetOS == OS.windows || codeConfig.targetOS == OS.linux) {
      // Scraper handles these platforms — no JVM needed at runtime.
      // No JDK/Jsoup download is performed here; dev tooling must use a local JDK/Jsoup.
      return;
    }

    if (codeConfig.targetOS == OS.android) {
      // Android uses the platform JVM — only need the Jsoup JAR for JNI.
      // However, with scraper as the runtime backend, this JAR is only
      // needed if JNI is used as a fallback. Keep for now.
      await _downloadJsoupJar(input.outputDirectoryShared);
      return;
    }

    if (codeConfig.targetOS == OS.iOS || codeConfig.targetOS == OS.macOS) {
      // SwiftSoup bundling TBD.
      return;
    }

    final ({String arch, bool isZip, String jvmLibPath, String os})? info = _jdkDownloadInfo[key];
    if (info == null) {
      throw UnsupportedError(
        'jsoup: JDK not available for '
        '${codeConfig.targetOS}-${codeConfig.targetArchitecture}.',
      );
    }

    // Download JDK and Jsoup JAR to the shared output directory.
    final Uri jvmLib = await _downloadJdk(input.outputDirectoryShared, info);
    await _downloadJsoupJar(input.outputDirectoryShared);

    // Register the JVM library so Jni.spawn() can find it.
    output.assets.code.add(
      CodeAsset(
        package: 'jsoup_jni',
        name: 'src/jre/jvm_library',
        linkMode: DynamicLoadingBundled(),
        file: jvmLib,
      ),
    );
  });
}

/// Downloads the Jsoup JAR from Maven Central to the shared output directory.
///
/// The JAR is stored at a predictable path so [JreManager] can locate it.
Future<void> _downloadJsoupJar(Uri outputDirectoryShared) async {
  final cacheDir = Directory.fromUri(
    outputDirectoryShared.resolve('jsoup-$jsoupVersion/'),
  );
  final jarFile = File.fromUri(cacheDir.uri.resolve('jsoup-$jsoupVersion.jar'));

  if (!await jarFile.exists()) {
    print('Downloading Jsoup $jsoupVersion from Maven Central ...');
    final http.Response response = await http.get(Uri.parse(_jsoupMavenUrl));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download Jsoup: HTTP ${response.statusCode}\n'
        'URL: $_jsoupMavenUrl',
      );
    }

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    await jarFile.writeAsBytes(response.bodyBytes);
    print('Jsoup $jsoupVersion cached at ${jarFile.path}');
  }
}

/// Downloads the Adoptium JDK and extracts it.
Future<Uri> _downloadJdk(
  Uri outputDirectoryShared,
  ({String os, String arch, String jvmLibPath, bool isZip}) info,
) async {
  final cacheDir = Directory.fromUri(
    outputDirectoryShared.resolve('jdk-$_jdkVersion-${info.os}-${info.arch}/'),
  );

  // The JDK extracts to a subdirectory like `jdk-17.0.x+y/`.
  // We need to find that directory after extraction.
  final jvmLibFile = File.fromUri(
    cacheDir.uri.resolve(_findJdkSubdir(cacheDir, info.jvmLibPath)),
  );

  if (await jvmLibFile.exists()) {
    return jvmLibFile.uri;
  }

  final Uri url = Uri.parse(
    'https://api.adoptium.net/v3/binary/latest/$_jdkVersion/ga/'
    '${info.os}/${info.arch}/jdk/hotspot/normal/eclipse',
  );

  print('Downloading Adoptium JDK $_jdkVersion for ${info.os}/${info.arch} ...');
  final http.Response response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception(
      'Failed to download JDK: HTTP ${response.statusCode}\n'
      'URL: $url',
    );
  }

  if (!await cacheDir.exists()) {
    await cacheDir.create(recursive: true);
  }

  // Extract archive.
  print('Extracting JDK ...');
  if (info.isZip) {
    final Archive archive = ZipDecoder().decodeBytes(response.bodyBytes);
    for (final file in archive) {
      if (!file.isFile) continue;
      final targetFile = File.fromUri(cacheDir.uri.resolve(file.name));
      await targetFile.create(recursive: true);
      await targetFile.writeAsBytes(file.content as List<int>);
    }
  } else {
    final List<int> gzDecoded = const GZipDecoder().decodeBytes(response.bodyBytes);
    final Archive archive = TarDecoder().decodeBytes(gzDecoded);
    for (final file in archive) {
      if (!file.isFile) continue;
      final targetFile = File.fromUri(cacheDir.uri.resolve(file.name));
      await targetFile.create(recursive: true);
      await targetFile.writeAsBytes(file.content as List<int>);
    }
  }

  // Find the actual JVM library path (inside the extracted subdirectory).
  final String resolvedPath = _findJdkSubdir(cacheDir, info.jvmLibPath);
  final resolvedFile = File.fromUri(cacheDir.uri.resolve(resolvedPath));

  if (!await resolvedFile.exists()) {
    // List what was extracted to help debug.
    final String contents = cacheDir.listSync().map((e) => e.path).join('\n  ');
    throw Exception(
      'Expected JVM library not found after extraction.\n'
      'Looked for: ${info.jvmLibPath}\n'
      'Cache dir contents:\n  $contents',
    );
  }

  print('JDK $_jdkVersion cached at ${cacheDir.path}');
  return resolvedFile.uri;
}

/// Finds the JDK subdirectory inside the cache dir.
///
/// Adoptium extracts to `jdk-17.x.x+y/`, so we need to find that dir
/// and prepend it to the library path.
String _findJdkSubdir(Directory cacheDir, String libPath) {
  if (!cacheDir.existsSync()) return libPath;
  final List<FileSystemEntity> entries = cacheDir.listSync();
  for (final entry in entries) {
    if (entry is Directory) {
      final candidate = File.fromUri(entry.uri.resolve(libPath));
      if (candidate.existsSync()) {
        // Directory URIs end with '/', so pathSegments.last is empty.
        // Use the directory's basename from the filesystem path.
        final String dirName = entry.uri.pathSegments.where((s) => s.isNotEmpty).last;
        return '$dirName/$libPath';
      }
    }
  }
  return libPath;
}

// Build hook that downloads prebuilt wasmer from GitHub releases and registers
// it as a bundled code asset. The Dart SDK automatically bundles the library
// with the application so `@Native`-annotated FFI functions resolve at runtime.
//
// Supported targets: linux-x64, linux-arm64, macOS-x64, macOS-arm64, windows-x64.
// iOS and Android require compiling wasmer from source (not yet automated).
// ignore_for_file: avoid_print
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:code_assets/code_assets.dart';
import 'package:crypto/crypto.dart';
import 'package:hooks/hooks.dart';
import 'package:http/http.dart' as http;

const _wasmerVersion = '7.0.1';

const _releaseBase = 'https://github.com/wasmerio/wasmer/releases/download/v$_wasmerVersion';

/// Maps (OS, Architecture) to (archive filename, library path inside archive, sha256).
const _downloadInfo = <(OS, Architecture), ({String archive, String libPath, String sha256})>{
  (OS.linux, Architecture.x64): (
    archive: 'wasmer-linux-amd64.tar.gz',
    libPath: 'lib/libwasmer.so',
    sha256: '', // TODO: fill in after verifying
  ),
  (OS.linux, Architecture.arm64): (
    archive: 'wasmer-linux-aarch64.tar.gz',
    libPath: 'lib/libwasmer.so',
    sha256: '',
  ),
  (OS.macOS, Architecture.x64): (
    archive: 'wasmer-darwin-amd64.tar.gz',
    libPath: 'lib/libwasmer.dylib',
    sha256: '',
  ),
  (OS.macOS, Architecture.arm64): (
    archive: 'wasmer-darwin-arm64.tar.gz',
    libPath: 'lib/libwasmer.dylib',
    sha256: '',
  ),
  (OS.windows, Architecture.x64): (
    archive: 'wasmer-windows-amd64.tar.gz',
    libPath: 'lib/wasmer.dll',
    sha256: '',
  ),
};

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final CodeConfig codeConfig = input.config.code;
    final (OS, Architecture) key = (codeConfig.targetOS, codeConfig.targetArchitecture);
    final ({String archive, String libPath, String sha256})? info = _downloadInfo[key];

    if (info == null) {
      throw UnsupportedError(
        'Wasmer prebuilt binaries are not available for '
        '${codeConfig.targetOS}-${codeConfig.targetArchitecture}. '
        'iOS and Android require compiling wasmer from Rust source.',
      );
    }

    final Uri libFile = await _downloadOrCached(
      input.outputDirectoryShared,
      info,
    );

    output.assets.code.add(
      CodeAsset(
        package: 'wasmer_runner',
        name: 'src/wasmer_bindings_generated.dart',
        linkMode: DynamicLoadingBundled(),
        file: libFile,
      ),
    );
  });
}

Future<Uri> _downloadOrCached(
  Uri outputDirectoryShared,
  ({String archive, String libPath, String sha256}) info,
) async {
  // Cache under a version+platform specific subdirectory.
  final cacheDir = Directory.fromUri(
    outputDirectoryShared.resolve('wasmer-v$_wasmerVersion/'),
  );
  final libFile = File.fromUri(cacheDir.uri.resolve(info.libPath));

  if (await libFile.exists()) {
    return libFile.uri;
  }

  final Uri url = Uri.parse('$_releaseBase/${info.archive}');
  print('Downloading wasmer v$_wasmerVersion from $url ...');
  final http.Response response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception(
      'Failed to download wasmer: HTTP ${response.statusCode}\n'
      'URL: $url',
    );
  }

  // Verify SHA-256 if provided.
  if (info.sha256.isNotEmpty) {
    final computed = sha256.convert(response.bodyBytes).toString();
    if (computed != info.sha256) {
      throw Exception(
        'SHA-256 mismatch for ${info.archive}:\n'
        '  expected: ${info.sha256}\n'
        '  computed: $computed',
      );
    }
  }

  // Extract tar.gz archive.
  print('Extracting ${info.archive} ...');
  final List<int> gzDecoded = const GZipDecoder().decodeBytes(response.bodyBytes);
  final Archive archive = TarDecoder().decodeBytes(gzDecoded);

  if (!await cacheDir.exists()) {
    await cacheDir.create(recursive: true);
  }

  for (final file in archive) {
    if (!file.isFile) continue;
    final targetFile = File.fromUri(cacheDir.uri.resolve(file.name));
    await targetFile.create(recursive: true);
    await targetFile.writeAsBytes(file.content as List<int>);
  }

  if (!await libFile.exists()) {
    throw Exception(
      'Expected library at ${libFile.path} not found after extraction.\n'
      'Archive contents: ${archive.map((ArchiveFile f) => f.name).join(', ')}',
    );
  }

  print('Wasmer v$_wasmerVersion cached at ${cacheDir.path}');
  return libFile.uri;
}

// Build hook that compiles the Swift SwiftSoupWrapper and registers the
// resulting dynamic library as a CodeAsset.
//
// On macOS: produces libSwiftSoupWrapper.dylib
// On iOS:   produces libSwiftSoupWrapper.dylib (cross-compiled)
//
// Only runs on iOS and macOS — other platforms use Rust scraper or TeaVM.
// ignore_for_file: avoid_print
import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final CodeConfig codeConfig = input.config.code;

    // Only build on iOS and macOS.
    if (codeConfig.targetOS != OS.iOS && codeConfig.targetOS != OS.macOS) {
      return;
    }

    final Uri swiftDir = input.packageRoot.resolve('swift/');
    final swiftDirFs = Directory.fromUri(swiftDir);
    if (!swiftDirFs.existsSync()) {
      throw StateError('Swift package not found at ${swiftDirFs.path}');
    }

    const libName = 'libSwiftSoupWrapper.dylib';

    final Uri libUri = await _swiftBuild(
      swiftDir: swiftDirFs,
      libName: libName,
      cacheDir: input.outputDirectoryShared,
      targetOS: codeConfig.targetOS,
      targetArch: codeConfig.targetArchitecture,
    );

    output.assets.code.add(
      CodeAsset(
        package: 'swiftsoup',
        name: 'src/swiftsoup_bindings_generated.dart',
        linkMode: DynamicLoadingBundled(),
        file: libUri,
      ),
    );
  });
}

Future<Uri> _swiftBuild({
  required Directory swiftDir,
  required String libName,
  required Uri cacheDir,
  required OS targetOS,
  required Architecture targetArch,
}) async {
  final cacheKey = '${targetOS.name}-${targetArch.name}';
  final buildCacheDir = Directory.fromUri(
    cacheDir.resolve('swiftsoup-$cacheKey/'),
  );
  final cachedLib = File(
    '${buildCacheDir.path}${Platform.pathSeparator}$libName',
  );
  if (cachedLib.existsSync()) {
    return cachedLib.uri;
  }

  print('swiftsoup: building SwiftSoupWrapper for $cacheKey ...');

  final List<String> buildArgs;
  if (targetOS == OS.macOS) {
    buildArgs = ['build', '-c', 'release'];
  } else {
    // iOS: cross-compile for arm64-apple-ios.
    final String triple = switch (targetArch) {
      Architecture.arm64 => 'arm64-apple-ios13.0',
      _ => throw UnsupportedError(
        'swiftsoup: unsupported iOS architecture $targetArch',
      ),
    };
    buildArgs = [
      'build',
      '-c',
      'release',
      '--triple',
      triple,
    ];
  }

  final ProcessResult result = await Process.run(
    'swift',
    buildArgs,
    workingDirectory: swiftDir.path,
  );

  if (result.exitCode != 0) {
    throw Exception(
      'swift build failed:\n${result.stdout}\n${result.stderr}',
    );
  }

  // Find the built library.
  final String buildDir;
  if (targetOS == OS.macOS) {
    buildDir = '${swiftDir.path}/.build/release';
  } else {
    final String triple = switch (targetArch) {
      Architecture.arm64 => 'arm64-apple-ios13.0',
      _ => 'arm64-apple-ios13.0',
    };
    buildDir = '${swiftDir.path}/.build/$triple/release';
  }

  final builtLib = File('$buildDir/$libName');
  if (!builtLib.existsSync()) {
    throw Exception('Built library not found at ${builtLib.path}');
  }

  if (!buildCacheDir.existsSync()) {
    buildCacheDir.createSync(recursive: true);
  }
  builtLib.copySync(cachedLib.path);

  print('swiftsoup: built $libName for $cacheKey');
  return cachedLib.uri;
}

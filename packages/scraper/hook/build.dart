// Build hook that compiles the Rust scraper_bridge crate and registers the
// resulting dynamic library as a CodeAsset.
//
// On Windows: produces scraper_bridge.dll
// On Linux:   produces libscraper_bridge.so
// On Android: produces libscraper_bridge.so (cross-compiled)
//
// If `cargo` is not on PATH, attempts to download and install rustup.
// ignore_for_file: avoid_print
import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final CodeConfig codeConfig = input.config.code;

    // iOS/macOS use SwiftSoup, web uses TeaVM — nothing to build.
    if (codeConfig.targetOS == OS.iOS || codeConfig.targetOS == OS.macOS) {
      return;
    }

    final String rustTarget = _rustTarget(
      codeConfig.targetOS,
      codeConfig.targetArchitecture,
    );

    final Uri cargoDir = input.packageRoot.resolve('rust/');
    final cargoDirFs = Directory.fromUri(cargoDir);
    if (!cargoDirFs.existsSync()) {
      throw StateError('Rust crate not found at ${cargoDirFs.path}');
    }

    // Ensure cargo is available.
    final String cargoExe = await _ensureCargo(input.outputDirectoryShared);

    // Build the Rust crate.
    final String libName = _libName(codeConfig.targetOS);
    final Uri libUri = await _cargoBuild(
      cargoExe: cargoExe,
      cargoDir: cargoDirFs,
      target: rustTarget,
      libName: libName,
      cacheDir: input.outputDirectoryShared,
      targetOS: codeConfig.targetOS,
    );

    output.assets.code.add(
      CodeAsset(
        package: 'scraper',
        name: 'src/scraper_bindings_generated.dart',
        linkMode: DynamicLoadingBundled(),
        file: libUri,
      ),
    );
  });
}

String _rustTarget(OS os, Architecture arch) {
  return switch ((os, arch)) {
    (OS.windows, Architecture.x64) => 'x86_64-pc-windows-msvc',
    (OS.linux, Architecture.x64) => 'x86_64-unknown-linux-gnu',
    (OS.linux, Architecture.arm64) => 'aarch64-unknown-linux-gnu',
    (OS.android, Architecture.arm64) => 'aarch64-linux-android',
    (OS.android, Architecture.arm) => 'armv7-linux-androideabi',
    (OS.android, Architecture.x64) => 'x86_64-linux-android',
    _ => throw UnsupportedError(
      'scraper: unsupported target $os-$arch',
    ),
  };
}

String _libName(OS os) {
  return switch (os) {
    OS.windows => 'scraper_bridge.dll',
    _ => 'libscraper_bridge.so',
  };
}

Future<String> _ensureCargo(Uri sharedDir) async {
  // Check if cargo is already available.
  final ProcessResult whichResult = await Process.run(
    Platform.isWindows ? 'where' : 'which',
    ['cargo'],
    runInShell: true,
  );
  if (whichResult.exitCode == 0) {
    return 'cargo';
  }

  // Check if rustup was previously installed by us.
  final rustupDir = Directory.fromUri(
    sharedDir.resolve('rustup/'),
  );
  final cargoHome = '${rustupDir.path}${Platform.pathSeparator}cargo';
  final cargoBin =
      '$cargoHome${Platform.pathSeparator}bin${Platform.pathSeparator}cargo${Platform.isWindows ? '.exe' : ''}';
  if (File(cargoBin).existsSync()) {
    return cargoBin;
  }

  print('scraper: cargo not found, installing Rust toolchain via rustup ...');
  if (!rustupDir.existsSync()) {
    rustupDir.createSync(recursive: true);
  }

  final rustupInit = Platform.isWindows
      ? '${rustupDir.path}${Platform.pathSeparator}rustup-init.exe'
      : '${rustupDir.path}${Platform.pathSeparator}rustup-init';

  // Download rustup-init.
  final url = Platform.isWindows
      ? 'https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe'
      : 'https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init';

  final ProcessResult dlResult = await Process.run(
    'curl',
    ['-sSfL', '-o', rustupInit, url],
    runInShell: true,
  );
  if (dlResult.exitCode != 0) {
    throw Exception(
      'Failed to download rustup-init: ${dlResult.stderr}',
    );
  }

  if (!Platform.isWindows) {
    await Process.run('chmod', ['+x', rustupInit]);
  }

  // Install with custom CARGO_HOME and RUSTUP_HOME.
  final ProcessResult installResult = await Process.run(
    rustupInit,
    ['--default-toolchain', 'stable', '-y', '--no-modify-path'],
    environment: {
      'CARGO_HOME': cargoHome,
      'RUSTUP_HOME': '${rustupDir.path}${Platform.pathSeparator}rustup',
    },
    runInShell: true,
  );
  if (installResult.exitCode != 0) {
    throw Exception(
      'rustup-init failed: ${installResult.stderr}',
    );
  }

  if (!File(cargoBin).existsSync()) {
    throw Exception('cargo binary not found after rustup installation');
  }

  print('scraper: Rust toolchain installed.');
  return cargoBin;
}

Future<Uri> _cargoBuild({
  required String cargoExe,
  required Directory cargoDir,
  required String target,
  required String libName,
  required Uri cacheDir,
  required OS targetOS,
}) async {
  // Check if already built and cached.
  final buildCacheDir = Directory.fromUri(
    cacheDir.resolve('scraper-$target/'),
  );
  final cachedLib = File('${buildCacheDir.path}${Platform.pathSeparator}$libName');
  if (cachedLib.existsSync()) {
    return cachedLib.uri;
  }

  print('scraper: building scraper_bridge for $target ...');

  final Map<String, String> env = {
    ...Platform.environment,
  };

  // For Android targets, set up NDK linker and ensure the Rust target is
  // installed (CI runners typically only have the host target).
  if (targetOS == OS.android) {
    _setupAndroidNdk(env, target);
    await _ensureRustTarget(cargoExe, target);
  }

  final ProcessResult result = await Process.run(
    cargoExe,
    ['build', '--release', '--target', target],
    workingDirectory: cargoDir.path,
    environment: env,
  );

  if (result.exitCode != 0) {
    throw Exception(
      'cargo build failed:\n${result.stdout}\n${result.stderr}',
    );
  }

  // Copy the built library to the cache.
  final builtLib = File(
    '${cargoDir.path}${Platform.pathSeparator}target${Platform.pathSeparator}$target${Platform.pathSeparator}release${Platform.pathSeparator}$libName',
  );
  if (!builtLib.existsSync()) {
    throw Exception(
      'Built library not found at ${builtLib.path}',
    );
  }

  if (!buildCacheDir.existsSync()) {
    buildCacheDir.createSync(recursive: true);
  }
  builtLib.copySync(cachedLib.path);

  print('scraper: built $libName for $target');
  return cachedLib.uri;
}

/// Ensure the given Rust target triple is installed via `rustup target add`.
Future<void> _ensureRustTarget(String cargoExe, String target) async {
  // Derive rustup path from cargo path (sibling binary in the same bin dir).
  final cargoFile = File(cargoExe);
  final String binDir = cargoFile.parent.path;
  final rustupExe = '$binDir${Platform.pathSeparator}rustup${Platform.isWindows ? '.exe' : ''}';
  final exe = File(rustupExe).existsSync() ? rustupExe : 'rustup';

  final ProcessResult result = await Process.run(
    exe,
    ['target', 'add', target],
    runInShell: true,
  );
  if (result.exitCode != 0) {
    throw Exception(
      'rustup target add $target failed:\n${result.stdout}\n${result.stderr}',
    );
  }
  print('scraper: ensured Rust target $target is installed');
}

void _setupAndroidNdk(Map<String, String> env, String target) {
  // Discover NDK from explicit env vars or by scanning the Android SDK.
  final String? ndkHome = env['ANDROID_NDK_HOME'] ?? env['ANDROID_NDK_ROOT'] ?? _findNdkInSdk(env);
  if (ndkHome == null || ndkHome.isEmpty) {
    throw Exception(
      'ANDROID_NDK_HOME not set and no NDK found in ANDROID_HOME/ANDROID_SDK_ROOT '
      '— required for Android cross-compilation.',
    );
  }

  // NDK clang is at: <ndk>/toolchains/llvm/prebuilt/<host>/bin/<triple><api>-clang
  final host = Platform.isWindows
      ? 'windows-x86_64'
      : Platform.isMacOS
      ? 'darwin-x86_64'
      : 'linux-x86_64';

  // Map Rust target triple to NDK clang prefix.
  final String ndkTriple = switch (target) {
    'aarch64-linux-android' => 'aarch64-linux-android',
    'armv7-linux-androideabi' => 'armv7a-linux-androideabi',
    'x86_64-linux-android' => 'x86_64-linux-android',
    _ => throw UnsupportedError('Unknown Android target: $target'),
  };

  const api = '21';
  final clang = '$ndkHome/toolchains/llvm/prebuilt/$host/bin/$ndkTriple$api-clang${Platform.isWindows ? '.cmd' : ''}';

  // CARGO_TARGET_<TRIPLE>_LINKER env var (triple in UPPER_SNAKE_CASE).
  final envKey = 'CARGO_TARGET_${target.toUpperCase().replaceAll('-', '_')}_LINKER';
  env[envKey] = clang;
}

/// Scan `<ANDROID_HOME>/ndk/` for the highest-versioned installed NDK.
String? _findNdkInSdk(Map<String, String> env) {
  final String? sdkRoot = env['ANDROID_HOME'] ?? env['ANDROID_SDK_ROOT'];
  if (sdkRoot == null || sdkRoot.isEmpty) return null;

  final ndkDir = Directory('$sdkRoot${Platform.pathSeparator}ndk');
  if (!ndkDir.existsSync()) return null;

  // Each subdirectory is a version like "27.0.12077973".
  final List<String> versions = ndkDir.listSync().whereType<Directory>().map((d) => d.path).toList()..sort();

  if (versions.isEmpty) return null;

  final String found = versions.last;
  print('scraper: auto-discovered NDK at $found');
  return found;
}

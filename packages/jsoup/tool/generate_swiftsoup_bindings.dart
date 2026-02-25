// Generates Dart FFI bindings for the SwiftSoupWrapper using swiftgen.
//
// Prerequisites:
//   - macOS with Xcode and Swift toolchain installed
//   - Run: dart pub get
//
// Usage:
//   cd packages/jsoup
//   dart run tool/generate_swiftsoup_bindings.dart
//
// This will:
// 1. Build the SwiftSoupWrapper Swift package into a .dylib
// 2. Use swiftgen to generate Dart FFI bindings
// 3. Output bindings to lib/src/swift/bindings/
//
// After generation, the SwiftSoupParser class in swift/swift_parser.dart
// should be updated to use the generated bindings.

// ignore_for_file: avoid_print

import 'dart:io';

void main() async {
  final String packageDir = Directory.current.path;
  final swiftDir = '$packageDir/swift';
  final outputDir = '$packageDir/lib/src/bindings/swiftsoup';

  // Step 1: Build the Swift package.
  print('Building SwiftSoupWrapper ...');
  final ProcessResult buildResult = await Process.run(
    'swift',
    ['build', '-c', 'release'],
    workingDirectory: swiftDir,
  );
  if (buildResult.exitCode != 0) {
    stderr.write('Swift build failed:\n${buildResult.stderr}');
    exit(1);
  }
  print('Swift build succeeded.');

  // Step 2: Ensure output directory exists.
  final outDir = Directory(outputDir);
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  // Step 3: Generate bindings using ffigen with the compiled dylib.
  // Note: swiftgen automates swift2objc + ffigen, but if swiftgen is not
  // available, you can use ffigen directly with an Objective-C header.
  //
  // For now, we generate a minimal ffigen config programmatically.
  print('''

=== Manual Steps Required ===

swiftgen is experimental and may not be available. To generate bindings:

1. Compile the Swift package:
   cd $swiftDir
   swift build -c release

2. Option A: Use swiftgen (if available):
   dart run swiftgen --config swiftgen.yaml

3. Option B: Use ffigen directly:
   a. Export Objective-C headers from the compiled Swift module:
      xcrun swift-frontend -emit-objc-header \\
        -module-name SwiftSoupWrapper \\
        swift/Sources/SwiftSoupWrapper.swift \\
        -o $outputDir/SwiftSoupWrapper.h
   b. Run ffigen with the generated header:
      dart run ffigen --config ffigen_swiftsoup.yaml

4. Copy generated bindings to lib/src/bindings/swiftsoup/

The generated bindings should expose SwiftSoupBridge class methods that
match the NativeHtmlParser interface.
''');
}

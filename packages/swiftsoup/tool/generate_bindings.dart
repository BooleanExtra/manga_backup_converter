// Generates Dart FFI bindings for the SwiftSoupWrapper using ffigen.
//
// Prerequisites:
//   - macOS with Xcode and Swift toolchain installed
//   - Run: dart pub get
//
// Usage:
//   cd packages/swiftsoup
//   dart run tool/generate_bindings.dart
//
// This will:
// 1. Build the Swift package (SPM) to produce the ObjC header
// 2. Auto-extract the SwiftSoupBridge @interface from the SPM-generated header
// 3. Write filtered header to swift/SwiftSoupBridge.h (auto-generated)
// 4. Run ffigen to output bindings to lib/src/swiftsoup_bindings_generated.dart

// ignore_for_file: avoid_print

import 'dart:io';

Future<void> main() async {
  final String packageDir = Directory.current.path;
  final swiftDir = '$packageDir/swift';

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

  // Step 2: Find and read the SPM-generated ObjC header.
  final File? generatedHeader = _findGeneratedHeader(swiftDir);
  if (generatedHeader == null) {
    stderr.writeln(
      'Could not find SwiftSoupWrapper-Swift.h in SPM build output.',
    );
    stderr.writeln('Searched in: $swiftDir/.build/');
    exit(1);
  }
  print('Found SPM header: ${generatedHeader.path}');

  final String headerContent = generatedHeader.readAsStringSync();

  // Step 3: Extract the SwiftSoupBridge @interface block and write filtered
  // header.
  final String? filteredHeader = _extractBridgeInterface(headerContent);
  if (filteredHeader == null) {
    stderr.writeln(
      'Could not find @interface SwiftSoupBridge in generated header.',
    );
    exit(1);
  }

  final outputHeader = File('$swiftDir/SwiftSoupBridge.h');
  outputHeader.writeAsStringSync(filteredHeader);
  print('Wrote filtered header: ${outputHeader.path}');

  // Step 4: Run ffigen with the filtered header.
  print('Generating Dart bindings with ffigen ...');
  final ProcessResult genResult = await Process.run(
    'dart',
    ['run', 'ffigen', '--config', 'ffigen.yaml'],
    workingDirectory: packageDir,
  );
  stdout.write(genResult.stdout);
  if (genResult.exitCode != 0) {
    stderr.write('ffigen failed:\n${genResult.stderr}');
    exit(1);
  }
  print('Bindings generated successfully.');
}

/// Finds the SPM-generated SwiftSoupWrapper-Swift.h header in the build
/// directory. Searches for release configuration first, then debug.
File? _findGeneratedHeader(String swiftDir) {
  final buildDir = Directory('$swiftDir/.build');
  if (!buildDir.existsSync()) return null;

  // Look for SwiftSoupWrapper-Swift.h under any architecture triple.
  // Pattern: .build/<triple>/release/SwiftSoupWrapper.build/include/...
  for (final config in ['release', 'debug']) {
    final List<FileSystemEntity> entities = buildDir.listSync();
    for (final entity in entities) {
      if (entity is! Directory) continue;
      final String name = entity.uri.pathSegments.reversed.firstWhere((s) => s.isNotEmpty);
      // Skip non-triple directories.
      if (name == 'index-build' ||
          name == 'repositories' ||
          name == 'artifacts' ||
          name == 'checkouts' ||
          name == 'manifest.db' ||
          name == 'workspace-state.json') {
        continue;
      }
      final headerPath =
          '${entity.path}/$config/SwiftSoupWrapper.build/include/'
          'SwiftSoupWrapper-Swift.h';
      final headerFile = File(headerPath);
      if (headerFile.existsSync()) return headerFile;
    }
  }
  return null;
}

/// Extracts the @interface SwiftSoupBridge block from the full SPM-generated
/// header, strips Swift macros (SWIFT_WARN_UNUSED_RESULT, SWIFT_CLASS, etc.),
/// and wraps it with minimal includes.
String? _extractBridgeInterface(String headerContent) {
  final List<String> lines = headerContent.split('\n');

  // Find @interface SwiftSoupBridge line (may be preceded by SWIFT_CLASS).
  var startIndex = -1;
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].contains('@interface SwiftSoupBridge')) {
      startIndex = i;
      break;
    }
  }
  if (startIndex < 0) return null;

  // Find @end.
  var endIndex = -1;
  for (var i = startIndex; i < lines.length; i++) {
    if (lines[i].trim() == '@end') {
      endIndex = i;
      break;
    }
  }
  if (endIndex < 0) return null;

  // Extract interface lines, cleaning up Swift macros.
  final interfaceLines = <String>[];
  for (var i = startIndex; i <= endIndex; i++) {
    String line = lines[i];

    // Strip SWIFT_CLASS(...) decorator line — the module mapping in
    // ffigen.yaml handles the Swift runtime class name.
    if (line.contains('SWIFT_CLASS(')) continue;

    // Strip SWIFT_WARN_UNUSED_RESULT.
    line = line.replaceAll(' SWIFT_WARN_UNUSED_RESULT', '');

    // Strip OBJC_DESIGNATED_INITIALIZER.
    line = line.replaceAll(' OBJC_DESIGNATED_INITIALIZER', '');

    // Skip the init method — not needed for static-only bridge.
    if (line.contains('- (nonnull instancetype)init')) continue;

    interfaceLines.add(line);
  }

  final buf = StringBuffer();
  buf.writeln(
    '// AUTO GENERATED FILE, DO NOT EDIT.',
  );
  buf.writeln(
    '// Generated by tool/generate_bindings.dart from '
    'SwiftSoupWrapper-Swift.h.',
  );
  buf.writeln(
    '// Re-run: cd packages/swiftsoup && '
    'dart run tool/generate_bindings.dart',
  );
  buf.writeln();
  buf.writeln('#include <stdint.h>');
  buf.writeln('#include <stdbool.h>');
  buf.writeln();
  buf.writeln('#import <Foundation/NSObject.h>');
  buf.writeln('#import <Foundation/NSString.h>');
  buf.writeln('#import <Foundation/NSArray.h>');
  buf.writeln();
  buf.writeln('@class NSNumber;');
  buf.writeln();
  for (final line in interfaceLines) {
    buf.writeln(line);
  }
  buf.writeln();

  return buf.toString();
}

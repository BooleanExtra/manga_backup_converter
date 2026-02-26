// test/wasm_imports_audit_test.dart
//
// WASM Import Audit — enumerates every import declared by the 4 fixture binaries
// and asserts that each is either registered in buildAidokuHostImports() or
// belongs to a known-stub module (canvas / js).
//
// Also prints a binary-verified import table useful for updating WASM_ABI.md.
//
// Run: dart test packages/wasmer_runner/test/wasm_imports_audit_test.dart --reporter expanded
// ignore_for_file: avoid_print
@TestOn('vm')
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasmer_runner/wasmer_runner.dart';

// ---------------------------------------------------------------------------
// Guards
// ---------------------------------------------------------------------------

/// Resolves fixture paths relative to the sibling `aidoku_plugin_loader`
/// package. This creates a cross-package dependency on
/// `packages/aidoku_plugin_loader/test/aidoku/fixtures/` — if the fixture
/// directory moves or is renamed, this function must be updated to match.
File _findFixture(String relPath) {
  // When run from packages/wasmer_runner/
  final a = File('../aidoku_plugin_loader/$relPath');
  if (a.existsSync()) return a;
  // When run from repo root
  return File('packages/aidoku_plugin_loader/$relPath');
}

// ---------------------------------------------------------------------------
// Registered import set — derived from buildAidokuHostImports() in aidoku_host.dart.
// Update this set whenever aidoku_host.dart gains or loses handlers.
// ---------------------------------------------------------------------------

const Set<String> _registeredImports = <String>{
  // std module
  'std::destroy',
  'std::buffer_len',
  'std::_read_buffer',
  'std::read_buffer',
  'std::_current_date',
  'std::current_date',
  'std::utc_offset',
  'std::_parse_date',
  'std::parse_date',
  // env module
  'env::_print',
  'env::print',
  'env::_sleep',
  'env::abort',
  'env::_send_partial_result',
  'env::send_partial_result',
  // net module
  'net::init',
  'net::set_url',
  'net::set_header',
  'net::set_body',
  'net::set_timeout',
  'net::send',
  'net::send_all',
  'net::data_len',
  'net::read_data',
  'net::get_status_code',
  'net::get_header',
  'net::html',
  'net::get_image',
  'net::net_set_rate_limit',
  'net::set_rate_limit',
  // html module
  'html::parse',
  'html::parse_fragment',
  'html::select',
  'html::select_first',
  'html::attr',
  'html::has_attr',
  'html::text',
  'html::own_text',
  'html::untrimmed_text',
  'html::html',
  'html::outer_html',
  'html::tag_name',
  'html::id',
  'html::class_name',
  'html::base_uri',
  'html::first',
  'html::last',
  'html::get',
  'html::html_get',
  'html::size',
  'html::parent',
  'html::children',
  'html::next',
  'html::previous',
  'html::siblings',
  'html::set_text',
  'html::set_html',
  'html::remove',
  'html::escape',
  'html::unescape',
  'html::has_class',
  'html::add_class',
  'html::remove_class',
  'html::set_attr',
  'html::remove_attr',
  'html::prepend',
  'html::append',
  'html::data',
  // defaults module
  'defaults::get',
  'defaults::set',
  // canvas module
  'canvas::new_context',
  'canvas::set_transform',
  'canvas::draw_image',
  'canvas::copy_image',
  'canvas::fill',
  'canvas::stroke',
  'canvas::draw_text',
  'canvas::get_image',
  'canvas::new_font',
  'canvas::system_font',
  'canvas::load_font',
  'canvas::new_image',
  'canvas::get_image_data',
  'canvas::get_image_width',
  'canvas::get_image_height',
};

/// Modules whose functions are intentionally stubbed (return −1 / no-op).
/// Imports from these modules are expected and need no individual registration.
const Set<String> _knownStubModules = <String>{'js'};

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _kindStr(int k) => switch (k) {
  0 => 'i32',
  1 => 'i64',
  2 => 'f32',
  3 => 'f64',
  _ => 'void',
};

void _printTable(
  String fixtureName,
  List<({String module, String name, int resultKind})> imports,
) {
  print('\n=== $fixtureName (${imports.length} imports) ===');
  print('| module       | name                   | result | registered |');
  print('|--------------|------------------------|--------|------------|');
  for (final imp in imports) {
    final key = '${imp.module}::${imp.name}';
    final bool isStubModule = _knownStubModules.contains(imp.module);
    final status = _registeredImports.contains(key)
        ? 'yes'
        : isStubModule
        ? 'stub'
        : '*** MISSING ***';
    print(
      '| ${imp.module.padRight(12)} | ${imp.name.padRight(22)} | ${_kindStr(imp.resultKind).padRight(6)} | $status |',
    );
  }
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const List<({String label, String wasmPath})> _fixtures = <({String label, String wasmPath})>[
  (label: 'multi.mangadex-v12', wasmPath: 'test/aidoku/fixtures/multi.mangadex-v12/Payload/main.wasm'),
  (label: 'en.asurascans-v11', wasmPath: 'test/aidoku/fixtures/en.asurascans-v11/Payload/main.wasm'),
  (label: 'en.weebcentral-v6', wasmPath: 'test/aidoku/fixtures/en.weebcentral-v6/Payload/main.wasm'),
  (label: 'multi.mangafire-v5', wasmPath: 'test/aidoku/fixtures/multi.mangafire-v5/Payload/main.wasm'),
];

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  final List<String> missingFixtures = _fixtures
      .where((({String label, String wasmPath}) f) => !_findFixture(f.wasmPath).existsSync())
      .map((({String label, String wasmPath}) f) => f.label)
      .toList();

  final String? skipReason = missingFixtures.isNotEmpty
      ? 'Missing fixture WASM(s): ${missingFixtures.join(', ')}'
      : null;

  group(
    'WASM import audit',
    skip: skipReason,
    () {
      // Collect imports per fixture once for the summary table.
      final allImports = <String, List<({String module, String name, int resultKind})>>{};

      setUpAll(() {
        for (final ({String label, String wasmPath}) f in _fixtures) {
          final File file = _findFixture(f.wasmPath);
          if (!file.existsSync()) continue;
          final Uint8List bytes = file.readAsBytesSync();
          allImports[f.label] = WasmerRunner.listImports(bytes);
        }
      });

      for (final ({String label, String wasmPath}) fixture in _fixtures) {
        test('${fixture.label} — all imports registered or known-stub', () {
          final List<({String module, String name, int resultKind})>? imports = allImports[fixture.label];
          if (imports == null) {
            // Fixture not present — skip (handled by group skip above).
            return;
          }

          _printTable(fixture.label, imports);

          final List<({String module, String name, int resultKind})> unexpected = imports.where((
            ({String module, String name, int resultKind}) imp,
          ) {
            final key = '${imp.module}::${imp.name}';
            return !_registeredImports.contains(key) && !_knownStubModules.contains(imp.module);
          }).toList();

          check(
            unexpected,
            because:
                'These imports are silently stubbed with -1.\n'
                'Add handlers in aidoku_host.dart or add module to _knownStubModules:\n'
                '  ${unexpected.map((({String module, String name, int resultKind}) i) => '${i.module}::${i.name} (→${_kindStr(i.resultKind)})').join(', ')}',
          ).isEmpty();
        });
      }

      test('aggregate — print unique imports across all fixtures', () {
        final unique = <String, ({int resultKind, List<String> fixtures})>{};
        for (final ({String label, String wasmPath}) f in _fixtures) {
          for (final ({String module, String name, int resultKind}) imp
              in allImports[f.label] ?? <({String module, String name, int resultKind})>[]) {
            final key = '${imp.module}::${imp.name}';
            final ({List<String> fixtures, int resultKind})? entry = unique[key];
            if (entry == null) {
              unique[key] = (resultKind: imp.resultKind, fixtures: <String>[f.label]);
            } else {
              entry.fixtures.add(f.label);
            }
          }
        }

        final List<MapEntry<String, ({List<String> fixtures, int resultKind})>> sorted = unique.entries.toList()
          ..sort(
            (
              MapEntry<String, ({List<String> fixtures, int resultKind})> a,
              MapEntry<String, ({List<String> fixtures, int resultKind})> b,
            ) => a.key.compareTo(b.key),
          );

        print('\n=== Aggregate: ${sorted.length} unique imports across all fixtures ===');
        print('| module       | name                   | result | mangadex | asurascans | weebcentral | mangafire |');
        print('|--------------|------------------------|--------|----------|------------|-------------|-----------|');
        for (final e in sorted) {
          final List<String> parts = e.key.split('::');
          final String mod = parts[0];
          final String nm = parts[1];
          final List<String> fixtures = e.value.fixtures;
          final md = fixtures.contains('multi.mangadex-v12') ? 'yes' : '-';
          final as_ = fixtures.contains('en.asurascans-v11') ? 'yes' : '-';
          final wc = fixtures.contains('en.weebcentral-v6') ? 'yes' : '-';
          final mf = fixtures.contains('multi.mangafire-v5') ? 'yes' : '-';
          print(
            '| ${mod.padRight(12)} | ${nm.padRight(22)} | ${_kindStr(e.value.resultKind).padRight(6)} | ${md.padRight(8)} | ${as_.padRight(10)} | ${wc.padRight(11)} | ${mf.padRight(9)} |',
          );
        }
      });
    },
  );
}

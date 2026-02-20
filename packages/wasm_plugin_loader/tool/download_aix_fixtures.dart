// Run from packages/wasm_plugin_loader/:
//   dart run tool/download_aix_fixtures.dart

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wasm_plugin_loader/src/source_list/source_entry.dart';
import 'package:wasm_plugin_loader/src/source_list/source_list.dart';
import 'package:wasm_plugin_loader/src/source_list/source_list_manager.dart';

const Set<String> _targetIds = <String>{'en.asurascans', 'en.weebcentral', 'multi.mangafire'};
const String _outputDir = 'test/aidoku/fixtures';

Future<void> main() async {
  final client = http.Client();
  final mgr = SourceListManager(httpClient: client);

  print('Fetching source list...');
  final RemoteSourceList? list = await mgr.fetchSourceList(kAidokuCommunitySourceListUrl);
  if (list == null) {
    stderr.writeln('Failed to fetch source list.');
    client.close();
    exit(1);
  }
  print('Found ${list.sources.length} sources in "${list.name}"');

  // Base URL = everything up to and including the last '/'
  final String baseUrl = list.url.substring(0, list.url.lastIndexOf('/') + 1);

  final List<SourceEntry> targets = list.sources.where((SourceEntry s) => _targetIds.contains(s.id)).toList();

  if (targets.isEmpty) {
    stderr.writeln('No matching sources found for IDs: $_targetIds');
    client.close();
    exit(1);
  }

  for (final source in targets) {
    final url = '$baseUrl${source.downloadUrl}';
    final String filename = source.downloadUrl.split('/').last;
    final outFile = File('$_outputDir/$filename');

    if (outFile.existsSync()) {
      print('[$filename] already exists, skipping');
      continue;
    }

    print('Downloading $filename from $url ...');
    try {
      final http.Response resp = await client.get(Uri.parse(url)).timeout(const Duration(minutes: 2));
      if (resp.statusCode == 200) {
        outFile.writeAsBytesSync(resp.bodyBytes);
        print('  -> saved ${resp.bodyBytes.length} bytes');
      } else {
        stderr.writeln('  -> HTTP ${resp.statusCode}');
      }
    } on Object catch (e) {
      stderr.writeln('  -> Error downloading $filename: $e');
    }
  }

  client.close();
  print('Done.');
}

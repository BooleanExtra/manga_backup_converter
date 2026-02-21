import 'dart:typed_data';

import 'package:aidoku_plugin_loader/aidoku_plugin_loader.dart';
import 'package:http/http.dart' as http;
import 'package:mangabackupconverter_cli/src/pipeline/extension_entry.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source_aidoku.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source_stub.dart';

sealed class PluginLoader {
  const PluginLoader();

  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  });

  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  });
}

class AidokuPluginLoader extends PluginLoader {
  const AidokuPluginLoader();

  @override
  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  }) async {
    final entries = <ExtensionEntry>[];
    final manager = SourceListManager();
    for (final url in repoUrls) {
      try {
        final RemoteSourceList sourceList = await manager.fetchRemoteSourceList(url);
        entries.addAll(sourceList.sources.map(AidokuExtensionEntry.fromSourceEntry));
      } on Object catch (e) {
        onWarning?.call('Failed to fetch repo $url: $e');
      }
    }
    return entries;
  }

  @override
  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  }) async {
    final loader = AidokuPluginMemoryStore();
    final plugins = <PluginSource>[];
    for (final (int i, ExtensionEntry extension_) in extensions.indexed) {
      final entry = extension_ as AidokuExtensionEntry;
      onProgress?.call(i + 1, extensions.length, 'Loading plugin: ${entry.name}');
      try {
        final http.Response response = await http.get(Uri.parse(entry.downloadUrl));
        if (response.statusCode != 200) {
          onProgress?.call(
            i + 1,
            extensions.length,
            'Warning: failed to download ${entry.name}: HTTP ${response.statusCode}',
          );
          continue;
        }
        final AidokuPlugin plugin = await loader.loadAixBytes(Uint8List.fromList(response.bodyBytes));
        plugins.add(AidokuPluginSource(plugin: plugin));
      } on Object catch (e) {
        onProgress?.call(i + 1, extensions.length, 'Warning: failed to load ${entry.name}: $e');
      }
    }
    return plugins;
  }
}

class PaperbackPluginLoader extends PluginLoader {
  const PaperbackPluginLoader();

  @override
  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  }) async => <ExtensionEntry>[];

  @override
  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  }) async => extensions
      .map(
        (ExtensionEntry e) => StubPluginSource(sourceId: e.id, sourceName: e.name),
      )
      .toList();
}

class TachiPluginLoader extends PluginLoader {
  const TachiPluginLoader();

  @override
  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  }) async => <ExtensionEntry>[];

  @override
  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  }) async => extensions
      .map(
        (ExtensionEntry e) => StubPluginSource(sourceId: e.id, sourceName: e.name),
      )
      .toList();
}

class MangayomiPluginLoader extends PluginLoader {
  const MangayomiPluginLoader();

  @override
  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  }) async => <ExtensionEntry>[];

  @override
  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  }) async => extensions
      .map(
        (ExtensionEntry e) => StubPluginSource(sourceId: e.id, sourceName: e.name),
      )
      .toList();
}

import 'dart:typed_data';

import 'package:aidoku_plugin_loader/aidoku_plugin_loader.dart';
import 'package:http/http.dart' as http;
import 'package:mangabackupconverter_cli/src/pipeline/extension_entry.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source_aidoku.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source_stub.dart';

abstract class PluginLoader {
  const PluginLoader();

  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  });

  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  });

  /// Downloads raw plugin bytes for [entry]. Returns null if not downloadable.
  Future<Uint8List?> downloadPluginBytes(ExtensionEntry entry) async => null;

  /// Loads a plugin from raw [bytes] for [entry]. Returns null if not supported.
  Future<PluginSource?> loadPluginFromBytes(
    ExtensionEntry entry,
    Uint8List bytes,
  ) async => null;
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
        final Uri sourceListUri = Uri.parse(sourceList.url);
        entries.addAll(
          sourceList.sources.map((SourceEntry s) {
            final downloadUrl = sourceListUri.resolve(s.downloadUrl).toString();
            final iconUrl = sourceListUri.resolve(s.iconUrl).toString();
            return AidokuExtensionEntry(
              id: s.id,
              name: s.name,
              languages: s.languages,
              version: s.version,
              iconUrl: iconUrl,
              downloadUrl: downloadUrl,
              contentRating: s.contentRating,
              baseUrl: s.baseUrl,
              altNames: s.altNames,
            );
          }),
        );
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
    final plugins = <PluginSource>[];
    for (final (int i, ExtensionEntry extension_) in extensions.indexed) {
      final entry = extension_ as AidokuExtensionEntry;
      try {
        onProgress?.call(
          i + 1,
          extensions.length,
          'Loading plugin: ${entry.name}',
        );
        final http.Response response = await http.get(Uri.parse(entry.downloadUrl));
        if (response.statusCode != 200) {
          onProgress?.call(
            i + 1,
            extensions.length,
            'Warning: failed to download ${entry.name}: '
            'HTTP ${response.statusCode}',
          );
          continue;
        }
        final bytes = Uint8List.fromList(response.bodyBytes);
        final AidokuPlugin plugin = await AidokuPlugin.fromAix(
          bytes,
          defaults: entry.baseUrl != null ? <String, dynamic>{'url': entry.baseUrl} : null,
        );
        plugins.add(AidokuPluginSource(plugin: plugin));
      } on Object catch (e) {
        onProgress?.call(
          i + 1,
          extensions.length,
          'Warning: failed to load ${entry.name}: $e',
        );
      }
    }
    return plugins;
  }

  @override
  Future<Uint8List?> downloadPluginBytes(ExtensionEntry entry) async {
    final aidokuEntry = entry as AidokuExtensionEntry;
    final http.Response response = await http.get(Uri.parse(aidokuEntry.downloadUrl));
    if (response.statusCode != 200) return null;
    return Uint8List.fromList(response.bodyBytes);
  }

  @override
  Future<PluginSource?> loadPluginFromBytes(
    ExtensionEntry entry,
    Uint8List bytes,
  ) async {
    final aidokuEntry = entry as AidokuExtensionEntry;
    final AidokuPlugin plugin = await AidokuPlugin.fromAix(
      bytes,
      defaults: aidokuEntry.baseUrl != null ? <String, dynamic>{'url': aidokuEntry.baseUrl} : null,
    );
    return AidokuPluginSource(plugin: plugin);
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

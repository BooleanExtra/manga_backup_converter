import 'dart:typed_data';

import 'package:mangabackupconverter_cli/src/commands/plugin_cache.dart';
import 'package:mangabackupconverter_cli/src/pipeline/extension_entry.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_loader.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';

class CachingPluginLoader extends PluginLoader {
  const CachingPluginLoader(this._inner, {required this.cache});

  final PluginLoader _inner;
  final PluginCache cache;

  @override
  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  }) => _inner.fetchExtensionLists(repoUrls, onWarning: onWarning);

  @override
  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  }) async {
    final plugins = <PluginSource>[];
    for (final (int i, ExtensionEntry entry) in extensions.indexed) {
      try {
        Uint8List? bytes = cache.get(entry);
        final cached = bytes != null;
        if (!cached) {
          onProgress?.call(
            i + 1,
            extensions.length,
            'Loading plugin: ${entry.name}',
          );
          bytes = await _inner.downloadPluginBytes(entry);
          if (bytes == null) {
            // Inner loader doesn't support per-entry download; fall through.
            final List<PluginSource> result = await _inner.loadPlugins(
              <ExtensionEntry>[entry],
              onProgress: onProgress,
            );
            plugins.addAll(result);
            continue;
          }
          cache.put(entry, bytes);
        } else {
          onProgress?.call(
            i + 1,
            extensions.length,
            'Loading plugin: ${entry.name} (cached)',
          );
        }
        final PluginSource? plugin = await _inner.loadPluginFromBytes(entry, bytes);
        if (plugin != null) {
          plugins.add(plugin);
        } else {
          onProgress?.call(
            i + 1,
            extensions.length,
            'Warning: failed to load ${entry.name}: unsupported format',
          );
        }
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
}

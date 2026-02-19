import 'dart:typed_data';
import 'package:wasm_plugin_loader/src/aidoku/aidoku_plugin.dart';
import 'package:wasm_plugin_loader/src/models/source_info.dart';

/// Registry for loaded Aidoku WASM source plugins.
/// Plugins are keyed by their source ID (e.g. 'multi.mangadex').
class WasmPluginLoader {
  WasmPluginLoader();

  final _plugins = <String, AidokuPlugin>{};

  /// Load a plugin from .aix bytes and register it.
  Future<AidokuPlugin> load(Uint8List aixBytes, {Map<String, dynamic>? defaults}) async {
    final plugin = await AidokuPlugin.fromAix(aixBytes, defaults: defaults);
    _plugins[plugin.sourceInfo.id] = plugin;
    return plugin;
  }

  /// Find a loaded plugin by source ID, or null if not loaded.
  AidokuPlugin? findBySourceId(String sourceId) => _plugins[sourceId];

  /// All currently loaded source infos.
  List<SourceInfo> get loadedSources => _plugins.values.map((p) => p.sourceInfo).toList();

  /// Unload a plugin by source ID.
  void unload(String sourceId) => _plugins.remove(sourceId);
}

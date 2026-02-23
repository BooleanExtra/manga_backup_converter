import 'dart:io';
import 'dart:typed_data';

import 'package:mangabackupconverter_cli/src/pipeline/extension_entry.dart';
import 'package:path/path.dart' as p;

class PluginCache {
  PluginCache({Directory? cacheDir})
    : cacheDir =
          cacheDir ??
          Directory(
            p.join(
              Directory.systemTemp.path,
              'manga_backup_converter',
              'plugins',
            ),
          );

  final Directory cacheDir;

  File cacheFileFor(ExtensionEntry entry) => File(p.join(cacheDir.path, entry.cacheKey));

  Uint8List? get(ExtensionEntry entry) {
    final File file = cacheFileFor(entry);
    return file.existsSync() ? file.readAsBytesSync() : null;
  }

  void put(ExtensionEntry entry, Uint8List bytes) {
    _cleanOldVersions(entry.id, entry.cacheKey);
    final File file = cacheFileFor(entry);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(bytes);
  }

  void _cleanOldVersions(String id, String currentCacheKey) {
    if (!cacheDir.existsSync()) return;
    final prefix = '$id-';
    final currentName = currentCacheKey;
    for (final FileSystemEntity entity in cacheDir.listSync()) {
      if (entity is File) {
        final String name = p.basename(entity.path);
        if (name.startsWith(prefix) && name != currentName) {
          entity.deleteSync();
        }
      }
    }
  }
}

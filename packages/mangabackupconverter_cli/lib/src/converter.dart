import 'dart:typed_data';

import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/mangayomi/mangayomi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';

class MangaBackupConverter {
  AidokuBackup importAidokuBackup(Uint8List bytes) {
    return AidokuBackup.fromData(bytes);
  }

  PaperbackBackup importPaperbackPas4Backup(Uint8List bytes, {String? name}) {
    return PaperbackBackup.fromData(bytes, name: name);
  }

  TachiBackup importTachibkBackup(Uint8List bytes, {Tachiyomi format = const Mihon()}) {
    return TachiBackup.fromData(bytes, format: format);
  }

  Future<TachimangaBackup> importTachimangaBackup(Uint8List bytes, {String? overrideName}) async {
    return await TachimangaBackup.fromData(bytes, overrideName: overrideName);
  }

  MangayomiBackup importMangayomiBackup(Uint8List bytes, {String? overrideName}) {
    return MangayomiBackup.fromData(bytes, overrideName: overrideName);
  }
}

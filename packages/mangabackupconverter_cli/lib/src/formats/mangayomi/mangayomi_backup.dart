import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/mangayomi_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/mangayomi/mangayomi_backup_db.dart';
import 'package:path/path.dart' as p;

part 'mangayomi_backup.mapper.dart';

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class MangayomiBackup with MangayomiBackupMappable {
  final String? name;
  final MangayomiBackupDb db;

  const MangayomiBackup({
    required this.db,
    this.name,
  });

  factory MangayomiBackup.fromZip(
    Uint8List bytes, {
    String? overrideName,
  }) {
    final backupArchive = ZipDecoder().decodeBytes(bytes);
    final backupJsonFile = backupArchive.files
        .where((file) => file.name.endsWith('.db'))
        .firstOrNull;
    if (backupJsonFile == null || backupJsonFile.content == null) {
      throw const MangayomiException(
        'Could not decode Mangayomi backup',
      );
    }
    final backupName = p.basenameWithoutExtension(backupJsonFile.name);
    final backupJson =
        String.fromCharCodes(backupJsonFile.content as Uint8List);
    final backupMap = jsonDecode(backupJson) as Map<String, dynamic>?;
    if (backupMap == null) {
      throw const MangayomiException(
        'Could not decode Mangayomi backup',
      );
    }
    final db = MangayomiBackupDb.fromMap(backupMap);

    return MangayomiBackup(
      name: overrideName ?? backupName,
      db: db,
    );
  }

  Uint8List toZip() {
    final archive = Archive();
    final dbJson = jsonEncode(db.toMap()).codeUnits;
    archive.addFile(ArchiveFile('$name.db', dbJson.length, dbJson));
    return Uint8List.fromList(ZipEncoder().encode(archive) ?? []);
  }

  static const fromMap = MangayomiBackupMapper.fromMap;
  static const fromJson = MangayomiBackupMapper.fromJson;
}

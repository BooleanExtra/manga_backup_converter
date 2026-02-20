// ignore_for_file: avoid_print, avoid_redundant_argument_values

import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/backup_type.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/mangayomi_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/mangayomi/mangayomi_backup_db.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_category.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_extension_repo.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_preference.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source_preferences.dart';
import 'package:path/path.dart' as p;

part 'mangayomi_backup.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackup with MangayomiBackupMappable implements ConvertableBackup {
  final String? name;
  final MangayomiBackupDb db;

  const MangayomiBackup({required this.db, this.name});

  factory MangayomiBackup.fromData(Uint8List bytes, {String? overrideName}) {
    final Archive backupArchive = ZipDecoder().decodeBytes(bytes);
    final ArchiveFile? backupJsonFile = backupArchive.files
        .where((ArchiveFile file) => file.name.endsWith('.db'))
        .firstOrNull;
    if (backupJsonFile == null) {
      throw const MangayomiException('Could not decode Mangayomi backup');
    }
    final String backupName = p.basenameWithoutExtension(backupJsonFile.name);
    final String backupJson = String.fromCharCodes(backupJsonFile.content);
    final Map<String, dynamic>? backupMap = jsonDecode(backupJson) as Map<String, dynamic>?;
    if (backupMap == null) {
      throw const MangayomiException('Could not decode Mangayomi backup');
    }
    final MangayomiBackupDb db = MangayomiBackupDb.fromMap(backupMap);

    return MangayomiBackup(name: overrideName ?? backupName, db: db);
  }

  static const MangayomiBackup Function(Map<String, dynamic> map) fromMap = MangayomiBackupMapper.fromMap;
  static const MangayomiBackup Function(String json) fromJson = MangayomiBackupMapper.fromJson;

  @override
  ConvertableBackup toBackup(BackupType type) {
    // TODO: implement toBackup
    return switch (type) {
      BackupType.mangayomi => this,
      BackupType.tachi => TachiBackup(
        backupCategories: (db.categories ?? <MangayomiBackupCategory>[])
            .map(
              (MangayomiBackupCategory category) =>
                  TachiBackupCategory(name: category.name ?? 'Default', order: category.pos ?? 0, flags: 0),
            )
            .toList(),
        backupManga: <TachiBackupManga>[],
        backupBrokenSources: <TachiBackupSource>[],
        backupSources: <TachiBackupSource>[],
        backupExtensionRepo: <TachiBackupExtensionRepo>[],
        backupPreferences: <TachiBackupPreference>[],
        backupSourcePreferences: <TachiBackupSourcePreferences>[],
      ),
      BackupType.aidoku => throw const MangayomiException('Mangayomi backup cannot be converted to Aidoku'),
      BackupType.paperback => throw const MangayomiException('Mangayomi backup cannot be converted to Paperback'),
      BackupType.tachimanga => throw const MangayomiException('Mangayomi backup cannot be converted to Tachiyomi'),
    };
  }

  @override
  Future<Uint8List> toData() async {
    final Archive archive = Archive();
    final List<int> dbJson = jsonEncode(db.toMap()).codeUnits;
    archive.addFile(ArchiveFile('$name.db', dbJson.length, dbJson));
    return ZipEncoder().encodeBytes(archive);
  }

  @override
  void verbosePrint(bool verbose) {
    if (!verbose) return;

    print('Mangayomi name: $name');
    print('Manga: ${db.manga?.length}');
    print('Categories: ${db.categories?.length}');
    print('Chapters: ${db.chapters?.length}');
    print('Downloads: ${db.downloads?.length}');
    print('Tracks: ${db.tracks?.length}');
    print('History: ${db.history?.length}');
    print('Updates: ${db.updates?.length}');
    print('Settings: ${db.settings?.length}');
    print('Extension Preferences: ${db.extensionPreferences?.length}');
    print('Track Preferences: ${db.trackPreferences?.length}');
    print('Extensions: ${db.extensions?.length}');
  }
}

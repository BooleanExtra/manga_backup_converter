// ignore_for_file: avoid_print, avoid_redundant_argument_values

import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/mangayomi_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/mangayomi/mangayomi_backup_db.dart';
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
    final backupJson = String.fromCharCodes(backupJsonFile.content);
    final backupMap = jsonDecode(backupJson) as Map<String, dynamic>?;
    if (backupMap == null) {
      throw const MangayomiException('Could not decode Mangayomi backup');
    }
    final MangayomiBackupDb db = MangayomiBackupDb.fromMap(backupMap);

    return MangayomiBackup(name: overrideName ?? backupName, db: db);
  }

  static const MangayomiBackup Function(Map<String, dynamic> map) fromMap = MangayomiBackupMapper.fromMap;
  static const MangayomiBackup Function(String json) fromJson = MangayomiBackupMapper.fromJson;

  @override
  List<MangayomiBackupManga> get mangaSearchEntries => db.manga ?? const <MangayomiBackupManga>[];

  @override
  Future<Uint8List> toData() async {
    final archive = Archive();
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

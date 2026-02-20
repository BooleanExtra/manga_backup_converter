// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/tachimanga_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db_models.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_meta.dart';
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:xcode_parser/xcode_parser.dart';

part 'tachimanga_backup.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
class TachimangaBackup with TachimangaBackupMappable implements ConvertableBackup {
  final String? name;
  final TachimangaBackupMeta meta;
  final Map<String, Object?>? pref;
  final Pbxproj? prefAll;
  final Map<String, Map<String, Object?>>? prefs;
  final Map<String, Uint8List>? extensions;
  final TachimangaBackupDb db;

  const TachimangaBackup({
    required this.meta,
    required this.db,
    this.pref,
    this.prefAll,
    this.prefs,
    this.extensions,
    this.name,
  });

  static Future<TachimangaBackup> fromData(Uint8List bytes, {String? overrideName}) async {
    final Archive backupArchive = ZipDecoder().decodeBytes(bytes);
    final ArchiveFile? metaFile = backupArchive.findFile('meta.json');
    if (metaFile == null) {
      throw const TachimangaException('Could not decode Tachimanga backup');
    }

    final TachimangaBackupMeta meta = TachimangaBackupMeta.fromJson(String.fromCharCodes(metaFile.content));
    final String archiveName = overrideName ?? meta.name;

    final ArchiveFile? contentZipFile = backupArchive.findFile('contents.zip');
    if (contentZipFile == null) {
      throw TachimangaException('Could not decode Tachimanga backup "$archiveName", contents.zip not found');
    }
    final Archive contentArchive = ZipDecoder().decodeBytes(contentZipFile.content);
    final ArchiveFile? prefFile = contentArchive.findFile('pref.json');
    if (prefFile == null) {
      throw TachimangaException('Could not decode Tachimanga backup "$archiveName", pref.json not found');
    }
    final pref = jsonDecode(String.fromCharCodes(prefFile.content)) as Map<String, Object?>;

    // This json file is actually a pbxproj file
    final ArchiveFile? prefAllFile = contentArchive.findFile('pref-all.json');
    if (prefAllFile == null) {
      throw TachimangaException('Could not decode Tachimanga backup "$archiveName", pref-all.json not found');
    }
    final prefAllContent = String.fromCharCodes(prefAllFile.content);
    final prefAll = Pbxproj.parse(prefAllContent, path: 'pref-all.json');

    final List<ArchiveFile> prefsFiles = contentArchive.files.where((ArchiveFile file) {
      return file.name.startsWith('prefs/') && file.name.endsWith('.plist');
    }).toList();
    final Map<String, Map<String, Object?>> prefs = prefsFiles.fold(<String, Map<String, Object?>>{}, (
      Map<String, Map<String, Object?>> map,
      ArchiveFile file,
    ) {
      map[file.name] =
          PropertyListSerialization.propertyListWithData(ByteData.sublistView(file.content)) as Map<String, Object?>;
      return map;
    });
    final List<ArchiveFile> extensionFiles = contentArchive.files.where((ArchiveFile file) {
      return file.name.startsWith('extensions/') && file.name.endsWith('.jar');
    }).toList();
    final Map<String, Uint8List> extensions = extensionFiles.fold(
      <String, Uint8List>{},
      (Map<String, Uint8List> map, ArchiveFile file) => map..addAll(<String, Uint8List>{file.name: file.content}),
    );

    final ArchiveFile? dbFile = contentArchive.findFile('tachimanga.db');
    if (dbFile == null) {
      throw TachimangaException('Could not decode Tachimanga backup "$archiveName", tachimanga.db not found');
    }
    final Uint8List dbContent = dbFile.content;
    final TachimangaBackupDb db = await TachimangaBackupDb.fromDatabase(dbContent);

    return TachimangaBackup(
      name: archiveName,
      meta: meta,
      pref: pref,
      prefs: prefs,
      prefAll: prefAll,
      db: db,
      extensions: extensions,
    );
  }

  @override
  Future<Uint8List> toData() async {
    final contentsArchive = Archive();
    if (pref case final Map<String, Object?> pref) {
      contentsArchive.addFile(ArchiveFile.string('pref.json', jsonEncode(pref)));
    }
    if (prefAll case final Pbxproj prefAll) {
      contentsArchive.addFile(ArchiveFile.string('pref-all.json', prefAll.toString()));
    }
    if (extensions case final Map<String, Uint8List> extensions) {
      extensions.forEach((String filename, Uint8List content) {
        contentsArchive.addFile(ArchiveFile(filename, content.elementSizeInBytes, content));
      });
    }
    if (prefs case final Map<String, Map<String, Object?>> prefs) {
      prefs.forEach((String filename, Map<String, Object?> content) {
        final ByteData binaryPlist = PropertyListSerialization.dataWithPropertyList(content);
        contentsArchive.addFile(
          ArchiveFile.noCompress(filename, binaryPlist.lengthInBytes, binaryPlist.buffer.asUint8List()),
        );
      });
    }

    final Uint8List dbContent = await db.exportDatabase();
    contentsArchive.addFile(ArchiveFile.noCompress('tachimanga.db', dbContent.lengthInBytes, dbContent));
    final List<int> contentsEncoded = ZipEncoder().encode(contentsArchive);

    final backupArchive = Archive();
    backupArchive.addFile(ArchiveFile.string('meta.json', meta.toJson()));
    backupArchive.addFile(ArchiveFile.noCompress('contents.zip', contentsEncoded.length, contentsEncoded));
    return ZipEncoder().encodeBytes(backupArchive);
  }

  @override
  List<TachimangaBackupManga> get mangaSearchEntries => db.mangaTable;

  TachiBackup toTachiBackup() {
    return TachiBackup(
      backupCategories: db.categoryTable.map((TachimangaBackupCategory c) => c.toType(db)).toList(),
      backupManga: db.mangaTable.map((TachimangaBackupManga c) => c.toType(db)).toList(),
      backupSources: db.sourceTable.map((TachimangaBackupSource c) => c.toType(db)).toList(),
      backupExtensionRepo: db.repoTable.map((TachimangaBackupRepo c) => c.toType(db)).toList(),
    );
  }

  static const TachimangaBackup Function(Map<String, dynamic> map) fromMap = TachimangaBackupMapper.fromMap;
  static const TachimangaBackup Function(String json) fromJson = TachimangaBackupMapper.fromJson;

  @override
  void verbosePrint(bool verbose) {
    if (!verbose) return;
    print('Imported Manga: ${db.mangaTable.length}');
    print('Imported Chapters: ${db.chapterTable.length}');
    print('Imported Manga History: ${db.historyTable.length}');
    print('Imported Tracked Manga Items: ${db.trackRecordTable.length}');
    print('Imported Categories: ${db.categoryTable.length}');
    print('Imported Sources: ${db.sourceTable.length}');
    print('Imported Repos: ${db.repoTable.length}');
    print('Tachimanga Backup Name: $name');
    print('Tachimanga Version: ${meta.version}');
  }
}

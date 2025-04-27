// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/backup_type.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/tachimanga_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_meta.dart';
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:xcode_parser/xcode_parser.dart';

part 'tachimanga_backup.mapper.dart';

@MappableClass(includeCustomMappers: [SecondsEpochDateTimeMapper()])
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
    final backupArchive = ZipDecoder().decodeBytes(bytes);
    final metaFile = backupArchive.findFile('meta.json');
    if (metaFile == null || metaFile.content == null) {
      throw const TachimangaException('Could not decode Tachimanga backup');
    }

    final meta = TachimangaBackupMeta.fromJson(String.fromCharCodes(metaFile.content as Uint8List));
    final archiveName = overrideName ?? meta.name;

    final contentZipFile = backupArchive.findFile('contents.zip');
    if (contentZipFile == null || contentZipFile.content == null) {
      throw TachimangaException('Could not decode Tachimanga backup "$archiveName", contents.zip not found');
    }
    final contentArchive = ZipDecoder().decodeBytes(contentZipFile.content as Uint8List);
    final prefFile = contentArchive.findFile('pref.json');
    if (prefFile == null || prefFile.content == null) {
      throw TachimangaException('Could not decode Tachimanga backup "$archiveName", pref.json not found');
    }
    final pref = jsonDecode(String.fromCharCodes(prefFile.content as Uint8List)) as Map<String, Object?>;

    // This json file is actually a pbxproj file
    final prefAllFile = contentArchive.findFile('pref-all.json');
    if (prefAllFile == null || prefAllFile.content == null) {
      throw TachimangaException('Could not decode Tachimanga backup "$archiveName", pref-all.json not found');
    }
    final prefAllContent = String.fromCharCodes(prefAllFile.content as Uint8List);
    final prefAll = Pbxproj.parse(prefAllContent, path: 'pref-all.json');

    final prefsFiles =
        contentArchive.files.where((file) {
          return file.name.startsWith('prefs/') && file.name.endsWith('.plist');
        }).toList();
    final prefs = prefsFiles.fold(<String, Map<String, Object?>>{}, (map, file) {
      final content = file.content as Uint8List;
      map[file.name] =
          PropertyListSerialization.propertyListWithData(ByteData.sublistView(content)) as Map<String, Object?>;
      return map;
    });
    final extensionFiles =
        contentArchive.files.where((file) {
          return file.name.startsWith('extensions/') && file.name.endsWith('.jar');
        }).toList();
    final extensions = extensionFiles.fold(
      <String, Uint8List>{},
      (map, file) => map..addAll({file.name: file.content as Uint8List}),
    );

    final dbFile = contentArchive.findFile('tachimanga.db');
    if (dbFile == null || dbFile.content == null) {
      throw TachimangaException('Could not decode Tachimanga backup "$archiveName", tachimanga.db not found');
    }
    final dbContent = dbFile.content as Uint8List;
    final db = await TachimangaBackupDb.fromDatabase(dbContent);

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
      extensions.forEach((filename, content) {
        contentsArchive.addFile(ArchiveFile(filename, content.elementSizeInBytes, content));
      });
    }
    if (prefs case final Map<String, Map<String, Object?>> prefs) {
      prefs.forEach((filename, content) {
        final ByteData binaryPlist = PropertyListSerialization.dataWithPropertyList(content);
        contentsArchive.addFile(
          ArchiveFile.noCompress(filename, binaryPlist.lengthInBytes, binaryPlist.buffer.asUint8List()),
        );
      });
    }

    final dbContent = await db.exportDatabase();
    contentsArchive.addFile(ArchiveFile.noCompress('tachimanga.db', dbContent.lengthInBytes, dbContent));
    final contentsEncoded = ZipEncoder().encode(contentsArchive);
    if (contentsEncoded == null) {
      throw const TachimangaException('Could not encode Tachimanga backup');
    }

    final backupArchive = Archive();
    backupArchive.addFile(ArchiveFile.string('meta.json', meta.toJson()));
    backupArchive.addFile(ArchiveFile.noCompress('contents.zip', contentsEncoded.length, contentsEncoded));
    final backupEncoded = ZipEncoder().encode(backupArchive);
    if (backupEncoded == null) {
      throw const TachimangaException('Could not encode Tachimanga backup');
    }
    return Uint8List.fromList(backupEncoded);
  }

  @override
  ConvertableBackup toBackup(BackupType type) {
    // TODO: implement toBackup
    return switch (type) {
      BackupType.tachimanga => this,
      BackupType.tachi => TachiBackup(
        backupCategories: db.categoryTable.map((c) => c.toType(db)).toList(),
        backupManga: db.mangaTable.map((c) => c.toType(db)).toList(),
        backupSources: db.sourceTable.map((c) => c.toType(db)).toList(),
        backupExtensionRepo: db.repoTable.map((c) => c.toType(db)).toList(),
      ),
      BackupType.aidoku => throw const TachimangaException('Tachimanga backup cannot be converted to Aidoku'),
      BackupType.paperback => throw const TachimangaException('Tachimanga backup cannot be converted to Paperback'),
      BackupType.mangayomi => throw const TachimangaException('Tachimanga backup cannot be converted to Mangayomi'),
    };
  }

  static const fromMap = TachimangaBackupMapper.fromMap;
  static const fromJson = TachimangaBackupMapper.fromJson;

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

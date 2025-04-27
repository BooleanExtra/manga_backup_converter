// ignore_for_file: unused_import, avoid_print

import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/backup_type.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/tachi_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_category.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_extension_repo.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_preference.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source_preferences.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_fork.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_j2k.proto/proto/schema_j2k.pb.dart'
    as j2k;
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart'
    as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_neko.proto/proto/schema_neko.pb.dart'
    as neko;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart'
    as sy;
import 'package:mangabackupconverter_cli/src/proto/schema_yokai.proto/proto/schema_yokai.pb.dart'
    as yokai;
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

part 'tachi_backup.mapper.dart';

@MappableClass(includeCustomMappers: [SecondsEpochDateTimeMapper()])
class TachiBackup with TachiBackupMappable implements ConvertableBackup {
  final TachiFork fork;
  final List<TachiBackupSource> backupBrokenSources;
  final List<TachiBackupSource> backupSources;
  final List<TachiBackupCategory> backupCategories;
  final List<TachiBackupExtensionRepo> backupExtensionRepo;
  final List<TachiBackupManga> backupManga;
  final List<TachiBackupPreference> backupPreferences;
  final List<TachiBackupSourcePreferences> backupSourcePreferences;

  const TachiBackup({
    required this.backupCategories,
    required this.backupManga,
    this.backupBrokenSources = const [],
    this.backupSources = const [],
    this.backupExtensionRepo = const [],
    this.backupPreferences = const [],
    this.backupSourcePreferences = const [],
    this.fork = TachiFork.mihon,
  });

  factory TachiBackup._fromMihon({required mihon.Backup backup}) {
    return TachiBackup(
      backupSources:
          backup.backupSources.map(TachiBackupSource.fromMihon).toList(),
      backupCategories:
          backup.backupCategories.map(TachiBackupCategory.fromMihon).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromMihon).toList(),
      backupExtensionRepo:
          backup.backupExtensionRepo
              .map(TachiBackupExtensionRepo.fromMihon)
              .toList(),
      backupPreferences:
          backup.backupPreferences
              .map(TachiBackupPreference.fromMihon)
              .toList(),
      backupSourcePreferences:
          backup.backupSourcePreferences
              .map(TachiBackupSourcePreferences.fromMihon)
              .toList(),
    );
  }

  factory TachiBackup._fromSy({required sy.Backup backup}) {
    return TachiBackup(
      backupSources:
          backup.backupSources.map(TachiBackupSource.fromSy).toList(),
      backupCategories:
          backup.backupCategories.map(TachiBackupCategory.fromSy).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromSy).toList(),
      backupExtensionRepo:
          backup.backupExtensionRepo
              .map(TachiBackupExtensionRepo.fromSy)
              .toList(),
      backupPreferences:
          backup.backupPreferences.map(TachiBackupPreference.fromSy).toList(),
      backupSourcePreferences:
          backup.backupSourcePreferences
              .map(TachiBackupSourcePreferences.fromSy)
              .toList(),
    );
  }

  factory TachiBackup._fromNeko({required neko.Backup backup}) {
    return TachiBackup(
      backupCategories:
          backup.backupCategories.map(TachiBackupCategory.fromNeko).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromNeko).toList(),
    );
  }

  factory TachiBackup._fromJ2k({required j2k.Backup backup}) {
    return TachiBackup(
      backupSources:
          backup.backupSources.map(TachiBackupSource.fromJ2k).toList(),
      backupCategories:
          backup.backupCategories.map(TachiBackupCategory.fromJ2k).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromJ2k).toList(),
    );
  }

  factory TachiBackup._fromYokai({required yokai.Backup backup}) {
    return TachiBackup(
      backupSources:
          backup.backupSources.map(TachiBackupSource.fromYokai).toList(),
      backupCategories:
          backup.backupCategories.map(TachiBackupCategory.fromYokai).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromYokai).toList(),
    );
  }

  factory TachiBackup.fromBackup(
    Uint8List bytes, {
    TachiFork fork = TachiFork.mihon,
  }) {
    final backupArchive = GZipDecoder().decodeBytes(bytes);
    return switch (fork) {
      TachiFork.mihon => TachiBackup._fromMihon(
        backup: mihon.Backup.fromBuffer(backupArchive),
      ),
      TachiFork.sy => TachiBackup._fromSy(
        backup: sy.Backup.fromBuffer(backupArchive),
      ),
      TachiFork.j2k => TachiBackup._fromJ2k(
        backup: j2k.Backup.fromBuffer(backupArchive),
      ),
      TachiFork.yokai => TachiBackup._fromYokai(
        backup: yokai.Backup.fromBuffer(backupArchive),
      ),
      TachiFork.neko => TachiBackup._fromNeko(
        backup: neko.Backup.fromBuffer(backupArchive),
      ),
    };
  }

  @override
  Future<Uint8List> toData() async {
    final json = toJson();
    final backupJson = switch (fork) {
      TachiFork.mihon => mihon.Backup.fromJson(json).toProto3Json(),
      TachiFork.sy => sy.Backup.fromJson(json).toProto3Json(),
      TachiFork.j2k => j2k.Backup.fromJson(json).toProto3Json(),
      TachiFork.yokai => yokai.Backup.fromJson(json).toProto3Json(),
      TachiFork.neko => neko.Backup.fromJson(json).toProto3Json(),
    };
    final gzip = GZipEncoder().encode(backupJson);
    if (gzip == null) {
      throw const TachiException('Could not encode Tachi backup');
    }
    return Uint8List.fromList(gzip);
  }

  @override
  ConvertableBackup toBackup(BackupType type) {
    // TODO: implement toBackup
    throw UnimplementedError();
  }

  static const fromMap = TachiBackupMapper.fromMap;
  static const fromJson = TachiBackupMapper.fromJson;

  @override
  void verbosePrint(bool verbose) {
    if (!verbose) return;
    print('Categories: ${backupCategories.length}');
    print('Manga: ${backupManga.length}');
    print('Sources: ${backupSources.length}');
    print('Extension Repos: ${backupExtensionRepo.length}');
  }
}

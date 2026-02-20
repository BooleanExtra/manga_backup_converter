// ignore_for_file: unused_import, avoid_print

import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/tachi_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_category.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_extension_repo.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_preference.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source_preferences.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_j2k.proto/proto/schema_j2k.pb.dart' as j2k;
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_neko.proto/proto/schema_neko.pb.dart' as neko;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;
import 'package:mangabackupconverter_cli/src/proto/schema_yokai.proto/proto/schema_yokai.pb.dart' as yokai;
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

part 'tachi_backup.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
class TachiBackup with TachiBackupMappable implements ConvertableBackup {
  final Tachiyomi format;
  final List<TachiBackupSource> backupBrokenSources;
  final List<TachiBackupSource> backupSources;
  final List<TachiBackupCategory> backupCategories;
  final List<TachiBackupExtensionRepo> backupExtensionRepo;
  final List<TachiBackupManga> backupManga;
  final List<TachiBackupPreference> backupPreferences;
  final List<TachiBackupSourcePreferences> backupSourcePreferences;

  const TachiBackup({
    this.backupCategories = const <TachiBackupCategory>[],
    this.backupManga = const <TachiBackupManga>[],
    this.backupBrokenSources = const <TachiBackupSource>[],
    this.backupSources = const <TachiBackupSource>[],
    this.backupExtensionRepo = const <TachiBackupExtensionRepo>[],
    this.backupPreferences = const <TachiBackupPreference>[],
    this.backupSourcePreferences = const <TachiBackupSourcePreferences>[],
    this.format = const Mihon(),
  });

  factory TachiBackup._fromMihon({required mihon.Backup backup}) {
    return TachiBackup(
      backupSources: backup.backupSources.map(TachiBackupSource.fromMihon).toList(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromMihon).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromMihon).toList(),
      backupExtensionRepo: backup.backupExtensionRepo.map(TachiBackupExtensionRepo.fromMihon).toList(),
      backupPreferences: backup.backupPreferences.map(TachiBackupPreference.fromMihon).toList(),
      backupSourcePreferences: backup.backupSourcePreferences.map(TachiBackupSourcePreferences.fromMihon).toList(),
    );
  }

  factory TachiBackup._fromSy({required sy.Backup backup}) {
    return TachiBackup(
      format: const TachiSy(),
      backupSources: backup.backupSources.map(TachiBackupSource.fromSy).toList(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromSy).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromSy).toList(),
      backupExtensionRepo: backup.backupExtensionRepo.map(TachiBackupExtensionRepo.fromSy).toList(),
      backupPreferences: backup.backupPreferences.map(TachiBackupPreference.fromSy).toList(),
      backupSourcePreferences: backup.backupSourcePreferences.map(TachiBackupSourcePreferences.fromSy).toList(),
    );
  }

  factory TachiBackup._fromNeko({required neko.Backup backup}) {
    return TachiBackup(
      format: const TachiNeko(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromNeko).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromNeko).toList(),
    );
  }

  factory TachiBackup._fromJ2k({required j2k.Backup backup}) {
    return TachiBackup(
      format: const TachiJ2k(),
      backupSources: backup.backupSources.map(TachiBackupSource.fromJ2k).toList(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromJ2k).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromJ2k).toList(),
    );
  }

  factory TachiBackup._fromYokai({required yokai.Backup backup}) {
    return TachiBackup(
      format: const TachiYokai(),
      backupSources: backup.backupSources.map(TachiBackupSource.fromYokai).toList(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromYokai).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromYokai).toList(),
    );
  }

  factory TachiBackup.fromData(Uint8List bytes, {Tachiyomi format = const Mihon()}) {
    final Uint8List backupArchive = const GZipDecoder().decodeBytes(bytes);
    return switch (format) {
      Mihon() => TachiBackup._fromMihon(backup: mihon.Backup.fromBuffer(backupArchive)),
      TachiSy() => TachiBackup._fromSy(backup: sy.Backup.fromBuffer(backupArchive)),
      TachiJ2k() => TachiBackup._fromJ2k(backup: j2k.Backup.fromBuffer(backupArchive)),
      TachiYokai() => TachiBackup._fromYokai(backup: yokai.Backup.fromBuffer(backupArchive)),
      TachiNeko() => TachiBackup._fromNeko(backup: neko.Backup.fromBuffer(backupArchive)),
    };
  }

  @override
  Future<Uint8List> toData() async {
    final String json = toJson();
    final Uint8List backupBytes = switch (format) {
      Mihon() => mihon.Backup.fromJson(json).writeToBuffer(),
      TachiSy() => sy.Backup.fromJson(json).writeToBuffer(),
      TachiJ2k() => j2k.Backup.fromJson(json).writeToBuffer(),
      TachiYokai() => yokai.Backup.fromJson(json).writeToBuffer(),
      TachiNeko() => neko.Backup.fromJson(json).writeToBuffer(),
    };
    return const GZipEncoder().encodeBytes(backupBytes);
  }

  @override
  List<TachiBackupManga> get mangaSearchEntries => backupManga;

  static const TachiBackup Function(Map<String, dynamic> map) fromMap = TachiBackupMapper.fromMap;
  static const TachiBackup Function(String json) fromJson = TachiBackupMapper.fromJson;

  @override
  void verbosePrint(bool verbose) {
    if (!verbose) return;
    print('Categories: ${backupCategories.length}');
    print('Manga: ${backupManga.length}');
    print('Sources: ${backupSources.length}');
    print('Extension Repos: ${backupExtensionRepo.length}');
  }
}

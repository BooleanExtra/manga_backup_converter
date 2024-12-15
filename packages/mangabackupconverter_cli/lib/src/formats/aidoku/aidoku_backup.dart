import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/aidoku_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_track_item.dart';
import 'package:propertylistserialization/propertylistserialization.dart';

part 'aidoku_backup.mapper.dart';

@MappableClass(includeCustomMappers: [SecondsEpochDateTimeMapper()])
class AidokuBackup with AidokuBackupMappable {
  final Set<AidokuBackupLibraryManga>? library;
  final Set<AidokuBackupHistory>? history;
  final Set<AidokuBackupManga>? manga;
  final Set<AidokuBackupChapter>? chapters;
  final Set<AidokuBackupTrackItem>? trackItems;
  final Set<String>? categories;
  final Set<String>? sources;
  final DateTime date;
  final String? name;
  final String? version;

  const AidokuBackup({
    required this.library,
    required this.history,
    required this.manga,
    required this.chapters,
    required this.trackItems,
    required this.categories,
    required this.sources,
    required this.date,
    required this.name,
    required this.version,
  });

  static AidokuBackup fromBinaryPropertyList(ByteData bytes) {
    final asMap = PropertyListSerialization.propertyListWithData(bytes)
        as Map<String, Object>;
    return fromMap(asMap);
  }

  ByteData? toBinaryPropertyList() {
    try {
      return PropertyListSerialization.dataWithPropertyList(toMap());
    } on PropertyListWriteStreamException catch (e) {
      throw AidokuException(e);
    }
  }

  static const fromMap = AidokuBackupMapper.fromMap;
  static const fromJson = AidokuBackupMapper.fromJson;

  AidokuBackup mergeWith(AidokuBackup aidokuBackup) {
    return AidokuBackup(
      library: (library ?? {})..addAll(aidokuBackup.library ?? {}),
      history: (history ?? {})..addAll(aidokuBackup.history ?? {}),
      manga: (manga ?? {})..addAll(aidokuBackup.manga ?? {}),
      chapters: (chapters ?? {})..addAll(aidokuBackup.chapters ?? {}),
      trackItems: (trackItems ?? {})..addAll(aidokuBackup.trackItems ?? {}),
      categories: (categories ?? {})..addAll(aidokuBackup.categories ?? {}),
      sources: (sources ?? {})..addAll(aidokuBackup.sources ?? {}),
      date: aidokuBackup.date,
      name: '${name ?? 'Backup'}Merged',
      version: aidokuBackup.version ?? version ?? '0.6.10',
    );
  }
}

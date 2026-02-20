// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/backup_type.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/paperback_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_chapter_progress_marker.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_manga_info.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_source_manga.dart';

part 'paperback_backup.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
class PaperbackBackup with PaperbackBackupMappable implements ConvertableBackup {
  final List<PaperbackBackupChapterProgressMarker>? chapterProgressMarker;
  final List<PaperbackBackupChapter>? chapters;
  final List<PaperbackBackupLibraryManga>? libraryManga;
  final List<PaperbackBackupMangaInfo>? mangaInfo;
  final List<PaperbackBackupSourceManga>? sourceManga;
  final String? name;

  const PaperbackBackup({
    this.chapterProgressMarker,
    this.chapters,
    this.libraryManga,
    this.mangaInfo,
    this.sourceManga,
    this.name,
  });

  factory PaperbackBackup.fromData(Uint8List bytes, {String? name}) {
    final Archive archive = ZipDecoder().decodeBytes(bytes);
    final ArchiveFile? chapterProgressMarkersArchive = archive.findFile('__CHAPTER_PROGRESS_MARKER_V4-1');
    final ArchiveFile? chaptersArchive = archive.findFile('__CHAPTER_V4');
    final ArchiveFile? libraryMangaArchive = archive.findFile('__LIBRARY_MANGA_V4');
    final ArchiveFile? mangaInfoArchive = archive.findFile('__MANGA_INFO_V4');
    final ArchiveFile? sourceMangaArchive = archive.findFile('__SOURCE_MANGA_V4');
    final Uint8List? chapterProgressMarkersArchiveContent = chapterProgressMarkersArchive?.content;
    final Uint8List? chaptersArchiveContent = chaptersArchive?.content;
    final Uint8List? libraryMangaArchiveContent = libraryMangaArchive?.content;
    final Uint8List? mangaInfoArchiveContent = mangaInfoArchive?.content;
    final Uint8List? sourceMangaArchiveContent = sourceMangaArchive?.content;

    return PaperbackBackup(
      name: name,
      chapterProgressMarker: chapterProgressMarkersArchiveContent == null
          ? null
          : (jsonDecode(String.fromCharCodes(chapterProgressMarkersArchiveContent)) as Map<String, dynamic>).entries
                .map(
                  (MapEntry<String, dynamic> e) =>
                      PaperbackBackupChapterProgressMarker.fromMap(e.value as Map<String, dynamic>),
                )
                .toList(),
      chapters: chaptersArchiveContent == null
          ? null
          : (jsonDecode(String.fromCharCodes(chaptersArchiveContent)) as Map<String, dynamic>).entries
                .map((MapEntry<String, dynamic> e) => PaperbackBackupChapter.fromMap(e.value as Map<String, dynamic>))
                .toList(),
      libraryManga: libraryMangaArchiveContent == null
          ? null
          : (jsonDecode(String.fromCharCodes(libraryMangaArchiveContent)) as Map<String, dynamic>).entries
                .map(
                  (MapEntry<String, dynamic> e) => PaperbackBackupLibraryManga.fromMap(e.value as Map<String, dynamic>),
                )
                .toList(),
      mangaInfo: mangaInfoArchiveContent == null
          ? null
          : (jsonDecode(String.fromCharCodes(mangaInfoArchiveContent)) as Map<String, dynamic>).entries
                .map((MapEntry<String, dynamic> e) => PaperbackBackupMangaInfo.fromMap(e.value as Map<String, dynamic>))
                .toList(),
      sourceManga: sourceMangaArchiveContent == null
          ? null
          : (jsonDecode(String.fromCharCodes(sourceMangaArchiveContent)) as Map<String, dynamic>).entries
                .map(
                  (MapEntry<String, dynamic> e) => PaperbackBackupSourceManga.fromMap(e.value as Map<String, dynamic>),
                )
                .toList(),
    );
  }

  static const PaperbackBackup Function(Map<String, dynamic> map) fromMap = PaperbackBackupMapper.fromMap;
  static const PaperbackBackup Function(String json) fromJson = PaperbackBackupMapper.fromJson;

  @override
  ConvertableBackup toBackup(BackupType type) {
    // TODO: implement toBackup
    return switch (type) {
      BackupType.paperback => this,
      BackupType.aidoku => throw const PaperbackException('Aidoku backup format not supported yet'),
      BackupType.mangayomi => throw const PaperbackException('Mangayomi backup format not supported yet'),
      BackupType.tachi => throw const PaperbackException('Tachi backup format not supported yet'),
      BackupType.tachimanga => throw const PaperbackException('TachiManga backup format not supported yet'),
    };
  }

  @override
  Future<Uint8List> toData() async {
    final Archive archive = Archive();

    archive.addFile(ArchiveFile.string('__CHAPTER_PROGRESS_MARKER_V4-1', jsonEncode(chapterProgressMarker)));
    archive.addFile(ArchiveFile.string('__CHAPTER_V4', jsonEncode(chapters)));
    archive.addFile(ArchiveFile.string('__LIBRARY_MANGA_V4', jsonEncode(libraryManga)));
    archive.addFile(ArchiveFile.string('__MANGA_INFO_V4', jsonEncode(mangaInfo)));
    archive.addFile(ArchiveFile.string('__SOURCE_MANGA_V4', jsonEncode(sourceManga)));
    return ZipEncoder().encodeBytes(archive);
  }

  @override
  void verbosePrint(bool verbose) {
    if (!verbose) return;
    print('Manga Info: ${mangaInfo?.length}');
    print('Library Manga: ${libraryManga?.length}');
    print('Chapters: ${chapters?.length}');
    print('Chapter Progress Marker: ${chapterProgressMarker?.length}');
    print('Source Manga: ${sourceManga?.length}');
    final List<PaperbackBackupLibraryManga>? trackedManga = libraryManga
        ?.where((PaperbackBackupLibraryManga i) => i.trackedSources.isNotEmpty)
        .toList();
    print('Tracked Manga: ${trackedManga?.length}');
    final List<PaperbackBackupLibraryManga>? mangaWithSecondarySources = libraryManga
        ?.where((PaperbackBackupLibraryManga i) => i.secondarySources.isNotEmpty)
        .toList();
    print('Manga with Secondary Sources: ${mangaWithSecondarySources?.length}');
    final List<PaperbackBackupMangaInfo>? mangaTagsWithTags = mangaInfo
        ?.where(
          (PaperbackBackupMangaInfo i) => i.tags.where((PaperbackBackupMangaTag e) => e.tags.isNotEmpty).isNotEmpty,
        )
        .toList();
    print('Manga with Tags: ${mangaTagsWithTags?.length}');
  }
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_chapter_progress_marker.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_reference.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_type.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_tab.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_manga_info.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_source_manga.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:test/scaffolding.dart';

Uint8List _buildZip(Map<String, String> files) {
  final archive = Archive();
  for (final MapEntry<String, String> entry in files.entries) {
    archive.addFile(ArchiveFile.string(entry.key, entry.value));
  }
  return ZipEncoder().encodeBytes(archive);
}

void main() {
  final epoch = DateTime.fromMillisecondsSinceEpoch(1700000000000);

  group('PaperbackBackup', () {
    group('fromData', () {
      test('parses ZIP with all expected archive file names', () {
        final Uint8List bytes = _buildZip(<String, String>{
          '__MANGA_INFO_V4': jsonEncode(<String, dynamic>{
            'info1': <String, dynamic>{
              'id': 'info1',
              'titles': <String>['My Manga'],
              'covers': <String>[],
              'image': 'https://example.com/cover.jpg',
              'desc': 'A description',
              'author': 'Author A',
              'artist': 'Artist B',
              'hentai': false,
              'status': 'Ongoing',
              'tags': <Map<String, dynamic>>[],
              'additionalInfo': <String, dynamic>{},
            },
          }),
          '__CHAPTER_V4': jsonEncode(<String, dynamic>{}),
          '__LIBRARY_MANGA_V4': jsonEncode(<String, dynamic>{}),
          '__SOURCE_MANGA_V4': jsonEncode(<String, dynamic>{}),
          '__CHAPTER_PROGRESS_MARKER_V4-1': jsonEncode(<String, dynamic>{}),
        });

        final backup = PaperbackBackup.fromData(bytes, name: 'test');

        check(backup.name).equals('test');
        check(backup.mangaInfo).isNotNull().length.equals(1);
        check(backup.mangaInfo!.first.id).equals('info1');
      });

      test('handles missing archive entries gracefully', () {
        final Uint8List bytes = _buildZip(<String, String>{
          '__MANGA_INFO_V4': jsonEncode(<String, dynamic>{
            'info1': <String, dynamic>{
              'id': 'info1',
              'titles': <String>['My Manga'],
              'covers': <String>[],
              'image': 'img.jpg',
              'desc': '',
              'author': '',
              'artist': '',
              'hentai': false,
              'status': 'Ongoing',
              'tags': <Map<String, dynamic>>[],
              'additionalInfo': <String, dynamic>{},
            },
          }),
        });

        final backup = PaperbackBackup.fromData(bytes);

        check(backup.mangaInfo).isNotNull().length.equals(1);
        check(backup.chapters).isNull();
        check(backup.chapterProgressMarker).isNull();
        check(backup.libraryManga).isNull();
        check(backup.sourceManga).isNull();
      });
    });

    group('toData', () {
      test('produces a valid ZIP with expected archive entries', () async {
        final sourceMangaRef = PaperbackBackupItemReference(
          type: PaperbackBackupItemType.sourceMangaV4,
          id: 'sm1',
        );

        final backup = PaperbackBackup(
          name: 'test',
          mangaInfo: <PaperbackBackupMangaInfo>[
            PaperbackBackupMangaInfo(
              id: 'info1',
              titles: <String>['Test Manga'],
              covers: <String>[],
              image: 'img.jpg',
              desc: 'Desc',
              author: 'Auth',
              artist: 'Art',
              hentai: false,
              status: 'Ongoing',
              tags: <PaperbackBackupMangaTag>[],
              additionalInfo: PaperbackBackupMangaAdditionalInfo(),
            ),
          ],
          chapters: <PaperbackBackupChapter>[
            PaperbackBackupChapter(
              volume: 1,
              langCode: 'en',
              group: 'Scanlator',
              sortingIndex: 0,
              id: 'ch1',
              chapNum: 1,
              chapterId: 'ch1',
              time: epoch,
              isNew: false,
              name: 'Chapter 1',
              sourceManga: sourceMangaRef,
            ),
          ],
        );

        final Uint8List bytes = await backup.toData();
        final Archive archive = ZipDecoder().decodeBytes(bytes);

        final Set<String> fileNames = archive.files.map((ArchiveFile f) => f.name).toSet();
        check(fileNames).contains('__MANGA_INFO_V4');
        check(fileNames).contains('__CHAPTER_V4');
        check(fileNames).contains('__LIBRARY_MANGA_V4');
        check(fileNames).contains('__SOURCE_MANGA_V4');
        check(fileNames).contains('__CHAPTER_PROGRESS_MARKER_V4-1');
      });

      test('round-trips through toData and fromData', () async {
        final sourceMangaRef = PaperbackBackupItemReference(
          type: PaperbackBackupItemType.sourceMangaV4,
          id: 'sm1',
        );

        final backup = PaperbackBackup(
          name: 'roundtrip',
          mangaInfo: <PaperbackBackupMangaInfo>[
            PaperbackBackupMangaInfo(
              id: 'info1',
              titles: <String>['Test Manga'],
              covers: <String>[],
              image: 'img.jpg',
              desc: 'Desc',
              author: 'Auth',
              artist: 'Art',
              hentai: false,
              status: 'Ongoing',
              tags: <PaperbackBackupMangaTag>[],
              additionalInfo: PaperbackBackupMangaAdditionalInfo(),
            ),
          ],
          chapters: <PaperbackBackupChapter>[
            PaperbackBackupChapter(
              volume: 1,
              langCode: 'en',
              group: 'Scanlator',
              sortingIndex: 0,
              id: 'ch1',
              chapNum: 1,
              chapterId: 'ch1',
              time: epoch,
              isNew: false,
              name: 'Chapter 1',
              sourceManga: sourceMangaRef,
            ),
          ],
        );

        final Uint8List bytes = await backup.toData();
        final PaperbackBackup restored = PaperbackBackup.fromData(bytes, name: 'roundtrip');

        check(restored.name).equals('roundtrip');
        check(restored.mangaInfo).isNotNull().length.equals(1);
        check(restored.mangaInfo!.first.id).equals('info1');
        check(restored.mangaInfo!.first.titles.first).equals('Test Manga');
        check(restored.chapters).isNotNull().length.equals(1);
        check(restored.chapters!.first.id).equals('ch1');
        check(restored.chapters!.first.name).equals('Chapter 1');
      });
    });

    group('mangaSearchEntries', () {
      test('returns manga info list', () {
        final backup = PaperbackBackup(
          mangaInfo: <PaperbackBackupMangaInfo>[
            PaperbackBackupMangaInfo(
              id: 'info1',
              titles: <String>['Manga A'],
              covers: <String>[],
              image: 'img.jpg',
              desc: '',
              author: 'A',
              artist: 'B',
              hentai: false,
              status: 'Ongoing',
              tags: <PaperbackBackupMangaTag>[],
              additionalInfo: PaperbackBackupMangaAdditionalInfo(),
            ),
          ],
        );

        check(backup.mangaSearchEntries.length).equals(1);
      });

      test('returns empty list when mangaInfo is null', () {
        const backup = PaperbackBackup();
        check(backup.mangaSearchEntries).isEmpty();
      });
    });

    group('sourceMangaDataEntries', () {
      test('links chapters and progress markers through sourceManga', () {
        final mangaInfoRef = PaperbackBackupItemReference(
          type: PaperbackBackupItemType.mangaInfoV4,
          id: 'info1',
        );
        final sourceMangaRef = PaperbackBackupItemReference(
          type: PaperbackBackupItemType.sourceMangaV4,
          id: 'sm1',
        );
        final chapterRef = PaperbackBackupItemReference(
          type: PaperbackBackupItemType.chapterV4,
          id: 'ch1',
        );

        final backup = PaperbackBackup(
          mangaInfo: <PaperbackBackupMangaInfo>[
            PaperbackBackupMangaInfo(
              id: 'info1',
              titles: <String>['Test'],
              covers: <String>[],
              image: 'img.jpg',
              desc: 'Desc',
              author: 'Auth',
              artist: 'Art',
              hentai: false,
              status: 'Ongoing',
              tags: <PaperbackBackupMangaTag>[
                PaperbackBackupMangaTag(id: 'tag1', label: 'Action'),
              ],
              additionalInfo: PaperbackBackupMangaAdditionalInfo(),
            ),
          ],
          sourceManga: <PaperbackBackupSourceManga>[
            PaperbackBackupSourceManga(
              sourceId: 'src1',
              mangaId: 'manga1',
              id: 'sm1',
              mangaInfo: mangaInfoRef,
            ),
          ],
          chapters: <PaperbackBackupChapter>[
            PaperbackBackupChapter(
              volume: 1,
              langCode: 'en',
              group: 'Group',
              sortingIndex: 0,
              id: 'ch1',
              chapNum: 1,
              chapterId: 'ch1',
              time: epoch,
              isNew: false,
              name: 'Chapter 1',
              sourceManga: sourceMangaRef,
            ),
          ],
          chapterProgressMarker: <PaperbackBackupChapterProgressMarker>[
            PaperbackBackupChapterProgressMarker(
              totalPages: 20,
              completed: true,
              chapter: chapterRef,
              lastPage: 19,
              time: epoch,
              hidden: false,
            ),
          ],
          libraryManga: <PaperbackBackupLibraryManga>[
            PaperbackBackupLibraryManga(
              id: 'info1',
              libraryTabs: <PaperbackBackupLibraryTab>[
                PaperbackBackupLibraryTab(
                  sortOrder: 0,
                  id: 'tab1',
                  name: 'Reading',
                ),
              ],
              lastRead: epoch,
              primarySource: sourceMangaRef,
              dateBookmarked: epoch,
              trackedSources: <PaperbackBackupItemReference>[],
              secondarySources: <PaperbackBackupItemReference>[],
            ),
          ],
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.length).equals(1);

        final SourceMangaData entry = entries.first;
        check(entry.details.title).equals('Test');
        check(entry.sourceId).equals('src1');
        check(entry.categories).deepEquals(<String>['Reading']);
        check(entry.chapters.length).equals(1);
        check(entry.chapters.first.title).equals('Chapter 1');
        check(entry.chapters.first.isRead).isTrue();
        check(entry.chapters.first.lastPageRead).equals(19);
        check(entry.dateAdded).isNotNull();
        check(entry.lastRead).isNotNull();
      });

      test('chapter isRead is false when no progress marker', () {
        final mangaInfoRef = PaperbackBackupItemReference(
          type: PaperbackBackupItemType.mangaInfoV4,
          id: 'info1',
        );
        final sourceMangaRef = PaperbackBackupItemReference(
          type: PaperbackBackupItemType.sourceMangaV4,
          id: 'sm1',
        );

        final backup = PaperbackBackup(
          mangaInfo: <PaperbackBackupMangaInfo>[
            PaperbackBackupMangaInfo(
              id: 'info1',
              titles: <String>['Test'],
              covers: <String>[],
              image: 'img.jpg',
              desc: '',
              author: '',
              artist: '',
              hentai: false,
              status: 'Ongoing',
              tags: <PaperbackBackupMangaTag>[],
              additionalInfo: PaperbackBackupMangaAdditionalInfo(),
            ),
          ],
          sourceManga: <PaperbackBackupSourceManga>[
            PaperbackBackupSourceManga(
              sourceId: 'src1',
              mangaId: 'manga1',
              id: 'sm1',
              mangaInfo: mangaInfoRef,
            ),
          ],
          chapters: <PaperbackBackupChapter>[
            PaperbackBackupChapter(
              volume: 0,
              langCode: 'en',
              group: '',
              sortingIndex: 0,
              id: 'ch1',
              chapNum: 1,
              chapterId: 'ch1',
              time: epoch,
              isNew: false,
              name: 'Ch 1',
              sourceManga: sourceMangaRef,
            ),
          ],
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.first.chapters.first.isRead).isFalse();
      });
    });
  });
}

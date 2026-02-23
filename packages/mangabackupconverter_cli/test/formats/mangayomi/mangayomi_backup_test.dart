import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/exceptions/mangayomi_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/mangayomi/mangayomi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/mangayomi/mangayomi_backup_db.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:test/scaffolding.dart';

Uint8List _buildMangayomiZip(Map<String, dynamic> dbContent, {String fileName = 'backup.db'}) {
  final archive = Archive();
  final List<int> dbJson = jsonEncode(dbContent).codeUnits;
  archive.addFile(ArchiveFile(fileName, dbJson.length, dbJson));
  return ZipEncoder().encodeBytes(archive);
}

void main() {
  group('MangayomiBackup', () {
    group('fromData', () {
      test('parses ZIP with .db file', () {
        final Uint8List bytes = _buildMangayomiZip(<String, dynamic>{
          'version': '2',
          'manga': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 1,
              'name': 'Test Manga',
              'source': 'src1',
              'author': 'Author',
              'artist': 'Artist',
              'genre': <String>['Action'],
              'imageUrl': 'img.jpg',
              'lang': 'en',
              'link': 'https://example.com',
              'status': 1,
              'description': 'A manga',
            },
          ],
        });

        final backup = MangayomiBackup.fromData(bytes);

        check(backup.name).equals('backup');
        check(backup.db.manga).isNotNull().length.equals(1);
        check(backup.db.manga!.first.name).equals('Test Manga');
      });

      test('uses overrideName when provided', () {
        final Uint8List bytes = _buildMangayomiZip(<String, dynamic>{
          'version': '2',
        });

        final backup = MangayomiBackup.fromData(bytes, overrideName: 'custom_name');

        check(backup.name).equals('custom_name');
      });

      test('throws MangayomiException when no .db file in archive', () {
        final archive = Archive();
        archive.addFile(ArchiveFile.string('readme.txt', 'not a backup'));
        final Uint8List bytes = ZipEncoder().encodeBytes(archive);

        check(() => MangayomiBackup.fromData(bytes)).throws<MangayomiException>();
      });
    });

    group('toData round-trip', () {
      test('serializes and deserializes back', () async {
        const backup = MangayomiBackup(
          name: 'roundtrip',
          db: MangayomiBackupDb(
            manga: <MangayomiBackupManga>[
              MangayomiBackupManga(
                source: 'src1',
                author: 'Author',
                artist: 'Artist',
                genre: <String>['Action'],
                imageUrl: 'img.jpg',
                lang: 'en',
                link: 'https://example.com',
                name: 'Manga A',
                status: 1,
                description: 'Desc',
                id: 1,
              ),
            ],
            categories: <MangayomiBackupCategory>[
              MangayomiBackupCategory(name: 'Action', forItemType: 0, id: 1),
            ],
          ),
        );

        final Uint8List bytes = await backup.toData();
        final restored = MangayomiBackup.fromData(bytes);

        check(restored.name).equals('roundtrip');
        check(restored.db.manga).isNotNull().length.equals(1);
        check(restored.db.manga!.first.name).equals('Manga A');
        check(restored.db.categories).isNotNull().length.equals(1);
      });
    });

    group('mangaSearchEntries', () {
      test('returns manga list from db', () {
        const backup = MangayomiBackup(
          db: MangayomiBackupDb(
            manga: <MangayomiBackupManga>[
              MangayomiBackupManga(
                source: 'src1',
                author: null,
                artist: null,
                genre: null,
                imageUrl: null,
                lang: null,
                link: null,
                name: 'Manga',
                status: null,
                description: null,
              ),
            ],
          ),
        );

        check(backup.mangaSearchEntries.length).equals(1);
      });

      test('returns empty list when manga is null', () {
        const backup = MangayomiBackup(db: MangayomiBackupDb());
        check(backup.mangaSearchEntries).isEmpty();
      });
    });

    group('sourceMangaDataEntries', () {
      test('links chapters, history, tracking, and categories by mangaId', () {
        const backup = MangayomiBackup(
          db: MangayomiBackupDb(
            manga: <MangayomiBackupManga>[
              MangayomiBackupManga(
                id: 1,
                source: 'src1',
                author: 'Author',
                artist: 'Artist',
                genre: <String>['Action'],
                imageUrl: 'img.jpg',
                lang: 'en',
                link: 'link',
                name: 'Manga A',
                status: 1,
                description: 'Desc',
                categories: '1,2',
                dateAdded: 1700000000000,
                lastRead: 1700000000000,
              ),
            ],
            categories: <MangayomiBackupCategory>[
              MangayomiBackupCategory(name: 'Action', forItemType: 0, id: 1),
              MangayomiBackupCategory(name: 'Comedy', forItemType: 0, id: 2),
            ],
            chapters: <MangayomiBackupChapter>[
              MangayomiBackupChapter(
                id: 10,
                mangaId: 1,
                name: 'Chapter 1',
                isRead: true,
                dateUpload: '1700000000000',
              ),
            ],
            history: <MangayomiBackupHistory>[
              MangayomiBackupHistory(
                itemType: ItemType.manga,
                chapterId: 10,
                mangaId: 1,
                date: '1700000000000',
              ),
            ],
            tracks: <MangayomiBackupTrack>[
              MangayomiBackupTrack(
                status: 1,
                mangaId: 1,
                syncId: 2,
                title: 'Tracked',
              ),
            ],
          ),
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.length).equals(1);

        final SourceMangaData entry = entries.first;
        check(entry.details.title).equals('Manga A');
        check(entry.sourceId).equals('src1');
        check(entry.categories).deepEquals(<String>['Action', 'Comedy']);
        check(entry.chapters.length).equals(1);
        check(entry.chapters.first.title).equals('Chapter 1');
        check(entry.chapters.first.isRead).isTrue();
        check(entry.history.length).equals(1);
        check(entry.tracking.length).equals(1);
        check(entry.tracking.first.syncId).equals(2);
        check(entry.dateAdded).isNotNull();
        check(entry.lastRead).isNotNull();
      });

      test('handles empty categories string', () {
        const backup = MangayomiBackup(
          db: MangayomiBackupDb(
            manga: <MangayomiBackupManga>[
              MangayomiBackupManga(
                id: 1,
                source: 'src1',
                author: null,
                artist: null,
                genre: null,
                imageUrl: null,
                lang: null,
                link: null,
                name: 'Manga',
                status: null,
                description: null,
                categories: '',
              ),
            ],
          ),
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.first.categories).isEmpty();
      });

      test('parses date from millisecond string', () {
        const backup = MangayomiBackup(
          db: MangayomiBackupDb(
            manga: <MangayomiBackupManga>[
              MangayomiBackupManga(
                id: 1,
                source: 'src1',
                author: null,
                artist: null,
                genre: null,
                imageUrl: null,
                lang: null,
                link: null,
                name: 'Manga',
                status: null,
                description: null,
              ),
            ],
            chapters: <MangayomiBackupChapter>[
              MangayomiBackupChapter(
                id: 10,
                mangaId: 1,
                name: 'Ch 1',
                dateUpload: '1700000000000',
              ),
            ],
          ),
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.first.chapters.first.dateUploaded).isNotNull();
      });

      test('returns null date for empty date string', () {
        const backup = MangayomiBackup(
          db: MangayomiBackupDb(
            manga: <MangayomiBackupManga>[
              MangayomiBackupManga(
                id: 1,
                source: 'src1',
                author: null,
                artist: null,
                genre: null,
                imageUrl: null,
                lang: null,
                link: null,
                name: 'Manga',
                status: null,
                description: null,
              ),
            ],
            chapters: <MangayomiBackupChapter>[
              MangayomiBackupChapter(
                id: 10,
                mangaId: 1,
                name: 'Ch 1',
              ),
            ],
          ),
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.first.chapters.first.dateUploaded).isNull();
      });
    });
  });
}

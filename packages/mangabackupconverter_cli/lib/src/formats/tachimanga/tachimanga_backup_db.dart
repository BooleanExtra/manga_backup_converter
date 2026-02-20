import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/constants.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db_manager.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db_models.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

part 'tachimanga_backup_db.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.equals | GenerateMethods.copy | GenerateMethods.stringify)
class TachimangaBackupDb with TachimangaBackupDbMappable {
  final List<TachimangaBackupCategory> categoryTable;
  final List<TachimangaBackupCategoryManga> categoryMangaTable;
  final List<TachimangaBackupCategoryMeta> categoryMetaTable;
  final List<TachimangaBackupChapter> chapterTable;
  final List<TachimangaBackupChapterMeta> chapterMetaTable;
  final List<TachimangaBackupExtension> extensionTable;
  final List<TachimangaBackupHistory> historyTable;
  final List<TachimangaBackupManga> mangaTable;
  final List<TachimangaBackupMangaMeta> mangaMetaTable;
  final List<TachimangaBackupDbMigrations> migrationsTable;
  final List<TachimangaBackupPage> pageTable;
  final List<TachimangaBackupRepo> repoTable;
  final List<TachimangaBackupSetting> settingTable;
  final List<TachimangaBackupSource> sourceTable;
  final List<TachimangaBackupTrackRecord> trackRecordTable;
  final List<TachimangaBackupSqliteSequence> sqliteSequenceTable;

  const TachimangaBackupDb({
    required this.categoryTable,
    required this.categoryMangaTable,
    required this.categoryMetaTable,
    required this.chapterTable,
    required this.chapterMetaTable,
    required this.extensionTable,
    required this.historyTable,
    required this.mangaTable,
    required this.mangaMetaTable,
    required this.migrationsTable,
    required this.pageTable,
    required this.repoTable,
    required this.settingTable,
    required this.sourceTable,
    required this.trackRecordTable,
    required this.sqliteSequenceTable,
  });

  static Future<TachimangaBackupDb> fromDatabase(Uint8List dbContent) async {
    final Database db;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      await databaseFactory.writeDatabaseBytes('tachimanga.db', dbContent);
      db = await databaseFactory.openDatabase('tachimanga.db');
    } else {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      await databaseFactory.writeDatabaseBytes('tachimanga.db', dbContent);
      db = await databaseFactory.openDatabase('tachimanga.db');
    }
    final backupDbManager = TachimangaBackupDbManager(
      db: db,
      databaseFactory: databaseFactory,
    );
    final List<TachimangaBackupCategory> category = await backupDbManager.queryTable(TachimangaBackupTable.category);
    final List<TachimangaBackupCategoryManga> categoryManga = await backupDbManager.queryTable(
      TachimangaBackupTable.categoryManga,
    );
    final List<TachimangaBackupCategoryMeta> categoryMeta = await backupDbManager.queryTable(
      TachimangaBackupTable.categoryMeta,
    );
    final List<TachimangaBackupChapter> chapter = await backupDbManager.queryTable(TachimangaBackupTable.chapter);
    final List<TachimangaBackupChapterMeta> chapterMeta = await backupDbManager.queryTable(
      TachimangaBackupTable.chapterMeta,
    );
    final List<TachimangaBackupExtension> extension = await backupDbManager.queryTable(TachimangaBackupTable.extension);
    final List<TachimangaBackupHistory> history = await backupDbManager.queryTable(TachimangaBackupTable.history);
    final List<TachimangaBackupManga> manga = await backupDbManager.queryTable(TachimangaBackupTable.manga);
    final List<TachimangaBackupMangaMeta> mangaMeta = await backupDbManager.queryTable(TachimangaBackupTable.mangaMeta);
    final List<TachimangaBackupDbMigrations> migrations = await backupDbManager.queryTable(
      TachimangaBackupTable.migrations,
    );
    final List<TachimangaBackupPage> page = await backupDbManager.queryTable(TachimangaBackupTable.page);
    final List<TachimangaBackupRepo> repo = await backupDbManager.queryTable(TachimangaBackupTable.repo);
    final List<TachimangaBackupSetting> setting = await backupDbManager.queryTable(TachimangaBackupTable.setting);
    final List<TachimangaBackupSource> source = await backupDbManager.queryTable(TachimangaBackupTable.source);
    final List<TachimangaBackupTrackRecord> trackRecord = await backupDbManager.queryTable(
      TachimangaBackupTable.trackRecord,
    );
    final List<TachimangaBackupSqliteSequence> sqliteSequence = await backupDbManager.queryTable(
      TachimangaBackupTable.sqlite_sequence,
    );

    await db.close();

    return TachimangaBackupDb(
      categoryTable: category,
      categoryMangaTable: categoryManga,
      categoryMetaTable: categoryMeta,
      chapterTable: chapter,
      chapterMetaTable: chapterMeta,
      extensionTable: extension,
      historyTable: history,
      mangaTable: manga,
      mangaMetaTable: mangaMeta,
      migrationsTable: migrations,
      pageTable: page,
      repoTable: repo,
      settingTable: setting,
      sourceTable: source,
      trackRecordTable: trackRecord,
      sqliteSequenceTable: sqliteSequence,
    );
  }

  Future<Uint8List> exportDatabase() async {
    final Database db;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      db = await databaseFactory.openDatabase('tachimanga.db');
    } else {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase('tachimanga.db');
    }
    final backupDbManager = TachimangaBackupDbManager(
      db: db,
      databaseFactory: databaseFactory,
    );
    await backupDbManager.initDb();
    await backupDbManager.insert(TachimangaBackupTable.category, categoryTable);
    await backupDbManager.insert(TachimangaBackupTable.categoryManga, categoryMangaTable);
    await backupDbManager.insert(TachimangaBackupTable.categoryMeta, categoryMetaTable);
    await backupDbManager.insert(TachimangaBackupTable.chapter, chapterTable);
    await backupDbManager.insert(TachimangaBackupTable.chapterMeta, chapterMetaTable);
    await backupDbManager.insert(TachimangaBackupTable.extension, extensionTable);
    await backupDbManager.insert(TachimangaBackupTable.history, historyTable);
    await backupDbManager.insert(TachimangaBackupTable.manga, mangaTable);
    await backupDbManager.insert(TachimangaBackupTable.mangaMeta, mangaMetaTable);
    await backupDbManager.insert(TachimangaBackupTable.migrations, migrationsTable);
    await backupDbManager.insert(TachimangaBackupTable.page, pageTable);
    await backupDbManager.insert(TachimangaBackupTable.repo, repoTable);
    await backupDbManager.insert(TachimangaBackupTable.setting, settingTable);
    await backupDbManager.insert(TachimangaBackupTable.source, sourceTable);
    await backupDbManager.insert(TachimangaBackupTable.trackRecord, trackRecordTable);
    await backupDbManager.insert(TachimangaBackupTable.sqlite_sequence, sqliteSequenceTable);

    final Uint8List dbContent = await databaseFactory.readDatabaseBytes('tachimanga.db');
    await db.close();

    return dbContent;
  }
}

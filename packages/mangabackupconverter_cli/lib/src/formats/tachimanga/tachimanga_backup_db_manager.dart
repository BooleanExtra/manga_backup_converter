import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db_models.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db_models.init.dart'
    as tachimanga_init;
import 'package:meta/meta.dart';
import 'package:sqflite_common/sqflite.dart';

@internal
class TachimangaBackupDbManager {
  final Database db;
  final DatabaseFactory databaseFactory;

  TachimangaBackupDbManager({required this.db, required this.databaseFactory});

  Future<List<T>> queryTable<T>(TachimangaBackupTable<T> table) async {
    final List<Map<String, Object?>> result = await db.query(table.name);
    return result.map(table.fromMap).toList();
  }

  Future<void> insert<T>(TachimangaBackupTable<T> table, List<T> categories) async {
    tachimanga_init.initializeMappers();
    for (final category in categories) {
      await db.insert(table.name, MapperContainer.globals.toMap(category));
    }
  }

  Future<void> initDb() async {
    tachimanga_init.initializeMappers();
    final tableQueries = <String>[
      'CREATE TABLE Category (id INTEGER PRIMARY KEY AUTOINCREMENT, "name" VARCHAR(64) NOT NULL, "order" INT DEFAULT 0 NOT NULL, is_default BOOLEAN DEFAULT 0 NOT NULL)',
      'CREATE TABLE CategoryManga (id INTEGER PRIMARY KEY AUTOINCREMENT, category INT NOT NULL, manga INT NOT NULL, CONSTRAINT fk_CategoryManga_category__id FOREIGN KEY (category) REFERENCES Category(id) ON DELETE RESTRICT ON UPDATE RESTRICT, CONSTRAINT fk_CategoryManga_manga__id FOREIGN KEY (manga) REFERENCES Manga(id) ON DELETE RESTRICT ON UPDATE RESTRICT)',
      'CREATE TABLE CategoryMeta (id INTEGER PRIMARY KEY AUTOINCREMENT, "key" VARCHAR(256) NOT NULL, "value" VARCHAR(4096) NOT NULL, category_ref INT NOT NULL, CONSTRAINT fk_CategoryMeta_category_ref__id FOREIGN KEY (category_ref) REFERENCES Category(id) ON DELETE CASCADE ON UPDATE RESTRICT)',
      'CREATE TABLE Chapter (id INTEGER PRIMARY KEY AUTOINCREMENT, url VARCHAR(2048) NOT NULL, "name" VARCHAR(512) NOT NULL, date_upload BIGINT DEFAULT 0 NOT NULL, chapter_number SINGLE DEFAULT -1.0 NOT NULL, scanlator VARCHAR(128) NULL, "read" BOOLEAN DEFAULT 0 NOT NULL, bookmark BOOLEAN DEFAULT 0 NOT NULL, last_page_read INT DEFAULT 0 NOT NULL, last_read_at BIGINT DEFAULT 0 NOT NULL, fetched_at BIGINT DEFAULT 0 NOT NULL, source_order INT NOT NULL, real_url VARCHAR(2048) NULL, is_downloaded BOOLEAN DEFAULT 0 NOT NULL, page_count INT DEFAULT -1 NOT NULL, manga INT NOT NULL, CONSTRAINT fk_Chapter_manga__id FOREIGN KEY (manga) REFERENCES Manga(id) ON DELETE RESTRICT ON UPDATE RESTRICT)',
      'CREATE TABLE ChapterMeta (id INTEGER PRIMARY KEY AUTOINCREMENT, "key" VARCHAR(256) NOT NULL, "value" VARCHAR(4096) NOT NULL, chapter_ref INT NOT NULL, CONSTRAINT fk_ChapterMeta_chapter_ref__id FOREIGN KEY (chapter_ref) REFERENCES Chapter(id) ON DELETE CASCADE ON UPDATE RESTRICT)',
      "CREATE TABLE Extension (id INTEGER PRIMARY KEY AUTOINCREMENT, apk_name VARCHAR(1024) NOT NULL, icon_url VARCHAR(2048) DEFAULT 'https://raw.githubusercontent.com/tachiyomiorg/tachiyomi/64ba127e7d43b1d7e6d58a6f5c9b2bd5fe0543f7/app/src/main/res/mipmap-xxxhdpi/ic_local_source.webp' NOT NULL, \"name\" VARCHAR(128) NOT NULL, pkg_name VARCHAR(128) NOT NULL, version_name VARCHAR(16) NOT NULL, version_code INT NOT NULL, lang VARCHAR(32) NOT NULL, is_nsfw BOOLEAN NOT NULL, is_installed BOOLEAN DEFAULT 0 NOT NULL, has_update BOOLEAN DEFAULT 0 NOT NULL, is_obsolete BOOLEAN DEFAULT 0 NOT NULL, class_name VARCHAR(1024) DEFAULT '' NOT NULL, pkg_factory VARCHAR(128) NULL, has_changelog BOOLEAN DEFAULT 0 NOT NULL, has_readme BOOLEAN DEFAULT 0 NOT NULL, repo_id INT DEFAULT 0 NOT NULL)",
      '''
CREATE TABLE History(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    create_at BIGINT DEFAULT 0 NOT NULL,
    update_at BIGINT DEFAULT 0 NOT NULL,
    is_delete BOOLEAN DEFAULT 0 NOT NULL,
    manga_id INTEGER NOT NULL,
    last_chapter_id INTEGER NOT NULL,
    last_read_at BIGINT DEFAULT 0 NOT NULL,
    UNIQUE (manga_id) ON CONFLICT REPLACE
)''',
      "CREATE TABLE Manga (id INTEGER PRIMARY KEY AUTOINCREMENT, url VARCHAR(2048) NOT NULL, title VARCHAR(512) NOT NULL, initialized BOOLEAN DEFAULT 0 NOT NULL, artist VARCHAR(512) NULL, author VARCHAR(512) NULL, description VARCHAR(2147483647) NULL, genre VARCHAR(2147483647) NULL, status INT DEFAULT 0 NOT NULL, thumbnail_url VARCHAR(2048) NULL, thumbnail_url_last_fetched BIGINT DEFAULT 0 NOT NULL, in_library BOOLEAN DEFAULT 0 NOT NULL, default_category BOOLEAN DEFAULT 1 NOT NULL, in_library_at BIGINT DEFAULT 0 NOT NULL, \"source\" BIGINT NOT NULL, real_url VARCHAR(2048) NULL, last_fetched_at BIGINT DEFAULT 0 NOT NULL, chapters_last_fetched_at BIGINT DEFAULT 0 NOT NULL, update_strategy VARCHAR(256) DEFAULT 'ALWAYS_UPDATE' NOT NULL, last_download_at BIGINT DEFAULT 0 NOT NULL)",
      'CREATE TABLE MangaMeta (id INTEGER PRIMARY KEY AUTOINCREMENT, "key" VARCHAR(256) NOT NULL, "value" VARCHAR(4096) NOT NULL, manga_ref INT NOT NULL, CONSTRAINT fk_MangaMeta_manga_ref__id FOREIGN KEY (manga_ref) REFERENCES Manga(id) ON DELETE CASCADE ON UPDATE RESTRICT)',
      'CREATE TABLE Migrations (version INT NOT NULL PRIMARY KEY, "name" VARCHAR(400) NOT NULL, executed_at TEXT NOT NULL)',
      'CREATE TABLE Page (id INTEGER PRIMARY KEY AUTOINCREMENT, "index" INT NOT NULL, url VARCHAR(2048) NOT NULL, imageUrl VARCHAR(2048) NULL, chapter INT NOT NULL, CONSTRAINT fk_Page_chapter__id FOREIGN KEY (chapter) REFERENCES Chapter(id) ON DELETE RESTRICT ON UPDATE RESTRICT)',
      'CREATE TABLE Repo (id INTEGER PRIMARY KEY AUTOINCREMENT, "type" INT DEFAULT 0 NOT NULL, "name" VARCHAR(1024) NOT NULL, meta_url VARCHAR(2048) NOT NULL, base_url VARCHAR(2048) NOT NULL, homepage VARCHAR(2048) NULL, deleted BOOLEAN DEFAULT 0 NOT NULL, create_at BIGINT DEFAULT 0 NOT NULL, update_at BIGINT DEFAULT 0 NOT NULL)',
      '''
CREATE TABLE Setting(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    create_at BIGINT DEFAULT 0 NOT NULL,
    update_at BIGINT DEFAULT 0 NOT NULL,
    is_delete BOOLEAN DEFAULT 0 NOT NULL,
    key VARCHAR(256) NOT NULL, 
    value VARCHAR(2048) NOT NULL, 
    UNIQUE (key) ON CONFLICT REPLACE
)
''',
      'CREATE TABLE "Source" (id BIGINT NOT NULL, "name" VARCHAR(128) NOT NULL, lang VARCHAR(32) NOT NULL, extension INT NOT NULL, is_nsfw BOOLEAN DEFAULT 0 NOT NULL, is_direct BOOLEAN DEFAULT NULL, random_ua BOOLEAN DEFAULT NULL, CONSTRAINT fk_Source_extension__id FOREIGN KEY (extension) REFERENCES Extension(id) ON DELETE RESTRICT ON UPDATE RESTRICT)',
      '''
CREATE TABLE TrackRecord(
    id INTEGER NOT NULL PRIMARY KEY,
    manga_id INTEGER NOT NULL,
    sync_id INTEGER NOT NULL,
    remote_id INTEGER NOT NULL,
    library_id INTEGER,
    title TEXT NOT NULL,
    last_chapter_read REAL NOT NULL,
    total_chapters INTEGER NOT NULL,
    status INTEGER NOT NULL,
    score REAL NOT NULL,
    remote_url TEXT NOT NULL,
    start_date INTEGER NOT NULL,
    finish_date INTEGER NOT NULL,
    UNIQUE (manga_id, sync_id) ON CONFLICT REPLACE
)
''',
      'CREATE TABLE sqlite_sequence(name,seq)',
    ];
    final indexQueries = <String>[
      'CREATE UNIQUE INDEX Migrations_name ON Migrations ("name")',
      'CREATE INDEX idx_last_read_at ON History (last_read_at)',
    ];
    for (final query in <String>[...tableQueries, ...indexQueries]) {
      await db.execute(query);
    }
  }
}

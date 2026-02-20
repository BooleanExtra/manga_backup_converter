@MappableLib(generateInitializerForScope: InitializerScope.library)
library;

import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';

part 'tachimanga_backup_db_models.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupCategory
    with TachimangaBackupCategoryMappable
    implements ConvertableType<TachiBackupCategory, TachimangaBackupDb> {
  final int id;
  final String name;
  final int order;
  final bool isDefault;

  const TachimangaBackupCategory({required this.id, required this.name, required this.order, required this.isDefault});

  @override
  TachiBackupCategory toType(TachimangaBackupDb db) {
    return TachiBackupCategory(name: name, order: order, flags: 1);
  }

  static const TachimangaBackupCategory Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupCategoryMapper.fromMap;
  static const TachimangaBackupCategory Function(String json) fromJson = TachimangaBackupCategoryMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupCategoryManga with TachimangaBackupCategoryMangaMappable {
  final int id;
  final int category;
  final int manga;

  const TachimangaBackupCategoryManga({required this.id, required this.category, required this.manga});

  static const TachimangaBackupCategoryManga Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupCategoryMangaMapper.fromMap;
  static const TachimangaBackupCategoryManga Function(String json) fromJson =
      TachimangaBackupCategoryMangaMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupCategoryMeta with TachimangaBackupCategoryMetaMappable {
  final int id;
  final String key;
  final String value;
  final int categoryRef;

  const TachimangaBackupCategoryMeta({
    required this.id,
    required this.key,
    required this.value,
    required this.categoryRef,
  });

  static const TachimangaBackupCategoryMeta Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupCategoryMetaMapper.fromMap;
  static const TachimangaBackupCategoryMeta Function(String json) fromJson =
      TachimangaBackupCategoryMetaMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupChapter
    with TachimangaBackupChapterMappable
    implements ConvertableType<TachiBackupChapter, TachimangaBackupDb> {
  final int id;
  final String url;
  final String name;
  final int dateUpload;

  /// Default should be -1.0 instead of 0
  final double chapterNumber;
  final String? scanlator;
  final bool read;
  final bool bookmark;
  final int lastPageRead;
  final int lastReadAt;
  final int fetchedAt;
  final int sourceOrder;
  final String? realUrl;
  final bool isDownloaded;
  final int pageCount;
  final int manga;

  const TachimangaBackupChapter({
    required this.id,
    required this.url,
    required this.name,
    required this.dateUpload,
    required this.chapterNumber,
    required this.scanlator,
    required this.read,
    required this.bookmark,
    required this.lastPageRead,
    required this.lastReadAt,
    required this.fetchedAt,
    required this.sourceOrder,
    required this.realUrl,
    required this.isDownloaded,
    required this.pageCount,
    required this.manga,
  });

  @override
  TachiBackupChapter toType(TachimangaBackupDb db) {
    return TachiBackupChapter(
      url: url,
      name: name,
      scanlator: scanlator ?? '',
      read: read,
      bookmark: bookmark,
      lastPageRead: lastPageRead,
      dateFetch: fetchedAt,
      dateUpload: dateUpload,
      chapterNumber: chapterNumber,
      sourceOrder: sourceOrder,
      lastModifiedAt: lastReadAt,
    );
  }

  static const TachimangaBackupChapter Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupChapterMapper.fromMap;
  static const TachimangaBackupChapter Function(String json) fromJson = TachimangaBackupChapterMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupChapterMeta with TachimangaBackupChapterMetaMappable {
  final int id;
  final String key;
  final String value;
  final int chapterRef;

  const TachimangaBackupChapterMeta({
    required this.id,
    required this.key,
    required this.value,
    required this.chapterRef,
  });

  static const TachimangaBackupChapterMeta Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupChapterMetaMapper.fromMap;
  static const TachimangaBackupChapterMeta Function(String json) fromJson = TachimangaBackupChapterMetaMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupExtension with TachimangaBackupExtensionMappable {
  final int id;
  final String apkName;
  final String iconUrl;
  final String name;
  final String pkgName;
  final String versionName;
  final int versionCode;
  final String lang;
  final bool isNsfw;
  final bool isInstalled;
  final bool hasUpdate;
  final bool isObsolete;
  final String className;
  final String? pkgFactory;
  final bool hasChangelog;
  final bool hasReadme;
  final int repoId;

  const TachimangaBackupExtension({
    required this.id,
    required this.apkName,
    required this.iconUrl,
    required this.name,
    required this.pkgName,
    required this.versionName,
    required this.versionCode,
    required this.lang,
    required this.isNsfw,
    required this.isInstalled,
    required this.hasUpdate,
    required this.isObsolete,
    required this.className,
    required this.pkgFactory,
    required this.hasChangelog,
    required this.hasReadme,
    required this.repoId,
  });

  static const TachimangaBackupExtension Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupExtensionMapper.fromMap;
  static const TachimangaBackupExtension Function(String json) fromJson = TachimangaBackupExtensionMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupHistory
    with TachimangaBackupHistoryMappable
    implements ConvertableType<TachiBackupHistory, TachimangaBackupDb> {
  final int id;
  final int createAt;
  final bool isDelete;
  final int mangaId;
  final int lastChapterId;
  final int lastReadAt;

  const TachimangaBackupHistory({
    required this.id,
    required this.createAt,
    required this.isDelete,
    required this.mangaId,
    required this.lastChapterId,
    required this.lastReadAt,
  });

  @override
  TachiBackupHistory toType(TachimangaBackupDb db) {
    final TachimangaBackupManga manga = db.mangaTable.firstWhere((TachimangaBackupManga manga) => manga.id == mangaId);
    return TachiBackupHistory(url: manga.realUrl ?? manga.url, lastRead: lastChapterId, readDuration: lastReadAt);
  }

  static const TachimangaBackupHistory Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupHistoryMapper.fromMap;
  static const TachimangaBackupHistory Function(String json) fromJson = TachimangaBackupHistoryMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupManga
    with TachimangaBackupMangaMappable
    implements ConvertableType<TachiBackupManga, TachimangaBackupDb>, MangaDetails {
  final int id;
  final String url;
  @override
  final String title;
  final bool initialized;
  final String? artist;
  final String? author;
  @override
  final String? description;
  final String? genre;
  final int status;
  final String? thumbnailUrl;
  final int thumbnailUrlLastFetched;
  final bool inLibrary;
  final bool defaultCategory;
  final int inLibraryAt;
  final int source;
  final String? realUrl;
  final int lastFetchedAt;
  final int chaptersLastFetchedAt;
  final String updateStrategy;
  final int lastDownloadAt;

  const TachimangaBackupManga({
    required this.id,
    required this.url,
    required this.title,
    required this.initialized,
    required this.artist,
    required this.author,
    required this.description,
    required this.genre,
    required this.status,
    required this.thumbnailUrl,
    required this.thumbnailUrlLastFetched,
    required this.inLibrary,
    required this.defaultCategory,
    required this.inLibraryAt,
    required this.source,
    required this.realUrl,
    required this.lastFetchedAt,
    required this.chaptersLastFetchedAt,
    required this.updateStrategy,
    required this.lastDownloadAt,
  });

  @override
  TachiBackupManga toType(TachimangaBackupDb db) {
    TachiUpdateStrategyMapper.ensureInitialized();
    return TachiBackupManga(
      url: realUrl ?? url,
      title: title,
      artist: artist ?? '',
      author: author ?? '',
      description: description ?? '',
      genre: (genre ?? '').split(', '),
      status: status,
      thumbnailUrl: thumbnailUrl ?? '',
      source: source,
      updateStrategy: TachiUpdateStrategyMapper.fromValue(updateStrategy),
      dateAdded: DateTime.now().millisecondsSinceEpoch,
      viewer: 1,
      viewerFlags: 1,
      chapterFlags: 1,
      favorite: false,
      chapters: db.chapterTable.map((TachimangaBackupChapter c) => c.toType(db)).toList(),
      history: db.historyTable.map((TachimangaBackupHistory c) => c.toType(db)).toList(),
      brokenHistory: <TachiBackupHistory>[],
      categories: db.categoryTable.map((TachimangaBackupCategory c) => c.id).toList(),
      tracking: db.trackRecordTable.map((TachimangaBackupTrackRecord c) => c.toType(db)).toList(),
    );
  }

  @override
  List<String> get altTitles => const <String>[];

  @override
  List<String> get authors => <String>[if (author != null) author!];

  @override
  List<String> get artists => <String>[if (artist != null) artist!];

  @override
  List<String> get tagNames => genre?.split(', ') ?? const <String>[];

  @override
  int? get chaptersCount => null;

  @override
  double? get latestChapterNum => null;

  @override
  String? get coverImageUrl => thumbnailUrl;

  @override
  List<String> get languages => const <String>[];

  static const TachimangaBackupManga Function(Map<String, dynamic> map) fromMap = TachimangaBackupMangaMapper.fromMap;
  static const TachimangaBackupManga Function(String json) fromJson = TachimangaBackupMangaMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupMangaMeta with TachimangaBackupMangaMetaMappable {
  final int id;
  final String key;
  final String value;
  final int mangaRef;

  const TachimangaBackupMangaMeta({required this.id, required this.key, required this.value, required this.mangaRef});

  static const TachimangaBackupMangaMeta Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupMangaMetaMapper.fromMap;
  static const TachimangaBackupMangaMeta Function(String json) fromJson = TachimangaBackupMangaMetaMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupDbMigrations with TachimangaBackupDbMigrationsMappable {
  final int version;
  final String name;
  final String executedAt;

  const TachimangaBackupDbMigrations({required this.version, required this.name, required this.executedAt});

  static const TachimangaBackupDbMigrations Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupDbMigrationsMapper.fromMap;
  static const TachimangaBackupDbMigrations Function(String json) fromJson =
      TachimangaBackupDbMigrationsMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class TachimangaBackupPage with TachimangaBackupPageMappable {
  final int id;
  final int index;
  final String url;
  final String? imageUrl;
  final int chapter;

  const TachimangaBackupPage({
    required this.id,
    required this.index,
    required this.url,
    required this.imageUrl,
    required this.chapter,
  });

  static const TachimangaBackupPage Function(Map<String, dynamic> map) fromMap = TachimangaBackupPageMapper.fromMap;
  static const TachimangaBackupPage Function(String json) fromJson = TachimangaBackupPageMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupRepo
    with TachimangaBackupRepoMappable
    implements ConvertableType<TachiBackupExtensionRepo, TachimangaBackupDb> {
  final int id;
  final int type;
  final String name;
  final String metaUrl;
  final String baseUrl;
  final String? homepage;
  final bool deleted;
  final int createAt;
  final int updateAt;

  const TachimangaBackupRepo({
    required this.id,
    required this.type,
    required this.name,
    required this.metaUrl,
    required this.baseUrl,
    required this.homepage,
    required this.deleted,
    required this.createAt,
    required this.updateAt,
  });

  @override
  TachiBackupExtensionRepo toType(TachimangaBackupDb arg) {
    return TachiBackupExtensionRepo(
      name: name,
      baseUrl: baseUrl,
      shortName: name,
      website: homepage ?? baseUrl,
      signingKeyFingerprint: '',
    );
  }

  static const TachimangaBackupRepo Function(Map<String, dynamic> map) fromMap = TachimangaBackupRepoMapper.fromMap;
  static const TachimangaBackupRepo Function(String json) fromJson = TachimangaBackupRepoMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupSetting with TachimangaBackupSettingMappable {
  final int id;
  final int createAt;
  final int updateAt;
  final bool isDelete;
  final String key;
  final String value;

  const TachimangaBackupSetting({
    required this.id,
    required this.createAt,
    required this.updateAt,
    required this.isDelete,
    required this.key,
    required this.value,
  });

  static const TachimangaBackupSetting Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupSettingMapper.fromMap;
  static const TachimangaBackupSetting Function(String json) fromJson = TachimangaBackupSettingMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupSource
    with TachimangaBackupSourceMappable
    implements ConvertableType<TachiBackupSource, TachimangaBackupDb> {
  final int id;
  final String name;
  final String lang;
  final int extension;
  final bool isNsfw;
  final bool? isDirect;
  final bool? randomUa;

  const TachimangaBackupSource({
    required this.id,
    required this.name,
    required this.lang,
    required this.extension,
    required this.isNsfw,
    required this.isDirect,
    required this.randomUa,
  });

  @override
  TachiBackupSource toType(TachimangaBackupDb arg) {
    return TachiBackupSource(name: name, sourceId: id);
  }

  static const TachimangaBackupSource Function(Map<String, dynamic> map) fromMap = TachimangaBackupSourceMapper.fromMap;
  static const TachimangaBackupSource Function(String json) fromJson = TachimangaBackupSourceMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupTrackRecord
    with TachimangaBackupTrackRecordMappable
    implements ConvertableType<TachiBackupTracking, TachimangaBackupDb> {
  final int id;
  final int mangaId;
  final int syncId;
  final int remoteId;
  final int? libraryId;
  final String title;
  final double lastChapterRead;
  final int totalChapters;
  final int status;
  final double score;
  final String remoteUrl;
  final int startDate;
  final int finishDate;

  const TachimangaBackupTrackRecord({
    required this.id,
    required this.mangaId,
    required this.syncId,
    required this.remoteId,
    required this.libraryId,
    required this.title,
    required this.lastChapterRead,
    required this.totalChapters,
    required this.status,
    required this.score,
    required this.remoteUrl,
    required this.startDate,
    required this.finishDate,
  });

  @override
  TachiBackupTracking toType(TachimangaBackupDb db) {
    return TachiBackupTracking(
      syncId: syncId,
      libraryId: libraryId ?? -1,
      mediaIdInt: mangaId,
      trackingUrl: remoteUrl,
      title: title,
      lastChapterRead: lastChapterRead,
      totalChapters: totalChapters,
      score: score,
      status: status,
      startedReadingDate: startDate,
      finishedReadingDate: finishDate,
      mediaId: mangaId,
    );
  }

  static const TachimangaBackupTrackRecord Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupTrackRecordMapper.fromMap;
  static const TachimangaBackupTrackRecord Function(String json) fromJson = TachimangaBackupTrackRecordMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class TachimangaBackupSqliteSequence with TachimangaBackupSqliteSequenceMappable {
  final String? name;
  final int? seq;

  const TachimangaBackupSqliteSequence({required this.name, required this.seq});

  static const TachimangaBackupSqliteSequence Function(Map<String, dynamic> map) fromMap =
      TachimangaBackupSqliteSequenceMapper.fromMap;
  static const TachimangaBackupSqliteSequence Function(String json) fromJson =
      TachimangaBackupSqliteSequenceMapper.fromJson;
}

@MappableEnum(caseStyle: CaseStyle.pascalCase)
enum TachimangaBackupTable<T> {
  category(TachimangaBackupCategory.fromMap),
  categoryMeta(TachimangaBackupCategoryMeta.fromMap),
  categoryManga(TachimangaBackupCategoryManga.fromMap),
  chapter(TachimangaBackupChapter.fromMap),
  chapterMeta(TachimangaBackupChapterMeta.fromMap),
  extension(TachimangaBackupExtension.fromMap),
  history(TachimangaBackupHistory.fromMap),
  manga(TachimangaBackupManga.fromMap),
  mangaMeta(TachimangaBackupMangaMeta.fromMap),
  migrations(TachimangaBackupDbMigrations.fromMap),
  page(TachimangaBackupPage.fromMap),
  repo(TachimangaBackupRepo.fromMap),
  setting(TachimangaBackupSetting.fromMap),
  source(TachimangaBackupSource.fromMap),
  trackRecord(TachimangaBackupTrackRecord.fromMap),

  // ignore: constant_identifier_names
  sqlite_sequence(TachimangaBackupSqliteSequence.fromMap)
  ;

  const TachimangaBackupTable(this.fromMap);

  final T Function(Map<String, dynamic> map) fromMap;
}

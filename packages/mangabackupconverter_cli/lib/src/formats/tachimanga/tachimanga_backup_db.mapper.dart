// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachimanga_backup_db.dart';

class TachimangaBackupDbMapper extends ClassMapperBase<TachimangaBackupDb> {
  TachimangaBackupDbMapper._();

  static TachimangaBackupDbMapper? _instance;
  static TachimangaBackupDbMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaBackupDbMapper._());
      TachimangaBackupCategoryMapper.ensureInitialized();
      TachimangaBackupCategoryMangaMapper.ensureInitialized();
      TachimangaBackupCategoryMetaMapper.ensureInitialized();
      TachimangaBackupChapterMapper.ensureInitialized();
      TachimangaBackupChapterMetaMapper.ensureInitialized();
      TachimangaBackupExtensionMapper.ensureInitialized();
      TachimangaBackupHistoryMapper.ensureInitialized();
      TachimangaBackupMangaMapper.ensureInitialized();
      TachimangaBackupMangaMetaMapper.ensureInitialized();
      TachimangaBackupDbMigrationsMapper.ensureInitialized();
      TachimangaBackupPageMapper.ensureInitialized();
      TachimangaBackupRepoMapper.ensureInitialized();
      TachimangaBackupSettingMapper.ensureInitialized();
      TachimangaBackupSourceMapper.ensureInitialized();
      TachimangaBackupTrackRecordMapper.ensureInitialized();
      TachimangaBackupSqliteSequenceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupDb';

  static List<TachimangaBackupCategory> _$categoryTable(TachimangaBackupDb v) =>
      v.categoryTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupCategory>>
  _f$categoryTable = Field('categoryTable', _$categoryTable);
  static List<TachimangaBackupCategoryManga> _$categoryMangaTable(
    TachimangaBackupDb v,
  ) => v.categoryMangaTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupCategoryManga>>
  _f$categoryMangaTable = Field('categoryMangaTable', _$categoryMangaTable);
  static List<TachimangaBackupCategoryMeta> _$categoryMetaTable(
    TachimangaBackupDb v,
  ) => v.categoryMetaTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupCategoryMeta>>
  _f$categoryMetaTable = Field('categoryMetaTable', _$categoryMetaTable);
  static List<TachimangaBackupChapter> _$chapterTable(TachimangaBackupDb v) =>
      v.chapterTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupChapter>>
  _f$chapterTable = Field('chapterTable', _$chapterTable);
  static List<TachimangaBackupChapterMeta> _$chapterMetaTable(
    TachimangaBackupDb v,
  ) => v.chapterMetaTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupChapterMeta>>
  _f$chapterMetaTable = Field('chapterMetaTable', _$chapterMetaTable);
  static List<TachimangaBackupExtension> _$extensionTable(
    TachimangaBackupDb v,
  ) => v.extensionTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupExtension>>
  _f$extensionTable = Field('extensionTable', _$extensionTable);
  static List<TachimangaBackupHistory> _$historyTable(TachimangaBackupDb v) =>
      v.historyTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupHistory>>
  _f$historyTable = Field('historyTable', _$historyTable);
  static List<TachimangaBackupManga> _$mangaTable(TachimangaBackupDb v) =>
      v.mangaTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupManga>>
  _f$mangaTable = Field('mangaTable', _$mangaTable);
  static List<TachimangaBackupMangaMeta> _$mangaMetaTable(
    TachimangaBackupDb v,
  ) => v.mangaMetaTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupMangaMeta>>
  _f$mangaMetaTable = Field('mangaMetaTable', _$mangaMetaTable);
  static List<TachimangaBackupDbMigrations> _$migrationsTable(
    TachimangaBackupDb v,
  ) => v.migrationsTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupDbMigrations>>
  _f$migrationsTable = Field('migrationsTable', _$migrationsTable);
  static List<TachimangaBackupPage> _$pageTable(TachimangaBackupDb v) =>
      v.pageTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupPage>>
  _f$pageTable = Field('pageTable', _$pageTable);
  static List<TachimangaBackupRepo> _$repoTable(TachimangaBackupDb v) =>
      v.repoTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupRepo>>
  _f$repoTable = Field('repoTable', _$repoTable);
  static List<TachimangaBackupSetting> _$settingTable(TachimangaBackupDb v) =>
      v.settingTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupSetting>>
  _f$settingTable = Field('settingTable', _$settingTable);
  static List<TachimangaBackupSource> _$sourceTable(TachimangaBackupDb v) =>
      v.sourceTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupSource>>
  _f$sourceTable = Field('sourceTable', _$sourceTable);
  static List<TachimangaBackupTrackRecord> _$trackRecordTable(
    TachimangaBackupDb v,
  ) => v.trackRecordTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupTrackRecord>>
  _f$trackRecordTable = Field('trackRecordTable', _$trackRecordTable);
  static List<TachimangaBackupSqliteSequence> _$sqliteSequenceTable(
    TachimangaBackupDb v,
  ) => v.sqliteSequenceTable;
  static const Field<TachimangaBackupDb, List<TachimangaBackupSqliteSequence>>
  _f$sqliteSequenceTable = Field('sqliteSequenceTable', _$sqliteSequenceTable);

  @override
  final MappableFields<TachimangaBackupDb> fields = const {
    #categoryTable: _f$categoryTable,
    #categoryMangaTable: _f$categoryMangaTable,
    #categoryMetaTable: _f$categoryMetaTable,
    #chapterTable: _f$chapterTable,
    #chapterMetaTable: _f$chapterMetaTable,
    #extensionTable: _f$extensionTable,
    #historyTable: _f$historyTable,
    #mangaTable: _f$mangaTable,
    #mangaMetaTable: _f$mangaMetaTable,
    #migrationsTable: _f$migrationsTable,
    #pageTable: _f$pageTable,
    #repoTable: _f$repoTable,
    #settingTable: _f$settingTable,
    #sourceTable: _f$sourceTable,
    #trackRecordTable: _f$trackRecordTable,
    #sqliteSequenceTable: _f$sqliteSequenceTable,
  };

  static TachimangaBackupDb _instantiate(DecodingData data) {
    return TachimangaBackupDb(
      categoryTable: data.dec(_f$categoryTable),
      categoryMangaTable: data.dec(_f$categoryMangaTable),
      categoryMetaTable: data.dec(_f$categoryMetaTable),
      chapterTable: data.dec(_f$chapterTable),
      chapterMetaTable: data.dec(_f$chapterMetaTable),
      extensionTable: data.dec(_f$extensionTable),
      historyTable: data.dec(_f$historyTable),
      mangaTable: data.dec(_f$mangaTable),
      mangaMetaTable: data.dec(_f$mangaMetaTable),
      migrationsTable: data.dec(_f$migrationsTable),
      pageTable: data.dec(_f$pageTable),
      repoTable: data.dec(_f$repoTable),
      settingTable: data.dec(_f$settingTable),
      sourceTable: data.dec(_f$sourceTable),
      trackRecordTable: data.dec(_f$trackRecordTable),
      sqliteSequenceTable: data.dec(_f$sqliteSequenceTable),
    );
  }

  @override
  final Function instantiate = _instantiate;
}

mixin TachimangaBackupDbMappable {
  TachimangaBackupDbCopyWith<
    TachimangaBackupDb,
    TachimangaBackupDb,
    TachimangaBackupDb
  >
  get copyWith => _TachimangaBackupDbCopyWithImpl(
    this as TachimangaBackupDb,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return TachimangaBackupDbMapper.ensureInitialized().stringifyValue(
      this as TachimangaBackupDb,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupDbMapper.ensureInitialized().equalsValue(
      this as TachimangaBackupDb,
      other,
    );
  }

  @override
  int get hashCode {
    return TachimangaBackupDbMapper.ensureInitialized().hashValue(
      this as TachimangaBackupDb,
    );
  }
}

extension TachimangaBackupDbValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupDb, $Out> {
  TachimangaBackupDbCopyWith<$R, TachimangaBackupDb, $Out>
  get $asTachimangaBackupDb =>
      $base.as((v, t, t2) => _TachimangaBackupDbCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupDbCopyWith<
  $R,
  $In extends TachimangaBackupDb,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    TachimangaBackupCategory,
    TachimangaBackupCategoryCopyWith<
      $R,
      TachimangaBackupCategory,
      TachimangaBackupCategory
    >
  >
  get categoryTable;
  ListCopyWith<
    $R,
    TachimangaBackupCategoryManga,
    TachimangaBackupCategoryMangaCopyWith<
      $R,
      TachimangaBackupCategoryManga,
      TachimangaBackupCategoryManga
    >
  >
  get categoryMangaTable;
  ListCopyWith<
    $R,
    TachimangaBackupCategoryMeta,
    TachimangaBackupCategoryMetaCopyWith<
      $R,
      TachimangaBackupCategoryMeta,
      TachimangaBackupCategoryMeta
    >
  >
  get categoryMetaTable;
  ListCopyWith<
    $R,
    TachimangaBackupChapter,
    TachimangaBackupChapterCopyWith<
      $R,
      TachimangaBackupChapter,
      TachimangaBackupChapter
    >
  >
  get chapterTable;
  ListCopyWith<
    $R,
    TachimangaBackupChapterMeta,
    TachimangaBackupChapterMetaCopyWith<
      $R,
      TachimangaBackupChapterMeta,
      TachimangaBackupChapterMeta
    >
  >
  get chapterMetaTable;
  ListCopyWith<
    $R,
    TachimangaBackupExtension,
    TachimangaBackupExtensionCopyWith<
      $R,
      TachimangaBackupExtension,
      TachimangaBackupExtension
    >
  >
  get extensionTable;
  ListCopyWith<
    $R,
    TachimangaBackupHistory,
    TachimangaBackupHistoryCopyWith<
      $R,
      TachimangaBackupHistory,
      TachimangaBackupHistory
    >
  >
  get historyTable;
  ListCopyWith<
    $R,
    TachimangaBackupManga,
    TachimangaBackupMangaCopyWith<
      $R,
      TachimangaBackupManga,
      TachimangaBackupManga
    >
  >
  get mangaTable;
  ListCopyWith<
    $R,
    TachimangaBackupMangaMeta,
    TachimangaBackupMangaMetaCopyWith<
      $R,
      TachimangaBackupMangaMeta,
      TachimangaBackupMangaMeta
    >
  >
  get mangaMetaTable;
  ListCopyWith<
    $R,
    TachimangaBackupDbMigrations,
    TachimangaBackupDbMigrationsCopyWith<
      $R,
      TachimangaBackupDbMigrations,
      TachimangaBackupDbMigrations
    >
  >
  get migrationsTable;
  ListCopyWith<
    $R,
    TachimangaBackupPage,
    TachimangaBackupPageCopyWith<$R, TachimangaBackupPage, TachimangaBackupPage>
  >
  get pageTable;
  ListCopyWith<
    $R,
    TachimangaBackupRepo,
    TachimangaBackupRepoCopyWith<$R, TachimangaBackupRepo, TachimangaBackupRepo>
  >
  get repoTable;
  ListCopyWith<
    $R,
    TachimangaBackupSetting,
    TachimangaBackupSettingCopyWith<
      $R,
      TachimangaBackupSetting,
      TachimangaBackupSetting
    >
  >
  get settingTable;
  ListCopyWith<
    $R,
    TachimangaBackupSource,
    TachimangaBackupSourceCopyWith<
      $R,
      TachimangaBackupSource,
      TachimangaBackupSource
    >
  >
  get sourceTable;
  ListCopyWith<
    $R,
    TachimangaBackupTrackRecord,
    TachimangaBackupTrackRecordCopyWith<
      $R,
      TachimangaBackupTrackRecord,
      TachimangaBackupTrackRecord
    >
  >
  get trackRecordTable;
  ListCopyWith<
    $R,
    TachimangaBackupSqliteSequence,
    TachimangaBackupSqliteSequenceCopyWith<
      $R,
      TachimangaBackupSqliteSequence,
      TachimangaBackupSqliteSequence
    >
  >
  get sqliteSequenceTable;
  $R call({
    List<TachimangaBackupCategory>? categoryTable,
    List<TachimangaBackupCategoryManga>? categoryMangaTable,
    List<TachimangaBackupCategoryMeta>? categoryMetaTable,
    List<TachimangaBackupChapter>? chapterTable,
    List<TachimangaBackupChapterMeta>? chapterMetaTable,
    List<TachimangaBackupExtension>? extensionTable,
    List<TachimangaBackupHistory>? historyTable,
    List<TachimangaBackupManga>? mangaTable,
    List<TachimangaBackupMangaMeta>? mangaMetaTable,
    List<TachimangaBackupDbMigrations>? migrationsTable,
    List<TachimangaBackupPage>? pageTable,
    List<TachimangaBackupRepo>? repoTable,
    List<TachimangaBackupSetting>? settingTable,
    List<TachimangaBackupSource>? sourceTable,
    List<TachimangaBackupTrackRecord>? trackRecordTable,
    List<TachimangaBackupSqliteSequence>? sqliteSequenceTable,
  });
  TachimangaBackupDbCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachimangaBackupDbCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupDb, $Out>
    implements TachimangaBackupDbCopyWith<$R, TachimangaBackupDb, $Out> {
  _TachimangaBackupDbCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupDb> $mapper =
      TachimangaBackupDbMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    TachimangaBackupCategory,
    TachimangaBackupCategoryCopyWith<
      $R,
      TachimangaBackupCategory,
      TachimangaBackupCategory
    >
  >
  get categoryTable => ListCopyWith(
    $value.categoryTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(categoryTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupCategoryManga,
    TachimangaBackupCategoryMangaCopyWith<
      $R,
      TachimangaBackupCategoryManga,
      TachimangaBackupCategoryManga
    >
  >
  get categoryMangaTable => ListCopyWith(
    $value.categoryMangaTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(categoryMangaTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupCategoryMeta,
    TachimangaBackupCategoryMetaCopyWith<
      $R,
      TachimangaBackupCategoryMeta,
      TachimangaBackupCategoryMeta
    >
  >
  get categoryMetaTable => ListCopyWith(
    $value.categoryMetaTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(categoryMetaTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupChapter,
    TachimangaBackupChapterCopyWith<
      $R,
      TachimangaBackupChapter,
      TachimangaBackupChapter
    >
  >
  get chapterTable => ListCopyWith(
    $value.chapterTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(chapterTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupChapterMeta,
    TachimangaBackupChapterMetaCopyWith<
      $R,
      TachimangaBackupChapterMeta,
      TachimangaBackupChapterMeta
    >
  >
  get chapterMetaTable => ListCopyWith(
    $value.chapterMetaTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(chapterMetaTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupExtension,
    TachimangaBackupExtensionCopyWith<
      $R,
      TachimangaBackupExtension,
      TachimangaBackupExtension
    >
  >
  get extensionTable => ListCopyWith(
    $value.extensionTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(extensionTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupHistory,
    TachimangaBackupHistoryCopyWith<
      $R,
      TachimangaBackupHistory,
      TachimangaBackupHistory
    >
  >
  get historyTable => ListCopyWith(
    $value.historyTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(historyTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupManga,
    TachimangaBackupMangaCopyWith<
      $R,
      TachimangaBackupManga,
      TachimangaBackupManga
    >
  >
  get mangaTable => ListCopyWith(
    $value.mangaTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mangaTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupMangaMeta,
    TachimangaBackupMangaMetaCopyWith<
      $R,
      TachimangaBackupMangaMeta,
      TachimangaBackupMangaMeta
    >
  >
  get mangaMetaTable => ListCopyWith(
    $value.mangaMetaTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mangaMetaTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupDbMigrations,
    TachimangaBackupDbMigrationsCopyWith<
      $R,
      TachimangaBackupDbMigrations,
      TachimangaBackupDbMigrations
    >
  >
  get migrationsTable => ListCopyWith(
    $value.migrationsTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(migrationsTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupPage,
    TachimangaBackupPageCopyWith<$R, TachimangaBackupPage, TachimangaBackupPage>
  >
  get pageTable => ListCopyWith(
    $value.pageTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(pageTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupRepo,
    TachimangaBackupRepoCopyWith<$R, TachimangaBackupRepo, TachimangaBackupRepo>
  >
  get repoTable => ListCopyWith(
    $value.repoTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(repoTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupSetting,
    TachimangaBackupSettingCopyWith<
      $R,
      TachimangaBackupSetting,
      TachimangaBackupSetting
    >
  >
  get settingTable => ListCopyWith(
    $value.settingTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(settingTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupSource,
    TachimangaBackupSourceCopyWith<
      $R,
      TachimangaBackupSource,
      TachimangaBackupSource
    >
  >
  get sourceTable => ListCopyWith(
    $value.sourceTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(sourceTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupTrackRecord,
    TachimangaBackupTrackRecordCopyWith<
      $R,
      TachimangaBackupTrackRecord,
      TachimangaBackupTrackRecord
    >
  >
  get trackRecordTable => ListCopyWith(
    $value.trackRecordTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(trackRecordTable: v),
  );
  @override
  ListCopyWith<
    $R,
    TachimangaBackupSqliteSequence,
    TachimangaBackupSqliteSequenceCopyWith<
      $R,
      TachimangaBackupSqliteSequence,
      TachimangaBackupSqliteSequence
    >
  >
  get sqliteSequenceTable => ListCopyWith(
    $value.sqliteSequenceTable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(sqliteSequenceTable: v),
  );
  @override
  $R call({
    List<TachimangaBackupCategory>? categoryTable,
    List<TachimangaBackupCategoryManga>? categoryMangaTable,
    List<TachimangaBackupCategoryMeta>? categoryMetaTable,
    List<TachimangaBackupChapter>? chapterTable,
    List<TachimangaBackupChapterMeta>? chapterMetaTable,
    List<TachimangaBackupExtension>? extensionTable,
    List<TachimangaBackupHistory>? historyTable,
    List<TachimangaBackupManga>? mangaTable,
    List<TachimangaBackupMangaMeta>? mangaMetaTable,
    List<TachimangaBackupDbMigrations>? migrationsTable,
    List<TachimangaBackupPage>? pageTable,
    List<TachimangaBackupRepo>? repoTable,
    List<TachimangaBackupSetting>? settingTable,
    List<TachimangaBackupSource>? sourceTable,
    List<TachimangaBackupTrackRecord>? trackRecordTable,
    List<TachimangaBackupSqliteSequence>? sqliteSequenceTable,
  }) => $apply(
    FieldCopyWithData({
      if (categoryTable != null) #categoryTable: categoryTable,
      if (categoryMangaTable != null) #categoryMangaTable: categoryMangaTable,
      if (categoryMetaTable != null) #categoryMetaTable: categoryMetaTable,
      if (chapterTable != null) #chapterTable: chapterTable,
      if (chapterMetaTable != null) #chapterMetaTable: chapterMetaTable,
      if (extensionTable != null) #extensionTable: extensionTable,
      if (historyTable != null) #historyTable: historyTable,
      if (mangaTable != null) #mangaTable: mangaTable,
      if (mangaMetaTable != null) #mangaMetaTable: mangaMetaTable,
      if (migrationsTable != null) #migrationsTable: migrationsTable,
      if (pageTable != null) #pageTable: pageTable,
      if (repoTable != null) #repoTable: repoTable,
      if (settingTable != null) #settingTable: settingTable,
      if (sourceTable != null) #sourceTable: sourceTable,
      if (trackRecordTable != null) #trackRecordTable: trackRecordTable,
      if (sqliteSequenceTable != null)
        #sqliteSequenceTable: sqliteSequenceTable,
    }),
  );
  @override
  TachimangaBackupDb $make(CopyWithData data) => TachimangaBackupDb(
    categoryTable: data.get(#categoryTable, or: $value.categoryTable),
    categoryMangaTable: data.get(
      #categoryMangaTable,
      or: $value.categoryMangaTable,
    ),
    categoryMetaTable: data.get(
      #categoryMetaTable,
      or: $value.categoryMetaTable,
    ),
    chapterTable: data.get(#chapterTable, or: $value.chapterTable),
    chapterMetaTable: data.get(#chapterMetaTable, or: $value.chapterMetaTable),
    extensionTable: data.get(#extensionTable, or: $value.extensionTable),
    historyTable: data.get(#historyTable, or: $value.historyTable),
    mangaTable: data.get(#mangaTable, or: $value.mangaTable),
    mangaMetaTable: data.get(#mangaMetaTable, or: $value.mangaMetaTable),
    migrationsTable: data.get(#migrationsTable, or: $value.migrationsTable),
    pageTable: data.get(#pageTable, or: $value.pageTable),
    repoTable: data.get(#repoTable, or: $value.repoTable),
    settingTable: data.get(#settingTable, or: $value.settingTable),
    sourceTable: data.get(#sourceTable, or: $value.sourceTable),
    trackRecordTable: data.get(#trackRecordTable, or: $value.trackRecordTable),
    sqliteSequenceTable: data.get(
      #sqliteSequenceTable,
      or: $value.sqliteSequenceTable,
    ),
  );

  @override
  TachimangaBackupDbCopyWith<$R2, TachimangaBackupDb, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachimangaBackupDbCopyWithImpl($value, $cast, t);
}

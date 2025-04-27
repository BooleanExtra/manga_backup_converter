// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mangayomi_backup_db.dart';

class ItemTypeMapper extends EnumMapper<ItemType> {
  ItemTypeMapper._();

  static ItemTypeMapper? _instance;
  static ItemTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ItemTypeMapper._());
    }
    return _instance!;
  }

  static ItemType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ItemType decode(dynamic value) {
    switch (value) {
      case 0:
        return ItemType.manga;
      case 1:
        return ItemType.anime;
      case 2:
        return ItemType.novel;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ItemType self) {
    switch (self) {
      case ItemType.manga:
        return 0;
      case ItemType.anime:
        return 1;
      case ItemType.novel:
        return 2;
    }
  }
}

extension ItemTypeMapperExtension on ItemType {
  dynamic toValue() {
    ItemTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ItemType>(this);
  }
}

class SourceCodeLanguageMapper extends EnumMapper<SourceCodeLanguage> {
  SourceCodeLanguageMapper._();

  static SourceCodeLanguageMapper? _instance;
  static SourceCodeLanguageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SourceCodeLanguageMapper._());
    }
    return _instance!;
  }

  static SourceCodeLanguage fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SourceCodeLanguage decode(dynamic value) {
    switch (value) {
      case 0:
        return SourceCodeLanguage.dart;
      case 1:
        return SourceCodeLanguage.javascript;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SourceCodeLanguage self) {
    switch (self) {
      case SourceCodeLanguage.dart:
        return 0;
      case SourceCodeLanguage.javascript:
        return 1;
    }
  }
}

extension SourceCodeLanguageMapperExtension on SourceCodeLanguage {
  dynamic toValue() {
    SourceCodeLanguageMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SourceCodeLanguage>(this);
  }
}

class MangayomiBackupDbMapper extends ClassMapperBase<MangayomiBackupDb> {
  MangayomiBackupDbMapper._();

  static MangayomiBackupDbMapper? _instance;
  static MangayomiBackupDbMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiBackupDbMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      MangayomiBackupMangaMapper.ensureInitialized();
      MangayomiBackupCategoryMapper.ensureInitialized();
      MangayomiBackupChapterMapper.ensureInitialized();
      MangayomiBackupDownloadMapper.ensureInitialized();
      MangayomiBackupTrackMapper.ensureInitialized();
      MangayomiBackupHistoryMapper.ensureInitialized();
      MangayomiBackupUpdateMapper.ensureInitialized();
      MangayomiBackupSettingsMapper.ensureInitialized();
      MangayomiBackupExtensionPreferencesMapper.ensureInitialized();
      MangayomiBackupTrackPreferencesMapper.ensureInitialized();
      MangayomiBackupExtensionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupDb';

  static String? _$version(MangayomiBackupDb v) => v.version;
  static const Field<MangayomiBackupDb, String> _f$version = Field(
    'version',
    _$version,
    opt: true,
    def: '2',
  );
  static List<MangayomiBackupManga>? _$manga(MangayomiBackupDb v) => v.manga;
  static const Field<MangayomiBackupDb, List<MangayomiBackupManga>> _f$manga =
      Field('manga', _$manga, opt: true);
  static List<MangayomiBackupCategory>? _$categories(MangayomiBackupDb v) =>
      v.categories;
  static const Field<MangayomiBackupDb, List<MangayomiBackupCategory>>
  _f$categories = Field('categories', _$categories, opt: true);
  static List<MangayomiBackupChapter>? _$chapters(MangayomiBackupDb v) =>
      v.chapters;
  static const Field<MangayomiBackupDb, List<MangayomiBackupChapter>>
  _f$chapters = Field('chapters', _$chapters, opt: true);
  static List<MangayomiBackupDownload>? _$downloads(MangayomiBackupDb v) =>
      v.downloads;
  static const Field<MangayomiBackupDb, List<MangayomiBackupDownload>>
  _f$downloads = Field('downloads', _$downloads, opt: true);
  static List<MangayomiBackupTrack>? _$tracks(MangayomiBackupDb v) => v.tracks;
  static const Field<MangayomiBackupDb, List<MangayomiBackupTrack>> _f$tracks =
      Field('tracks', _$tracks, opt: true);
  static List<MangayomiBackupHistory>? _$history(MangayomiBackupDb v) =>
      v.history;
  static const Field<MangayomiBackupDb, List<MangayomiBackupHistory>>
  _f$history = Field('history', _$history, opt: true);
  static List<MangayomiBackupUpdate>? _$updates(MangayomiBackupDb v) =>
      v.updates;
  static const Field<MangayomiBackupDb, List<MangayomiBackupUpdate>>
  _f$updates = Field('updates', _$updates, opt: true);
  static List<MangayomiBackupSettings>? _$settings(MangayomiBackupDb v) =>
      v.settings;
  static const Field<MangayomiBackupDb, List<MangayomiBackupSettings>>
  _f$settings = Field('settings', _$settings, opt: true);
  static List<MangayomiBackupExtensionPreferences>? _$extensionPreferences(
    MangayomiBackupDb v,
  ) => v.extensionPreferences;
  static const Field<
    MangayomiBackupDb,
    List<MangayomiBackupExtensionPreferences>
  >
  _f$extensionPreferences = Field(
    'extensionPreferences',
    _$extensionPreferences,
    key: r'extension_preferences',
    opt: true,
  );
  static List<MangayomiBackupTrackPreferences>? _$trackPreferences(
    MangayomiBackupDb v,
  ) => v.trackPreferences;
  static const Field<MangayomiBackupDb, List<MangayomiBackupTrackPreferences>>
  _f$trackPreferences = Field(
    'trackPreferences',
    _$trackPreferences,
    opt: true,
  );
  static List<MangayomiBackupExtension>? _$extensions(MangayomiBackupDb v) =>
      v.extensions;
  static const Field<MangayomiBackupDb, List<MangayomiBackupExtension>>
  _f$extensions = Field('extensions', _$extensions, opt: true);

  @override
  final MappableFields<MangayomiBackupDb> fields = const {
    #version: _f$version,
    #manga: _f$manga,
    #categories: _f$categories,
    #chapters: _f$chapters,
    #downloads: _f$downloads,
    #tracks: _f$tracks,
    #history: _f$history,
    #updates: _f$updates,
    #settings: _f$settings,
    #extensionPreferences: _f$extensionPreferences,
    #trackPreferences: _f$trackPreferences,
    #extensions: _f$extensions,
  };

  static MangayomiBackupDb _instantiate(DecodingData data) {
    return MangayomiBackupDb(
      version: data.dec(_f$version),
      manga: data.dec(_f$manga),
      categories: data.dec(_f$categories),
      chapters: data.dec(_f$chapters),
      downloads: data.dec(_f$downloads),
      tracks: data.dec(_f$tracks),
      history: data.dec(_f$history),
      updates: data.dec(_f$updates),
      settings: data.dec(_f$settings),
      extensionPreferences: data.dec(_f$extensionPreferences),
      trackPreferences: data.dec(_f$trackPreferences),
      extensions: data.dec(_f$extensions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupDb fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupDb>(map);
  }

  static MangayomiBackupDb fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupDb>(json);
  }
}

mixin MangayomiBackupDbMappable {
  String toJson() {
    return MangayomiBackupDbMapper.ensureInitialized()
        .encodeJson<MangayomiBackupDb>(this as MangayomiBackupDb);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupDbMapper.ensureInitialized()
        .encodeMap<MangayomiBackupDb>(this as MangayomiBackupDb);
  }

  MangayomiBackupDbCopyWith<
    MangayomiBackupDb,
    MangayomiBackupDb,
    MangayomiBackupDb
  >
  get copyWith => _MangayomiBackupDbCopyWithImpl(
    this as MangayomiBackupDb,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupDbMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupDb,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupDbMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupDb,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupDbMapper.ensureInitialized().hashValue(
      this as MangayomiBackupDb,
    );
  }
}

extension MangayomiBackupDbValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupDb, $Out> {
  MangayomiBackupDbCopyWith<$R, MangayomiBackupDb, $Out>
  get $asMangayomiBackupDb =>
      $base.as((v, t, t2) => _MangayomiBackupDbCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupDbCopyWith<
  $R,
  $In extends MangayomiBackupDb,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    MangayomiBackupManga,
    MangayomiBackupMangaCopyWith<$R, MangayomiBackupManga, MangayomiBackupManga>
  >?
  get manga;
  ListCopyWith<
    $R,
    MangayomiBackupCategory,
    MangayomiBackupCategoryCopyWith<
      $R,
      MangayomiBackupCategory,
      MangayomiBackupCategory
    >
  >?
  get categories;
  ListCopyWith<
    $R,
    MangayomiBackupChapter,
    MangayomiBackupChapterCopyWith<
      $R,
      MangayomiBackupChapter,
      MangayomiBackupChapter
    >
  >?
  get chapters;
  ListCopyWith<
    $R,
    MangayomiBackupDownload,
    MangayomiBackupDownloadCopyWith<
      $R,
      MangayomiBackupDownload,
      MangayomiBackupDownload
    >
  >?
  get downloads;
  ListCopyWith<
    $R,
    MangayomiBackupTrack,
    MangayomiBackupTrackCopyWith<$R, MangayomiBackupTrack, MangayomiBackupTrack>
  >?
  get tracks;
  ListCopyWith<
    $R,
    MangayomiBackupHistory,
    MangayomiBackupHistoryCopyWith<
      $R,
      MangayomiBackupHistory,
      MangayomiBackupHistory
    >
  >?
  get history;
  ListCopyWith<
    $R,
    MangayomiBackupUpdate,
    MangayomiBackupUpdateCopyWith<
      $R,
      MangayomiBackupUpdate,
      MangayomiBackupUpdate
    >
  >?
  get updates;
  ListCopyWith<
    $R,
    MangayomiBackupSettings,
    MangayomiBackupSettingsCopyWith<
      $R,
      MangayomiBackupSettings,
      MangayomiBackupSettings
    >
  >?
  get settings;
  ListCopyWith<
    $R,
    MangayomiBackupExtensionPreferences,
    MangayomiBackupExtensionPreferencesCopyWith<
      $R,
      MangayomiBackupExtensionPreferences,
      MangayomiBackupExtensionPreferences
    >
  >?
  get extensionPreferences;
  ListCopyWith<
    $R,
    MangayomiBackupTrackPreferences,
    MangayomiBackupTrackPreferencesCopyWith<
      $R,
      MangayomiBackupTrackPreferences,
      MangayomiBackupTrackPreferences
    >
  >?
  get trackPreferences;
  ListCopyWith<
    $R,
    MangayomiBackupExtension,
    MangayomiBackupExtensionCopyWith<
      $R,
      MangayomiBackupExtension,
      MangayomiBackupExtension
    >
  >?
  get extensions;
  $R call({
    String? version,
    List<MangayomiBackupManga>? manga,
    List<MangayomiBackupCategory>? categories,
    List<MangayomiBackupChapter>? chapters,
    List<MangayomiBackupDownload>? downloads,
    List<MangayomiBackupTrack>? tracks,
    List<MangayomiBackupHistory>? history,
    List<MangayomiBackupUpdate>? updates,
    List<MangayomiBackupSettings>? settings,
    List<MangayomiBackupExtensionPreferences>? extensionPreferences,
    List<MangayomiBackupTrackPreferences>? trackPreferences,
    List<MangayomiBackupExtension>? extensions,
  });
  MangayomiBackupDbCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupDbCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupDb, $Out>
    implements MangayomiBackupDbCopyWith<$R, MangayomiBackupDb, $Out> {
  _MangayomiBackupDbCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupDb> $mapper =
      MangayomiBackupDbMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    MangayomiBackupManga,
    MangayomiBackupMangaCopyWith<$R, MangayomiBackupManga, MangayomiBackupManga>
  >?
  get manga =>
      $value.manga != null
          ? ListCopyWith(
            $value.manga!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(manga: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupCategory,
    MangayomiBackupCategoryCopyWith<
      $R,
      MangayomiBackupCategory,
      MangayomiBackupCategory
    >
  >?
  get categories =>
      $value.categories != null
          ? ListCopyWith(
            $value.categories!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(categories: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupChapter,
    MangayomiBackupChapterCopyWith<
      $R,
      MangayomiBackupChapter,
      MangayomiBackupChapter
    >
  >?
  get chapters =>
      $value.chapters != null
          ? ListCopyWith(
            $value.chapters!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(chapters: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupDownload,
    MangayomiBackupDownloadCopyWith<
      $R,
      MangayomiBackupDownload,
      MangayomiBackupDownload
    >
  >?
  get downloads =>
      $value.downloads != null
          ? ListCopyWith(
            $value.downloads!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(downloads: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupTrack,
    MangayomiBackupTrackCopyWith<$R, MangayomiBackupTrack, MangayomiBackupTrack>
  >?
  get tracks =>
      $value.tracks != null
          ? ListCopyWith(
            $value.tracks!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(tracks: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupHistory,
    MangayomiBackupHistoryCopyWith<
      $R,
      MangayomiBackupHistory,
      MangayomiBackupHistory
    >
  >?
  get history =>
      $value.history != null
          ? ListCopyWith(
            $value.history!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(history: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupUpdate,
    MangayomiBackupUpdateCopyWith<
      $R,
      MangayomiBackupUpdate,
      MangayomiBackupUpdate
    >
  >?
  get updates =>
      $value.updates != null
          ? ListCopyWith(
            $value.updates!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(updates: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupSettings,
    MangayomiBackupSettingsCopyWith<
      $R,
      MangayomiBackupSettings,
      MangayomiBackupSettings
    >
  >?
  get settings =>
      $value.settings != null
          ? ListCopyWith(
            $value.settings!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(settings: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupExtensionPreferences,
    MangayomiBackupExtensionPreferencesCopyWith<
      $R,
      MangayomiBackupExtensionPreferences,
      MangayomiBackupExtensionPreferences
    >
  >?
  get extensionPreferences =>
      $value.extensionPreferences != null
          ? ListCopyWith(
            $value.extensionPreferences!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(extensionPreferences: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupTrackPreferences,
    MangayomiBackupTrackPreferencesCopyWith<
      $R,
      MangayomiBackupTrackPreferences,
      MangayomiBackupTrackPreferences
    >
  >?
  get trackPreferences =>
      $value.trackPreferences != null
          ? ListCopyWith(
            $value.trackPreferences!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(trackPreferences: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    MangayomiBackupExtension,
    MangayomiBackupExtensionCopyWith<
      $R,
      MangayomiBackupExtension,
      MangayomiBackupExtension
    >
  >?
  get extensions =>
      $value.extensions != null
          ? ListCopyWith(
            $value.extensions!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(extensions: v),
          )
          : null;
  @override
  $R call({
    Object? version = $none,
    Object? manga = $none,
    Object? categories = $none,
    Object? chapters = $none,
    Object? downloads = $none,
    Object? tracks = $none,
    Object? history = $none,
    Object? updates = $none,
    Object? settings = $none,
    Object? extensionPreferences = $none,
    Object? trackPreferences = $none,
    Object? extensions = $none,
  }) => $apply(
    FieldCopyWithData({
      if (version != $none) #version: version,
      if (manga != $none) #manga: manga,
      if (categories != $none) #categories: categories,
      if (chapters != $none) #chapters: chapters,
      if (downloads != $none) #downloads: downloads,
      if (tracks != $none) #tracks: tracks,
      if (history != $none) #history: history,
      if (updates != $none) #updates: updates,
      if (settings != $none) #settings: settings,
      if (extensionPreferences != $none)
        #extensionPreferences: extensionPreferences,
      if (trackPreferences != $none) #trackPreferences: trackPreferences,
      if (extensions != $none) #extensions: extensions,
    }),
  );
  @override
  MangayomiBackupDb $make(CopyWithData data) => MangayomiBackupDb(
    version: data.get(#version, or: $value.version),
    manga: data.get(#manga, or: $value.manga),
    categories: data.get(#categories, or: $value.categories),
    chapters: data.get(#chapters, or: $value.chapters),
    downloads: data.get(#downloads, or: $value.downloads),
    tracks: data.get(#tracks, or: $value.tracks),
    history: data.get(#history, or: $value.history),
    updates: data.get(#updates, or: $value.updates),
    settings: data.get(#settings, or: $value.settings),
    extensionPreferences: data.get(
      #extensionPreferences,
      or: $value.extensionPreferences,
    ),
    trackPreferences: data.get(#trackPreferences, or: $value.trackPreferences),
    extensions: data.get(#extensions, or: $value.extensions),
  );

  @override
  MangayomiBackupDbCopyWith<$R2, MangayomiBackupDb, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MangayomiBackupDbCopyWithImpl($value, $cast, t);
}

class MangayomiBackupMangaMapper extends ClassMapperBase<MangayomiBackupManga> {
  MangayomiBackupMangaMapper._();

  static MangayomiBackupMangaMapper? _instance;
  static MangayomiBackupMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiBackupMangaMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      ItemTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupManga';

  static String? _$source(MangayomiBackupManga v) => v.source;
  static const Field<MangayomiBackupManga, String> _f$source = Field(
    'source',
    _$source,
  );
  static String? _$author(MangayomiBackupManga v) => v.author;
  static const Field<MangayomiBackupManga, String> _f$author = Field(
    'author',
    _$author,
  );
  static String? _$artist(MangayomiBackupManga v) => v.artist;
  static const Field<MangayomiBackupManga, String> _f$artist = Field(
    'artist',
    _$artist,
  );
  static List<String>? _$genre(MangayomiBackupManga v) => v.genre;
  static const Field<MangayomiBackupManga, List<String>> _f$genre = Field(
    'genre',
    _$genre,
  );
  static String? _$imageUrl(MangayomiBackupManga v) => v.imageUrl;
  static const Field<MangayomiBackupManga, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
  );
  static String? _$lang(MangayomiBackupManga v) => v.lang;
  static const Field<MangayomiBackupManga, String> _f$lang = Field(
    'lang',
    _$lang,
  );
  static String? _$link(MangayomiBackupManga v) => v.link;
  static const Field<MangayomiBackupManga, String> _f$link = Field(
    'link',
    _$link,
  );
  static String? _$name(MangayomiBackupManga v) => v.name;
  static const Field<MangayomiBackupManga, String> _f$name = Field(
    'name',
    _$name,
  );
  static int? _$status(MangayomiBackupManga v) => v.status;
  static const Field<MangayomiBackupManga, int> _f$status = Field(
    'status',
    _$status,
  );
  static String? _$description(MangayomiBackupManga v) => v.description;
  static const Field<MangayomiBackupManga, String> _f$description = Field(
    'description',
    _$description,
  );
  static int? _$id(MangayomiBackupManga v) => v.id;
  static const Field<MangayomiBackupManga, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static bool? _$favorite(MangayomiBackupManga v) => v.favorite;
  static const Field<MangayomiBackupManga, bool> _f$favorite = Field(
    'favorite',
    _$favorite,
    opt: true,
    def: false,
  );
  static bool? _$isManga(MangayomiBackupManga v) => v.isManga;
  static const Field<MangayomiBackupManga, bool> _f$isManga = Field(
    'isManga',
    _$isManga,
    opt: true,
  );
  static ItemType? _$itemType(MangayomiBackupManga v) => v.itemType;
  static const Field<MangayomiBackupManga, ItemType> _f$itemType = Field(
    'itemType',
    _$itemType,
    opt: true,
    def: ItemType.manga,
  );
  static List<String>? _$genres(MangayomiBackupManga v) => v.genres;
  static const Field<MangayomiBackupManga, List<String>> _f$genres = Field(
    'genres',
    _$genres,
    opt: true,
  );
  static int? _$dateAdded(MangayomiBackupManga v) => v.dateAdded;
  static const Field<MangayomiBackupManga, int> _f$dateAdded = Field(
    'dateAdded',
    _$dateAdded,
    opt: true,
  );
  static int? _$lastUpdate(MangayomiBackupManga v) => v.lastUpdate;
  static const Field<MangayomiBackupManga, int> _f$lastUpdate = Field(
    'lastUpdate',
    _$lastUpdate,
    opt: true,
  );
  static String? _$categories(MangayomiBackupManga v) => v.categories;
  static const Field<MangayomiBackupManga, String> _f$categories = Field(
    'categories',
    _$categories,
    opt: true,
  );
  static int? _$lastRead(MangayomiBackupManga v) => v.lastRead;
  static const Field<MangayomiBackupManga, int> _f$lastRead = Field(
    'lastRead',
    _$lastRead,
    opt: true,
    def: 0,
  );
  static bool? _$isLocalArchive(MangayomiBackupManga v) => v.isLocalArchive;
  static const Field<MangayomiBackupManga, bool> _f$isLocalArchive = Field(
    'isLocalArchive',
    _$isLocalArchive,
    opt: true,
    def: false,
  );
  static String? _$customCoverImage(MangayomiBackupManga v) =>
      v.customCoverImage;
  static const Field<MangayomiBackupManga, String> _f$customCoverImage = Field(
    'customCoverImage',
    _$customCoverImage,
    opt: true,
  );
  static String? _$customCoverFromTracker(MangayomiBackupManga v) =>
      v.customCoverFromTracker;
  static const Field<MangayomiBackupManga, String> _f$customCoverFromTracker =
      Field('customCoverFromTracker', _$customCoverFromTracker, opt: true);

  @override
  final MappableFields<MangayomiBackupManga> fields = const {
    #source: _f$source,
    #author: _f$author,
    #artist: _f$artist,
    #genre: _f$genre,
    #imageUrl: _f$imageUrl,
    #lang: _f$lang,
    #link: _f$link,
    #name: _f$name,
    #status: _f$status,
    #description: _f$description,
    #id: _f$id,
    #favorite: _f$favorite,
    #isManga: _f$isManga,
    #itemType: _f$itemType,
    #genres: _f$genres,
    #dateAdded: _f$dateAdded,
    #lastUpdate: _f$lastUpdate,
    #categories: _f$categories,
    #lastRead: _f$lastRead,
    #isLocalArchive: _f$isLocalArchive,
    #customCoverImage: _f$customCoverImage,
    #customCoverFromTracker: _f$customCoverFromTracker,
  };

  static MangayomiBackupManga _instantiate(DecodingData data) {
    return MangayomiBackupManga(
      source: data.dec(_f$source),
      author: data.dec(_f$author),
      artist: data.dec(_f$artist),
      genre: data.dec(_f$genre),
      imageUrl: data.dec(_f$imageUrl),
      lang: data.dec(_f$lang),
      link: data.dec(_f$link),
      name: data.dec(_f$name),
      status: data.dec(_f$status),
      description: data.dec(_f$description),
      id: data.dec(_f$id),
      favorite: data.dec(_f$favorite),
      isManga: data.dec(_f$isManga),
      itemType: data.dec(_f$itemType),
      genres: data.dec(_f$genres),
      dateAdded: data.dec(_f$dateAdded),
      lastUpdate: data.dec(_f$lastUpdate),
      categories: data.dec(_f$categories),
      lastRead: data.dec(_f$lastRead),
      isLocalArchive: data.dec(_f$isLocalArchive),
      customCoverImage: data.dec(_f$customCoverImage),
      customCoverFromTracker: data.dec(_f$customCoverFromTracker),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupManga>(map);
  }

  static MangayomiBackupManga fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupManga>(json);
  }
}

mixin MangayomiBackupMangaMappable {
  String toJson() {
    return MangayomiBackupMangaMapper.ensureInitialized()
        .encodeJson<MangayomiBackupManga>(this as MangayomiBackupManga);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupMangaMapper.ensureInitialized()
        .encodeMap<MangayomiBackupManga>(this as MangayomiBackupManga);
  }

  MangayomiBackupMangaCopyWith<
    MangayomiBackupManga,
    MangayomiBackupManga,
    MangayomiBackupManga
  >
  get copyWith => _MangayomiBackupMangaCopyWithImpl(
    this as MangayomiBackupManga,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupMangaMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupManga,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupMangaMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupManga,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupMangaMapper.ensureInitialized().hashValue(
      this as MangayomiBackupManga,
    );
  }
}

extension MangayomiBackupMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupManga, $Out> {
  MangayomiBackupMangaCopyWith<$R, MangayomiBackupManga, $Out>
  get $asMangayomiBackupManga =>
      $base.as((v, t, t2) => _MangayomiBackupMangaCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupMangaCopyWith<
  $R,
  $In extends MangayomiBackupManga,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get genre;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get genres;
  $R call({
    String? source,
    String? author,
    String? artist,
    List<String>? genre,
    String? imageUrl,
    String? lang,
    String? link,
    String? name,
    int? status,
    String? description,
    int? id,
    bool? favorite,
    bool? isManga,
    ItemType? itemType,
    List<String>? genres,
    int? dateAdded,
    int? lastUpdate,
    String? categories,
    int? lastRead,
    bool? isLocalArchive,
    String? customCoverImage,
    String? customCoverFromTracker,
  });
  MangayomiBackupMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupManga, $Out>
    implements MangayomiBackupMangaCopyWith<$R, MangayomiBackupManga, $Out> {
  _MangayomiBackupMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupManga> $mapper =
      MangayomiBackupMangaMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get genre =>
      $value.genre != null
          ? ListCopyWith(
            $value.genre!,
            (v, t) => ObjectCopyWith(v, $identity, t),
            (v) => call(genre: v),
          )
          : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get genres =>
      $value.genres != null
          ? ListCopyWith(
            $value.genres!,
            (v, t) => ObjectCopyWith(v, $identity, t),
            (v) => call(genres: v),
          )
          : null;
  @override
  $R call({
    Object? source = $none,
    Object? author = $none,
    Object? artist = $none,
    Object? genre = $none,
    Object? imageUrl = $none,
    Object? lang = $none,
    Object? link = $none,
    Object? name = $none,
    Object? status = $none,
    Object? description = $none,
    Object? id = $none,
    Object? favorite = $none,
    Object? isManga = $none,
    Object? itemType = $none,
    Object? genres = $none,
    Object? dateAdded = $none,
    Object? lastUpdate = $none,
    Object? categories = $none,
    Object? lastRead = $none,
    Object? isLocalArchive = $none,
    Object? customCoverImage = $none,
    Object? customCoverFromTracker = $none,
  }) => $apply(
    FieldCopyWithData({
      if (source != $none) #source: source,
      if (author != $none) #author: author,
      if (artist != $none) #artist: artist,
      if (genre != $none) #genre: genre,
      if (imageUrl != $none) #imageUrl: imageUrl,
      if (lang != $none) #lang: lang,
      if (link != $none) #link: link,
      if (name != $none) #name: name,
      if (status != $none) #status: status,
      if (description != $none) #description: description,
      if (id != $none) #id: id,
      if (favorite != $none) #favorite: favorite,
      if (isManga != $none) #isManga: isManga,
      if (itemType != $none) #itemType: itemType,
      if (genres != $none) #genres: genres,
      if (dateAdded != $none) #dateAdded: dateAdded,
      if (lastUpdate != $none) #lastUpdate: lastUpdate,
      if (categories != $none) #categories: categories,
      if (lastRead != $none) #lastRead: lastRead,
      if (isLocalArchive != $none) #isLocalArchive: isLocalArchive,
      if (customCoverImage != $none) #customCoverImage: customCoverImage,
      if (customCoverFromTracker != $none)
        #customCoverFromTracker: customCoverFromTracker,
    }),
  );
  @override
  MangayomiBackupManga $make(CopyWithData data) => MangayomiBackupManga(
    source: data.get(#source, or: $value.source),
    author: data.get(#author, or: $value.author),
    artist: data.get(#artist, or: $value.artist),
    genre: data.get(#genre, or: $value.genre),
    imageUrl: data.get(#imageUrl, or: $value.imageUrl),
    lang: data.get(#lang, or: $value.lang),
    link: data.get(#link, or: $value.link),
    name: data.get(#name, or: $value.name),
    status: data.get(#status, or: $value.status),
    description: data.get(#description, or: $value.description),
    id: data.get(#id, or: $value.id),
    favorite: data.get(#favorite, or: $value.favorite),
    isManga: data.get(#isManga, or: $value.isManga),
    itemType: data.get(#itemType, or: $value.itemType),
    genres: data.get(#genres, or: $value.genres),
    dateAdded: data.get(#dateAdded, or: $value.dateAdded),
    lastUpdate: data.get(#lastUpdate, or: $value.lastUpdate),
    categories: data.get(#categories, or: $value.categories),
    lastRead: data.get(#lastRead, or: $value.lastRead),
    isLocalArchive: data.get(#isLocalArchive, or: $value.isLocalArchive),
    customCoverImage: data.get(#customCoverImage, or: $value.customCoverImage),
    customCoverFromTracker: data.get(
      #customCoverFromTracker,
      or: $value.customCoverFromTracker,
    ),
  );

  @override
  MangayomiBackupMangaCopyWith<$R2, MangayomiBackupManga, $Out2> $chain<
    $R2,
    $Out2
  >(Then<$Out2, $R2> t) => _MangayomiBackupMangaCopyWithImpl($value, $cast, t);
}

class MangayomiBackupCategoryMapper
    extends ClassMapperBase<MangayomiBackupCategory> {
  MangayomiBackupCategoryMapper._();

  static MangayomiBackupCategoryMapper? _instance;
  static MangayomiBackupCategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = MangayomiBackupCategoryMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupCategory';

  static String? _$name(MangayomiBackupCategory v) => v.name;
  static const Field<MangayomiBackupCategory, String> _f$name = Field(
    'name',
    _$name,
  );
  static int? _$forItemType(MangayomiBackupCategory v) => v.forItemType;
  static const Field<MangayomiBackupCategory, int> _f$forItemType = Field(
    'forItemType',
    _$forItemType,
  );
  static int? _$id(MangayomiBackupCategory v) => v.id;
  static const Field<MangayomiBackupCategory, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static int? _$pos(MangayomiBackupCategory v) => v.pos;
  static const Field<MangayomiBackupCategory, int> _f$pos = Field(
    'pos',
    _$pos,
    opt: true,
  );
  static bool? _$hide(MangayomiBackupCategory v) => v.hide;
  static const Field<MangayomiBackupCategory, bool> _f$hide = Field(
    'hide',
    _$hide,
    opt: true,
  );

  @override
  final MappableFields<MangayomiBackupCategory> fields = const {
    #name: _f$name,
    #forItemType: _f$forItemType,
    #id: _f$id,
    #pos: _f$pos,
    #hide: _f$hide,
  };

  static MangayomiBackupCategory _instantiate(DecodingData data) {
    return MangayomiBackupCategory(
      name: data.dec(_f$name),
      forItemType: data.dec(_f$forItemType),
      id: data.dec(_f$id),
      pos: data.dec(_f$pos),
      hide: data.dec(_f$hide),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupCategory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupCategory>(map);
  }

  static MangayomiBackupCategory fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupCategory>(json);
  }
}

mixin MangayomiBackupCategoryMappable {
  String toJson() {
    return MangayomiBackupCategoryMapper.ensureInitialized()
        .encodeJson<MangayomiBackupCategory>(this as MangayomiBackupCategory);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupCategoryMapper.ensureInitialized()
        .encodeMap<MangayomiBackupCategory>(this as MangayomiBackupCategory);
  }

  MangayomiBackupCategoryCopyWith<
    MangayomiBackupCategory,
    MangayomiBackupCategory,
    MangayomiBackupCategory
  >
  get copyWith => _MangayomiBackupCategoryCopyWithImpl(
    this as MangayomiBackupCategory,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupCategoryMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupCategory,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupCategoryMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupCategory,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupCategoryMapper.ensureInitialized().hashValue(
      this as MangayomiBackupCategory,
    );
  }
}

extension MangayomiBackupCategoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupCategory, $Out> {
  MangayomiBackupCategoryCopyWith<$R, MangayomiBackupCategory, $Out>
  get $asMangayomiBackupCategory =>
      $base.as((v, t, t2) => _MangayomiBackupCategoryCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupCategoryCopyWith<
  $R,
  $In extends MangayomiBackupCategory,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, int? forItemType, int? id, int? pos, bool? hide});
  MangayomiBackupCategoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupCategoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupCategory, $Out>
    implements
        MangayomiBackupCategoryCopyWith<$R, MangayomiBackupCategory, $Out> {
  _MangayomiBackupCategoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupCategory> $mapper =
      MangayomiBackupCategoryMapper.ensureInitialized();
  @override
  $R call({
    Object? name = $none,
    Object? forItemType = $none,
    Object? id = $none,
    Object? pos = $none,
    Object? hide = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != $none) #name: name,
      if (forItemType != $none) #forItemType: forItemType,
      if (id != $none) #id: id,
      if (pos != $none) #pos: pos,
      if (hide != $none) #hide: hide,
    }),
  );
  @override
  MangayomiBackupCategory $make(CopyWithData data) => MangayomiBackupCategory(
    name: data.get(#name, or: $value.name),
    forItemType: data.get(#forItemType, or: $value.forItemType),
    id: data.get(#id, or: $value.id),
    pos: data.get(#pos, or: $value.pos),
    hide: data.get(#hide, or: $value.hide),
  );

  @override
  MangayomiBackupCategoryCopyWith<$R2, MangayomiBackupCategory, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MangayomiBackupCategoryCopyWithImpl($value, $cast, t);
}

class MangayomiBackupChapterMapper
    extends ClassMapperBase<MangayomiBackupChapter> {
  MangayomiBackupChapterMapper._();

  static MangayomiBackupChapterMapper? _instance;
  static MangayomiBackupChapterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiBackupChapterMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupChapter';

  static int? _$mangaId(MangayomiBackupChapter v) => v.mangaId;
  static const Field<MangayomiBackupChapter, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
  );
  static String? _$name(MangayomiBackupChapter v) => v.name;
  static const Field<MangayomiBackupChapter, String> _f$name = Field(
    'name',
    _$name,
  );
  static int? _$id(MangayomiBackupChapter v) => v.id;
  static const Field<MangayomiBackupChapter, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static String? _$url(MangayomiBackupChapter v) => v.url;
  static const Field<MangayomiBackupChapter, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
    def: '',
  );
  static String? _$dateUpload(MangayomiBackupChapter v) => v.dateUpload;
  static const Field<MangayomiBackupChapter, String> _f$dateUpload = Field(
    'dateUpload',
    _$dateUpload,
    opt: true,
    def: '',
  );
  static bool? _$isBookmarked(MangayomiBackupChapter v) => v.isBookmarked;
  static const Field<MangayomiBackupChapter, bool> _f$isBookmarked = Field(
    'isBookmarked',
    _$isBookmarked,
    opt: true,
    def: false,
  );
  static String? _$scanlator(MangayomiBackupChapter v) => v.scanlator;
  static const Field<MangayomiBackupChapter, String> _f$scanlator = Field(
    'scanlator',
    _$scanlator,
    opt: true,
    def: '',
  );
  static bool? _$isRead(MangayomiBackupChapter v) => v.isRead;
  static const Field<MangayomiBackupChapter, bool> _f$isRead = Field(
    'isRead',
    _$isRead,
    opt: true,
    def: false,
  );
  static String? _$lastPageRead(MangayomiBackupChapter v) => v.lastPageRead;
  static const Field<MangayomiBackupChapter, String> _f$lastPageRead = Field(
    'lastPageRead',
    _$lastPageRead,
    opt: true,
    def: '',
  );
  static String? _$archivePath(MangayomiBackupChapter v) => v.archivePath;
  static const Field<MangayomiBackupChapter, String> _f$archivePath = Field(
    'archivePath',
    _$archivePath,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<MangayomiBackupChapter> fields = const {
    #mangaId: _f$mangaId,
    #name: _f$name,
    #id: _f$id,
    #url: _f$url,
    #dateUpload: _f$dateUpload,
    #isBookmarked: _f$isBookmarked,
    #scanlator: _f$scanlator,
    #isRead: _f$isRead,
    #lastPageRead: _f$lastPageRead,
    #archivePath: _f$archivePath,
  };

  static MangayomiBackupChapter _instantiate(DecodingData data) {
    return MangayomiBackupChapter(
      mangaId: data.dec(_f$mangaId),
      name: data.dec(_f$name),
      id: data.dec(_f$id),
      url: data.dec(_f$url),
      dateUpload: data.dec(_f$dateUpload),
      isBookmarked: data.dec(_f$isBookmarked),
      scanlator: data.dec(_f$scanlator),
      isRead: data.dec(_f$isRead),
      lastPageRead: data.dec(_f$lastPageRead),
      archivePath: data.dec(_f$archivePath),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupChapter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupChapter>(map);
  }

  static MangayomiBackupChapter fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupChapter>(json);
  }
}

mixin MangayomiBackupChapterMappable {
  String toJson() {
    return MangayomiBackupChapterMapper.ensureInitialized()
        .encodeJson<MangayomiBackupChapter>(this as MangayomiBackupChapter);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupChapterMapper.ensureInitialized()
        .encodeMap<MangayomiBackupChapter>(this as MangayomiBackupChapter);
  }

  MangayomiBackupChapterCopyWith<
    MangayomiBackupChapter,
    MangayomiBackupChapter,
    MangayomiBackupChapter
  >
  get copyWith => _MangayomiBackupChapterCopyWithImpl(
    this as MangayomiBackupChapter,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupChapterMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupChapter,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupChapterMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupChapter,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupChapterMapper.ensureInitialized().hashValue(
      this as MangayomiBackupChapter,
    );
  }
}

extension MangayomiBackupChapterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupChapter, $Out> {
  MangayomiBackupChapterCopyWith<$R, MangayomiBackupChapter, $Out>
  get $asMangayomiBackupChapter =>
      $base.as((v, t, t2) => _MangayomiBackupChapterCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupChapterCopyWith<
  $R,
  $In extends MangayomiBackupChapter,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? mangaId,
    String? name,
    int? id,
    String? url,
    String? dateUpload,
    bool? isBookmarked,
    String? scanlator,
    bool? isRead,
    String? lastPageRead,
    String? archivePath,
  });
  MangayomiBackupChapterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupChapterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupChapter, $Out>
    implements
        MangayomiBackupChapterCopyWith<$R, MangayomiBackupChapter, $Out> {
  _MangayomiBackupChapterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupChapter> $mapper =
      MangayomiBackupChapterMapper.ensureInitialized();
  @override
  $R call({
    Object? mangaId = $none,
    Object? name = $none,
    Object? id = $none,
    Object? url = $none,
    Object? dateUpload = $none,
    Object? isBookmarked = $none,
    Object? scanlator = $none,
    Object? isRead = $none,
    Object? lastPageRead = $none,
    Object? archivePath = $none,
  }) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (name != $none) #name: name,
      if (id != $none) #id: id,
      if (url != $none) #url: url,
      if (dateUpload != $none) #dateUpload: dateUpload,
      if (isBookmarked != $none) #isBookmarked: isBookmarked,
      if (scanlator != $none) #scanlator: scanlator,
      if (isRead != $none) #isRead: isRead,
      if (lastPageRead != $none) #lastPageRead: lastPageRead,
      if (archivePath != $none) #archivePath: archivePath,
    }),
  );
  @override
  MangayomiBackupChapter $make(CopyWithData data) => MangayomiBackupChapter(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    name: data.get(#name, or: $value.name),
    id: data.get(#id, or: $value.id),
    url: data.get(#url, or: $value.url),
    dateUpload: data.get(#dateUpload, or: $value.dateUpload),
    isBookmarked: data.get(#isBookmarked, or: $value.isBookmarked),
    scanlator: data.get(#scanlator, or: $value.scanlator),
    isRead: data.get(#isRead, or: $value.isRead),
    lastPageRead: data.get(#lastPageRead, or: $value.lastPageRead),
    archivePath: data.get(#archivePath, or: $value.archivePath),
  );

  @override
  MangayomiBackupChapterCopyWith<$R2, MangayomiBackupChapter, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MangayomiBackupChapterCopyWithImpl($value, $cast, t);
}

class MangayomiBackupDownloadMapper
    extends ClassMapperBase<MangayomiBackupDownload> {
  MangayomiBackupDownloadMapper._();

  static MangayomiBackupDownloadMapper? _instance;
  static MangayomiBackupDownloadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = MangayomiBackupDownloadMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupDownload';

  static int? _$succeeded(MangayomiBackupDownload v) => v.succeeded;
  static const Field<MangayomiBackupDownload, int> _f$succeeded = Field(
    'succeeded',
    _$succeeded,
  );
  static int? _$failed(MangayomiBackupDownload v) => v.failed;
  static const Field<MangayomiBackupDownload, int> _f$failed = Field(
    'failed',
    _$failed,
  );
  static int? _$total(MangayomiBackupDownload v) => v.total;
  static const Field<MangayomiBackupDownload, int> _f$total = Field(
    'total',
    _$total,
  );
  static bool? _$isDownload(MangayomiBackupDownload v) => v.isDownload;
  static const Field<MangayomiBackupDownload, bool> _f$isDownload = Field(
    'isDownload',
    _$isDownload,
  );
  static bool? _$isStartDownload(MangayomiBackupDownload v) =>
      v.isStartDownload;
  static const Field<MangayomiBackupDownload, bool> _f$isStartDownload = Field(
    'isStartDownload',
    _$isStartDownload,
  );
  static int? _$id(MangayomiBackupDownload v) => v.id;
  static const Field<MangayomiBackupDownload, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<MangayomiBackupDownload> fields = const {
    #succeeded: _f$succeeded,
    #failed: _f$failed,
    #total: _f$total,
    #isDownload: _f$isDownload,
    #isStartDownload: _f$isStartDownload,
    #id: _f$id,
  };

  static MangayomiBackupDownload _instantiate(DecodingData data) {
    return MangayomiBackupDownload(
      succeeded: data.dec(_f$succeeded),
      failed: data.dec(_f$failed),
      total: data.dec(_f$total),
      isDownload: data.dec(_f$isDownload),
      isStartDownload: data.dec(_f$isStartDownload),
      id: data.dec(_f$id),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupDownload fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupDownload>(map);
  }

  static MangayomiBackupDownload fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupDownload>(json);
  }
}

mixin MangayomiBackupDownloadMappable {
  String toJson() {
    return MangayomiBackupDownloadMapper.ensureInitialized()
        .encodeJson<MangayomiBackupDownload>(this as MangayomiBackupDownload);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupDownloadMapper.ensureInitialized()
        .encodeMap<MangayomiBackupDownload>(this as MangayomiBackupDownload);
  }

  MangayomiBackupDownloadCopyWith<
    MangayomiBackupDownload,
    MangayomiBackupDownload,
    MangayomiBackupDownload
  >
  get copyWith => _MangayomiBackupDownloadCopyWithImpl(
    this as MangayomiBackupDownload,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupDownloadMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupDownload,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupDownloadMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupDownload,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupDownloadMapper.ensureInitialized().hashValue(
      this as MangayomiBackupDownload,
    );
  }
}

extension MangayomiBackupDownloadValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupDownload, $Out> {
  MangayomiBackupDownloadCopyWith<$R, MangayomiBackupDownload, $Out>
  get $asMangayomiBackupDownload =>
      $base.as((v, t, t2) => _MangayomiBackupDownloadCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupDownloadCopyWith<
  $R,
  $In extends MangayomiBackupDownload,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? succeeded,
    int? failed,
    int? total,
    bool? isDownload,
    bool? isStartDownload,
    int? id,
  });
  MangayomiBackupDownloadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupDownloadCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupDownload, $Out>
    implements
        MangayomiBackupDownloadCopyWith<$R, MangayomiBackupDownload, $Out> {
  _MangayomiBackupDownloadCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupDownload> $mapper =
      MangayomiBackupDownloadMapper.ensureInitialized();
  @override
  $R call({
    Object? succeeded = $none,
    Object? failed = $none,
    Object? total = $none,
    Object? isDownload = $none,
    Object? isStartDownload = $none,
    Object? id = $none,
  }) => $apply(
    FieldCopyWithData({
      if (succeeded != $none) #succeeded: succeeded,
      if (failed != $none) #failed: failed,
      if (total != $none) #total: total,
      if (isDownload != $none) #isDownload: isDownload,
      if (isStartDownload != $none) #isStartDownload: isStartDownload,
      if (id != $none) #id: id,
    }),
  );
  @override
  MangayomiBackupDownload $make(CopyWithData data) => MangayomiBackupDownload(
    succeeded: data.get(#succeeded, or: $value.succeeded),
    failed: data.get(#failed, or: $value.failed),
    total: data.get(#total, or: $value.total),
    isDownload: data.get(#isDownload, or: $value.isDownload),
    isStartDownload: data.get(#isStartDownload, or: $value.isStartDownload),
    id: data.get(#id, or: $value.id),
  );

  @override
  MangayomiBackupDownloadCopyWith<$R2, MangayomiBackupDownload, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MangayomiBackupDownloadCopyWithImpl($value, $cast, t);
}

class MangayomiBackupTrackMapper extends ClassMapperBase<MangayomiBackupTrack> {
  MangayomiBackupTrackMapper._();

  static MangayomiBackupTrackMapper? _instance;
  static MangayomiBackupTrackMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiBackupTrackMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      ItemTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupTrack';

  static int? _$status(MangayomiBackupTrack v) => v.status;
  static const Field<MangayomiBackupTrack, int> _f$status = Field(
    'status',
    _$status,
  );
  static int? _$id(MangayomiBackupTrack v) => v.id;
  static const Field<MangayomiBackupTrack, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static int? _$libraryId(MangayomiBackupTrack v) => v.libraryId;
  static const Field<MangayomiBackupTrack, int> _f$libraryId = Field(
    'libraryId',
    _$libraryId,
    opt: true,
  );
  static int? _$mediaId(MangayomiBackupTrack v) => v.mediaId;
  static const Field<MangayomiBackupTrack, int> _f$mediaId = Field(
    'mediaId',
    _$mediaId,
    opt: true,
  );
  static int? _$mangaId(MangayomiBackupTrack v) => v.mangaId;
  static const Field<MangayomiBackupTrack, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static int? _$syncId(MangayomiBackupTrack v) => v.syncId;
  static const Field<MangayomiBackupTrack, int> _f$syncId = Field(
    'syncId',
    _$syncId,
    opt: true,
  );
  static String? _$title(MangayomiBackupTrack v) => v.title;
  static const Field<MangayomiBackupTrack, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static int? _$lastChapterRead(MangayomiBackupTrack v) => v.lastChapterRead;
  static const Field<MangayomiBackupTrack, int> _f$lastChapterRead = Field(
    'lastChapterRead',
    _$lastChapterRead,
    opt: true,
  );
  static int? _$totalChapter(MangayomiBackupTrack v) => v.totalChapter;
  static const Field<MangayomiBackupTrack, int> _f$totalChapter = Field(
    'totalChapter',
    _$totalChapter,
    opt: true,
  );
  static int? _$score(MangayomiBackupTrack v) => v.score;
  static const Field<MangayomiBackupTrack, int> _f$score = Field(
    'score',
    _$score,
    opt: true,
  );
  static int? _$startedReadingDate(MangayomiBackupTrack v) =>
      v.startedReadingDate;
  static const Field<MangayomiBackupTrack, int> _f$startedReadingDate = Field(
    'startedReadingDate',
    _$startedReadingDate,
    opt: true,
  );
  static int? _$finishedReadingDate(MangayomiBackupTrack v) =>
      v.finishedReadingDate;
  static const Field<MangayomiBackupTrack, int> _f$finishedReadingDate = Field(
    'finishedReadingDate',
    _$finishedReadingDate,
    opt: true,
  );
  static String? _$trackingUrl(MangayomiBackupTrack v) => v.trackingUrl;
  static const Field<MangayomiBackupTrack, String> _f$trackingUrl = Field(
    'trackingUrl',
    _$trackingUrl,
    opt: true,
  );
  static bool? _$isManga(MangayomiBackupTrack v) => v.isManga;
  static const Field<MangayomiBackupTrack, bool> _f$isManga = Field(
    'isManga',
    _$isManga,
    opt: true,
  );
  static ItemType _$itemType(MangayomiBackupTrack v) => v.itemType;
  static const Field<MangayomiBackupTrack, ItemType> _f$itemType = Field(
    'itemType',
    _$itemType,
    opt: true,
    def: ItemType.manga,
  );

  @override
  final MappableFields<MangayomiBackupTrack> fields = const {
    #status: _f$status,
    #id: _f$id,
    #libraryId: _f$libraryId,
    #mediaId: _f$mediaId,
    #mangaId: _f$mangaId,
    #syncId: _f$syncId,
    #title: _f$title,
    #lastChapterRead: _f$lastChapterRead,
    #totalChapter: _f$totalChapter,
    #score: _f$score,
    #startedReadingDate: _f$startedReadingDate,
    #finishedReadingDate: _f$finishedReadingDate,
    #trackingUrl: _f$trackingUrl,
    #isManga: _f$isManga,
    #itemType: _f$itemType,
  };

  static MangayomiBackupTrack _instantiate(DecodingData data) {
    return MangayomiBackupTrack(
      status: data.dec(_f$status),
      id: data.dec(_f$id),
      libraryId: data.dec(_f$libraryId),
      mediaId: data.dec(_f$mediaId),
      mangaId: data.dec(_f$mangaId),
      syncId: data.dec(_f$syncId),
      title: data.dec(_f$title),
      lastChapterRead: data.dec(_f$lastChapterRead),
      totalChapter: data.dec(_f$totalChapter),
      score: data.dec(_f$score),
      startedReadingDate: data.dec(_f$startedReadingDate),
      finishedReadingDate: data.dec(_f$finishedReadingDate),
      trackingUrl: data.dec(_f$trackingUrl),
      isManga: data.dec(_f$isManga),
      itemType: data.dec(_f$itemType),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupTrack fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupTrack>(map);
  }

  static MangayomiBackupTrack fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupTrack>(json);
  }
}

mixin MangayomiBackupTrackMappable {
  String toJson() {
    return MangayomiBackupTrackMapper.ensureInitialized()
        .encodeJson<MangayomiBackupTrack>(this as MangayomiBackupTrack);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupTrackMapper.ensureInitialized()
        .encodeMap<MangayomiBackupTrack>(this as MangayomiBackupTrack);
  }

  MangayomiBackupTrackCopyWith<
    MangayomiBackupTrack,
    MangayomiBackupTrack,
    MangayomiBackupTrack
  >
  get copyWith => _MangayomiBackupTrackCopyWithImpl(
    this as MangayomiBackupTrack,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupTrackMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupTrack,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupTrackMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupTrack,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupTrackMapper.ensureInitialized().hashValue(
      this as MangayomiBackupTrack,
    );
  }
}

extension MangayomiBackupTrackValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupTrack, $Out> {
  MangayomiBackupTrackCopyWith<$R, MangayomiBackupTrack, $Out>
  get $asMangayomiBackupTrack =>
      $base.as((v, t, t2) => _MangayomiBackupTrackCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupTrackCopyWith<
  $R,
  $In extends MangayomiBackupTrack,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? status,
    int? id,
    int? libraryId,
    int? mediaId,
    int? mangaId,
    int? syncId,
    String? title,
    int? lastChapterRead,
    int? totalChapter,
    int? score,
    int? startedReadingDate,
    int? finishedReadingDate,
    String? trackingUrl,
    bool? isManga,
    ItemType? itemType,
  });
  MangayomiBackupTrackCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupTrackCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupTrack, $Out>
    implements MangayomiBackupTrackCopyWith<$R, MangayomiBackupTrack, $Out> {
  _MangayomiBackupTrackCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupTrack> $mapper =
      MangayomiBackupTrackMapper.ensureInitialized();
  @override
  $R call({
    Object? status = $none,
    Object? id = $none,
    Object? libraryId = $none,
    Object? mediaId = $none,
    Object? mangaId = $none,
    Object? syncId = $none,
    Object? title = $none,
    Object? lastChapterRead = $none,
    Object? totalChapter = $none,
    Object? score = $none,
    Object? startedReadingDate = $none,
    Object? finishedReadingDate = $none,
    Object? trackingUrl = $none,
    Object? isManga = $none,
    ItemType? itemType,
  }) => $apply(
    FieldCopyWithData({
      if (status != $none) #status: status,
      if (id != $none) #id: id,
      if (libraryId != $none) #libraryId: libraryId,
      if (mediaId != $none) #mediaId: mediaId,
      if (mangaId != $none) #mangaId: mangaId,
      if (syncId != $none) #syncId: syncId,
      if (title != $none) #title: title,
      if (lastChapterRead != $none) #lastChapterRead: lastChapterRead,
      if (totalChapter != $none) #totalChapter: totalChapter,
      if (score != $none) #score: score,
      if (startedReadingDate != $none) #startedReadingDate: startedReadingDate,
      if (finishedReadingDate != $none)
        #finishedReadingDate: finishedReadingDate,
      if (trackingUrl != $none) #trackingUrl: trackingUrl,
      if (isManga != $none) #isManga: isManga,
      if (itemType != null) #itemType: itemType,
    }),
  );
  @override
  MangayomiBackupTrack $make(CopyWithData data) => MangayomiBackupTrack(
    status: data.get(#status, or: $value.status),
    id: data.get(#id, or: $value.id),
    libraryId: data.get(#libraryId, or: $value.libraryId),
    mediaId: data.get(#mediaId, or: $value.mediaId),
    mangaId: data.get(#mangaId, or: $value.mangaId),
    syncId: data.get(#syncId, or: $value.syncId),
    title: data.get(#title, or: $value.title),
    lastChapterRead: data.get(#lastChapterRead, or: $value.lastChapterRead),
    totalChapter: data.get(#totalChapter, or: $value.totalChapter),
    score: data.get(#score, or: $value.score),
    startedReadingDate: data.get(
      #startedReadingDate,
      or: $value.startedReadingDate,
    ),
    finishedReadingDate: data.get(
      #finishedReadingDate,
      or: $value.finishedReadingDate,
    ),
    trackingUrl: data.get(#trackingUrl, or: $value.trackingUrl),
    isManga: data.get(#isManga, or: $value.isManga),
    itemType: data.get(#itemType, or: $value.itemType),
  );

  @override
  MangayomiBackupTrackCopyWith<$R2, MangayomiBackupTrack, $Out2> $chain<
    $R2,
    $Out2
  >(Then<$Out2, $R2> t) => _MangayomiBackupTrackCopyWithImpl($value, $cast, t);
}

class MangayomiBackupHistoryMapper
    extends ClassMapperBase<MangayomiBackupHistory> {
  MangayomiBackupHistoryMapper._();

  static MangayomiBackupHistoryMapper? _instance;
  static MangayomiBackupHistoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiBackupHistoryMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      ItemTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupHistory';

  static ItemType _$itemType(MangayomiBackupHistory v) => v.itemType;
  static const Field<MangayomiBackupHistory, ItemType> _f$itemType = Field(
    'itemType',
    _$itemType,
  );
  static int? _$chapterId(MangayomiBackupHistory v) => v.chapterId;
  static const Field<MangayomiBackupHistory, int> _f$chapterId = Field(
    'chapterId',
    _$chapterId,
  );
  static int? _$mangaId(MangayomiBackupHistory v) => v.mangaId;
  static const Field<MangayomiBackupHistory, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
  );
  static String? _$date(MangayomiBackupHistory v) => v.date;
  static const Field<MangayomiBackupHistory, String> _f$date = Field(
    'date',
    _$date,
  );
  static int? _$id(MangayomiBackupHistory v) => v.id;
  static const Field<MangayomiBackupHistory, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static bool? _$isManga(MangayomiBackupHistory v) => v.isManga;
  static const Field<MangayomiBackupHistory, bool> _f$isManga = Field(
    'isManga',
    _$isManga,
    opt: true,
  );

  @override
  final MappableFields<MangayomiBackupHistory> fields = const {
    #itemType: _f$itemType,
    #chapterId: _f$chapterId,
    #mangaId: _f$mangaId,
    #date: _f$date,
    #id: _f$id,
    #isManga: _f$isManga,
  };

  static MangayomiBackupHistory _instantiate(DecodingData data) {
    return MangayomiBackupHistory(
      itemType: data.dec(_f$itemType),
      chapterId: data.dec(_f$chapterId),
      mangaId: data.dec(_f$mangaId),
      date: data.dec(_f$date),
      id: data.dec(_f$id),
      isManga: data.dec(_f$isManga),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupHistory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupHistory>(map);
  }

  static MangayomiBackupHistory fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupHistory>(json);
  }
}

mixin MangayomiBackupHistoryMappable {
  String toJson() {
    return MangayomiBackupHistoryMapper.ensureInitialized()
        .encodeJson<MangayomiBackupHistory>(this as MangayomiBackupHistory);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupHistoryMapper.ensureInitialized()
        .encodeMap<MangayomiBackupHistory>(this as MangayomiBackupHistory);
  }

  MangayomiBackupHistoryCopyWith<
    MangayomiBackupHistory,
    MangayomiBackupHistory,
    MangayomiBackupHistory
  >
  get copyWith => _MangayomiBackupHistoryCopyWithImpl(
    this as MangayomiBackupHistory,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupHistoryMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupHistory,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupHistoryMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupHistory,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupHistoryMapper.ensureInitialized().hashValue(
      this as MangayomiBackupHistory,
    );
  }
}

extension MangayomiBackupHistoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupHistory, $Out> {
  MangayomiBackupHistoryCopyWith<$R, MangayomiBackupHistory, $Out>
  get $asMangayomiBackupHistory =>
      $base.as((v, t, t2) => _MangayomiBackupHistoryCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupHistoryCopyWith<
  $R,
  $In extends MangayomiBackupHistory,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    ItemType? itemType,
    int? chapterId,
    int? mangaId,
    String? date,
    int? id,
    bool? isManga,
  });
  MangayomiBackupHistoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupHistoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupHistory, $Out>
    implements
        MangayomiBackupHistoryCopyWith<$R, MangayomiBackupHistory, $Out> {
  _MangayomiBackupHistoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupHistory> $mapper =
      MangayomiBackupHistoryMapper.ensureInitialized();
  @override
  $R call({
    ItemType? itemType,
    Object? chapterId = $none,
    Object? mangaId = $none,
    Object? date = $none,
    Object? id = $none,
    Object? isManga = $none,
  }) => $apply(
    FieldCopyWithData({
      if (itemType != null) #itemType: itemType,
      if (chapterId != $none) #chapterId: chapterId,
      if (mangaId != $none) #mangaId: mangaId,
      if (date != $none) #date: date,
      if (id != $none) #id: id,
      if (isManga != $none) #isManga: isManga,
    }),
  );
  @override
  MangayomiBackupHistory $make(CopyWithData data) => MangayomiBackupHistory(
    itemType: data.get(#itemType, or: $value.itemType),
    chapterId: data.get(#chapterId, or: $value.chapterId),
    mangaId: data.get(#mangaId, or: $value.mangaId),
    date: data.get(#date, or: $value.date),
    id: data.get(#id, or: $value.id),
    isManga: data.get(#isManga, or: $value.isManga),
  );

  @override
  MangayomiBackupHistoryCopyWith<$R2, MangayomiBackupHistory, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MangayomiBackupHistoryCopyWithImpl($value, $cast, t);
}

class MangayomiBackupUpdateMapper
    extends ClassMapperBase<MangayomiBackupUpdate> {
  MangayomiBackupUpdateMapper._();

  static MangayomiBackupUpdateMapper? _instance;
  static MangayomiBackupUpdateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiBackupUpdateMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupUpdate';

  static int? _$mangaId(MangayomiBackupUpdate v) => v.mangaId;
  static const Field<MangayomiBackupUpdate, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
  );
  static String? _$chapterName(MangayomiBackupUpdate v) => v.chapterName;
  static const Field<MangayomiBackupUpdate, String> _f$chapterName = Field(
    'chapterName',
    _$chapterName,
  );
  static String? _$date(MangayomiBackupUpdate v) => v.date;
  static const Field<MangayomiBackupUpdate, String> _f$date = Field(
    'date',
    _$date,
  );
  static int? _$id(MangayomiBackupUpdate v) => v.id;
  static const Field<MangayomiBackupUpdate, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );

  @override
  final MappableFields<MangayomiBackupUpdate> fields = const {
    #mangaId: _f$mangaId,
    #chapterName: _f$chapterName,
    #date: _f$date,
    #id: _f$id,
  };

  static MangayomiBackupUpdate _instantiate(DecodingData data) {
    return MangayomiBackupUpdate(
      mangaId: data.dec(_f$mangaId),
      chapterName: data.dec(_f$chapterName),
      date: data.dec(_f$date),
      id: data.dec(_f$id),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupUpdate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupUpdate>(map);
  }

  static MangayomiBackupUpdate fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupUpdate>(json);
  }
}

mixin MangayomiBackupUpdateMappable {
  String toJson() {
    return MangayomiBackupUpdateMapper.ensureInitialized()
        .encodeJson<MangayomiBackupUpdate>(this as MangayomiBackupUpdate);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupUpdateMapper.ensureInitialized()
        .encodeMap<MangayomiBackupUpdate>(this as MangayomiBackupUpdate);
  }

  MangayomiBackupUpdateCopyWith<
    MangayomiBackupUpdate,
    MangayomiBackupUpdate,
    MangayomiBackupUpdate
  >
  get copyWith => _MangayomiBackupUpdateCopyWithImpl(
    this as MangayomiBackupUpdate,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupUpdateMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupUpdate,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupUpdateMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupUpdate,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupUpdateMapper.ensureInitialized().hashValue(
      this as MangayomiBackupUpdate,
    );
  }
}

extension MangayomiBackupUpdateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupUpdate, $Out> {
  MangayomiBackupUpdateCopyWith<$R, MangayomiBackupUpdate, $Out>
  get $asMangayomiBackupUpdate =>
      $base.as((v, t, t2) => _MangayomiBackupUpdateCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupUpdateCopyWith<
  $R,
  $In extends MangayomiBackupUpdate,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? mangaId, String? chapterName, String? date, int? id});
  MangayomiBackupUpdateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupUpdateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupUpdate, $Out>
    implements MangayomiBackupUpdateCopyWith<$R, MangayomiBackupUpdate, $Out> {
  _MangayomiBackupUpdateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupUpdate> $mapper =
      MangayomiBackupUpdateMapper.ensureInitialized();
  @override
  $R call({
    Object? mangaId = $none,
    Object? chapterName = $none,
    Object? date = $none,
    Object? id = $none,
  }) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (chapterName != $none) #chapterName: chapterName,
      if (date != $none) #date: date,
      if (id != $none) #id: id,
    }),
  );
  @override
  MangayomiBackupUpdate $make(CopyWithData data) => MangayomiBackupUpdate(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    chapterName: data.get(#chapterName, or: $value.chapterName),
    date: data.get(#date, or: $value.date),
    id: data.get(#id, or: $value.id),
  );

  @override
  MangayomiBackupUpdateCopyWith<$R2, MangayomiBackupUpdate, $Out2> $chain<
    $R2,
    $Out2
  >(Then<$Out2, $R2> t) => _MangayomiBackupUpdateCopyWithImpl($value, $cast, t);
}

class MangayomiBackupExtensionPreferencesMapper
    extends ClassMapperBase<MangayomiBackupExtensionPreferences> {
  MangayomiBackupExtensionPreferencesMapper._();

  static MangayomiBackupExtensionPreferencesMapper? _instance;
  static MangayomiBackupExtensionPreferencesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = MangayomiBackupExtensionPreferencesMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      EditTextPreferenceMapper.ensureInitialized();
      ListPreferenceMapper.ensureInitialized();
      SwitchPreferenceCompatMapper.ensureInitialized();
      MultiSelectListPreferenceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupExtensionPreferences';

  static int? _$id(MangayomiBackupExtensionPreferences v) => v.id;
  static const Field<MangayomiBackupExtensionPreferences, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static int? _$sourceId(MangayomiBackupExtensionPreferences v) => v.sourceId;
  static const Field<MangayomiBackupExtensionPreferences, int> _f$sourceId =
      Field('sourceId', _$sourceId, opt: true);
  static String? _$key(MangayomiBackupExtensionPreferences v) => v.key;
  static const Field<MangayomiBackupExtensionPreferences, String> _f$key =
      Field('key', _$key, opt: true);
  static EditTextPreference? _$editTextPreference(
    MangayomiBackupExtensionPreferences v,
  ) => v.editTextPreference;
  static const Field<MangayomiBackupExtensionPreferences, EditTextPreference>
  _f$editTextPreference = Field(
    'editTextPreference',
    _$editTextPreference,
    opt: true,
  );
  static ListPreference? _$listPreference(
    MangayomiBackupExtensionPreferences v,
  ) => v.listPreference;
  static const Field<MangayomiBackupExtensionPreferences, ListPreference>
  _f$listPreference = Field('listPreference', _$listPreference, opt: true);
  static SwitchPreferenceCompat? _$switchPreferenceCompat(
    MangayomiBackupExtensionPreferences v,
  ) => v.switchPreferenceCompat;
  static const Field<
    MangayomiBackupExtensionPreferences,
    SwitchPreferenceCompat
  >
  _f$switchPreferenceCompat = Field(
    'switchPreferenceCompat',
    _$switchPreferenceCompat,
    opt: true,
  );
  static MultiSelectListPreference? _$multiSelectListPreference(
    MangayomiBackupExtensionPreferences v,
  ) => v.multiSelectListPreference;
  static const Field<
    MangayomiBackupExtensionPreferences,
    MultiSelectListPreference
  >
  _f$multiSelectListPreference = Field(
    'multiSelectListPreference',
    _$multiSelectListPreference,
    opt: true,
  );

  @override
  final MappableFields<MangayomiBackupExtensionPreferences> fields = const {
    #id: _f$id,
    #sourceId: _f$sourceId,
    #key: _f$key,
    #editTextPreference: _f$editTextPreference,
    #listPreference: _f$listPreference,
    #switchPreferenceCompat: _f$switchPreferenceCompat,
    #multiSelectListPreference: _f$multiSelectListPreference,
  };

  static MangayomiBackupExtensionPreferences _instantiate(DecodingData data) {
    return MangayomiBackupExtensionPreferences(
      id: data.dec(_f$id),
      sourceId: data.dec(_f$sourceId),
      key: data.dec(_f$key),
      editTextPreference: data.dec(_f$editTextPreference),
      listPreference: data.dec(_f$listPreference),
      switchPreferenceCompat: data.dec(_f$switchPreferenceCompat),
      multiSelectListPreference: data.dec(_f$multiSelectListPreference),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupExtensionPreferences fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupExtensionPreferences>(
      map,
    );
  }

  static MangayomiBackupExtensionPreferences fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupExtensionPreferences>(
      json,
    );
  }
}

mixin MangayomiBackupExtensionPreferencesMappable {
  String toJson() {
    return MangayomiBackupExtensionPreferencesMapper.ensureInitialized()
        .encodeJson<MangayomiBackupExtensionPreferences>(
          this as MangayomiBackupExtensionPreferences,
        );
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupExtensionPreferencesMapper.ensureInitialized()
        .encodeMap<MangayomiBackupExtensionPreferences>(
          this as MangayomiBackupExtensionPreferences,
        );
  }

  MangayomiBackupExtensionPreferencesCopyWith<
    MangayomiBackupExtensionPreferences,
    MangayomiBackupExtensionPreferences,
    MangayomiBackupExtensionPreferences
  >
  get copyWith => _MangayomiBackupExtensionPreferencesCopyWithImpl(
    this as MangayomiBackupExtensionPreferences,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupExtensionPreferencesMapper.ensureInitialized()
        .stringifyValue(this as MangayomiBackupExtensionPreferences);
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupExtensionPreferencesMapper.ensureInitialized()
        .equalsValue(this as MangayomiBackupExtensionPreferences, other);
  }

  @override
  int get hashCode {
    return MangayomiBackupExtensionPreferencesMapper.ensureInitialized()
        .hashValue(this as MangayomiBackupExtensionPreferences);
  }
}

extension MangayomiBackupExtensionPreferencesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupExtensionPreferences, $Out> {
  MangayomiBackupExtensionPreferencesCopyWith<
    $R,
    MangayomiBackupExtensionPreferences,
    $Out
  >
  get $asMangayomiBackupExtensionPreferences => $base.as(
    (v, t, t2) => _MangayomiBackupExtensionPreferencesCopyWithImpl(v, t, t2),
  );
}

abstract class MangayomiBackupExtensionPreferencesCopyWith<
  $R,
  $In extends MangayomiBackupExtensionPreferences,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  EditTextPreferenceCopyWith<$R, EditTextPreference, EditTextPreference>?
  get editTextPreference;
  ListPreferenceCopyWith<$R, ListPreference, ListPreference>?
  get listPreference;
  SwitchPreferenceCompatCopyWith<
    $R,
    SwitchPreferenceCompat,
    SwitchPreferenceCompat
  >?
  get switchPreferenceCompat;
  MultiSelectListPreferenceCopyWith<
    $R,
    MultiSelectListPreference,
    MultiSelectListPreference
  >?
  get multiSelectListPreference;
  $R call({
    int? id,
    int? sourceId,
    String? key,
    EditTextPreference? editTextPreference,
    ListPreference? listPreference,
    SwitchPreferenceCompat? switchPreferenceCompat,
    MultiSelectListPreference? multiSelectListPreference,
  });
  MangayomiBackupExtensionPreferencesCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MangayomiBackupExtensionPreferencesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupExtensionPreferences, $Out>
    implements
        MangayomiBackupExtensionPreferencesCopyWith<
          $R,
          MangayomiBackupExtensionPreferences,
          $Out
        > {
  _MangayomiBackupExtensionPreferencesCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<MangayomiBackupExtensionPreferences> $mapper =
      MangayomiBackupExtensionPreferencesMapper.ensureInitialized();
  @override
  EditTextPreferenceCopyWith<$R, EditTextPreference, EditTextPreference>?
  get editTextPreference => $value.editTextPreference?.copyWith.$chain(
    (v) => call(editTextPreference: v),
  );
  @override
  ListPreferenceCopyWith<$R, ListPreference, ListPreference>?
  get listPreference =>
      $value.listPreference?.copyWith.$chain((v) => call(listPreference: v));
  @override
  SwitchPreferenceCompatCopyWith<
    $R,
    SwitchPreferenceCompat,
    SwitchPreferenceCompat
  >?
  get switchPreferenceCompat => $value.switchPreferenceCompat?.copyWith.$chain(
    (v) => call(switchPreferenceCompat: v),
  );
  @override
  MultiSelectListPreferenceCopyWith<
    $R,
    MultiSelectListPreference,
    MultiSelectListPreference
  >?
  get multiSelectListPreference => $value.multiSelectListPreference?.copyWith
      .$chain((v) => call(multiSelectListPreference: v));
  @override
  $R call({
    Object? id = $none,
    Object? sourceId = $none,
    Object? key = $none,
    Object? editTextPreference = $none,
    Object? listPreference = $none,
    Object? switchPreferenceCompat = $none,
    Object? multiSelectListPreference = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (sourceId != $none) #sourceId: sourceId,
      if (key != $none) #key: key,
      if (editTextPreference != $none) #editTextPreference: editTextPreference,
      if (listPreference != $none) #listPreference: listPreference,
      if (switchPreferenceCompat != $none)
        #switchPreferenceCompat: switchPreferenceCompat,
      if (multiSelectListPreference != $none)
        #multiSelectListPreference: multiSelectListPreference,
    }),
  );
  @override
  MangayomiBackupExtensionPreferences $make(CopyWithData data) =>
      MangayomiBackupExtensionPreferences(
        id: data.get(#id, or: $value.id),
        sourceId: data.get(#sourceId, or: $value.sourceId),
        key: data.get(#key, or: $value.key),
        editTextPreference: data.get(
          #editTextPreference,
          or: $value.editTextPreference,
        ),
        listPreference: data.get(#listPreference, or: $value.listPreference),
        switchPreferenceCompat: data.get(
          #switchPreferenceCompat,
          or: $value.switchPreferenceCompat,
        ),
        multiSelectListPreference: data.get(
          #multiSelectListPreference,
          or: $value.multiSelectListPreference,
        ),
      );

  @override
  MangayomiBackupExtensionPreferencesCopyWith<
    $R2,
    MangayomiBackupExtensionPreferences,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MangayomiBackupExtensionPreferencesCopyWithImpl($value, $cast, t);
}

class EditTextPreferenceMapper extends ClassMapperBase<EditTextPreference> {
  EditTextPreferenceMapper._();

  static EditTextPreferenceMapper? _instance;
  static EditTextPreferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditTextPreferenceMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'EditTextPreference';

  static String? _$title(EditTextPreference v) => v.title;
  static const Field<EditTextPreference, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$summary(EditTextPreference v) => v.summary;
  static const Field<EditTextPreference, String> _f$summary = Field(
    'summary',
    _$summary,
    opt: true,
  );
  static String? _$value(EditTextPreference v) => v.value;
  static const Field<EditTextPreference, String> _f$value = Field(
    'value',
    _$value,
    opt: true,
  );
  static String? _$dialogTitle(EditTextPreference v) => v.dialogTitle;
  static const Field<EditTextPreference, String> _f$dialogTitle = Field(
    'dialogTitle',
    _$dialogTitle,
    opt: true,
  );
  static String? _$dialogMessage(EditTextPreference v) => v.dialogMessage;
  static const Field<EditTextPreference, String> _f$dialogMessage = Field(
    'dialogMessage',
    _$dialogMessage,
    opt: true,
  );
  static String? _$text(EditTextPreference v) => v.text;
  static const Field<EditTextPreference, String> _f$text = Field(
    'text',
    _$text,
    opt: true,
  );

  @override
  final MappableFields<EditTextPreference> fields = const {
    #title: _f$title,
    #summary: _f$summary,
    #value: _f$value,
    #dialogTitle: _f$dialogTitle,
    #dialogMessage: _f$dialogMessage,
    #text: _f$text,
  };

  static EditTextPreference _instantiate(DecodingData data) {
    return EditTextPreference(
      title: data.dec(_f$title),
      summary: data.dec(_f$summary),
      value: data.dec(_f$value),
      dialogTitle: data.dec(_f$dialogTitle),
      dialogMessage: data.dec(_f$dialogMessage),
      text: data.dec(_f$text),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EditTextPreference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditTextPreference>(map);
  }

  static EditTextPreference fromJson(String json) {
    return ensureInitialized().decodeJson<EditTextPreference>(json);
  }
}

mixin EditTextPreferenceMappable {
  String toJson() {
    return EditTextPreferenceMapper.ensureInitialized()
        .encodeJson<EditTextPreference>(this as EditTextPreference);
  }

  Map<String, dynamic> toMap() {
    return EditTextPreferenceMapper.ensureInitialized()
        .encodeMap<EditTextPreference>(this as EditTextPreference);
  }

  EditTextPreferenceCopyWith<
    EditTextPreference,
    EditTextPreference,
    EditTextPreference
  >
  get copyWith => _EditTextPreferenceCopyWithImpl(
    this as EditTextPreference,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return EditTextPreferenceMapper.ensureInitialized().stringifyValue(
      this as EditTextPreference,
    );
  }

  @override
  bool operator ==(Object other) {
    return EditTextPreferenceMapper.ensureInitialized().equalsValue(
      this as EditTextPreference,
      other,
    );
  }

  @override
  int get hashCode {
    return EditTextPreferenceMapper.ensureInitialized().hashValue(
      this as EditTextPreference,
    );
  }
}

extension EditTextPreferenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EditTextPreference, $Out> {
  EditTextPreferenceCopyWith<$R, EditTextPreference, $Out>
  get $asEditTextPreference =>
      $base.as((v, t, t2) => _EditTextPreferenceCopyWithImpl(v, t, t2));
}

abstract class EditTextPreferenceCopyWith<
  $R,
  $In extends EditTextPreference,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? title,
    String? summary,
    String? value,
    String? dialogTitle,
    String? dialogMessage,
    String? text,
  });
  EditTextPreferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EditTextPreferenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EditTextPreference, $Out>
    implements EditTextPreferenceCopyWith<$R, EditTextPreference, $Out> {
  _EditTextPreferenceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EditTextPreference> $mapper =
      EditTextPreferenceMapper.ensureInitialized();
  @override
  $R call({
    Object? title = $none,
    Object? summary = $none,
    Object? value = $none,
    Object? dialogTitle = $none,
    Object? dialogMessage = $none,
    Object? text = $none,
  }) => $apply(
    FieldCopyWithData({
      if (title != $none) #title: title,
      if (summary != $none) #summary: summary,
      if (value != $none) #value: value,
      if (dialogTitle != $none) #dialogTitle: dialogTitle,
      if (dialogMessage != $none) #dialogMessage: dialogMessage,
      if (text != $none) #text: text,
    }),
  );
  @override
  EditTextPreference $make(CopyWithData data) => EditTextPreference(
    title: data.get(#title, or: $value.title),
    summary: data.get(#summary, or: $value.summary),
    value: data.get(#value, or: $value.value),
    dialogTitle: data.get(#dialogTitle, or: $value.dialogTitle),
    dialogMessage: data.get(#dialogMessage, or: $value.dialogMessage),
    text: data.get(#text, or: $value.text),
  );

  @override
  EditTextPreferenceCopyWith<$R2, EditTextPreference, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditTextPreferenceCopyWithImpl($value, $cast, t);
}

class ListPreferenceMapper extends ClassMapperBase<ListPreference> {
  ListPreferenceMapper._();

  static ListPreferenceMapper? _instance;
  static ListPreferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ListPreferenceMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ListPreference';

  static String? _$title(ListPreference v) => v.title;
  static const Field<ListPreference, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$summary(ListPreference v) => v.summary;
  static const Field<ListPreference, String> _f$summary = Field(
    'summary',
    _$summary,
    opt: true,
  );
  static int? _$valueIndex(ListPreference v) => v.valueIndex;
  static const Field<ListPreference, int> _f$valueIndex = Field(
    'valueIndex',
    _$valueIndex,
    opt: true,
  );
  static List<String>? _$entries(ListPreference v) => v.entries;
  static const Field<ListPreference, List<String>> _f$entries = Field(
    'entries',
    _$entries,
    opt: true,
  );
  static List<String>? _$entryValues(ListPreference v) => v.entryValues;
  static const Field<ListPreference, List<String>> _f$entryValues = Field(
    'entryValues',
    _$entryValues,
    opt: true,
  );

  @override
  final MappableFields<ListPreference> fields = const {
    #title: _f$title,
    #summary: _f$summary,
    #valueIndex: _f$valueIndex,
    #entries: _f$entries,
    #entryValues: _f$entryValues,
  };

  static ListPreference _instantiate(DecodingData data) {
    return ListPreference(
      title: data.dec(_f$title),
      summary: data.dec(_f$summary),
      valueIndex: data.dec(_f$valueIndex),
      entries: data.dec(_f$entries),
      entryValues: data.dec(_f$entryValues),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ListPreference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ListPreference>(map);
  }

  static ListPreference fromJson(String json) {
    return ensureInitialized().decodeJson<ListPreference>(json);
  }
}

mixin ListPreferenceMappable {
  String toJson() {
    return ListPreferenceMapper.ensureInitialized().encodeJson<ListPreference>(
      this as ListPreference,
    );
  }

  Map<String, dynamic> toMap() {
    return ListPreferenceMapper.ensureInitialized().encodeMap<ListPreference>(
      this as ListPreference,
    );
  }

  ListPreferenceCopyWith<ListPreference, ListPreference, ListPreference>
  get copyWith =>
      _ListPreferenceCopyWithImpl(this as ListPreference, $identity, $identity);
  @override
  String toString() {
    return ListPreferenceMapper.ensureInitialized().stringifyValue(
      this as ListPreference,
    );
  }

  @override
  bool operator ==(Object other) {
    return ListPreferenceMapper.ensureInitialized().equalsValue(
      this as ListPreference,
      other,
    );
  }

  @override
  int get hashCode {
    return ListPreferenceMapper.ensureInitialized().hashValue(
      this as ListPreference,
    );
  }
}

extension ListPreferenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ListPreference, $Out> {
  ListPreferenceCopyWith<$R, ListPreference, $Out> get $asListPreference =>
      $base.as((v, t, t2) => _ListPreferenceCopyWithImpl(v, t, t2));
}

abstract class ListPreferenceCopyWith<$R, $In extends ListPreference, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get entries;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get entryValues;
  $R call({
    String? title,
    String? summary,
    int? valueIndex,
    List<String>? entries,
    List<String>? entryValues,
  });
  ListPreferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ListPreferenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ListPreference, $Out>
    implements ListPreferenceCopyWith<$R, ListPreference, $Out> {
  _ListPreferenceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ListPreference> $mapper =
      ListPreferenceMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get entries =>
      $value.entries != null
          ? ListCopyWith(
            $value.entries!,
            (v, t) => ObjectCopyWith(v, $identity, t),
            (v) => call(entries: v),
          )
          : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get entryValues =>
      $value.entryValues != null
          ? ListCopyWith(
            $value.entryValues!,
            (v, t) => ObjectCopyWith(v, $identity, t),
            (v) => call(entryValues: v),
          )
          : null;
  @override
  $R call({
    Object? title = $none,
    Object? summary = $none,
    Object? valueIndex = $none,
    Object? entries = $none,
    Object? entryValues = $none,
  }) => $apply(
    FieldCopyWithData({
      if (title != $none) #title: title,
      if (summary != $none) #summary: summary,
      if (valueIndex != $none) #valueIndex: valueIndex,
      if (entries != $none) #entries: entries,
      if (entryValues != $none) #entryValues: entryValues,
    }),
  );
  @override
  ListPreference $make(CopyWithData data) => ListPreference(
    title: data.get(#title, or: $value.title),
    summary: data.get(#summary, or: $value.summary),
    valueIndex: data.get(#valueIndex, or: $value.valueIndex),
    entries: data.get(#entries, or: $value.entries),
    entryValues: data.get(#entryValues, or: $value.entryValues),
  );

  @override
  ListPreferenceCopyWith<$R2, ListPreference, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ListPreferenceCopyWithImpl($value, $cast, t);
}

class SwitchPreferenceCompatMapper
    extends ClassMapperBase<SwitchPreferenceCompat> {
  SwitchPreferenceCompatMapper._();

  static SwitchPreferenceCompatMapper? _instance;
  static SwitchPreferenceCompatMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SwitchPreferenceCompatMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'SwitchPreferenceCompat';

  static String? _$title(SwitchPreferenceCompat v) => v.title;
  static const Field<SwitchPreferenceCompat, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$summary(SwitchPreferenceCompat v) => v.summary;
  static const Field<SwitchPreferenceCompat, String> _f$summary = Field(
    'summary',
    _$summary,
    opt: true,
  );
  static bool? _$value(SwitchPreferenceCompat v) => v.value;
  static const Field<SwitchPreferenceCompat, bool> _f$value = Field(
    'value',
    _$value,
    opt: true,
  );

  @override
  final MappableFields<SwitchPreferenceCompat> fields = const {
    #title: _f$title,
    #summary: _f$summary,
    #value: _f$value,
  };

  static SwitchPreferenceCompat _instantiate(DecodingData data) {
    return SwitchPreferenceCompat(
      title: data.dec(_f$title),
      summary: data.dec(_f$summary),
      value: data.dec(_f$value),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SwitchPreferenceCompat fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SwitchPreferenceCompat>(map);
  }

  static SwitchPreferenceCompat fromJson(String json) {
    return ensureInitialized().decodeJson<SwitchPreferenceCompat>(json);
  }
}

mixin SwitchPreferenceCompatMappable {
  String toJson() {
    return SwitchPreferenceCompatMapper.ensureInitialized()
        .encodeJson<SwitchPreferenceCompat>(this as SwitchPreferenceCompat);
  }

  Map<String, dynamic> toMap() {
    return SwitchPreferenceCompatMapper.ensureInitialized()
        .encodeMap<SwitchPreferenceCompat>(this as SwitchPreferenceCompat);
  }

  SwitchPreferenceCompatCopyWith<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    SwitchPreferenceCompat
  >
  get copyWith => _SwitchPreferenceCompatCopyWithImpl(
    this as SwitchPreferenceCompat,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SwitchPreferenceCompatMapper.ensureInitialized().stringifyValue(
      this as SwitchPreferenceCompat,
    );
  }

  @override
  bool operator ==(Object other) {
    return SwitchPreferenceCompatMapper.ensureInitialized().equalsValue(
      this as SwitchPreferenceCompat,
      other,
    );
  }

  @override
  int get hashCode {
    return SwitchPreferenceCompatMapper.ensureInitialized().hashValue(
      this as SwitchPreferenceCompat,
    );
  }
}

extension SwitchPreferenceCompatValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SwitchPreferenceCompat, $Out> {
  SwitchPreferenceCompatCopyWith<$R, SwitchPreferenceCompat, $Out>
  get $asSwitchPreferenceCompat =>
      $base.as((v, t, t2) => _SwitchPreferenceCompatCopyWithImpl(v, t, t2));
}

abstract class SwitchPreferenceCompatCopyWith<
  $R,
  $In extends SwitchPreferenceCompat,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? title, String? summary, bool? value});
  SwitchPreferenceCompatCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SwitchPreferenceCompatCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SwitchPreferenceCompat, $Out>
    implements
        SwitchPreferenceCompatCopyWith<$R, SwitchPreferenceCompat, $Out> {
  _SwitchPreferenceCompatCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SwitchPreferenceCompat> $mapper =
      SwitchPreferenceCompatMapper.ensureInitialized();
  @override
  $R call({
    Object? title = $none,
    Object? summary = $none,
    Object? value = $none,
  }) => $apply(
    FieldCopyWithData({
      if (title != $none) #title: title,
      if (summary != $none) #summary: summary,
      if (value != $none) #value: value,
    }),
  );
  @override
  SwitchPreferenceCompat $make(CopyWithData data) => SwitchPreferenceCompat(
    title: data.get(#title, or: $value.title),
    summary: data.get(#summary, or: $value.summary),
    value: data.get(#value, or: $value.value),
  );

  @override
  SwitchPreferenceCompatCopyWith<$R2, SwitchPreferenceCompat, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SwitchPreferenceCompatCopyWithImpl($value, $cast, t);
}

class MultiSelectListPreferenceMapper
    extends ClassMapperBase<MultiSelectListPreference> {
  MultiSelectListPreferenceMapper._();

  static MultiSelectListPreferenceMapper? _instance;
  static MultiSelectListPreferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = MultiSelectListPreferenceMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MultiSelectListPreference';

  static String? _$title(MultiSelectListPreference v) => v.title;
  static const Field<MultiSelectListPreference, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$summary(MultiSelectListPreference v) => v.summary;
  static const Field<MultiSelectListPreference, String> _f$summary = Field(
    'summary',
    _$summary,
    opt: true,
  );
  static List<String>? _$values(MultiSelectListPreference v) => v.values;
  static const Field<MultiSelectListPreference, List<String>> _f$values = Field(
    'values',
    _$values,
    opt: true,
  );
  static List<String>? _$entries(MultiSelectListPreference v) => v.entries;
  static const Field<MultiSelectListPreference, List<String>> _f$entries =
      Field('entries', _$entries, opt: true);
  static List<String>? _$entryValues(MultiSelectListPreference v) =>
      v.entryValues;
  static const Field<MultiSelectListPreference, List<String>> _f$entryValues =
      Field('entryValues', _$entryValues, opt: true);

  @override
  final MappableFields<MultiSelectListPreference> fields = const {
    #title: _f$title,
    #summary: _f$summary,
    #values: _f$values,
    #entries: _f$entries,
    #entryValues: _f$entryValues,
  };

  static MultiSelectListPreference _instantiate(DecodingData data) {
    return MultiSelectListPreference(
      title: data.dec(_f$title),
      summary: data.dec(_f$summary),
      values: data.dec(_f$values),
      entries: data.dec(_f$entries),
      entryValues: data.dec(_f$entryValues),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MultiSelectListPreference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MultiSelectListPreference>(map);
  }

  static MultiSelectListPreference fromJson(String json) {
    return ensureInitialized().decodeJson<MultiSelectListPreference>(json);
  }
}

mixin MultiSelectListPreferenceMappable {
  String toJson() {
    return MultiSelectListPreferenceMapper.ensureInitialized()
        .encodeJson<MultiSelectListPreference>(
          this as MultiSelectListPreference,
        );
  }

  Map<String, dynamic> toMap() {
    return MultiSelectListPreferenceMapper.ensureInitialized()
        .encodeMap<MultiSelectListPreference>(
          this as MultiSelectListPreference,
        );
  }

  MultiSelectListPreferenceCopyWith<
    MultiSelectListPreference,
    MultiSelectListPreference,
    MultiSelectListPreference
  >
  get copyWith => _MultiSelectListPreferenceCopyWithImpl(
    this as MultiSelectListPreference,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MultiSelectListPreferenceMapper.ensureInitialized().stringifyValue(
      this as MultiSelectListPreference,
    );
  }

  @override
  bool operator ==(Object other) {
    return MultiSelectListPreferenceMapper.ensureInitialized().equalsValue(
      this as MultiSelectListPreference,
      other,
    );
  }

  @override
  int get hashCode {
    return MultiSelectListPreferenceMapper.ensureInitialized().hashValue(
      this as MultiSelectListPreference,
    );
  }
}

extension MultiSelectListPreferenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MultiSelectListPreference, $Out> {
  MultiSelectListPreferenceCopyWith<$R, MultiSelectListPreference, $Out>
  get $asMultiSelectListPreference =>
      $base.as((v, t, t2) => _MultiSelectListPreferenceCopyWithImpl(v, t, t2));
}

abstract class MultiSelectListPreferenceCopyWith<
  $R,
  $In extends MultiSelectListPreference,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get values;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get entries;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get entryValues;
  $R call({
    String? title,
    String? summary,
    List<String>? values,
    List<String>? entries,
    List<String>? entryValues,
  });
  MultiSelectListPreferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MultiSelectListPreferenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MultiSelectListPreference, $Out>
    implements
        MultiSelectListPreferenceCopyWith<$R, MultiSelectListPreference, $Out> {
  _MultiSelectListPreferenceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MultiSelectListPreference> $mapper =
      MultiSelectListPreferenceMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get values =>
      $value.values != null
          ? ListCopyWith(
            $value.values!,
            (v, t) => ObjectCopyWith(v, $identity, t),
            (v) => call(values: v),
          )
          : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get entries =>
      $value.entries != null
          ? ListCopyWith(
            $value.entries!,
            (v, t) => ObjectCopyWith(v, $identity, t),
            (v) => call(entries: v),
          )
          : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get entryValues =>
      $value.entryValues != null
          ? ListCopyWith(
            $value.entryValues!,
            (v, t) => ObjectCopyWith(v, $identity, t),
            (v) => call(entryValues: v),
          )
          : null;
  @override
  $R call({
    Object? title = $none,
    Object? summary = $none,
    Object? values = $none,
    Object? entries = $none,
    Object? entryValues = $none,
  }) => $apply(
    FieldCopyWithData({
      if (title != $none) #title: title,
      if (summary != $none) #summary: summary,
      if (values != $none) #values: values,
      if (entries != $none) #entries: entries,
      if (entryValues != $none) #entryValues: entryValues,
    }),
  );
  @override
  MultiSelectListPreference $make(CopyWithData data) =>
      MultiSelectListPreference(
        title: data.get(#title, or: $value.title),
        summary: data.get(#summary, or: $value.summary),
        values: data.get(#values, or: $value.values),
        entries: data.get(#entries, or: $value.entries),
        entryValues: data.get(#entryValues, or: $value.entryValues),
      );

  @override
  MultiSelectListPreferenceCopyWith<$R2, MultiSelectListPreference, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MultiSelectListPreferenceCopyWithImpl($value, $cast, t);
}

class MangayomiBackupTrackPreferencesMapper
    extends ClassMapperBase<MangayomiBackupTrackPreferences> {
  MangayomiBackupTrackPreferencesMapper._();

  static MangayomiBackupTrackPreferencesMapper? _instance;
  static MangayomiBackupTrackPreferencesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = MangayomiBackupTrackPreferencesMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupTrackPreferences';

  static int? _$chapterId(MangayomiBackupTrackPreferences v) => v.chapterId;
  static const Field<MangayomiBackupTrackPreferences, int> _f$chapterId = Field(
    'chapterId',
    _$chapterId,
    opt: true,
  );
  static int? _$date(MangayomiBackupTrackPreferences v) => v.date;
  static const Field<MangayomiBackupTrackPreferences, int> _f$date = Field(
    'date',
    _$date,
    opt: true,
  );
  static int? _$id(MangayomiBackupTrackPreferences v) => v.id;
  static const Field<MangayomiBackupTrackPreferences, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static int? _$itemType(MangayomiBackupTrackPreferences v) => v.itemType;
  static const Field<MangayomiBackupTrackPreferences, int> _f$itemType = Field(
    'itemType',
    _$itemType,
    opt: true,
  );
  static int? _$mangaId(MangayomiBackupTrackPreferences v) => v.mangaId;
  static const Field<MangayomiBackupTrackPreferences, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );

  @override
  final MappableFields<MangayomiBackupTrackPreferences> fields = const {
    #chapterId: _f$chapterId,
    #date: _f$date,
    #id: _f$id,
    #itemType: _f$itemType,
    #mangaId: _f$mangaId,
  };

  static MangayomiBackupTrackPreferences _instantiate(DecodingData data) {
    return MangayomiBackupTrackPreferences(
      chapterId: data.dec(_f$chapterId),
      date: data.dec(_f$date),
      id: data.dec(_f$id),
      itemType: data.dec(_f$itemType),
      mangaId: data.dec(_f$mangaId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupTrackPreferences fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupTrackPreferences>(map);
  }

  static MangayomiBackupTrackPreferences fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupTrackPreferences>(
      json,
    );
  }
}

mixin MangayomiBackupTrackPreferencesMappable {
  String toJson() {
    return MangayomiBackupTrackPreferencesMapper.ensureInitialized()
        .encodeJson<MangayomiBackupTrackPreferences>(
          this as MangayomiBackupTrackPreferences,
        );
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupTrackPreferencesMapper.ensureInitialized()
        .encodeMap<MangayomiBackupTrackPreferences>(
          this as MangayomiBackupTrackPreferences,
        );
  }

  MangayomiBackupTrackPreferencesCopyWith<
    MangayomiBackupTrackPreferences,
    MangayomiBackupTrackPreferences,
    MangayomiBackupTrackPreferences
  >
  get copyWith => _MangayomiBackupTrackPreferencesCopyWithImpl(
    this as MangayomiBackupTrackPreferences,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupTrackPreferencesMapper.ensureInitialized()
        .stringifyValue(this as MangayomiBackupTrackPreferences);
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupTrackPreferencesMapper.ensureInitialized()
        .equalsValue(this as MangayomiBackupTrackPreferences, other);
  }

  @override
  int get hashCode {
    return MangayomiBackupTrackPreferencesMapper.ensureInitialized().hashValue(
      this as MangayomiBackupTrackPreferences,
    );
  }
}

extension MangayomiBackupTrackPreferencesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupTrackPreferences, $Out> {
  MangayomiBackupTrackPreferencesCopyWith<
    $R,
    MangayomiBackupTrackPreferences,
    $Out
  >
  get $asMangayomiBackupTrackPreferences => $base.as(
    (v, t, t2) => _MangayomiBackupTrackPreferencesCopyWithImpl(v, t, t2),
  );
}

abstract class MangayomiBackupTrackPreferencesCopyWith<
  $R,
  $In extends MangayomiBackupTrackPreferences,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? chapterId, int? date, int? id, int? itemType, int? mangaId});
  MangayomiBackupTrackPreferencesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupTrackPreferencesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupTrackPreferences, $Out>
    implements
        MangayomiBackupTrackPreferencesCopyWith<
          $R,
          MangayomiBackupTrackPreferences,
          $Out
        > {
  _MangayomiBackupTrackPreferencesCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<MangayomiBackupTrackPreferences> $mapper =
      MangayomiBackupTrackPreferencesMapper.ensureInitialized();
  @override
  $R call({
    Object? chapterId = $none,
    Object? date = $none,
    Object? id = $none,
    Object? itemType = $none,
    Object? mangaId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (chapterId != $none) #chapterId: chapterId,
      if (date != $none) #date: date,
      if (id != $none) #id: id,
      if (itemType != $none) #itemType: itemType,
      if (mangaId != $none) #mangaId: mangaId,
    }),
  );
  @override
  MangayomiBackupTrackPreferences $make(CopyWithData data) =>
      MangayomiBackupTrackPreferences(
        chapterId: data.get(#chapterId, or: $value.chapterId),
        date: data.get(#date, or: $value.date),
        id: data.get(#id, or: $value.id),
        itemType: data.get(#itemType, or: $value.itemType),
        mangaId: data.get(#mangaId, or: $value.mangaId),
      );

  @override
  MangayomiBackupTrackPreferencesCopyWith<
    $R2,
    MangayomiBackupTrackPreferences,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MangayomiBackupTrackPreferencesCopyWithImpl($value, $cast, t);
}

class MangayomiBackupExtensionMapper
    extends ClassMapperBase<MangayomiBackupExtension> {
  MangayomiBackupExtensionMapper._();

  static MangayomiBackupExtensionMapper? _instance;
  static MangayomiBackupExtensionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = MangayomiBackupExtensionMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      ItemTypeMapper.ensureInitialized();
      RepoMapper.ensureInitialized();
      SourceCodeLanguageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupExtension';

  static int? _$id(MangayomiBackupExtension v) => v.id;
  static const Field<MangayomiBackupExtension, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: 0,
  );
  static String? _$name(MangayomiBackupExtension v) => v.name;
  static const Field<MangayomiBackupExtension, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
    def: '',
  );
  static String? _$baseUrl(MangayomiBackupExtension v) => v.baseUrl;
  static const Field<MangayomiBackupExtension, String> _f$baseUrl = Field(
    'baseUrl',
    _$baseUrl,
    opt: true,
    def: '',
  );
  static String? _$lang(MangayomiBackupExtension v) => v.lang;
  static const Field<MangayomiBackupExtension, String> _f$lang = Field(
    'lang',
    _$lang,
    opt: true,
    def: '',
  );
  static String? _$typeSource(MangayomiBackupExtension v) => v.typeSource;
  static const Field<MangayomiBackupExtension, String> _f$typeSource = Field(
    'typeSource',
    _$typeSource,
    opt: true,
    def: '',
  );
  static String? _$iconUrl(MangayomiBackupExtension v) => v.iconUrl;
  static const Field<MangayomiBackupExtension, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
    def: '',
  );
  static String? _$dateFormat(MangayomiBackupExtension v) => v.dateFormat;
  static const Field<MangayomiBackupExtension, String> _f$dateFormat = Field(
    'dateFormat',
    _$dateFormat,
    opt: true,
    def: '',
  );
  static String? _$dateFormatLocale(MangayomiBackupExtension v) =>
      v.dateFormatLocale;
  static const Field<MangayomiBackupExtension, String> _f$dateFormatLocale =
      Field('dateFormatLocale', _$dateFormatLocale, opt: true, def: '');
  static bool? _$isActive(MangayomiBackupExtension v) => v.isActive;
  static const Field<MangayomiBackupExtension, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
    def: true,
  );
  static bool? _$isAdded(MangayomiBackupExtension v) => v.isAdded;
  static const Field<MangayomiBackupExtension, bool> _f$isAdded = Field(
    'isAdded',
    _$isAdded,
    opt: true,
    def: false,
  );
  static bool? _$isNsfw(MangayomiBackupExtension v) => v.isNsfw;
  static const Field<MangayomiBackupExtension, bool> _f$isNsfw = Field(
    'isNsfw',
    _$isNsfw,
    opt: true,
    def: false,
  );
  static bool? _$isFullData(MangayomiBackupExtension v) => v.isFullData;
  static const Field<MangayomiBackupExtension, bool> _f$isFullData = Field(
    'isFullData',
    _$isFullData,
    opt: true,
    def: false,
  );
  static bool? _$hasCloudflare(MangayomiBackupExtension v) => v.hasCloudflare;
  static const Field<MangayomiBackupExtension, bool> _f$hasCloudflare = Field(
    'hasCloudflare',
    _$hasCloudflare,
    opt: true,
    def: false,
  );
  static bool? _$isPinned(MangayomiBackupExtension v) => v.isPinned;
  static const Field<MangayomiBackupExtension, bool> _f$isPinned = Field(
    'isPinned',
    _$isPinned,
    opt: true,
    def: false,
  );
  static bool? _$lastUsed(MangayomiBackupExtension v) => v.lastUsed;
  static const Field<MangayomiBackupExtension, bool> _f$lastUsed = Field(
    'lastUsed',
    _$lastUsed,
    opt: true,
    def: false,
  );
  static String? _$apiUrl(MangayomiBackupExtension v) => v.apiUrl;
  static const Field<MangayomiBackupExtension, String> _f$apiUrl = Field(
    'apiUrl',
    _$apiUrl,
    opt: true,
    def: '',
  );
  static String? _$sourceCodeUrl(MangayomiBackupExtension v) => v.sourceCodeUrl;
  static const Field<MangayomiBackupExtension, String> _f$sourceCodeUrl = Field(
    'sourceCodeUrl',
    _$sourceCodeUrl,
    opt: true,
    def: '',
  );
  static String? _$version(MangayomiBackupExtension v) => v.version;
  static const Field<MangayomiBackupExtension, String> _f$version = Field(
    'version',
    _$version,
    opt: true,
    def: '0.0.1',
  );
  static String? _$versionLast(MangayomiBackupExtension v) => v.versionLast;
  static const Field<MangayomiBackupExtension, String> _f$versionLast = Field(
    'versionLast',
    _$versionLast,
    opt: true,
    def: '0.0.1',
  );
  static String? _$sourceCode(MangayomiBackupExtension v) => v.sourceCode;
  static const Field<MangayomiBackupExtension, String> _f$sourceCode = Field(
    'sourceCode',
    _$sourceCode,
    opt: true,
    def: '',
  );
  static String? _$headers(MangayomiBackupExtension v) => v.headers;
  static const Field<MangayomiBackupExtension, String> _f$headers = Field(
    'headers',
    _$headers,
    opt: true,
    def: '',
  );
  static bool? _$isManga(MangayomiBackupExtension v) => v.isManga;
  static const Field<MangayomiBackupExtension, bool> _f$isManga = Field(
    'isManga',
    _$isManga,
    opt: true,
  );
  static ItemType _$itemType(MangayomiBackupExtension v) => v.itemType;
  static const Field<MangayomiBackupExtension, ItemType> _f$itemType = Field(
    'itemType',
    _$itemType,
    opt: true,
    def: ItemType.manga,
  );
  static String? _$appMinVerReq(MangayomiBackupExtension v) => v.appMinVerReq;
  static const Field<MangayomiBackupExtension, String> _f$appMinVerReq = Field(
    'appMinVerReq',
    _$appMinVerReq,
    opt: true,
    def: '',
  );
  static String? _$additionalParams(MangayomiBackupExtension v) =>
      v.additionalParams;
  static const Field<MangayomiBackupExtension, String> _f$additionalParams =
      Field('additionalParams', _$additionalParams, opt: true, def: '');
  static bool? _$isLocal(MangayomiBackupExtension v) => v.isLocal;
  static const Field<MangayomiBackupExtension, bool> _f$isLocal = Field(
    'isLocal',
    _$isLocal,
    opt: true,
    def: false,
  );
  static bool? _$isObsolete(MangayomiBackupExtension v) => v.isObsolete;
  static const Field<MangayomiBackupExtension, bool> _f$isObsolete = Field(
    'isObsolete',
    _$isObsolete,
    opt: true,
    def: false,
  );
  static Repo? _$repo(MangayomiBackupExtension v) => v.repo;
  static const Field<MangayomiBackupExtension, Repo> _f$repo = Field(
    'repo',
    _$repo,
    opt: true,
  );
  static SourceCodeLanguage _$sourceCodeLanguage(MangayomiBackupExtension v) =>
      v.sourceCodeLanguage;
  static const Field<MangayomiBackupExtension, SourceCodeLanguage>
  _f$sourceCodeLanguage = Field(
    'sourceCodeLanguage',
    _$sourceCodeLanguage,
    opt: true,
    def: SourceCodeLanguage.dart,
  );

  @override
  final MappableFields<MangayomiBackupExtension> fields = const {
    #id: _f$id,
    #name: _f$name,
    #baseUrl: _f$baseUrl,
    #lang: _f$lang,
    #typeSource: _f$typeSource,
    #iconUrl: _f$iconUrl,
    #dateFormat: _f$dateFormat,
    #dateFormatLocale: _f$dateFormatLocale,
    #isActive: _f$isActive,
    #isAdded: _f$isAdded,
    #isNsfw: _f$isNsfw,
    #isFullData: _f$isFullData,
    #hasCloudflare: _f$hasCloudflare,
    #isPinned: _f$isPinned,
    #lastUsed: _f$lastUsed,
    #apiUrl: _f$apiUrl,
    #sourceCodeUrl: _f$sourceCodeUrl,
    #version: _f$version,
    #versionLast: _f$versionLast,
    #sourceCode: _f$sourceCode,
    #headers: _f$headers,
    #isManga: _f$isManga,
    #itemType: _f$itemType,
    #appMinVerReq: _f$appMinVerReq,
    #additionalParams: _f$additionalParams,
    #isLocal: _f$isLocal,
    #isObsolete: _f$isObsolete,
    #repo: _f$repo,
    #sourceCodeLanguage: _f$sourceCodeLanguage,
  };

  static MangayomiBackupExtension _instantiate(DecodingData data) {
    return MangayomiBackupExtension(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      baseUrl: data.dec(_f$baseUrl),
      lang: data.dec(_f$lang),
      typeSource: data.dec(_f$typeSource),
      iconUrl: data.dec(_f$iconUrl),
      dateFormat: data.dec(_f$dateFormat),
      dateFormatLocale: data.dec(_f$dateFormatLocale),
      isActive: data.dec(_f$isActive),
      isAdded: data.dec(_f$isAdded),
      isNsfw: data.dec(_f$isNsfw),
      isFullData: data.dec(_f$isFullData),
      hasCloudflare: data.dec(_f$hasCloudflare),
      isPinned: data.dec(_f$isPinned),
      lastUsed: data.dec(_f$lastUsed),
      apiUrl: data.dec(_f$apiUrl),
      sourceCodeUrl: data.dec(_f$sourceCodeUrl),
      version: data.dec(_f$version),
      versionLast: data.dec(_f$versionLast),
      sourceCode: data.dec(_f$sourceCode),
      headers: data.dec(_f$headers),
      isManga: data.dec(_f$isManga),
      itemType: data.dec(_f$itemType),
      appMinVerReq: data.dec(_f$appMinVerReq),
      additionalParams: data.dec(_f$additionalParams),
      isLocal: data.dec(_f$isLocal),
      isObsolete: data.dec(_f$isObsolete),
      repo: data.dec(_f$repo),
      sourceCodeLanguage: data.dec(_f$sourceCodeLanguage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupExtension fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupExtension>(map);
  }

  static MangayomiBackupExtension fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupExtension>(json);
  }
}

mixin MangayomiBackupExtensionMappable {
  String toJson() {
    return MangayomiBackupExtensionMapper.ensureInitialized()
        .encodeJson<MangayomiBackupExtension>(this as MangayomiBackupExtension);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupExtensionMapper.ensureInitialized()
        .encodeMap<MangayomiBackupExtension>(this as MangayomiBackupExtension);
  }

  MangayomiBackupExtensionCopyWith<
    MangayomiBackupExtension,
    MangayomiBackupExtension,
    MangayomiBackupExtension
  >
  get copyWith => _MangayomiBackupExtensionCopyWithImpl(
    this as MangayomiBackupExtension,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MangayomiBackupExtensionMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupExtension,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupExtensionMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupExtension,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupExtensionMapper.ensureInitialized().hashValue(
      this as MangayomiBackupExtension,
    );
  }
}

extension MangayomiBackupExtensionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupExtension, $Out> {
  MangayomiBackupExtensionCopyWith<$R, MangayomiBackupExtension, $Out>
  get $asMangayomiBackupExtension =>
      $base.as((v, t, t2) => _MangayomiBackupExtensionCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupExtensionCopyWith<
  $R,
  $In extends MangayomiBackupExtension,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  RepoCopyWith<$R, Repo, Repo>? get repo;
  $R call({
    int? id,
    String? name,
    String? baseUrl,
    String? lang,
    String? typeSource,
    String? iconUrl,
    String? dateFormat,
    String? dateFormatLocale,
    bool? isActive,
    bool? isAdded,
    bool? isNsfw,
    bool? isFullData,
    bool? hasCloudflare,
    bool? isPinned,
    bool? lastUsed,
    String? apiUrl,
    String? sourceCodeUrl,
    String? version,
    String? versionLast,
    String? sourceCode,
    String? headers,
    bool? isManga,
    ItemType? itemType,
    String? appMinVerReq,
    String? additionalParams,
    bool? isLocal,
    bool? isObsolete,
    Repo? repo,
    SourceCodeLanguage? sourceCodeLanguage,
  });
  MangayomiBackupExtensionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupExtensionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupExtension, $Out>
    implements
        MangayomiBackupExtensionCopyWith<$R, MangayomiBackupExtension, $Out> {
  _MangayomiBackupExtensionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupExtension> $mapper =
      MangayomiBackupExtensionMapper.ensureInitialized();
  @override
  RepoCopyWith<$R, Repo, Repo>? get repo =>
      $value.repo?.copyWith.$chain((v) => call(repo: v));
  @override
  $R call({
    Object? id = $none,
    Object? name = $none,
    Object? baseUrl = $none,
    Object? lang = $none,
    Object? typeSource = $none,
    Object? iconUrl = $none,
    Object? dateFormat = $none,
    Object? dateFormatLocale = $none,
    Object? isActive = $none,
    Object? isAdded = $none,
    Object? isNsfw = $none,
    Object? isFullData = $none,
    Object? hasCloudflare = $none,
    Object? isPinned = $none,
    Object? lastUsed = $none,
    Object? apiUrl = $none,
    Object? sourceCodeUrl = $none,
    Object? version = $none,
    Object? versionLast = $none,
    Object? sourceCode = $none,
    Object? headers = $none,
    Object? isManga = $none,
    ItemType? itemType,
    Object? appMinVerReq = $none,
    Object? additionalParams = $none,
    Object? isLocal = $none,
    Object? isObsolete = $none,
    Object? repo = $none,
    SourceCodeLanguage? sourceCodeLanguage,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (name != $none) #name: name,
      if (baseUrl != $none) #baseUrl: baseUrl,
      if (lang != $none) #lang: lang,
      if (typeSource != $none) #typeSource: typeSource,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (dateFormat != $none) #dateFormat: dateFormat,
      if (dateFormatLocale != $none) #dateFormatLocale: dateFormatLocale,
      if (isActive != $none) #isActive: isActive,
      if (isAdded != $none) #isAdded: isAdded,
      if (isNsfw != $none) #isNsfw: isNsfw,
      if (isFullData != $none) #isFullData: isFullData,
      if (hasCloudflare != $none) #hasCloudflare: hasCloudflare,
      if (isPinned != $none) #isPinned: isPinned,
      if (lastUsed != $none) #lastUsed: lastUsed,
      if (apiUrl != $none) #apiUrl: apiUrl,
      if (sourceCodeUrl != $none) #sourceCodeUrl: sourceCodeUrl,
      if (version != $none) #version: version,
      if (versionLast != $none) #versionLast: versionLast,
      if (sourceCode != $none) #sourceCode: sourceCode,
      if (headers != $none) #headers: headers,
      if (isManga != $none) #isManga: isManga,
      if (itemType != null) #itemType: itemType,
      if (appMinVerReq != $none) #appMinVerReq: appMinVerReq,
      if (additionalParams != $none) #additionalParams: additionalParams,
      if (isLocal != $none) #isLocal: isLocal,
      if (isObsolete != $none) #isObsolete: isObsolete,
      if (repo != $none) #repo: repo,
      if (sourceCodeLanguage != null) #sourceCodeLanguage: sourceCodeLanguage,
    }),
  );
  @override
  MangayomiBackupExtension $make(CopyWithData data) => MangayomiBackupExtension(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    baseUrl: data.get(#baseUrl, or: $value.baseUrl),
    lang: data.get(#lang, or: $value.lang),
    typeSource: data.get(#typeSource, or: $value.typeSource),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    dateFormat: data.get(#dateFormat, or: $value.dateFormat),
    dateFormatLocale: data.get(#dateFormatLocale, or: $value.dateFormatLocale),
    isActive: data.get(#isActive, or: $value.isActive),
    isAdded: data.get(#isAdded, or: $value.isAdded),
    isNsfw: data.get(#isNsfw, or: $value.isNsfw),
    isFullData: data.get(#isFullData, or: $value.isFullData),
    hasCloudflare: data.get(#hasCloudflare, or: $value.hasCloudflare),
    isPinned: data.get(#isPinned, or: $value.isPinned),
    lastUsed: data.get(#lastUsed, or: $value.lastUsed),
    apiUrl: data.get(#apiUrl, or: $value.apiUrl),
    sourceCodeUrl: data.get(#sourceCodeUrl, or: $value.sourceCodeUrl),
    version: data.get(#version, or: $value.version),
    versionLast: data.get(#versionLast, or: $value.versionLast),
    sourceCode: data.get(#sourceCode, or: $value.sourceCode),
    headers: data.get(#headers, or: $value.headers),
    isManga: data.get(#isManga, or: $value.isManga),
    itemType: data.get(#itemType, or: $value.itemType),
    appMinVerReq: data.get(#appMinVerReq, or: $value.appMinVerReq),
    additionalParams: data.get(#additionalParams, or: $value.additionalParams),
    isLocal: data.get(#isLocal, or: $value.isLocal),
    isObsolete: data.get(#isObsolete, or: $value.isObsolete),
    repo: data.get(#repo, or: $value.repo),
    sourceCodeLanguage: data.get(
      #sourceCodeLanguage,
      or: $value.sourceCodeLanguage,
    ),
  );

  @override
  MangayomiBackupExtensionCopyWith<$R2, MangayomiBackupExtension, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MangayomiBackupExtensionCopyWithImpl($value, $cast, t);
}

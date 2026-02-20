// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_manga.dart';

class TachiBackupMangaMapper extends ClassMapperBase<TachiBackupManga> {
  TachiBackupMangaMapper._();

  static TachiBackupMangaMapper? _instance;
  static TachiBackupMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiBackupMangaMapper._());
      TachiBackupChapterMapper.ensureInitialized();
      TachiBackupTrackingMapper.ensureInitialized();
      TachiBackupHistoryMapper.ensureInitialized();
      TachiUpdateStrategyMapper.ensureInitialized();
      NekoBackupMergeMangaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupManga';

  static int _$source(TachiBackupManga v) => v.source;
  static const Field<TachiBackupManga, int> _f$source = Field(
    'source',
    _$source,
  );
  static String _$url(TachiBackupManga v) => v.url;
  static const Field<TachiBackupManga, String> _f$url = Field('url', _$url);
  static String _$title(TachiBackupManga v) => v.title;
  static const Field<TachiBackupManga, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$artist(TachiBackupManga v) => v.artist;
  static const Field<TachiBackupManga, String> _f$artist = Field(
    'artist',
    _$artist,
  );
  static String _$author(TachiBackupManga v) => v.author;
  static const Field<TachiBackupManga, String> _f$author = Field(
    'author',
    _$author,
  );
  static String _$description(TachiBackupManga v) => v.description;
  static const Field<TachiBackupManga, String> _f$description = Field(
    'description',
    _$description,
  );
  static List<String> _$genre(TachiBackupManga v) => v.genre;
  static const Field<TachiBackupManga, List<String>> _f$genre = Field(
    'genre',
    _$genre,
  );
  static int _$status(TachiBackupManga v) => v.status;
  static const Field<TachiBackupManga, int> _f$status = Field(
    'status',
    _$status,
  );
  static String _$thumbnailUrl(TachiBackupManga v) => v.thumbnailUrl;
  static const Field<TachiBackupManga, String> _f$thumbnailUrl = Field(
    'thumbnailUrl',
    _$thumbnailUrl,
  );
  static int _$dateAdded(TachiBackupManga v) => v.dateAdded;
  static const Field<TachiBackupManga, int> _f$dateAdded = Field(
    'dateAdded',
    _$dateAdded,
  );
  static int _$viewer(TachiBackupManga v) => v.viewer;
  static const Field<TachiBackupManga, int> _f$viewer = Field(
    'viewer',
    _$viewer,
  );
  static List<TachiBackupChapter> _$chapters(TachiBackupManga v) => v.chapters;
  static const Field<TachiBackupManga, List<TachiBackupChapter>> _f$chapters =
      Field('chapters', _$chapters);
  static List<int> _$categories(TachiBackupManga v) => v.categories;
  static const Field<TachiBackupManga, List<int>> _f$categories = Field(
    'categories',
    _$categories,
  );
  static List<TachiBackupTracking> _$tracking(TachiBackupManga v) => v.tracking;
  static const Field<TachiBackupManga, List<TachiBackupTracking>> _f$tracking =
      Field('tracking', _$tracking);
  static bool _$favorite(TachiBackupManga v) => v.favorite;
  static const Field<TachiBackupManga, bool> _f$favorite = Field(
    'favorite',
    _$favorite,
  );
  static int _$chapterFlags(TachiBackupManga v) => v.chapterFlags;
  static const Field<TachiBackupManga, int> _f$chapterFlags = Field(
    'chapterFlags',
    _$chapterFlags,
  );
  static int _$viewerFlags(TachiBackupManga v) => v.viewerFlags;
  static const Field<TachiBackupManga, int> _f$viewerFlags = Field(
    'viewerFlags',
    _$viewerFlags,
  );
  static List<TachiBackupHistory> _$history(TachiBackupManga v) => v.history;
  static const Field<TachiBackupManga, List<TachiBackupHistory>> _f$history =
      Field('history', _$history);
  static List<TachiBackupHistory> _$brokenHistory(TachiBackupManga v) =>
      v.brokenHistory;
  static const Field<TachiBackupManga, List<TachiBackupHistory>>
  _f$brokenHistory = Field(
    'brokenHistory',
    _$brokenHistory,
    opt: true,
    def: const <TachiBackupHistory>[],
  );
  static TachiUpdateStrategy _$updateStrategy(TachiBackupManga v) =>
      v.updateStrategy;
  static const Field<TachiBackupManga, TachiUpdateStrategy> _f$updateStrategy =
      Field(
        'updateStrategy',
        _$updateStrategy,
        opt: true,
        def: TachiUpdateStrategy.alwaysUpdate,
      );
  static int? _$lastModifiedAt(TachiBackupManga v) => v.lastModifiedAt;
  static const Field<TachiBackupManga, int> _f$lastModifiedAt = Field(
    'lastModifiedAt',
    _$lastModifiedAt,
    opt: true,
  );
  static int? _$favoriteModifiedAt(TachiBackupManga v) => v.favoriteModifiedAt;
  static const Field<TachiBackupManga, int> _f$favoriteModifiedAt = Field(
    'favoriteModifiedAt',
    _$favoriteModifiedAt,
    opt: true,
  );
  static List<String>? _$excludedScanlators(TachiBackupManga v) =>
      v.excludedScanlators;
  static const Field<TachiBackupManga, List<String>> _f$excludedScanlators =
      Field('excludedScanlators', _$excludedScanlators, opt: true);
  static int? _$version(TachiBackupManga v) => v.version;
  static const Field<TachiBackupManga, int> _f$version = Field(
    'version',
    _$version,
    opt: true,
  );
  static int? _$customStatus(TachiBackupManga v) => v.customStatus;
  static const Field<TachiBackupManga, int> _f$customStatus = Field(
    'customStatus',
    _$customStatus,
    opt: true,
  );
  static String? _$customThumbnailUrl(TachiBackupManga v) =>
      v.customThumbnailUrl;
  static const Field<TachiBackupManga, String> _f$customThumbnailUrl = Field(
    'customThumbnailUrl',
    _$customThumbnailUrl,
    opt: true,
  );
  static String? _$customTitle(TachiBackupManga v) => v.customTitle;
  static const Field<TachiBackupManga, String> _f$customTitle = Field(
    'customTitle',
    _$customTitle,
    opt: true,
  );
  static String? _$customArtist(TachiBackupManga v) => v.customArtist;
  static const Field<TachiBackupManga, String> _f$customArtist = Field(
    'customArtist',
    _$customArtist,
    opt: true,
  );
  static String? _$customAuthor(TachiBackupManga v) => v.customAuthor;
  static const Field<TachiBackupManga, String> _f$customAuthor = Field(
    'customAuthor',
    _$customAuthor,
    opt: true,
  );
  static String? _$customDescription(TachiBackupManga v) => v.customDescription;
  static const Field<TachiBackupManga, String> _f$customDescription = Field(
    'customDescription',
    _$customDescription,
    opt: true,
  );
  static List<String>? _$customGenre(TachiBackupManga v) => v.customGenre;
  static const Field<TachiBackupManga, List<String>> _f$customGenre = Field(
    'customGenre',
    _$customGenre,
    opt: true,
  );
  static String? _$scanlatorFilter(TachiBackupManga v) => v.scanlatorFilter;
  static const Field<TachiBackupManga, String> _f$scanlatorFilter = Field(
    'scanlatorFilter',
    _$scanlatorFilter,
    opt: true,
  );
  static String? _$alternativeArtwork(TachiBackupManga v) =>
      v.alternativeArtwork;
  static const Field<TachiBackupManga, String> _f$alternativeArtwork = Field(
    'alternativeArtwork',
    _$alternativeArtwork,
    opt: true,
  );
  static List<NekoBackupMergeManga>? _$mergeMangaList(TachiBackupManga v) =>
      v.mergeMangaList;
  static const Field<TachiBackupManga, List<NekoBackupMergeManga>>
  _f$mergeMangaList = Field('mergeMangaList', _$mergeMangaList, opt: true);

  @override
  final MappableFields<TachiBackupManga> fields = const {
    #source: _f$source,
    #url: _f$url,
    #title: _f$title,
    #artist: _f$artist,
    #author: _f$author,
    #description: _f$description,
    #genre: _f$genre,
    #status: _f$status,
    #thumbnailUrl: _f$thumbnailUrl,
    #dateAdded: _f$dateAdded,
    #viewer: _f$viewer,
    #chapters: _f$chapters,
    #categories: _f$categories,
    #tracking: _f$tracking,
    #favorite: _f$favorite,
    #chapterFlags: _f$chapterFlags,
    #viewerFlags: _f$viewerFlags,
    #history: _f$history,
    #brokenHistory: _f$brokenHistory,
    #updateStrategy: _f$updateStrategy,
    #lastModifiedAt: _f$lastModifiedAt,
    #favoriteModifiedAt: _f$favoriteModifiedAt,
    #excludedScanlators: _f$excludedScanlators,
    #version: _f$version,
    #customStatus: _f$customStatus,
    #customThumbnailUrl: _f$customThumbnailUrl,
    #customTitle: _f$customTitle,
    #customArtist: _f$customArtist,
    #customAuthor: _f$customAuthor,
    #customDescription: _f$customDescription,
    #customGenre: _f$customGenre,
    #scanlatorFilter: _f$scanlatorFilter,
    #alternativeArtwork: _f$alternativeArtwork,
    #mergeMangaList: _f$mergeMangaList,
  };

  static TachiBackupManga _instantiate(DecodingData data) {
    return TachiBackupManga(
      source: data.dec(_f$source),
      url: data.dec(_f$url),
      title: data.dec(_f$title),
      artist: data.dec(_f$artist),
      author: data.dec(_f$author),
      description: data.dec(_f$description),
      genre: data.dec(_f$genre),
      status: data.dec(_f$status),
      thumbnailUrl: data.dec(_f$thumbnailUrl),
      dateAdded: data.dec(_f$dateAdded),
      viewer: data.dec(_f$viewer),
      chapters: data.dec(_f$chapters),
      categories: data.dec(_f$categories),
      tracking: data.dec(_f$tracking),
      favorite: data.dec(_f$favorite),
      chapterFlags: data.dec(_f$chapterFlags),
      viewerFlags: data.dec(_f$viewerFlags),
      history: data.dec(_f$history),
      brokenHistory: data.dec(_f$brokenHistory),
      updateStrategy: data.dec(_f$updateStrategy),
      lastModifiedAt: data.dec(_f$lastModifiedAt),
      favoriteModifiedAt: data.dec(_f$favoriteModifiedAt),
      excludedScanlators: data.dec(_f$excludedScanlators),
      version: data.dec(_f$version),
      customStatus: data.dec(_f$customStatus),
      customThumbnailUrl: data.dec(_f$customThumbnailUrl),
      customTitle: data.dec(_f$customTitle),
      customArtist: data.dec(_f$customArtist),
      customAuthor: data.dec(_f$customAuthor),
      customDescription: data.dec(_f$customDescription),
      customGenre: data.dec(_f$customGenre),
      scanlatorFilter: data.dec(_f$scanlatorFilter),
      alternativeArtwork: data.dec(_f$alternativeArtwork),
      mergeMangaList: data.dec(_f$mergeMangaList),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupManga>(map);
  }

  static TachiBackupManga fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupManga>(json);
  }
}

mixin TachiBackupMangaMappable {
  String toJson() {
    return TachiBackupMangaMapper.ensureInitialized()
        .encodeJson<TachiBackupManga>(this as TachiBackupManga);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupMangaMapper.ensureInitialized()
        .encodeMap<TachiBackupManga>(this as TachiBackupManga);
  }

  TachiBackupMangaCopyWith<TachiBackupManga, TachiBackupManga, TachiBackupManga>
  get copyWith =>
      _TachiBackupMangaCopyWithImpl<TachiBackupManga, TachiBackupManga>(
        this as TachiBackupManga,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TachiBackupMangaMapper.ensureInitialized().stringifyValue(
      this as TachiBackupManga,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupMangaMapper.ensureInitialized().equalsValue(
      this as TachiBackupManga,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiBackupMangaMapper.ensureInitialized().hashValue(
      this as TachiBackupManga,
    );
  }
}

extension TachiBackupMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupManga, $Out> {
  TachiBackupMangaCopyWith<$R, TachiBackupManga, $Out>
  get $asTachiBackupManga =>
      $base.as((v, t, t2) => _TachiBackupMangaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TachiBackupMangaCopyWith<$R, $In extends TachiBackupManga, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get genre;
  ListCopyWith<
    $R,
    TachiBackupChapter,
    TachiBackupChapterCopyWith<$R, TachiBackupChapter, TachiBackupChapter>
  >
  get chapters;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get categories;
  ListCopyWith<
    $R,
    TachiBackupTracking,
    TachiBackupTrackingCopyWith<$R, TachiBackupTracking, TachiBackupTracking>
  >
  get tracking;
  ListCopyWith<
    $R,
    TachiBackupHistory,
    TachiBackupHistoryCopyWith<$R, TachiBackupHistory, TachiBackupHistory>
  >
  get history;
  ListCopyWith<
    $R,
    TachiBackupHistory,
    TachiBackupHistoryCopyWith<$R, TachiBackupHistory, TachiBackupHistory>
  >
  get brokenHistory;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get excludedScanlators;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get customGenre;
  ListCopyWith<
    $R,
    NekoBackupMergeManga,
    NekoBackupMergeMangaCopyWith<$R, NekoBackupMergeManga, NekoBackupMergeManga>
  >?
  get mergeMangaList;
  $R call({
    int? source,
    String? url,
    String? title,
    String? artist,
    String? author,
    String? description,
    List<String>? genre,
    int? status,
    String? thumbnailUrl,
    int? dateAdded,
    int? viewer,
    List<TachiBackupChapter>? chapters,
    List<int>? categories,
    List<TachiBackupTracking>? tracking,
    bool? favorite,
    int? chapterFlags,
    int? viewerFlags,
    List<TachiBackupHistory>? history,
    List<TachiBackupHistory>? brokenHistory,
    TachiUpdateStrategy? updateStrategy,
    int? lastModifiedAt,
    int? favoriteModifiedAt,
    List<String>? excludedScanlators,
    int? version,
    int? customStatus,
    String? customThumbnailUrl,
    String? customTitle,
    String? customArtist,
    String? customAuthor,
    String? customDescription,
    List<String>? customGenre,
    String? scanlatorFilter,
    String? alternativeArtwork,
    List<NekoBackupMergeManga>? mergeMangaList,
  });
  TachiBackupMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachiBackupMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupManga, $Out>
    implements TachiBackupMangaCopyWith<$R, TachiBackupManga, $Out> {
  _TachiBackupMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupManga> $mapper =
      TachiBackupMangaMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get genre =>
      ListCopyWith(
        $value.genre,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(genre: v),
      );
  @override
  ListCopyWith<
    $R,
    TachiBackupChapter,
    TachiBackupChapterCopyWith<$R, TachiBackupChapter, TachiBackupChapter>
  >
  get chapters => ListCopyWith(
    $value.chapters,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(chapters: v),
  );
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get categories =>
      ListCopyWith(
        $value.categories,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(categories: v),
      );
  @override
  ListCopyWith<
    $R,
    TachiBackupTracking,
    TachiBackupTrackingCopyWith<$R, TachiBackupTracking, TachiBackupTracking>
  >
  get tracking => ListCopyWith(
    $value.tracking,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(tracking: v),
  );
  @override
  ListCopyWith<
    $R,
    TachiBackupHistory,
    TachiBackupHistoryCopyWith<$R, TachiBackupHistory, TachiBackupHistory>
  >
  get history => ListCopyWith(
    $value.history,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(history: v),
  );
  @override
  ListCopyWith<
    $R,
    TachiBackupHistory,
    TachiBackupHistoryCopyWith<$R, TachiBackupHistory, TachiBackupHistory>
  >
  get brokenHistory => ListCopyWith(
    $value.brokenHistory,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(brokenHistory: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get excludedScanlators => $value.excludedScanlators != null
      ? ListCopyWith(
          $value.excludedScanlators!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(excludedScanlators: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get customGenre => $value.customGenre != null
      ? ListCopyWith(
          $value.customGenre!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(customGenre: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    NekoBackupMergeManga,
    NekoBackupMergeMangaCopyWith<$R, NekoBackupMergeManga, NekoBackupMergeManga>
  >?
  get mergeMangaList => $value.mergeMangaList != null
      ? ListCopyWith(
          $value.mergeMangaList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(mergeMangaList: v),
        )
      : null;
  @override
  $R call({
    int? source,
    String? url,
    String? title,
    String? artist,
    String? author,
    String? description,
    List<String>? genre,
    int? status,
    String? thumbnailUrl,
    int? dateAdded,
    int? viewer,
    List<TachiBackupChapter>? chapters,
    List<int>? categories,
    List<TachiBackupTracking>? tracking,
    bool? favorite,
    int? chapterFlags,
    int? viewerFlags,
    List<TachiBackupHistory>? history,
    List<TachiBackupHistory>? brokenHistory,
    TachiUpdateStrategy? updateStrategy,
    Object? lastModifiedAt = $none,
    Object? favoriteModifiedAt = $none,
    Object? excludedScanlators = $none,
    Object? version = $none,
    Object? customStatus = $none,
    Object? customThumbnailUrl = $none,
    Object? customTitle = $none,
    Object? customArtist = $none,
    Object? customAuthor = $none,
    Object? customDescription = $none,
    Object? customGenre = $none,
    Object? scanlatorFilter = $none,
    Object? alternativeArtwork = $none,
    Object? mergeMangaList = $none,
  }) => $apply(
    FieldCopyWithData({
      if (source != null) #source: source,
      if (url != null) #url: url,
      if (title != null) #title: title,
      if (artist != null) #artist: artist,
      if (author != null) #author: author,
      if (description != null) #description: description,
      if (genre != null) #genre: genre,
      if (status != null) #status: status,
      if (thumbnailUrl != null) #thumbnailUrl: thumbnailUrl,
      if (dateAdded != null) #dateAdded: dateAdded,
      if (viewer != null) #viewer: viewer,
      if (chapters != null) #chapters: chapters,
      if (categories != null) #categories: categories,
      if (tracking != null) #tracking: tracking,
      if (favorite != null) #favorite: favorite,
      if (chapterFlags != null) #chapterFlags: chapterFlags,
      if (viewerFlags != null) #viewerFlags: viewerFlags,
      if (history != null) #history: history,
      if (brokenHistory != null) #brokenHistory: brokenHistory,
      if (updateStrategy != null) #updateStrategy: updateStrategy,
      if (lastModifiedAt != $none) #lastModifiedAt: lastModifiedAt,
      if (favoriteModifiedAt != $none) #favoriteModifiedAt: favoriteModifiedAt,
      if (excludedScanlators != $none) #excludedScanlators: excludedScanlators,
      if (version != $none) #version: version,
      if (customStatus != $none) #customStatus: customStatus,
      if (customThumbnailUrl != $none) #customThumbnailUrl: customThumbnailUrl,
      if (customTitle != $none) #customTitle: customTitle,
      if (customArtist != $none) #customArtist: customArtist,
      if (customAuthor != $none) #customAuthor: customAuthor,
      if (customDescription != $none) #customDescription: customDescription,
      if (customGenre != $none) #customGenre: customGenre,
      if (scanlatorFilter != $none) #scanlatorFilter: scanlatorFilter,
      if (alternativeArtwork != $none) #alternativeArtwork: alternativeArtwork,
      if (mergeMangaList != $none) #mergeMangaList: mergeMangaList,
    }),
  );
  @override
  TachiBackupManga $make(CopyWithData data) => TachiBackupManga(
    source: data.get(#source, or: $value.source),
    url: data.get(#url, or: $value.url),
    title: data.get(#title, or: $value.title),
    artist: data.get(#artist, or: $value.artist),
    author: data.get(#author, or: $value.author),
    description: data.get(#description, or: $value.description),
    genre: data.get(#genre, or: $value.genre),
    status: data.get(#status, or: $value.status),
    thumbnailUrl: data.get(#thumbnailUrl, or: $value.thumbnailUrl),
    dateAdded: data.get(#dateAdded, or: $value.dateAdded),
    viewer: data.get(#viewer, or: $value.viewer),
    chapters: data.get(#chapters, or: $value.chapters),
    categories: data.get(#categories, or: $value.categories),
    tracking: data.get(#tracking, or: $value.tracking),
    favorite: data.get(#favorite, or: $value.favorite),
    chapterFlags: data.get(#chapterFlags, or: $value.chapterFlags),
    viewerFlags: data.get(#viewerFlags, or: $value.viewerFlags),
    history: data.get(#history, or: $value.history),
    brokenHistory: data.get(#brokenHistory, or: $value.brokenHistory),
    updateStrategy: data.get(#updateStrategy, or: $value.updateStrategy),
    lastModifiedAt: data.get(#lastModifiedAt, or: $value.lastModifiedAt),
    favoriteModifiedAt: data.get(
      #favoriteModifiedAt,
      or: $value.favoriteModifiedAt,
    ),
    excludedScanlators: data.get(
      #excludedScanlators,
      or: $value.excludedScanlators,
    ),
    version: data.get(#version, or: $value.version),
    customStatus: data.get(#customStatus, or: $value.customStatus),
    customThumbnailUrl: data.get(
      #customThumbnailUrl,
      or: $value.customThumbnailUrl,
    ),
    customTitle: data.get(#customTitle, or: $value.customTitle),
    customArtist: data.get(#customArtist, or: $value.customArtist),
    customAuthor: data.get(#customAuthor, or: $value.customAuthor),
    customDescription: data.get(
      #customDescription,
      or: $value.customDescription,
    ),
    customGenre: data.get(#customGenre, or: $value.customGenre),
    scanlatorFilter: data.get(#scanlatorFilter, or: $value.scanlatorFilter),
    alternativeArtwork: data.get(
      #alternativeArtwork,
      or: $value.alternativeArtwork,
    ),
    mergeMangaList: data.get(#mergeMangaList, or: $value.mergeMangaList),
  );

  @override
  TachiBackupMangaCopyWith<$R2, TachiBackupManga, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachiBackupMangaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


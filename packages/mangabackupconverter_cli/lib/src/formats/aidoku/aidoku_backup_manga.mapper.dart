// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'aidoku_backup_manga.dart';

class AidokuBackupMangaMapper extends ClassMapperBase<AidokuBackupManga> {
  AidokuBackupMangaMapper._();

  static AidokuBackupMangaMapper? _instance;
  static AidokuBackupMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuBackupMangaMapper._());
      AidokuPublishingStatusMapper.ensureInitialized();
      AidokuMangaContentRatingMapper.ensureInitialized();
      AidokuMangaViewerMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AidokuBackupManga';

  static String _$id(AidokuBackupManga v) => v.id;
  static const Field<AidokuBackupManga, String> _f$id = Field('id', _$id);
  static String _$sourceId(AidokuBackupManga v) => v.sourceId;
  static const Field<AidokuBackupManga, String> _f$sourceId = Field(
    'sourceId',
    _$sourceId,
  );
  static String _$title(AidokuBackupManga v) => v.title;
  static const Field<AidokuBackupManga, String> _f$title = Field(
    'title',
    _$title,
  );
  static String? _$author(AidokuBackupManga v) => v.author;
  static const Field<AidokuBackupManga, String> _f$author = Field(
    'author',
    _$author,
    opt: true,
  );
  static String? _$artist(AidokuBackupManga v) => v.artist;
  static const Field<AidokuBackupManga, String> _f$artist = Field(
    'artist',
    _$artist,
    opt: true,
  );
  static String? _$desc(AidokuBackupManga v) => v.desc;
  static const Field<AidokuBackupManga, String> _f$desc = Field(
    'desc',
    _$desc,
    opt: true,
  );
  static List<String>? _$tags(AidokuBackupManga v) => v.tags;
  static const Field<AidokuBackupManga, List<String>> _f$tags = Field(
    'tags',
    _$tags,
    opt: true,
  );
  static String? _$cover(AidokuBackupManga v) => v.cover;
  static const Field<AidokuBackupManga, String> _f$cover = Field(
    'cover',
    _$cover,
    opt: true,
  );
  static String? _$url(AidokuBackupManga v) => v.url;
  static const Field<AidokuBackupManga, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static AidokuPublishingStatus _$status(AidokuBackupManga v) => v.status;
  static const Field<AidokuBackupManga, AidokuPublishingStatus> _f$status =
      Field('status', _$status, opt: true, def: AidokuPublishingStatus.unknown);
  static AidokuMangaContentRating _$nsfw(AidokuBackupManga v) => v.nsfw;
  static const Field<AidokuBackupManga, AidokuMangaContentRating> _f$nsfw =
      Field('nsfw', _$nsfw, opt: true, def: AidokuMangaContentRating.safe);
  static AidokuMangaViewer _$viewer(AidokuBackupManga v) => v.viewer;
  static const Field<AidokuBackupManga, AidokuMangaViewer> _f$viewer = Field(
    'viewer',
    _$viewer,
    opt: true,
    def: AidokuMangaViewer.defaultViewer,
  );
  static int _$chapterFlags(AidokuBackupManga v) => v.chapterFlags;
  static const Field<AidokuBackupManga, int> _f$chapterFlags = Field(
    'chapterFlags',
    _$chapterFlags,
    opt: true,
    def: 0,
  );
  static String? _$langFilter(AidokuBackupManga v) => v.langFilter;
  static const Field<AidokuBackupManga, String> _f$langFilter = Field(
    'langFilter',
    _$langFilter,
    opt: true,
  );
  static List<String>? _$scanlatorFilter(AidokuBackupManga v) =>
      v.scanlatorFilter;
  static const Field<AidokuBackupManga, List<String>> _f$scanlatorFilter =
      Field('scanlatorFilter', _$scanlatorFilter, opt: true);

  @override
  final MappableFields<AidokuBackupManga> fields = const {
    #id: _f$id,
    #sourceId: _f$sourceId,
    #title: _f$title,
    #author: _f$author,
    #artist: _f$artist,
    #desc: _f$desc,
    #tags: _f$tags,
    #cover: _f$cover,
    #url: _f$url,
    #status: _f$status,
    #nsfw: _f$nsfw,
    #viewer: _f$viewer,
    #chapterFlags: _f$chapterFlags,
    #langFilter: _f$langFilter,
    #scanlatorFilter: _f$scanlatorFilter,
  };
  @override
  final bool ignoreNull = true;

  static AidokuBackupManga _instantiate(DecodingData data) {
    return AidokuBackupManga(
      id: data.dec(_f$id),
      sourceId: data.dec(_f$sourceId),
      title: data.dec(_f$title),
      author: data.dec(_f$author),
      artist: data.dec(_f$artist),
      desc: data.dec(_f$desc),
      tags: data.dec(_f$tags),
      cover: data.dec(_f$cover),
      url: data.dec(_f$url),
      status: data.dec(_f$status),
      nsfw: data.dec(_f$nsfw),
      viewer: data.dec(_f$viewer),
      chapterFlags: data.dec(_f$chapterFlags),
      langFilter: data.dec(_f$langFilter),
      scanlatorFilter: data.dec(_f$scanlatorFilter),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AidokuBackupManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AidokuBackupManga>(map);
  }

  static AidokuBackupManga fromJson(String json) {
    return ensureInitialized().decodeJson<AidokuBackupManga>(json);
  }
}

mixin AidokuBackupMangaMappable {
  String toJson() {
    return AidokuBackupMangaMapper.ensureInitialized()
        .encodeJson<AidokuBackupManga>(this as AidokuBackupManga);
  }

  Map<String, dynamic> toMap() {
    return AidokuBackupMangaMapper.ensureInitialized()
        .encodeMap<AidokuBackupManga>(this as AidokuBackupManga);
  }

  AidokuBackupMangaCopyWith<
    AidokuBackupManga,
    AidokuBackupManga,
    AidokuBackupManga
  >
  get copyWith =>
      _AidokuBackupMangaCopyWithImpl<AidokuBackupManga, AidokuBackupManga>(
        this as AidokuBackupManga,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AidokuBackupMangaMapper.ensureInitialized().stringifyValue(
      this as AidokuBackupManga,
    );
  }

  @override
  bool operator ==(Object other) {
    return AidokuBackupMangaMapper.ensureInitialized().equalsValue(
      this as AidokuBackupManga,
      other,
    );
  }

  @override
  int get hashCode {
    return AidokuBackupMangaMapper.ensureInitialized().hashValue(
      this as AidokuBackupManga,
    );
  }
}

extension AidokuBackupMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AidokuBackupManga, $Out> {
  AidokuBackupMangaCopyWith<$R, AidokuBackupManga, $Out>
  get $asAidokuBackupManga => $base.as(
    (v, t, t2) => _AidokuBackupMangaCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AidokuBackupMangaCopyWith<
  $R,
  $In extends AidokuBackupManga,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get tags;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get scanlatorFilter;
  $R call({
    String? id,
    String? sourceId,
    String? title,
    String? author,
    String? artist,
    String? desc,
    List<String>? tags,
    String? cover,
    String? url,
    AidokuPublishingStatus? status,
    AidokuMangaContentRating? nsfw,
    AidokuMangaViewer? viewer,
    int? chapterFlags,
    String? langFilter,
    List<String>? scanlatorFilter,
  });
  AidokuBackupMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AidokuBackupMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AidokuBackupManga, $Out>
    implements AidokuBackupMangaCopyWith<$R, AidokuBackupManga, $Out> {
  _AidokuBackupMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AidokuBackupManga> $mapper =
      AidokuBackupMangaMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get tags =>
      $value.tags != null
      ? ListCopyWith(
          $value.tags!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(tags: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get scanlatorFilter => $value.scanlatorFilter != null
      ? ListCopyWith(
          $value.scanlatorFilter!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(scanlatorFilter: v),
        )
      : null;
  @override
  $R call({
    String? id,
    String? sourceId,
    String? title,
    Object? author = $none,
    Object? artist = $none,
    Object? desc = $none,
    Object? tags = $none,
    Object? cover = $none,
    Object? url = $none,
    AidokuPublishingStatus? status,
    AidokuMangaContentRating? nsfw,
    AidokuMangaViewer? viewer,
    int? chapterFlags,
    Object? langFilter = $none,
    Object? scanlatorFilter = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (sourceId != null) #sourceId: sourceId,
      if (title != null) #title: title,
      if (author != $none) #author: author,
      if (artist != $none) #artist: artist,
      if (desc != $none) #desc: desc,
      if (tags != $none) #tags: tags,
      if (cover != $none) #cover: cover,
      if (url != $none) #url: url,
      if (status != null) #status: status,
      if (nsfw != null) #nsfw: nsfw,
      if (viewer != null) #viewer: viewer,
      if (chapterFlags != null) #chapterFlags: chapterFlags,
      if (langFilter != $none) #langFilter: langFilter,
      if (scanlatorFilter != $none) #scanlatorFilter: scanlatorFilter,
    }),
  );
  @override
  AidokuBackupManga $make(CopyWithData data) => AidokuBackupManga(
    id: data.get(#id, or: $value.id),
    sourceId: data.get(#sourceId, or: $value.sourceId),
    title: data.get(#title, or: $value.title),
    author: data.get(#author, or: $value.author),
    artist: data.get(#artist, or: $value.artist),
    desc: data.get(#desc, or: $value.desc),
    tags: data.get(#tags, or: $value.tags),
    cover: data.get(#cover, or: $value.cover),
    url: data.get(#url, or: $value.url),
    status: data.get(#status, or: $value.status),
    nsfw: data.get(#nsfw, or: $value.nsfw),
    viewer: data.get(#viewer, or: $value.viewer),
    chapterFlags: data.get(#chapterFlags, or: $value.chapterFlags),
    langFilter: data.get(#langFilter, or: $value.langFilter),
    scanlatorFilter: data.get(#scanlatorFilter, or: $value.scanlatorFilter),
  );

  @override
  AidokuBackupMangaCopyWith<$R2, AidokuBackupManga, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AidokuBackupMangaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


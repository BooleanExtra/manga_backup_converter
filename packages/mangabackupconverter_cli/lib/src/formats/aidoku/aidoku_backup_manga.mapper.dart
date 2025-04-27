// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'aidoku_backup_manga.dart';

class AidokuBackupMangaMapper extends ClassMapperBase<AidokuBackupManga> {
  AidokuBackupMangaMapper._();

  static AidokuBackupMangaMapper? _instance;
  static AidokuBackupMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuBackupMangaMapper._());
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
  );
  static String? _$artist(AidokuBackupManga v) => v.artist;
  static const Field<AidokuBackupManga, String> _f$artist = Field(
    'artist',
    _$artist,
  );
  static String? _$desc(AidokuBackupManga v) => v.desc;
  static const Field<AidokuBackupManga, String> _f$desc = Field('desc', _$desc);
  static List<String>? _$tags(AidokuBackupManga v) => v.tags;
  static const Field<AidokuBackupManga, List<String>> _f$tags = Field(
    'tags',
    _$tags,
  );
  static String? _$cover(AidokuBackupManga v) => v.cover;
  static const Field<AidokuBackupManga, String> _f$cover = Field(
    'cover',
    _$cover,
  );
  static String? _$url(AidokuBackupManga v) => v.url;
  static const Field<AidokuBackupManga, String> _f$url = Field('url', _$url);
  static int _$status(AidokuBackupManga v) => v.status;
  static const Field<AidokuBackupManga, int> _f$status = Field(
    'status',
    _$status,
  );
  static int _$nsfw(AidokuBackupManga v) => v.nsfw;
  static const Field<AidokuBackupManga, int> _f$nsfw = Field('nsfw', _$nsfw);
  static int _$viewer(AidokuBackupManga v) => v.viewer;
  static const Field<AidokuBackupManga, int> _f$viewer = Field(
    'viewer',
    _$viewer,
  );
  static int? _$chapterFlags(AidokuBackupManga v) => v.chapterFlags;
  static const Field<AidokuBackupManga, int> _f$chapterFlags = Field(
    'chapterFlags',
    _$chapterFlags,
  );
  static String? _$langFilter(AidokuBackupManga v) => v.langFilter;
  static const Field<AidokuBackupManga, String> _f$langFilter = Field(
    'langFilter',
    _$langFilter,
  );

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
  get copyWith => _AidokuBackupMangaCopyWithImpl(
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
  get $asAidokuBackupManga =>
      $base.as((v, t, t2) => _AidokuBackupMangaCopyWithImpl(v, t, t2));
}

abstract class AidokuBackupMangaCopyWith<
  $R,
  $In extends AidokuBackupManga,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get tags;
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
    int? status,
    int? nsfw,
    int? viewer,
    int? chapterFlags,
    String? langFilter,
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
    int? status,
    int? nsfw,
    int? viewer,
    Object? chapterFlags = $none,
    Object? langFilter = $none,
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
      if (chapterFlags != $none) #chapterFlags: chapterFlags,
      if (langFilter != $none) #langFilter: langFilter,
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
  );

  @override
  AidokuBackupMangaCopyWith<$R2, AidokuBackupManga, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AidokuBackupMangaCopyWithImpl($value, $cast, t);
}

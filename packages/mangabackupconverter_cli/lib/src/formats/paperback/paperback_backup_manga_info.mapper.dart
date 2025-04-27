// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup_manga_info.dart';

class PaperbackBackupMangaInfoMapper
    extends ClassMapperBase<PaperbackBackupMangaInfo> {
  PaperbackBackupMangaInfoMapper._();

  static PaperbackBackupMangaInfoMapper? _instance;
  static PaperbackBackupMangaInfoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PaperbackBackupMangaInfoMapper._(),
      );
      PaperbackBackupMangaTagMapper.ensureInitialized();
      PaperbackBackupMangaAdditionalInfoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupMangaInfo';

  static List<PaperbackBackupMangaTag> _$tags(PaperbackBackupMangaInfo v) =>
      v.tags;
  static const Field<PaperbackBackupMangaInfo, List<PaperbackBackupMangaTag>>
  _f$tags = Field('tags', _$tags);
  static String _$desc(PaperbackBackupMangaInfo v) => v.desc;
  static const Field<PaperbackBackupMangaInfo, String> _f$desc = Field(
    'desc',
    _$desc,
  );
  static List<String> _$titles(PaperbackBackupMangaInfo v) => v.titles;
  static const Field<PaperbackBackupMangaInfo, List<String>> _f$titles = Field(
    'titles',
    _$titles,
  );
  static List<String> _$covers(PaperbackBackupMangaInfo v) => v.covers;
  static const Field<PaperbackBackupMangaInfo, List<String>> _f$covers = Field(
    'covers',
    _$covers,
  );
  static String _$author(PaperbackBackupMangaInfo v) => v.author;
  static const Field<PaperbackBackupMangaInfo, String> _f$author = Field(
    'author',
    _$author,
  );
  static String _$image(PaperbackBackupMangaInfo v) => v.image;
  static const Field<PaperbackBackupMangaInfo, String> _f$image = Field(
    'image',
    _$image,
  );
  static bool _$hentai(PaperbackBackupMangaInfo v) => v.hentai;
  static const Field<PaperbackBackupMangaInfo, bool> _f$hentai = Field(
    'hentai',
    _$hentai,
  );
  static PaperbackBackupMangaAdditionalInfo _$additionalInfo(
    PaperbackBackupMangaInfo v,
  ) => v.additionalInfo;
  static const Field<
    PaperbackBackupMangaInfo,
    PaperbackBackupMangaAdditionalInfo
  >
  _f$additionalInfo = Field('additionalInfo', _$additionalInfo);
  static String _$artist(PaperbackBackupMangaInfo v) => v.artist;
  static const Field<PaperbackBackupMangaInfo, String> _f$artist = Field(
    'artist',
    _$artist,
  );
  static String _$id(PaperbackBackupMangaInfo v) => v.id;
  static const Field<PaperbackBackupMangaInfo, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$status(PaperbackBackupMangaInfo v) => v.status;
  static const Field<PaperbackBackupMangaInfo, String> _f$status = Field(
    'status',
    _$status,
  );
  static String? _$rating(PaperbackBackupMangaInfo v) => v.rating;
  static const Field<PaperbackBackupMangaInfo, String> _f$rating = Field(
    'rating',
    _$rating,
    opt: true,
  );
  static String? _$banner(PaperbackBackupMangaInfo v) => v.banner;
  static const Field<PaperbackBackupMangaInfo, String> _f$banner = Field(
    'banner',
    _$banner,
    opt: true,
  );

  @override
  final MappableFields<PaperbackBackupMangaInfo> fields = const {
    #tags: _f$tags,
    #desc: _f$desc,
    #titles: _f$titles,
    #covers: _f$covers,
    #author: _f$author,
    #image: _f$image,
    #hentai: _f$hentai,
    #additionalInfo: _f$additionalInfo,
    #artist: _f$artist,
    #id: _f$id,
    #status: _f$status,
    #rating: _f$rating,
    #banner: _f$banner,
  };

  static PaperbackBackupMangaInfo _instantiate(DecodingData data) {
    return PaperbackBackupMangaInfo(
      tags: data.dec(_f$tags),
      desc: data.dec(_f$desc),
      titles: data.dec(_f$titles),
      covers: data.dec(_f$covers),
      author: data.dec(_f$author),
      image: data.dec(_f$image),
      hentai: data.dec(_f$hentai),
      additionalInfo: data.dec(_f$additionalInfo),
      artist: data.dec(_f$artist),
      id: data.dec(_f$id),
      status: data.dec(_f$status),
      rating: data.dec(_f$rating),
      banner: data.dec(_f$banner),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupMangaInfo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupMangaInfo>(map);
  }

  static PaperbackBackupMangaInfo fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupMangaInfo>(json);
  }
}

mixin PaperbackBackupMangaInfoMappable {
  String toJson() {
    return PaperbackBackupMangaInfoMapper.ensureInitialized()
        .encodeJson<PaperbackBackupMangaInfo>(this as PaperbackBackupMangaInfo);
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupMangaInfoMapper.ensureInitialized()
        .encodeMap<PaperbackBackupMangaInfo>(this as PaperbackBackupMangaInfo);
  }

  PaperbackBackupMangaInfoCopyWith<
    PaperbackBackupMangaInfo,
    PaperbackBackupMangaInfo,
    PaperbackBackupMangaInfo
  >
  get copyWith => _PaperbackBackupMangaInfoCopyWithImpl(
    this as PaperbackBackupMangaInfo,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PaperbackBackupMangaInfoMapper.ensureInitialized().stringifyValue(
      this as PaperbackBackupMangaInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupMangaInfoMapper.ensureInitialized().equalsValue(
      this as PaperbackBackupMangaInfo,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackBackupMangaInfoMapper.ensureInitialized().hashValue(
      this as PaperbackBackupMangaInfo,
    );
  }
}

extension PaperbackBackupMangaInfoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaperbackBackupMangaInfo, $Out> {
  PaperbackBackupMangaInfoCopyWith<$R, PaperbackBackupMangaInfo, $Out>
  get $asPaperbackBackupMangaInfo =>
      $base.as((v, t, t2) => _PaperbackBackupMangaInfoCopyWithImpl(v, t, t2));
}

abstract class PaperbackBackupMangaInfoCopyWith<
  $R,
  $In extends PaperbackBackupMangaInfo,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    PaperbackBackupMangaTag,
    PaperbackBackupMangaTagCopyWith<
      $R,
      PaperbackBackupMangaTag,
      PaperbackBackupMangaTag
    >
  >
  get tags;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get titles;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get covers;
  PaperbackBackupMangaAdditionalInfoCopyWith<
    $R,
    PaperbackBackupMangaAdditionalInfo,
    PaperbackBackupMangaAdditionalInfo
  >
  get additionalInfo;
  $R call({
    List<PaperbackBackupMangaTag>? tags,
    String? desc,
    List<String>? titles,
    List<String>? covers,
    String? author,
    String? image,
    bool? hentai,
    PaperbackBackupMangaAdditionalInfo? additionalInfo,
    String? artist,
    String? id,
    String? status,
    String? rating,
    String? banner,
  });
  PaperbackBackupMangaInfoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaperbackBackupMangaInfoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackupMangaInfo, $Out>
    implements
        PaperbackBackupMangaInfoCopyWith<$R, PaperbackBackupMangaInfo, $Out> {
  _PaperbackBackupMangaInfoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaperbackBackupMangaInfo> $mapper =
      PaperbackBackupMangaInfoMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    PaperbackBackupMangaTag,
    PaperbackBackupMangaTagCopyWith<
      $R,
      PaperbackBackupMangaTag,
      PaperbackBackupMangaTag
    >
  >
  get tags => ListCopyWith(
    $value.tags,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(tags: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get titles =>
      ListCopyWith(
        $value.titles,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(titles: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get covers =>
      ListCopyWith(
        $value.covers,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(covers: v),
      );
  @override
  PaperbackBackupMangaAdditionalInfoCopyWith<
    $R,
    PaperbackBackupMangaAdditionalInfo,
    PaperbackBackupMangaAdditionalInfo
  >
  get additionalInfo =>
      $value.additionalInfo.copyWith.$chain((v) => call(additionalInfo: v));
  @override
  $R call({
    List<PaperbackBackupMangaTag>? tags,
    String? desc,
    List<String>? titles,
    List<String>? covers,
    String? author,
    String? image,
    bool? hentai,
    PaperbackBackupMangaAdditionalInfo? additionalInfo,
    String? artist,
    String? id,
    String? status,
    Object? rating = $none,
    Object? banner = $none,
  }) => $apply(
    FieldCopyWithData({
      if (tags != null) #tags: tags,
      if (desc != null) #desc: desc,
      if (titles != null) #titles: titles,
      if (covers != null) #covers: covers,
      if (author != null) #author: author,
      if (image != null) #image: image,
      if (hentai != null) #hentai: hentai,
      if (additionalInfo != null) #additionalInfo: additionalInfo,
      if (artist != null) #artist: artist,
      if (id != null) #id: id,
      if (status != null) #status: status,
      if (rating != $none) #rating: rating,
      if (banner != $none) #banner: banner,
    }),
  );
  @override
  PaperbackBackupMangaInfo $make(CopyWithData data) => PaperbackBackupMangaInfo(
    tags: data.get(#tags, or: $value.tags),
    desc: data.get(#desc, or: $value.desc),
    titles: data.get(#titles, or: $value.titles),
    covers: data.get(#covers, or: $value.covers),
    author: data.get(#author, or: $value.author),
    image: data.get(#image, or: $value.image),
    hentai: data.get(#hentai, or: $value.hentai),
    additionalInfo: data.get(#additionalInfo, or: $value.additionalInfo),
    artist: data.get(#artist, or: $value.artist),
    id: data.get(#id, or: $value.id),
    status: data.get(#status, or: $value.status),
    rating: data.get(#rating, or: $value.rating),
    banner: data.get(#banner, or: $value.banner),
  );

  @override
  PaperbackBackupMangaInfoCopyWith<$R2, PaperbackBackupMangaInfo, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaperbackBackupMangaInfoCopyWithImpl($value, $cast, t);
}

class PaperbackBackupMangaTagMapper
    extends ClassMapperBase<PaperbackBackupMangaTag> {
  PaperbackBackupMangaTagMapper._();

  static PaperbackBackupMangaTagMapper? _instance;
  static PaperbackBackupMangaTagMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PaperbackBackupMangaTagMapper._(),
      );
      PaperbackBackupMangaTagMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupMangaTag';

  static String _$id(PaperbackBackupMangaTag v) => v.id;
  static const Field<PaperbackBackupMangaTag, String> _f$id = Field('id', _$id);
  static String _$label(PaperbackBackupMangaTag v) => v.label;
  static const Field<PaperbackBackupMangaTag, String> _f$label = Field(
    'label',
    _$label,
  );
  static List<PaperbackBackupMangaTag> _$tags(PaperbackBackupMangaTag v) =>
      v.tags;
  static const Field<PaperbackBackupMangaTag, List<PaperbackBackupMangaTag>>
  _f$tags = Field('tags', _$tags, opt: true, def: const []);

  @override
  final MappableFields<PaperbackBackupMangaTag> fields = const {
    #id: _f$id,
    #label: _f$label,
    #tags: _f$tags,
  };

  static PaperbackBackupMangaTag _instantiate(DecodingData data) {
    return PaperbackBackupMangaTag(
      id: data.dec(_f$id),
      label: data.dec(_f$label),
      tags: data.dec(_f$tags),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupMangaTag fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupMangaTag>(map);
  }

  static PaperbackBackupMangaTag fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupMangaTag>(json);
  }
}

mixin PaperbackBackupMangaTagMappable {
  String toJson() {
    return PaperbackBackupMangaTagMapper.ensureInitialized()
        .encodeJson<PaperbackBackupMangaTag>(this as PaperbackBackupMangaTag);
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupMangaTagMapper.ensureInitialized()
        .encodeMap<PaperbackBackupMangaTag>(this as PaperbackBackupMangaTag);
  }

  PaperbackBackupMangaTagCopyWith<
    PaperbackBackupMangaTag,
    PaperbackBackupMangaTag,
    PaperbackBackupMangaTag
  >
  get copyWith => _PaperbackBackupMangaTagCopyWithImpl(
    this as PaperbackBackupMangaTag,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PaperbackBackupMangaTagMapper.ensureInitialized().stringifyValue(
      this as PaperbackBackupMangaTag,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupMangaTagMapper.ensureInitialized().equalsValue(
      this as PaperbackBackupMangaTag,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackBackupMangaTagMapper.ensureInitialized().hashValue(
      this as PaperbackBackupMangaTag,
    );
  }
}

extension PaperbackBackupMangaTagValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaperbackBackupMangaTag, $Out> {
  PaperbackBackupMangaTagCopyWith<$R, PaperbackBackupMangaTag, $Out>
  get $asPaperbackBackupMangaTag =>
      $base.as((v, t, t2) => _PaperbackBackupMangaTagCopyWithImpl(v, t, t2));
}

abstract class PaperbackBackupMangaTagCopyWith<
  $R,
  $In extends PaperbackBackupMangaTag,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    PaperbackBackupMangaTag,
    PaperbackBackupMangaTagCopyWith<
      $R,
      PaperbackBackupMangaTag,
      PaperbackBackupMangaTag
    >
  >
  get tags;
  $R call({String? id, String? label, List<PaperbackBackupMangaTag>? tags});
  PaperbackBackupMangaTagCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaperbackBackupMangaTagCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackupMangaTag, $Out>
    implements
        PaperbackBackupMangaTagCopyWith<$R, PaperbackBackupMangaTag, $Out> {
  _PaperbackBackupMangaTagCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaperbackBackupMangaTag> $mapper =
      PaperbackBackupMangaTagMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    PaperbackBackupMangaTag,
    PaperbackBackupMangaTagCopyWith<
      $R,
      PaperbackBackupMangaTag,
      PaperbackBackupMangaTag
    >
  >
  get tags => ListCopyWith(
    $value.tags,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(tags: v),
  );
  @override
  $R call({String? id, String? label, List<PaperbackBackupMangaTag>? tags}) =>
      $apply(
        FieldCopyWithData({
          if (id != null) #id: id,
          if (label != null) #label: label,
          if (tags != null) #tags: tags,
        }),
      );
  @override
  PaperbackBackupMangaTag $make(CopyWithData data) => PaperbackBackupMangaTag(
    id: data.get(#id, or: $value.id),
    label: data.get(#label, or: $value.label),
    tags: data.get(#tags, or: $value.tags),
  );

  @override
  PaperbackBackupMangaTagCopyWith<$R2, PaperbackBackupMangaTag, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaperbackBackupMangaTagCopyWithImpl($value, $cast, t);
}

class PaperbackBackupMangaAdditionalInfoMapper
    extends ClassMapperBase<PaperbackBackupMangaAdditionalInfo> {
  PaperbackBackupMangaAdditionalInfoMapper._();

  static PaperbackBackupMangaAdditionalInfoMapper? _instance;
  static PaperbackBackupMangaAdditionalInfoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PaperbackBackupMangaAdditionalInfoMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupMangaAdditionalInfo';

  static String? _$langFlag(PaperbackBackupMangaAdditionalInfo v) => v.langFlag;
  static const Field<PaperbackBackupMangaAdditionalInfo, String> _f$langFlag =
      Field('langFlag', _$langFlag, opt: true);
  static String? _$avgRating(PaperbackBackupMangaAdditionalInfo v) =>
      v.avgRating;
  static const Field<PaperbackBackupMangaAdditionalInfo, String> _f$avgRating =
      Field('avgRating', _$avgRating, opt: true);
  static String? _$views(PaperbackBackupMangaAdditionalInfo v) => v.views;
  static const Field<PaperbackBackupMangaAdditionalInfo, String> _f$views =
      Field('views', _$views, opt: true);
  static String? _$follows(PaperbackBackupMangaAdditionalInfo v) => v.follows;
  static const Field<PaperbackBackupMangaAdditionalInfo, String> _f$follows =
      Field('follows', _$follows, opt: true);
  static String? _$users(PaperbackBackupMangaAdditionalInfo v) => v.users;
  static const Field<PaperbackBackupMangaAdditionalInfo, String> _f$users =
      Field('users', _$users, opt: true);
  static String? _$langName(PaperbackBackupMangaAdditionalInfo v) => v.langName;
  static const Field<PaperbackBackupMangaAdditionalInfo, String> _f$langName =
      Field('langName', _$langName, opt: true);

  @override
  final MappableFields<PaperbackBackupMangaAdditionalInfo> fields = const {
    #langFlag: _f$langFlag,
    #avgRating: _f$avgRating,
    #views: _f$views,
    #follows: _f$follows,
    #users: _f$users,
    #langName: _f$langName,
  };

  static PaperbackBackupMangaAdditionalInfo _instantiate(DecodingData data) {
    return PaperbackBackupMangaAdditionalInfo(
      langFlag: data.dec(_f$langFlag),
      avgRating: data.dec(_f$avgRating),
      views: data.dec(_f$views),
      follows: data.dec(_f$follows),
      users: data.dec(_f$users),
      langName: data.dec(_f$langName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupMangaAdditionalInfo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupMangaAdditionalInfo>(
      map,
    );
  }

  static PaperbackBackupMangaAdditionalInfo fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupMangaAdditionalInfo>(
      json,
    );
  }
}

mixin PaperbackBackupMangaAdditionalInfoMappable {
  String toJson() {
    return PaperbackBackupMangaAdditionalInfoMapper.ensureInitialized()
        .encodeJson<PaperbackBackupMangaAdditionalInfo>(
          this as PaperbackBackupMangaAdditionalInfo,
        );
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupMangaAdditionalInfoMapper.ensureInitialized()
        .encodeMap<PaperbackBackupMangaAdditionalInfo>(
          this as PaperbackBackupMangaAdditionalInfo,
        );
  }

  PaperbackBackupMangaAdditionalInfoCopyWith<
    PaperbackBackupMangaAdditionalInfo,
    PaperbackBackupMangaAdditionalInfo,
    PaperbackBackupMangaAdditionalInfo
  >
  get copyWith => _PaperbackBackupMangaAdditionalInfoCopyWithImpl(
    this as PaperbackBackupMangaAdditionalInfo,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PaperbackBackupMangaAdditionalInfoMapper.ensureInitialized()
        .stringifyValue(this as PaperbackBackupMangaAdditionalInfo);
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupMangaAdditionalInfoMapper.ensureInitialized()
        .equalsValue(this as PaperbackBackupMangaAdditionalInfo, other);
  }

  @override
  int get hashCode {
    return PaperbackBackupMangaAdditionalInfoMapper.ensureInitialized()
        .hashValue(this as PaperbackBackupMangaAdditionalInfo);
  }
}

extension PaperbackBackupMangaAdditionalInfoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaperbackBackupMangaAdditionalInfo, $Out> {
  PaperbackBackupMangaAdditionalInfoCopyWith<
    $R,
    PaperbackBackupMangaAdditionalInfo,
    $Out
  >
  get $asPaperbackBackupMangaAdditionalInfo => $base.as(
    (v, t, t2) => _PaperbackBackupMangaAdditionalInfoCopyWithImpl(v, t, t2),
  );
}

abstract class PaperbackBackupMangaAdditionalInfoCopyWith<
  $R,
  $In extends PaperbackBackupMangaAdditionalInfo,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? langFlag,
    String? avgRating,
    String? views,
    String? follows,
    String? users,
    String? langName,
  });
  PaperbackBackupMangaAdditionalInfoCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PaperbackBackupMangaAdditionalInfoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackupMangaAdditionalInfo, $Out>
    implements
        PaperbackBackupMangaAdditionalInfoCopyWith<
          $R,
          PaperbackBackupMangaAdditionalInfo,
          $Out
        > {
  _PaperbackBackupMangaAdditionalInfoCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PaperbackBackupMangaAdditionalInfo> $mapper =
      PaperbackBackupMangaAdditionalInfoMapper.ensureInitialized();
  @override
  $R call({
    Object? langFlag = $none,
    Object? avgRating = $none,
    Object? views = $none,
    Object? follows = $none,
    Object? users = $none,
    Object? langName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (langFlag != $none) #langFlag: langFlag,
      if (avgRating != $none) #avgRating: avgRating,
      if (views != $none) #views: views,
      if (follows != $none) #follows: follows,
      if (users != $none) #users: users,
      if (langName != $none) #langName: langName,
    }),
  );
  @override
  PaperbackBackupMangaAdditionalInfo $make(CopyWithData data) =>
      PaperbackBackupMangaAdditionalInfo(
        langFlag: data.get(#langFlag, or: $value.langFlag),
        avgRating: data.get(#avgRating, or: $value.avgRating),
        views: data.get(#views, or: $value.views),
        follows: data.get(#follows, or: $value.follows),
        users: data.get(#users, or: $value.users),
        langName: data.get(#langName, or: $value.langName),
      );

  @override
  PaperbackBackupMangaAdditionalInfoCopyWith<
    $R2,
    PaperbackBackupMangaAdditionalInfo,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaperbackBackupMangaAdditionalInfoCopyWithImpl($value, $cast, t);
}

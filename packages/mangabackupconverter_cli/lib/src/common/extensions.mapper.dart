// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'extensions.dart';

class ExtensionTypeMapper extends EnumMapper<ExtensionType> {
  ExtensionTypeMapper._();

  static ExtensionTypeMapper? _instance;
  static ExtensionTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExtensionTypeMapper._());
    }
    return _instance!;
  }

  static ExtensionType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ExtensionType decode(dynamic value) {
    switch (value) {
      case r'aidoku':
        return ExtensionType.aidoku;
      case r'paperback':
        return ExtensionType.paperback;
      case r'tachi':
        return ExtensionType.tachi;
      case r'mangayomi':
        return ExtensionType.mangayomi;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ExtensionType self) {
    switch (self) {
      case ExtensionType.aidoku:
        return r'aidoku';
      case ExtensionType.paperback:
        return r'paperback';
      case ExtensionType.tachi:
        return r'tachi';
      case ExtensionType.mangayomi:
        return r'mangayomi';
    }
  }
}

extension ExtensionTypeMapperExtension on ExtensionType {
  String toValue() {
    ExtensionTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ExtensionType>(this) as String;
  }
}

class ExtensionRepoIndexMapper extends ClassMapperBase<ExtensionRepoIndex> {
  ExtensionRepoIndexMapper._();

  static ExtensionRepoIndexMapper? _instance;
  static ExtensionRepoIndexMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExtensionRepoIndexMapper._());
      ExtensionTypeMapper.ensureInitialized();
      ExtensionRepoMapper.ensureInitialized();
      SiteIndexMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ExtensionRepoIndex';

  static Map<ExtensionType, List<ExtensionRepo>> _$repos(
    ExtensionRepoIndex v,
  ) => v.repos;
  static const Field<
    ExtensionRepoIndex,
    Map<ExtensionType, List<ExtensionRepo>>
  >
  _f$repos = Field('repos', _$repos);
  static List<SiteIndex> _$sites(ExtensionRepoIndex v) => v.sites;
  static const Field<ExtensionRepoIndex, List<SiteIndex>> _f$sites = Field(
    'sites',
    _$sites,
  );

  @override
  final MappableFields<ExtensionRepoIndex> fields = const {
    #repos: _f$repos,
    #sites: _f$sites,
  };

  static ExtensionRepoIndex _instantiate(DecodingData data) {
    return ExtensionRepoIndex(
      repos: data.dec(_f$repos),
      sites: data.dec(_f$sites),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ExtensionRepoIndex fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExtensionRepoIndex>(map);
  }

  static ExtensionRepoIndex fromJson(String json) {
    return ensureInitialized().decodeJson<ExtensionRepoIndex>(json);
  }
}

mixin ExtensionRepoIndexMappable {
  String toJson() {
    return ExtensionRepoIndexMapper.ensureInitialized()
        .encodeJson<ExtensionRepoIndex>(this as ExtensionRepoIndex);
  }

  Map<String, dynamic> toMap() {
    return ExtensionRepoIndexMapper.ensureInitialized()
        .encodeMap<ExtensionRepoIndex>(this as ExtensionRepoIndex);
  }

  ExtensionRepoIndexCopyWith<
    ExtensionRepoIndex,
    ExtensionRepoIndex,
    ExtensionRepoIndex
  >
  get copyWith =>
      _ExtensionRepoIndexCopyWithImpl<ExtensionRepoIndex, ExtensionRepoIndex>(
        this as ExtensionRepoIndex,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ExtensionRepoIndexMapper.ensureInitialized().stringifyValue(
      this as ExtensionRepoIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExtensionRepoIndexMapper.ensureInitialized().equalsValue(
      this as ExtensionRepoIndex,
      other,
    );
  }

  @override
  int get hashCode {
    return ExtensionRepoIndexMapper.ensureInitialized().hashValue(
      this as ExtensionRepoIndex,
    );
  }
}

extension ExtensionRepoIndexValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExtensionRepoIndex, $Out> {
  ExtensionRepoIndexCopyWith<$R, ExtensionRepoIndex, $Out>
  get $asExtensionRepoIndex => $base.as(
    (v, t, t2) => _ExtensionRepoIndexCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ExtensionRepoIndexCopyWith<
  $R,
  $In extends ExtensionRepoIndex,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    ExtensionType,
    List<ExtensionRepo>,
    ObjectCopyWith<$R, List<ExtensionRepo>, List<ExtensionRepo>>
  >
  get repos;
  ListCopyWith<$R, SiteIndex, SiteIndexCopyWith<$R, SiteIndex, SiteIndex>>
  get sites;
  $R call({
    Map<ExtensionType, List<ExtensionRepo>>? repos,
    List<SiteIndex>? sites,
  });
  ExtensionRepoIndexCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ExtensionRepoIndexCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExtensionRepoIndex, $Out>
    implements ExtensionRepoIndexCopyWith<$R, ExtensionRepoIndex, $Out> {
  _ExtensionRepoIndexCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExtensionRepoIndex> $mapper =
      ExtensionRepoIndexMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    ExtensionType,
    List<ExtensionRepo>,
    ObjectCopyWith<$R, List<ExtensionRepo>, List<ExtensionRepo>>
  >
  get repos => MapCopyWith(
    $value.repos,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(repos: v),
  );
  @override
  ListCopyWith<$R, SiteIndex, SiteIndexCopyWith<$R, SiteIndex, SiteIndex>>
  get sites => ListCopyWith(
    $value.sites,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(sites: v),
  );
  @override
  $R call({
    Map<ExtensionType, List<ExtensionRepo>>? repos,
    List<SiteIndex>? sites,
  }) => $apply(
    FieldCopyWithData({
      if (repos != null) #repos: repos,
      if (sites != null) #sites: sites,
    }),
  );
  @override
  ExtensionRepoIndex $make(CopyWithData data) => ExtensionRepoIndex(
    repos: data.get(#repos, or: $value.repos),
    sites: data.get(#sites, or: $value.sites),
  );

  @override
  ExtensionRepoIndexCopyWith<$R2, ExtensionRepoIndex, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExtensionRepoIndexCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExtensionRepoMapper extends ClassMapperBase<ExtensionRepo> {
  ExtensionRepoMapper._();

  static ExtensionRepoMapper? _instance;
  static ExtensionRepoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExtensionRepoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ExtensionRepo';

  static String _$name(ExtensionRepo v) => v.name;
  static const Field<ExtensionRepo, String> _f$name = Field('name', _$name);
  static String _$url(ExtensionRepo v) => v.url;
  static const Field<ExtensionRepo, String> _f$url = Field('url', _$url);

  @override
  final MappableFields<ExtensionRepo> fields = const {
    #name: _f$name,
    #url: _f$url,
  };

  static ExtensionRepo _instantiate(DecodingData data) {
    return ExtensionRepo(name: data.dec(_f$name), url: data.dec(_f$url));
  }

  @override
  final Function instantiate = _instantiate;

  static ExtensionRepo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ExtensionRepo>(map);
  }

  static ExtensionRepo fromJson(String json) {
    return ensureInitialized().decodeJson<ExtensionRepo>(json);
  }
}

mixin ExtensionRepoMappable {
  String toJson() {
    return ExtensionRepoMapper.ensureInitialized().encodeJson<ExtensionRepo>(
      this as ExtensionRepo,
    );
  }

  Map<String, dynamic> toMap() {
    return ExtensionRepoMapper.ensureInitialized().encodeMap<ExtensionRepo>(
      this as ExtensionRepo,
    );
  }

  ExtensionRepoCopyWith<ExtensionRepo, ExtensionRepo, ExtensionRepo>
  get copyWith => _ExtensionRepoCopyWithImpl<ExtensionRepo, ExtensionRepo>(
    this as ExtensionRepo,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ExtensionRepoMapper.ensureInitialized().stringifyValue(
      this as ExtensionRepo,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExtensionRepoMapper.ensureInitialized().equalsValue(
      this as ExtensionRepo,
      other,
    );
  }

  @override
  int get hashCode {
    return ExtensionRepoMapper.ensureInitialized().hashValue(
      this as ExtensionRepo,
    );
  }
}

extension ExtensionRepoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ExtensionRepo, $Out> {
  ExtensionRepoCopyWith<$R, ExtensionRepo, $Out> get $asExtensionRepo =>
      $base.as((v, t, t2) => _ExtensionRepoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExtensionRepoCopyWith<$R, $In extends ExtensionRepo, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? url});
  ExtensionRepoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExtensionRepoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ExtensionRepo, $Out>
    implements ExtensionRepoCopyWith<$R, ExtensionRepo, $Out> {
  _ExtensionRepoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ExtensionRepo> $mapper =
      ExtensionRepoMapper.ensureInitialized();
  @override
  $R call({String? name, String? url}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (url != null) #url: url,
    }),
  );
  @override
  ExtensionRepo $make(CopyWithData data) => ExtensionRepo(
    name: data.get(#name, or: $value.name),
    url: data.get(#url, or: $value.url),
  );

  @override
  ExtensionRepoCopyWith<$R2, ExtensionRepo, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExtensionRepoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SiteIndexMapper extends ClassMapperBase<SiteIndex> {
  SiteIndexMapper._();

  static SiteIndexMapper? _instance;
  static SiteIndexMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SiteIndexMapper._());
      ExtensionTypeMapper.ensureInitialized();
      ExtensionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SiteIndex';

  static String _$name(SiteIndex v) => v.name;
  static const Field<SiteIndex, String> _f$name = Field('name', _$name);
  static Map<ExtensionType, List<Extension>> _$extensions(SiteIndex v) =>
      v.extensions;
  static const Field<SiteIndex, Map<ExtensionType, List<Extension>>>
  _f$extensions = Field('extensions', _$extensions);

  @override
  final MappableFields<SiteIndex> fields = const {
    #name: _f$name,
    #extensions: _f$extensions,
  };

  static SiteIndex _instantiate(DecodingData data) {
    return SiteIndex(
      name: data.dec(_f$name),
      extensions: data.dec(_f$extensions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SiteIndex fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SiteIndex>(map);
  }

  static SiteIndex fromJson(String json) {
    return ensureInitialized().decodeJson<SiteIndex>(json);
  }
}

mixin SiteIndexMappable {
  String toJson() {
    return SiteIndexMapper.ensureInitialized().encodeJson<SiteIndex>(
      this as SiteIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return SiteIndexMapper.ensureInitialized().encodeMap<SiteIndex>(
      this as SiteIndex,
    );
  }

  SiteIndexCopyWith<SiteIndex, SiteIndex, SiteIndex> get copyWith =>
      _SiteIndexCopyWithImpl<SiteIndex, SiteIndex>(
        this as SiteIndex,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SiteIndexMapper.ensureInitialized().stringifyValue(
      this as SiteIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    return SiteIndexMapper.ensureInitialized().equalsValue(
      this as SiteIndex,
      other,
    );
  }

  @override
  int get hashCode {
    return SiteIndexMapper.ensureInitialized().hashValue(this as SiteIndex);
  }
}

extension SiteIndexValueCopy<$R, $Out> on ObjectCopyWith<$R, SiteIndex, $Out> {
  SiteIndexCopyWith<$R, SiteIndex, $Out> get $asSiteIndex =>
      $base.as((v, t, t2) => _SiteIndexCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SiteIndexCopyWith<$R, $In extends SiteIndex, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    ExtensionType,
    List<Extension>,
    ObjectCopyWith<$R, List<Extension>, List<Extension>>
  >
  get extensions;
  $R call({String? name, Map<ExtensionType, List<Extension>>? extensions});
  SiteIndexCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SiteIndexCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SiteIndex, $Out>
    implements SiteIndexCopyWith<$R, SiteIndex, $Out> {
  _SiteIndexCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SiteIndex> $mapper =
      SiteIndexMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    ExtensionType,
    List<Extension>,
    ObjectCopyWith<$R, List<Extension>, List<Extension>>
  >
  get extensions => MapCopyWith(
    $value.extensions,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(extensions: v),
  );
  @override
  $R call({String? name, Map<ExtensionType, List<Extension>>? extensions}) =>
      $apply(
        FieldCopyWithData({
          if (name != null) #name: name,
          if (extensions != null) #extensions: extensions,
        }),
      );
  @override
  SiteIndex $make(CopyWithData data) => SiteIndex(
    name: data.get(#name, or: $value.name),
    extensions: data.get(#extensions, or: $value.extensions),
  );

  @override
  SiteIndexCopyWith<$R2, SiteIndex, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SiteIndexCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ExtensionMapper extends ClassMapperBase<Extension> {
  ExtensionMapper._();

  static ExtensionMapper? _instance;
  static ExtensionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExtensionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Extension';

  static String _$name(Extension v) => v.name;
  static const Field<Extension, String> _f$name = Field('name', _$name);
  static String _$id(Extension v) => v.id;
  static const Field<Extension, String> _f$id = Field('id', _$id);
  static String? _$repo(Extension v) => v.repo;
  static const Field<Extension, String> _f$repo = Field(
    'repo',
    _$repo,
    opt: true,
  );
  static String? _$lang(Extension v) => v.lang;
  static const Field<Extension, String> _f$lang = Field(
    'lang',
    _$lang,
    opt: true,
  );

  @override
  final MappableFields<Extension> fields = const {
    #name: _f$name,
    #id: _f$id,
    #repo: _f$repo,
    #lang: _f$lang,
  };

  static Extension _instantiate(DecodingData data) {
    return Extension(
      name: data.dec(_f$name),
      id: data.dec(_f$id),
      repo: data.dec(_f$repo),
      lang: data.dec(_f$lang),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Extension fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Extension>(map);
  }

  static Extension fromJson(String json) {
    return ensureInitialized().decodeJson<Extension>(json);
  }
}

mixin ExtensionMappable {
  String toJson() {
    return ExtensionMapper.ensureInitialized().encodeJson<Extension>(
      this as Extension,
    );
  }

  Map<String, dynamic> toMap() {
    return ExtensionMapper.ensureInitialized().encodeMap<Extension>(
      this as Extension,
    );
  }

  ExtensionCopyWith<Extension, Extension, Extension> get copyWith =>
      _ExtensionCopyWithImpl<Extension, Extension>(
        this as Extension,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ExtensionMapper.ensureInitialized().stringifyValue(
      this as Extension,
    );
  }

  @override
  bool operator ==(Object other) {
    return ExtensionMapper.ensureInitialized().equalsValue(
      this as Extension,
      other,
    );
  }

  @override
  int get hashCode {
    return ExtensionMapper.ensureInitialized().hashValue(this as Extension);
  }
}

extension ExtensionValueCopy<$R, $Out> on ObjectCopyWith<$R, Extension, $Out> {
  ExtensionCopyWith<$R, Extension, $Out> get $asExtension =>
      $base.as((v, t, t2) => _ExtensionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ExtensionCopyWith<$R, $In extends Extension, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? id, String? repo, String? lang});
  ExtensionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExtensionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Extension, $Out>
    implements ExtensionCopyWith<$R, Extension, $Out> {
  _ExtensionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Extension> $mapper =
      ExtensionMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    String? id,
    Object? repo = $none,
    Object? lang = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (id != null) #id: id,
      if (repo != $none) #repo: repo,
      if (lang != $none) #lang: lang,
    }),
  );
  @override
  Extension $make(CopyWithData data) => Extension(
    name: data.get(#name, or: $value.name),
    id: data.get(#id, or: $value.id),
    repo: data.get(#repo, or: $value.repo),
    lang: data.get(#lang, or: $value.lang),
  );

  @override
  ExtensionCopyWith<$R2, Extension, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ExtensionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


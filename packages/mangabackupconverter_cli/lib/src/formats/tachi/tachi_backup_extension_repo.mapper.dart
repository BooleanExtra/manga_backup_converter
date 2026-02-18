// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_extension_repo.dart';

class TachiBackupExtensionRepoMapper
    extends ClassMapperBase<TachiBackupExtensionRepo> {
  TachiBackupExtensionRepoMapper._();

  static TachiBackupExtensionRepoMapper? _instance;
  static TachiBackupExtensionRepoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = TachiBackupExtensionRepoMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupExtensionRepo';

  static String _$name(TachiBackupExtensionRepo v) => v.name;
  static const Field<TachiBackupExtensionRepo, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$baseUrl(TachiBackupExtensionRepo v) => v.baseUrl;
  static const Field<TachiBackupExtensionRepo, String> _f$baseUrl = Field(
    'baseUrl',
    _$baseUrl,
  );
  static String _$shortName(TachiBackupExtensionRepo v) => v.shortName;
  static const Field<TachiBackupExtensionRepo, String> _f$shortName = Field(
    'shortName',
    _$shortName,
  );
  static String _$website(TachiBackupExtensionRepo v) => v.website;
  static const Field<TachiBackupExtensionRepo, String> _f$website = Field(
    'website',
    _$website,
  );
  static String _$signingKeyFingerprint(TachiBackupExtensionRepo v) =>
      v.signingKeyFingerprint;
  static const Field<TachiBackupExtensionRepo, String>
  _f$signingKeyFingerprint = Field(
    'signingKeyFingerprint',
    _$signingKeyFingerprint,
  );

  @override
  final MappableFields<TachiBackupExtensionRepo> fields = const {
    #name: _f$name,
    #baseUrl: _f$baseUrl,
    #shortName: _f$shortName,
    #website: _f$website,
    #signingKeyFingerprint: _f$signingKeyFingerprint,
  };

  static TachiBackupExtensionRepo _instantiate(DecodingData data) {
    return TachiBackupExtensionRepo(
      name: data.dec(_f$name),
      baseUrl: data.dec(_f$baseUrl),
      shortName: data.dec(_f$shortName),
      website: data.dec(_f$website),
      signingKeyFingerprint: data.dec(_f$signingKeyFingerprint),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupExtensionRepo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupExtensionRepo>(map);
  }

  static TachiBackupExtensionRepo fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupExtensionRepo>(json);
  }
}

mixin TachiBackupExtensionRepoMappable {
  String toJson() {
    return TachiBackupExtensionRepoMapper.ensureInitialized()
        .encodeJson<TachiBackupExtensionRepo>(this as TachiBackupExtensionRepo);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupExtensionRepoMapper.ensureInitialized()
        .encodeMap<TachiBackupExtensionRepo>(this as TachiBackupExtensionRepo);
  }

  TachiBackupExtensionRepoCopyWith<
    TachiBackupExtensionRepo,
    TachiBackupExtensionRepo,
    TachiBackupExtensionRepo
  >
  get copyWith =>
      _TachiBackupExtensionRepoCopyWithImpl<
        TachiBackupExtensionRepo,
        TachiBackupExtensionRepo
      >(this as TachiBackupExtensionRepo, $identity, $identity);
  @override
  String toString() {
    return TachiBackupExtensionRepoMapper.ensureInitialized().stringifyValue(
      this as TachiBackupExtensionRepo,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupExtensionRepoMapper.ensureInitialized().equalsValue(
      this as TachiBackupExtensionRepo,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiBackupExtensionRepoMapper.ensureInitialized().hashValue(
      this as TachiBackupExtensionRepo,
    );
  }
}

extension TachiBackupExtensionRepoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupExtensionRepo, $Out> {
  TachiBackupExtensionRepoCopyWith<$R, TachiBackupExtensionRepo, $Out>
  get $asTachiBackupExtensionRepo => $base.as(
    (v, t, t2) => _TachiBackupExtensionRepoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TachiBackupExtensionRepoCopyWith<
  $R,
  $In extends TachiBackupExtensionRepo,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? name,
    String? baseUrl,
    String? shortName,
    String? website,
    String? signingKeyFingerprint,
  });
  TachiBackupExtensionRepoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachiBackupExtensionRepoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupExtensionRepo, $Out>
    implements
        TachiBackupExtensionRepoCopyWith<$R, TachiBackupExtensionRepo, $Out> {
  _TachiBackupExtensionRepoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupExtensionRepo> $mapper =
      TachiBackupExtensionRepoMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    String? baseUrl,
    String? shortName,
    String? website,
    String? signingKeyFingerprint,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (baseUrl != null) #baseUrl: baseUrl,
      if (shortName != null) #shortName: shortName,
      if (website != null) #website: website,
      if (signingKeyFingerprint != null)
        #signingKeyFingerprint: signingKeyFingerprint,
    }),
  );
  @override
  TachiBackupExtensionRepo $make(CopyWithData data) => TachiBackupExtensionRepo(
    name: data.get(#name, or: $value.name),
    baseUrl: data.get(#baseUrl, or: $value.baseUrl),
    shortName: data.get(#shortName, or: $value.shortName),
    website: data.get(#website, or: $value.website),
    signingKeyFingerprint: data.get(
      #signingKeyFingerprint,
      or: $value.signingKeyFingerprint,
    ),
  );

  @override
  TachiBackupExtensionRepoCopyWith<$R2, TachiBackupExtensionRepo, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TachiBackupExtensionRepoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


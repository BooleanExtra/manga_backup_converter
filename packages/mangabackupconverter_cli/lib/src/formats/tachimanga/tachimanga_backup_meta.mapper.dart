// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachimanga_backup_meta.dart';

class TachimangaBackupMetaMapper extends ClassMapperBase<TachimangaBackupMeta> {
  TachimangaBackupMetaMapper._();

  static TachimangaBackupMetaMapper? _instance;
  static TachimangaBackupMetaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaBackupMetaMapper._());
      MapperContainer.globals.useAll(<MapperBase<Object>>[
        SecondsEpochDateTimeMapper(),
      ]);
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupMeta';

  static String _$name(TachimangaBackupMeta v) => v.name;
  static const Field<TachimangaBackupMeta, String> _f$name = Field(
    'name',
    _$name,
  );
  static bool _$remoteBackup(TachimangaBackupMeta v) => v.remoteBackup;
  static const Field<TachimangaBackupMeta, bool> _f$remoteBackup = Field(
    'remoteBackup',
    _$remoteBackup,
  );
  static bool _$downloaded(TachimangaBackupMeta v) => v.downloaded;
  static const Field<TachimangaBackupMeta, bool> _f$downloaded = Field(
    'downloaded',
    _$downloaded,
  );
  static int _$backupId(TachimangaBackupMeta v) => v.backupId;
  static const Field<TachimangaBackupMeta, int> _f$backupId = Field(
    'backupId',
    _$backupId,
  );
  static int _$updateAt(TachimangaBackupMeta v) => v.updateAt;
  static const Field<TachimangaBackupMeta, int> _f$updateAt = Field(
    'updateAt',
    _$updateAt,
  );
  static int _$type(TachimangaBackupMeta v) => v.type;
  static const Field<TachimangaBackupMeta, int> _f$type = Field('type', _$type);
  static int _$size(TachimangaBackupMeta v) => v.size;
  static const Field<TachimangaBackupMeta, int> _f$size = Field('size', _$size);
  static String _$checksum(TachimangaBackupMeta v) => v.checksum;
  static const Field<TachimangaBackupMeta, String> _f$checksum = Field(
    'checksum',
    _$checksum,
  );
  static int _$createAt(TachimangaBackupMeta v) => v.createAt;
  static const Field<TachimangaBackupMeta, int> _f$createAt = Field(
    'createAt',
    _$createAt,
  );
  static bool _$cloudBackup(TachimangaBackupMeta v) => v.cloudBackup;
  static const Field<TachimangaBackupMeta, bool> _f$cloudBackup = Field(
    'cloudBackup',
    _$cloudBackup,
  );
  static int _$version(TachimangaBackupMeta v) => v.version;
  static const Field<TachimangaBackupMeta, int> _f$version = Field(
    'version',
    _$version,
  );
  static double _$downloadProgress(TachimangaBackupMeta v) =>
      v.downloadProgress;
  static const Field<TachimangaBackupMeta, double> _f$downloadProgress = Field(
    'downloadProgress',
    _$downloadProgress,
  );
  static int _$state(TachimangaBackupMeta v) => v.state;
  static const Field<TachimangaBackupMeta, int> _f$state = Field(
    'state',
    _$state,
  );
  static Object? _$extInfo(TachimangaBackupMeta v) => v.extInfo;
  static const Field<TachimangaBackupMeta, Object> _f$extInfo = Field(
    'extInfo',
    _$extInfo,
  );

  @override
  final MappableFields<TachimangaBackupMeta> fields = const {
    #name: _f$name,
    #remoteBackup: _f$remoteBackup,
    #downloaded: _f$downloaded,
    #backupId: _f$backupId,
    #updateAt: _f$updateAt,
    #type: _f$type,
    #size: _f$size,
    #checksum: _f$checksum,
    #createAt: _f$createAt,
    #cloudBackup: _f$cloudBackup,
    #version: _f$version,
    #downloadProgress: _f$downloadProgress,
    #state: _f$state,
    #extInfo: _f$extInfo,
  };

  static TachimangaBackupMeta _instantiate(DecodingData data) {
    return TachimangaBackupMeta(
      name: data.dec(_f$name),
      remoteBackup: data.dec(_f$remoteBackup),
      downloaded: data.dec(_f$downloaded),
      backupId: data.dec(_f$backupId),
      updateAt: data.dec(_f$updateAt),
      type: data.dec(_f$type),
      size: data.dec(_f$size),
      checksum: data.dec(_f$checksum),
      createAt: data.dec(_f$createAt),
      cloudBackup: data.dec(_f$cloudBackup),
      version: data.dec(_f$version),
      downloadProgress: data.dec(_f$downloadProgress),
      state: data.dec(_f$state),
      extInfo: data.dec(_f$extInfo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupMeta fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupMeta>(map);
  }

  static TachimangaBackupMeta fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupMeta>(json);
  }
}

mixin TachimangaBackupMetaMappable {
  String toJson() {
    return TachimangaBackupMetaMapper.ensureInitialized()
        .encodeJson<TachimangaBackupMeta>(this as TachimangaBackupMeta);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupMetaMapper.ensureInitialized()
        .encodeMap<TachimangaBackupMeta>(this as TachimangaBackupMeta);
  }

  TachimangaBackupMetaCopyWith<
    TachimangaBackupMeta,
    TachimangaBackupMeta,
    TachimangaBackupMeta
  >
  get copyWith =>
      _TachimangaBackupMetaCopyWithImpl<
        TachimangaBackupMeta,
        TachimangaBackupMeta
      >(this as TachimangaBackupMeta, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupMetaMapper.ensureInitialized().stringifyValue(
      this as TachimangaBackupMeta,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupMetaMapper.ensureInitialized().equalsValue(
      this as TachimangaBackupMeta,
      other,
    );
  }

  @override
  int get hashCode {
    return TachimangaBackupMetaMapper.ensureInitialized().hashValue(
      this as TachimangaBackupMeta,
    );
  }
}

extension TachimangaBackupMetaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupMeta, $Out> {
  TachimangaBackupMetaCopyWith<$R, TachimangaBackupMeta, $Out>
  get $asTachimangaBackupMeta => $base.as(
    (v, t, t2) => _TachimangaBackupMetaCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TachimangaBackupMetaCopyWith<
  $R,
  $In extends TachimangaBackupMeta,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? name,
    bool? remoteBackup,
    bool? downloaded,
    int? backupId,
    int? updateAt,
    int? type,
    int? size,
    String? checksum,
    int? createAt,
    bool? cloudBackup,
    int? version,
    double? downloadProgress,
    int? state,
    Object? extInfo,
  });
  TachimangaBackupMetaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachimangaBackupMetaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupMeta, $Out>
    implements TachimangaBackupMetaCopyWith<$R, TachimangaBackupMeta, $Out> {
  _TachimangaBackupMetaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupMeta> $mapper =
      TachimangaBackupMetaMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    bool? remoteBackup,
    bool? downloaded,
    int? backupId,
    int? updateAt,
    int? type,
    int? size,
    String? checksum,
    int? createAt,
    bool? cloudBackup,
    int? version,
    double? downloadProgress,
    int? state,
    Object? extInfo = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (remoteBackup != null) #remoteBackup: remoteBackup,
      if (downloaded != null) #downloaded: downloaded,
      if (backupId != null) #backupId: backupId,
      if (updateAt != null) #updateAt: updateAt,
      if (type != null) #type: type,
      if (size != null) #size: size,
      if (checksum != null) #checksum: checksum,
      if (createAt != null) #createAt: createAt,
      if (cloudBackup != null) #cloudBackup: cloudBackup,
      if (version != null) #version: version,
      if (downloadProgress != null) #downloadProgress: downloadProgress,
      if (state != null) #state: state,
      if (extInfo != $none) #extInfo: extInfo,
    }),
  );
  @override
  TachimangaBackupMeta $make(CopyWithData data) => TachimangaBackupMeta(
    name: data.get(#name, or: $value.name),
    remoteBackup: data.get(#remoteBackup, or: $value.remoteBackup),
    downloaded: data.get(#downloaded, or: $value.downloaded),
    backupId: data.get(#backupId, or: $value.backupId),
    updateAt: data.get(#updateAt, or: $value.updateAt),
    type: data.get(#type, or: $value.type),
    size: data.get(#size, or: $value.size),
    checksum: data.get(#checksum, or: $value.checksum),
    createAt: data.get(#createAt, or: $value.createAt),
    cloudBackup: data.get(#cloudBackup, or: $value.cloudBackup),
    version: data.get(#version, or: $value.version),
    downloadProgress: data.get(#downloadProgress, or: $value.downloadProgress),
    state: data.get(#state, or: $value.state),
    extInfo: data.get(#extInfo, or: $value.extInfo),
  );

  @override
  TachimangaBackupMetaCopyWith<$R2, TachimangaBackupMeta, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TachimangaBackupMetaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


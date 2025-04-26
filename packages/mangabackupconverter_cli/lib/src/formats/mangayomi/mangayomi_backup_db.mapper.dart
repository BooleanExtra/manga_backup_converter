// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mangayomi_backup_db.dart';

class MangayomiBackupDbMapper extends ClassMapperBase<MangayomiBackupDb> {
  MangayomiBackupDbMapper._();

  static MangayomiBackupDbMapper? _instance;
  static MangayomiBackupDbMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiBackupDbMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupDb';

  static String? _$version(MangayomiBackupDb v) => v.version;
  static const Field<MangayomiBackupDb, String> _f$version =
      Field('version', _$version, opt: true, def: '2');

  @override
  final MappableFields<MangayomiBackupDb> fields = const {
    #version: _f$version,
  };

  static MangayomiBackupDb _instantiate(DecodingData data) {
    return MangayomiBackupDb(version: data.dec(_f$version));
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

  MangayomiBackupDbCopyWith<MangayomiBackupDb, MangayomiBackupDb,
          MangayomiBackupDb>
      get copyWith => _MangayomiBackupDbCopyWithImpl(
          this as MangayomiBackupDb, $identity, $identity);
  @override
  String toString() {
    return MangayomiBackupDbMapper.ensureInitialized()
        .stringifyValue(this as MangayomiBackupDb);
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupDbMapper.ensureInitialized()
        .equalsValue(this as MangayomiBackupDb, other);
  }

  @override
  int get hashCode {
    return MangayomiBackupDbMapper.ensureInitialized()
        .hashValue(this as MangayomiBackupDb);
  }
}

extension MangayomiBackupDbValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupDb, $Out> {
  MangayomiBackupDbCopyWith<$R, MangayomiBackupDb, $Out>
      get $asMangayomiBackupDb =>
          $base.as((v, t, t2) => _MangayomiBackupDbCopyWithImpl(v, t, t2));
}

abstract class MangayomiBackupDbCopyWith<$R, $In extends MangayomiBackupDb,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? version});
  MangayomiBackupDbCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MangayomiBackupDbCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupDb, $Out>
    implements MangayomiBackupDbCopyWith<$R, MangayomiBackupDb, $Out> {
  _MangayomiBackupDbCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupDb> $mapper =
      MangayomiBackupDbMapper.ensureInitialized();
  @override
  $R call({Object? version = $none}) =>
      $apply(FieldCopyWithData({if (version != $none) #version: version}));
  @override
  MangayomiBackupDb $make(CopyWithData data) =>
      MangayomiBackupDb(version: data.get(#version, or: $value.version));

  @override
  MangayomiBackupDbCopyWith<$R2, MangayomiBackupDb, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MangayomiBackupDbCopyWithImpl($value, $cast, t);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mangayomi_backup.dart';

class MangayomiBackupMapper extends ClassMapperBase<MangayomiBackup> {
  MangayomiBackupMapper._();

  static MangayomiBackupMapper? _instance;
  static MangayomiBackupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiBackupMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      MangayomiBackupDbMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackup';

  static MangayomiBackupDb _$db(MangayomiBackup v) => v.db;
  static const Field<MangayomiBackup, MangayomiBackupDb> _f$db = Field(
    'db',
    _$db,
  );
  static String? _$name(MangayomiBackup v) => v.name;
  static const Field<MangayomiBackup, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );

  @override
  final MappableFields<MangayomiBackup> fields = const {
    #db: _f$db,
    #name: _f$name,
  };

  static MangayomiBackup _instantiate(DecodingData data) {
    return MangayomiBackup(db: data.dec(_f$db), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackup fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackup>(map);
  }

  static MangayomiBackup fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackup>(json);
  }
}

mixin MangayomiBackupMappable {
  String toJson() {
    return MangayomiBackupMapper.ensureInitialized()
        .encodeJson<MangayomiBackup>(this as MangayomiBackup);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupMapper.ensureInitialized().encodeMap<MangayomiBackup>(
      this as MangayomiBackup,
    );
  }

  MangayomiBackupCopyWith<MangayomiBackup, MangayomiBackup, MangayomiBackup>
  get copyWith =>
      _MangayomiBackupCopyWithImpl<MangayomiBackup, MangayomiBackup>(
        this as MangayomiBackup,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MangayomiBackupMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackup,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupMapper.ensureInitialized().equalsValue(
      this as MangayomiBackup,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupMapper.ensureInitialized().hashValue(
      this as MangayomiBackup,
    );
  }
}

extension MangayomiBackupValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackup, $Out> {
  MangayomiBackupCopyWith<$R, MangayomiBackup, $Out> get $asMangayomiBackup =>
      $base.as((v, t, t2) => _MangayomiBackupCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MangayomiBackupCopyWith<$R, $In extends MangayomiBackup, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MangayomiBackupDbCopyWith<$R, MangayomiBackupDb, MangayomiBackupDb> get db;
  $R call({MangayomiBackupDb? db, String? name});
  MangayomiBackupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackup, $Out>
    implements MangayomiBackupCopyWith<$R, MangayomiBackup, $Out> {
  _MangayomiBackupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackup> $mapper =
      MangayomiBackupMapper.ensureInitialized();
  @override
  MangayomiBackupDbCopyWith<$R, MangayomiBackupDb, MangayomiBackupDb> get db =>
      $value.db.copyWith.$chain((v) => call(db: v));
  @override
  $R call({MangayomiBackupDb? db, Object? name = $none}) => $apply(
    FieldCopyWithData({
      if (db != null) #db: db,
      if (name != $none) #name: name,
    }),
  );
  @override
  MangayomiBackup $make(CopyWithData data) => MangayomiBackup(
    db: data.get(#db, or: $value.db),
    name: data.get(#name, or: $value.name),
  );

  @override
  MangayomiBackupCopyWith<$R2, MangayomiBackup, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MangayomiBackupCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachimanga_backup.dart';

class TachimangaBackupMapper extends ClassMapperBase<TachimangaBackup> {
  TachimangaBackupMapper._();

  static TachimangaBackupMapper? _instance;
  static TachimangaBackupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaBackupMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      TachimangaBackupMetaMapper.ensureInitialized();
      TachimangaBackupDbMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackup';

  static TachimangaBackupMeta _$meta(TachimangaBackup v) => v.meta;
  static const Field<TachimangaBackup, TachimangaBackupMeta> _f$meta = Field(
    'meta',
    _$meta,
  );
  static TachimangaBackupDb _$db(TachimangaBackup v) => v.db;
  static const Field<TachimangaBackup, TachimangaBackupDb> _f$db = Field(
    'db',
    _$db,
  );
  static Map<String, Object?>? _$pref(TachimangaBackup v) => v.pref;
  static const Field<TachimangaBackup, Map<String, Object?>> _f$pref = Field(
    'pref',
    _$pref,
    opt: true,
  );
  static Pbxproj? _$prefAll(TachimangaBackup v) => v.prefAll;
  static const Field<TachimangaBackup, Pbxproj> _f$prefAll = Field(
    'prefAll',
    _$prefAll,
    opt: true,
  );
  static Map<String, Map<String, Object?>>? _$prefs(TachimangaBackup v) =>
      v.prefs;
  static const Field<TachimangaBackup, Map<String, Map<String, Object?>>>
  _f$prefs = Field('prefs', _$prefs, opt: true);
  static Map<String, Uint8List>? _$extensions(TachimangaBackup v) =>
      v.extensions;
  static const Field<TachimangaBackup, Map<String, Uint8List>> _f$extensions =
      Field('extensions', _$extensions, opt: true);
  static String? _$name(TachimangaBackup v) => v.name;
  static const Field<TachimangaBackup, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );

  @override
  final MappableFields<TachimangaBackup> fields = const {
    #meta: _f$meta,
    #db: _f$db,
    #pref: _f$pref,
    #prefAll: _f$prefAll,
    #prefs: _f$prefs,
    #extensions: _f$extensions,
    #name: _f$name,
  };

  static TachimangaBackup _instantiate(DecodingData data) {
    return TachimangaBackup(
      meta: data.dec(_f$meta),
      db: data.dec(_f$db),
      pref: data.dec(_f$pref),
      prefAll: data.dec(_f$prefAll),
      prefs: data.dec(_f$prefs),
      extensions: data.dec(_f$extensions),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackup fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackup>(map);
  }

  static TachimangaBackup fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackup>(json);
  }
}

mixin TachimangaBackupMappable {
  String toJson() {
    return TachimangaBackupMapper.ensureInitialized()
        .encodeJson<TachimangaBackup>(this as TachimangaBackup);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupMapper.ensureInitialized()
        .encodeMap<TachimangaBackup>(this as TachimangaBackup);
  }

  TachimangaBackupCopyWith<TachimangaBackup, TachimangaBackup, TachimangaBackup>
  get copyWith =>
      _TachimangaBackupCopyWithImpl<TachimangaBackup, TachimangaBackup>(
        this as TachimangaBackup,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TachimangaBackupMapper.ensureInitialized().stringifyValue(
      this as TachimangaBackup,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupMapper.ensureInitialized().equalsValue(
      this as TachimangaBackup,
      other,
    );
  }

  @override
  int get hashCode {
    return TachimangaBackupMapper.ensureInitialized().hashValue(
      this as TachimangaBackup,
    );
  }
}

extension TachimangaBackupValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackup, $Out> {
  TachimangaBackupCopyWith<$R, TachimangaBackup, $Out>
  get $asTachimangaBackup =>
      $base.as((v, t, t2) => _TachimangaBackupCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TachimangaBackupCopyWith<$R, $In extends TachimangaBackup, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  TachimangaBackupMetaCopyWith<$R, TachimangaBackupMeta, TachimangaBackupMeta>
  get meta;
  TachimangaBackupDbCopyWith<$R, TachimangaBackupDb, TachimangaBackupDb> get db;
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>?
  get pref;
  MapCopyWith<
    $R,
    String,
    Map<String, Object?>,
    ObjectCopyWith<$R, Map<String, Object?>, Map<String, Object?>>
  >?
  get prefs;
  MapCopyWith<$R, String, Uint8List, ObjectCopyWith<$R, Uint8List, Uint8List>>?
  get extensions;
  $R call({
    TachimangaBackupMeta? meta,
    TachimangaBackupDb? db,
    Map<String, Object?>? pref,
    Pbxproj? prefAll,
    Map<String, Map<String, Object?>>? prefs,
    Map<String, Uint8List>? extensions,
    String? name,
  });
  TachimangaBackupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachimangaBackupCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackup, $Out>
    implements TachimangaBackupCopyWith<$R, TachimangaBackup, $Out> {
  _TachimangaBackupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackup> $mapper =
      TachimangaBackupMapper.ensureInitialized();
  @override
  TachimangaBackupMetaCopyWith<$R, TachimangaBackupMeta, TachimangaBackupMeta>
  get meta => $value.meta.copyWith.$chain((v) => call(meta: v));
  @override
  TachimangaBackupDbCopyWith<$R, TachimangaBackupDb, TachimangaBackupDb>
  get db => $value.db.copyWith.$chain((v) => call(db: v));
  @override
  MapCopyWith<$R, String, Object?, ObjectCopyWith<$R, Object?, Object?>?>?
  get pref => $value.pref != null
      ? MapCopyWith(
          $value.pref!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(pref: v),
        )
      : null;
  @override
  MapCopyWith<
    $R,
    String,
    Map<String, Object?>,
    ObjectCopyWith<$R, Map<String, Object?>, Map<String, Object?>>
  >?
  get prefs => $value.prefs != null
      ? MapCopyWith(
          $value.prefs!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(prefs: v),
        )
      : null;
  @override
  MapCopyWith<$R, String, Uint8List, ObjectCopyWith<$R, Uint8List, Uint8List>>?
  get extensions => $value.extensions != null
      ? MapCopyWith(
          $value.extensions!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(extensions: v),
        )
      : null;
  @override
  $R call({
    TachimangaBackupMeta? meta,
    TachimangaBackupDb? db,
    Object? pref = $none,
    Object? prefAll = $none,
    Object? prefs = $none,
    Object? extensions = $none,
    Object? name = $none,
  }) => $apply(
    FieldCopyWithData({
      if (meta != null) #meta: meta,
      if (db != null) #db: db,
      if (pref != $none) #pref: pref,
      if (prefAll != $none) #prefAll: prefAll,
      if (prefs != $none) #prefs: prefs,
      if (extensions != $none) #extensions: extensions,
      if (name != $none) #name: name,
    }),
  );
  @override
  TachimangaBackup $make(CopyWithData data) => TachimangaBackup(
    meta: data.get(#meta, or: $value.meta),
    db: data.get(#db, or: $value.db),
    pref: data.get(#pref, or: $value.pref),
    prefAll: data.get(#prefAll, or: $value.prefAll),
    prefs: data.get(#prefs, or: $value.prefs),
    extensions: data.get(#extensions, or: $value.extensions),
    name: data.get(#name, or: $value.name),
  );

  @override
  TachimangaBackupCopyWith<$R2, TachimangaBackup, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachimangaBackupCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


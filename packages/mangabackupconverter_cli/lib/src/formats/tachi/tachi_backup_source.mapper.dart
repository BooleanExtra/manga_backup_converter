// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_source.dart';

class TachiBackupSourceMapper extends ClassMapperBase<TachiBackupSource> {
  TachiBackupSourceMapper._();

  static TachiBackupSourceMapper? _instance;
  static TachiBackupSourceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiBackupSourceMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupSource';

  static String _$name(TachiBackupSource v) => v.name;
  static const Field<TachiBackupSource, String> _f$name = Field('name', _$name);
  static int _$sourceId(TachiBackupSource v) => v.sourceId;
  static const Field<TachiBackupSource, int> _f$sourceId = Field(
    'sourceId',
    _$sourceId,
  );

  @override
  final MappableFields<TachiBackupSource> fields = const {
    #name: _f$name,
    #sourceId: _f$sourceId,
  };

  static TachiBackupSource _instantiate(DecodingData data) {
    return TachiBackupSource(
      name: data.dec(_f$name),
      sourceId: data.dec(_f$sourceId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupSource fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupSource>(map);
  }

  static TachiBackupSource fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupSource>(json);
  }
}

mixin TachiBackupSourceMappable {
  String toJson() {
    return TachiBackupSourceMapper.ensureInitialized()
        .encodeJson<TachiBackupSource>(this as TachiBackupSource);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupSourceMapper.ensureInitialized()
        .encodeMap<TachiBackupSource>(this as TachiBackupSource);
  }

  TachiBackupSourceCopyWith<
    TachiBackupSource,
    TachiBackupSource,
    TachiBackupSource
  >
  get copyWith =>
      _TachiBackupSourceCopyWithImpl<TachiBackupSource, TachiBackupSource>(
        this as TachiBackupSource,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TachiBackupSourceMapper.ensureInitialized().stringifyValue(
      this as TachiBackupSource,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupSourceMapper.ensureInitialized().equalsValue(
      this as TachiBackupSource,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiBackupSourceMapper.ensureInitialized().hashValue(
      this as TachiBackupSource,
    );
  }
}

extension TachiBackupSourceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupSource, $Out> {
  TachiBackupSourceCopyWith<$R, TachiBackupSource, $Out>
  get $asTachiBackupSource => $base.as(
    (v, t, t2) => _TachiBackupSourceCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TachiBackupSourceCopyWith<
  $R,
  $In extends TachiBackupSource,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, int? sourceId});
  TachiBackupSourceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachiBackupSourceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupSource, $Out>
    implements TachiBackupSourceCopyWith<$R, TachiBackupSource, $Out> {
  _TachiBackupSourceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupSource> $mapper =
      TachiBackupSourceMapper.ensureInitialized();
  @override
  $R call({String? name, int? sourceId}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (sourceId != null) #sourceId: sourceId,
    }),
  );
  @override
  TachiBackupSource $make(CopyWithData data) => TachiBackupSource(
    name: data.get(#name, or: $value.name),
    sourceId: data.get(#sourceId, or: $value.sourceId),
  );

  @override
  TachiBackupSourceCopyWith<$R2, TachiBackupSource, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachiBackupSourceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


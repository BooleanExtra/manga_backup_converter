// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_preference.dart';

class TachiBackupPreferenceMapper
    extends ClassMapperBase<TachiBackupPreference> {
  TachiBackupPreferenceMapper._();

  static TachiBackupPreferenceMapper? _instance;
  static TachiBackupPreferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiBackupPreferenceMapper._());
      TachiBackupPreferenceValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupPreference';

  static String _$key(TachiBackupPreference v) => v.key;
  static const Field<TachiBackupPreference, String> _f$key =
      Field('key', _$key);
  static TachiBackupPreferenceValue _$value(TachiBackupPreference v) => v.value;
  static const Field<TachiBackupPreference, TachiBackupPreferenceValue>
      _f$value = Field('value', _$value);

  @override
  final MappableFields<TachiBackupPreference> fields = const {
    #key: _f$key,
    #value: _f$value,
  };

  static TachiBackupPreference _instantiate(DecodingData data) {
    return TachiBackupPreference(
        key: data.dec(_f$key), value: data.dec(_f$value));
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupPreference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupPreference>(map);
  }

  static TachiBackupPreference fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupPreference>(json);
  }
}

mixin TachiBackupPreferenceMappable {
  String toJson() {
    return TachiBackupPreferenceMapper.ensureInitialized()
        .encodeJson<TachiBackupPreference>(this as TachiBackupPreference);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupPreferenceMapper.ensureInitialized()
        .encodeMap<TachiBackupPreference>(this as TachiBackupPreference);
  }

  TachiBackupPreferenceCopyWith<TachiBackupPreference, TachiBackupPreference,
          TachiBackupPreference>
      get copyWith => _TachiBackupPreferenceCopyWithImpl(
          this as TachiBackupPreference, $identity, $identity);
  @override
  String toString() {
    return TachiBackupPreferenceMapper.ensureInitialized()
        .stringifyValue(this as TachiBackupPreference);
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupPreferenceMapper.ensureInitialized()
        .equalsValue(this as TachiBackupPreference, other);
  }

  @override
  int get hashCode {
    return TachiBackupPreferenceMapper.ensureInitialized()
        .hashValue(this as TachiBackupPreference);
  }
}

extension TachiBackupPreferenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupPreference, $Out> {
  TachiBackupPreferenceCopyWith<$R, TachiBackupPreference, $Out>
      get $asTachiBackupPreference =>
          $base.as((v, t, t2) => _TachiBackupPreferenceCopyWithImpl(v, t, t2));
}

abstract class TachiBackupPreferenceCopyWith<
    $R,
    $In extends TachiBackupPreference,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  TachiBackupPreferenceValueCopyWith<$R, TachiBackupPreferenceValue,
      TachiBackupPreferenceValue> get value;
  $R call({String? key, TachiBackupPreferenceValue? value});
  TachiBackupPreferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachiBackupPreferenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupPreference, $Out>
    implements TachiBackupPreferenceCopyWith<$R, TachiBackupPreference, $Out> {
  _TachiBackupPreferenceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupPreference> $mapper =
      TachiBackupPreferenceMapper.ensureInitialized();
  @override
  TachiBackupPreferenceValueCopyWith<$R, TachiBackupPreferenceValue,
          TachiBackupPreferenceValue>
      get value => $value.value.copyWith.$chain((v) => call(value: v));
  @override
  $R call({String? key, TachiBackupPreferenceValue? value}) =>
      $apply(FieldCopyWithData(
          {if (key != null) #key: key, if (value != null) #value: value}));
  @override
  TachiBackupPreference $make(CopyWithData data) => TachiBackupPreference(
      key: data.get(#key, or: $value.key),
      value: data.get(#value, or: $value.value));

  @override
  TachiBackupPreferenceCopyWith<$R2, TachiBackupPreference, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachiBackupPreferenceCopyWithImpl($value, $cast, t);
}

class TachiBackupPreferenceValueMapper
    extends ClassMapperBase<TachiBackupPreferenceValue> {
  TachiBackupPreferenceValueMapper._();

  static TachiBackupPreferenceValueMapper? _instance;
  static TachiBackupPreferenceValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachiBackupPreferenceValueMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupPreferenceValue';

  static String _$type(TachiBackupPreferenceValue v) => v.type;
  static const Field<TachiBackupPreferenceValue, String> _f$type =
      Field('type', _$type);
  static List<int> _$truevalue(TachiBackupPreferenceValue v) => v.truevalue;
  static const Field<TachiBackupPreferenceValue, List<int>> _f$truevalue =
      Field('truevalue', _$truevalue);

  @override
  final MappableFields<TachiBackupPreferenceValue> fields = const {
    #type: _f$type,
    #truevalue: _f$truevalue,
  };

  static TachiBackupPreferenceValue _instantiate(DecodingData data) {
    return TachiBackupPreferenceValue(
        type: data.dec(_f$type), truevalue: data.dec(_f$truevalue));
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupPreferenceValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupPreferenceValue>(map);
  }

  static TachiBackupPreferenceValue fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupPreferenceValue>(json);
  }
}

mixin TachiBackupPreferenceValueMappable {
  String toJson() {
    return TachiBackupPreferenceValueMapper.ensureInitialized()
        .encodeJson<TachiBackupPreferenceValue>(
            this as TachiBackupPreferenceValue);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupPreferenceValueMapper.ensureInitialized()
        .encodeMap<TachiBackupPreferenceValue>(
            this as TachiBackupPreferenceValue);
  }

  TachiBackupPreferenceValueCopyWith<TachiBackupPreferenceValue,
          TachiBackupPreferenceValue, TachiBackupPreferenceValue>
      get copyWith => _TachiBackupPreferenceValueCopyWithImpl(
          this as TachiBackupPreferenceValue, $identity, $identity);
  @override
  String toString() {
    return TachiBackupPreferenceValueMapper.ensureInitialized()
        .stringifyValue(this as TachiBackupPreferenceValue);
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupPreferenceValueMapper.ensureInitialized()
        .equalsValue(this as TachiBackupPreferenceValue, other);
  }

  @override
  int get hashCode {
    return TachiBackupPreferenceValueMapper.ensureInitialized()
        .hashValue(this as TachiBackupPreferenceValue);
  }
}

extension TachiBackupPreferenceValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupPreferenceValue, $Out> {
  TachiBackupPreferenceValueCopyWith<$R, TachiBackupPreferenceValue, $Out>
      get $asTachiBackupPreferenceValue => $base
          .as((v, t, t2) => _TachiBackupPreferenceValueCopyWithImpl(v, t, t2));
}

abstract class TachiBackupPreferenceValueCopyWith<
    $R,
    $In extends TachiBackupPreferenceValue,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get truevalue;
  $R call({String? type, List<int>? truevalue});
  TachiBackupPreferenceValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachiBackupPreferenceValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupPreferenceValue, $Out>
    implements
        TachiBackupPreferenceValueCopyWith<$R, TachiBackupPreferenceValue,
            $Out> {
  _TachiBackupPreferenceValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupPreferenceValue> $mapper =
      TachiBackupPreferenceValueMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get truevalue =>
      ListCopyWith($value.truevalue, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(truevalue: v));
  @override
  $R call({String? type, List<int>? truevalue}) => $apply(FieldCopyWithData({
        if (type != null) #type: type,
        if (truevalue != null) #truevalue: truevalue
      }));
  @override
  TachiBackupPreferenceValue $make(CopyWithData data) =>
      TachiBackupPreferenceValue(
          type: data.get(#type, or: $value.type),
          truevalue: data.get(#truevalue, or: $value.truevalue));

  @override
  TachiBackupPreferenceValueCopyWith<$R2, TachiBackupPreferenceValue, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachiBackupPreferenceValueCopyWithImpl($value, $cast, t);
}

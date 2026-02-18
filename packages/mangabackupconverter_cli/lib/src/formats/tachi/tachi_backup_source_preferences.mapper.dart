// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_source_preferences.dart';

class TachiBackupSourcePreferencesMapper
    extends ClassMapperBase<TachiBackupSourcePreferences> {
  TachiBackupSourcePreferencesMapper._();

  static TachiBackupSourcePreferencesMapper? _instance;
  static TachiBackupSourcePreferencesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = TachiBackupSourcePreferencesMapper._(),
      );
      TachiBackupPreferenceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupSourcePreferences';

  static String _$sourceKey(TachiBackupSourcePreferences v) => v.sourceKey;
  static const Field<TachiBackupSourcePreferences, String> _f$sourceKey = Field(
    'sourceKey',
    _$sourceKey,
  );
  static List<TachiBackupPreference> _$prefs(TachiBackupSourcePreferences v) =>
      v.prefs;
  static const Field<TachiBackupSourcePreferences, List<TachiBackupPreference>>
  _f$prefs = Field('prefs', _$prefs);

  @override
  final MappableFields<TachiBackupSourcePreferences> fields = const {
    #sourceKey: _f$sourceKey,
    #prefs: _f$prefs,
  };

  static TachiBackupSourcePreferences _instantiate(DecodingData data) {
    return TachiBackupSourcePreferences(
      sourceKey: data.dec(_f$sourceKey),
      prefs: data.dec(_f$prefs),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupSourcePreferences fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupSourcePreferences>(map);
  }

  static TachiBackupSourcePreferences fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupSourcePreferences>(json);
  }
}

mixin TachiBackupSourcePreferencesMappable {
  String toJson() {
    return TachiBackupSourcePreferencesMapper.ensureInitialized()
        .encodeJson<TachiBackupSourcePreferences>(
          this as TachiBackupSourcePreferences,
        );
  }

  Map<String, dynamic> toMap() {
    return TachiBackupSourcePreferencesMapper.ensureInitialized()
        .encodeMap<TachiBackupSourcePreferences>(
          this as TachiBackupSourcePreferences,
        );
  }

  TachiBackupSourcePreferencesCopyWith<
    TachiBackupSourcePreferences,
    TachiBackupSourcePreferences,
    TachiBackupSourcePreferences
  >
  get copyWith =>
      _TachiBackupSourcePreferencesCopyWithImpl<
        TachiBackupSourcePreferences,
        TachiBackupSourcePreferences
      >(this as TachiBackupSourcePreferences, $identity, $identity);
  @override
  String toString() {
    return TachiBackupSourcePreferencesMapper.ensureInitialized()
        .stringifyValue(this as TachiBackupSourcePreferences);
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupSourcePreferencesMapper.ensureInitialized().equalsValue(
      this as TachiBackupSourcePreferences,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiBackupSourcePreferencesMapper.ensureInitialized().hashValue(
      this as TachiBackupSourcePreferences,
    );
  }
}

extension TachiBackupSourcePreferencesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupSourcePreferences, $Out> {
  TachiBackupSourcePreferencesCopyWith<$R, TachiBackupSourcePreferences, $Out>
  get $asTachiBackupSourcePreferences => $base.as(
    (v, t, t2) => _TachiBackupSourcePreferencesCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TachiBackupSourcePreferencesCopyWith<
  $R,
  $In extends TachiBackupSourcePreferences,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    TachiBackupPreference,
    TachiBackupPreferenceCopyWith<
      $R,
      TachiBackupPreference,
      TachiBackupPreference
    >
  >
  get prefs;
  $R call({String? sourceKey, List<TachiBackupPreference>? prefs});
  TachiBackupSourcePreferencesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachiBackupSourcePreferencesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupSourcePreferences, $Out>
    implements
        TachiBackupSourcePreferencesCopyWith<
          $R,
          TachiBackupSourcePreferences,
          $Out
        > {
  _TachiBackupSourcePreferencesCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<TachiBackupSourcePreferences> $mapper =
      TachiBackupSourcePreferencesMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    TachiBackupPreference,
    TachiBackupPreferenceCopyWith<
      $R,
      TachiBackupPreference,
      TachiBackupPreference
    >
  >
  get prefs => ListCopyWith(
    $value.prefs,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(prefs: v),
  );
  @override
  $R call({String? sourceKey, List<TachiBackupPreference>? prefs}) => $apply(
    FieldCopyWithData({
      if (sourceKey != null) #sourceKey: sourceKey,
      if (prefs != null) #prefs: prefs,
    }),
  );
  @override
  TachiBackupSourcePreferences $make(CopyWithData data) =>
      TachiBackupSourcePreferences(
        sourceKey: data.get(#sourceKey, or: $value.sourceKey),
        prefs: data.get(#prefs, or: $value.prefs),
      );

  @override
  TachiBackupSourcePreferencesCopyWith<$R2, TachiBackupSourcePreferences, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TachiBackupSourcePreferencesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


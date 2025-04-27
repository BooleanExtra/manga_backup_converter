// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_history.dart';

class TachiBackupHistoryMapper extends ClassMapperBase<TachiBackupHistory> {
  TachiBackupHistoryMapper._();

  static TachiBackupHistoryMapper? _instance;
  static TachiBackupHistoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiBackupHistoryMapper._());
      TachiBrokenBackupHistoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupHistory';

  static String _$url(TachiBackupHistory v) => v.url;
  static const Field<TachiBackupHistory, String> _f$url = Field('url', _$url);
  static int _$lastRead(TachiBackupHistory v) => v.lastRead;
  static const Field<TachiBackupHistory, int> _f$lastRead = Field(
    'lastRead',
    _$lastRead,
  );
  static int _$readDuration(TachiBackupHistory v) => v.readDuration;
  static const Field<TachiBackupHistory, int> _f$readDuration = Field(
    'readDuration',
    _$readDuration,
  );

  @override
  final MappableFields<TachiBackupHistory> fields = const {
    #url: _f$url,
    #lastRead: _f$lastRead,
    #readDuration: _f$readDuration,
  };

  static TachiBackupHistory _instantiate(DecodingData data) {
    return TachiBackupHistory(
      url: data.dec(_f$url),
      lastRead: data.dec(_f$lastRead),
      readDuration: data.dec(_f$readDuration),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupHistory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupHistory>(map);
  }

  static TachiBackupHistory fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupHistory>(json);
  }
}

mixin TachiBackupHistoryMappable {
  String toJson() {
    return TachiBackupHistoryMapper.ensureInitialized()
        .encodeJson<TachiBackupHistory>(this as TachiBackupHistory);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupHistoryMapper.ensureInitialized()
        .encodeMap<TachiBackupHistory>(this as TachiBackupHistory);
  }

  TachiBackupHistoryCopyWith<
    TachiBackupHistory,
    TachiBackupHistory,
    TachiBackupHistory
  >
  get copyWith => _TachiBackupHistoryCopyWithImpl(
    this as TachiBackupHistory,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return TachiBackupHistoryMapper.ensureInitialized().stringifyValue(
      this as TachiBackupHistory,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupHistoryMapper.ensureInitialized().equalsValue(
      this as TachiBackupHistory,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiBackupHistoryMapper.ensureInitialized().hashValue(
      this as TachiBackupHistory,
    );
  }
}

extension TachiBackupHistoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupHistory, $Out> {
  TachiBackupHistoryCopyWith<$R, TachiBackupHistory, $Out>
  get $asTachiBackupHistory =>
      $base.as((v, t, t2) => _TachiBackupHistoryCopyWithImpl(v, t, t2));
}

abstract class TachiBackupHistoryCopyWith<
  $R,
  $In extends TachiBackupHistory,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? url, int? lastRead, int? readDuration});
  TachiBackupHistoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachiBackupHistoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupHistory, $Out>
    implements TachiBackupHistoryCopyWith<$R, TachiBackupHistory, $Out> {
  _TachiBackupHistoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupHistory> $mapper =
      TachiBackupHistoryMapper.ensureInitialized();
  @override
  $R call({String? url, int? lastRead, int? readDuration}) => $apply(
    FieldCopyWithData({
      if (url != null) #url: url,
      if (lastRead != null) #lastRead: lastRead,
      if (readDuration != null) #readDuration: readDuration,
    }),
  );
  @override
  TachiBackupHistory $make(CopyWithData data) => TachiBackupHistory(
    url: data.get(#url, or: $value.url),
    lastRead: data.get(#lastRead, or: $value.lastRead),
    readDuration: data.get(#readDuration, or: $value.readDuration),
  );

  @override
  TachiBackupHistoryCopyWith<$R2, TachiBackupHistory, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachiBackupHistoryCopyWithImpl($value, $cast, t);
}

class TachiBrokenBackupHistoryMapper
    extends ClassMapperBase<TachiBrokenBackupHistory> {
  TachiBrokenBackupHistoryMapper._();

  static TachiBrokenBackupHistoryMapper? _instance;
  static TachiBrokenBackupHistoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = TachiBrokenBackupHistoryMapper._(),
      );
      TachiBackupHistoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBrokenBackupHistory';

  static String _$url(TachiBrokenBackupHistory v) => v.url;
  static const Field<TachiBrokenBackupHistory, String> _f$url = Field(
    'url',
    _$url,
  );
  static int _$lastRead(TachiBrokenBackupHistory v) => v.lastRead;
  static const Field<TachiBrokenBackupHistory, int> _f$lastRead = Field(
    'lastRead',
    _$lastRead,
  );
  static int _$readDuration(TachiBrokenBackupHistory v) => v.readDuration;
  static const Field<TachiBrokenBackupHistory, int> _f$readDuration = Field(
    'readDuration',
    _$readDuration,
  );

  @override
  final MappableFields<TachiBrokenBackupHistory> fields = const {
    #url: _f$url,
    #lastRead: _f$lastRead,
    #readDuration: _f$readDuration,
  };

  static TachiBrokenBackupHistory _instantiate(DecodingData data) {
    return TachiBrokenBackupHistory(
      url: data.dec(_f$url),
      lastRead: data.dec(_f$lastRead),
      readDuration: data.dec(_f$readDuration),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBrokenBackupHistory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBrokenBackupHistory>(map);
  }

  static TachiBrokenBackupHistory fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBrokenBackupHistory>(json);
  }
}

mixin TachiBrokenBackupHistoryMappable {
  String toJson() {
    return TachiBrokenBackupHistoryMapper.ensureInitialized()
        .encodeJson<TachiBrokenBackupHistory>(this as TachiBrokenBackupHistory);
  }

  Map<String, dynamic> toMap() {
    return TachiBrokenBackupHistoryMapper.ensureInitialized()
        .encodeMap<TachiBrokenBackupHistory>(this as TachiBrokenBackupHistory);
  }

  TachiBrokenBackupHistoryCopyWith<
    TachiBrokenBackupHistory,
    TachiBrokenBackupHistory,
    TachiBrokenBackupHistory
  >
  get copyWith => _TachiBrokenBackupHistoryCopyWithImpl(
    this as TachiBrokenBackupHistory,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return TachiBrokenBackupHistoryMapper.ensureInitialized().stringifyValue(
      this as TachiBrokenBackupHistory,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiBrokenBackupHistoryMapper.ensureInitialized().equalsValue(
      this as TachiBrokenBackupHistory,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiBrokenBackupHistoryMapper.ensureInitialized().hashValue(
      this as TachiBrokenBackupHistory,
    );
  }
}

extension TachiBrokenBackupHistoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBrokenBackupHistory, $Out> {
  TachiBrokenBackupHistoryCopyWith<$R, TachiBrokenBackupHistory, $Out>
  get $asTachiBrokenBackupHistory =>
      $base.as((v, t, t2) => _TachiBrokenBackupHistoryCopyWithImpl(v, t, t2));
}

abstract class TachiBrokenBackupHistoryCopyWith<
  $R,
  $In extends TachiBrokenBackupHistory,
  $Out
>
    implements TachiBackupHistoryCopyWith<$R, $In, $Out> {
  @override
  $R call({String? url, int? lastRead, int? readDuration});
  TachiBrokenBackupHistoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachiBrokenBackupHistoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBrokenBackupHistory, $Out>
    implements
        TachiBrokenBackupHistoryCopyWith<$R, TachiBrokenBackupHistory, $Out> {
  _TachiBrokenBackupHistoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBrokenBackupHistory> $mapper =
      TachiBrokenBackupHistoryMapper.ensureInitialized();
  @override
  $R call({String? url, int? lastRead, int? readDuration}) => $apply(
    FieldCopyWithData({
      if (url != null) #url: url,
      if (lastRead != null) #lastRead: lastRead,
      if (readDuration != null) #readDuration: readDuration,
    }),
  );
  @override
  TachiBrokenBackupHistory $make(CopyWithData data) => TachiBrokenBackupHistory(
    url: data.get(#url, or: $value.url),
    lastRead: data.get(#lastRead, or: $value.lastRead),
    readDuration: data.get(#readDuration, or: $value.readDuration),
  );

  @override
  TachiBrokenBackupHistoryCopyWith<$R2, TachiBrokenBackupHistory, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TachiBrokenBackupHistoryCopyWithImpl($value, $cast, t);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'aidoku_backup_history.dart';

class AidokuBackupHistoryMapper extends ClassMapperBase<AidokuBackupHistory> {
  AidokuBackupHistoryMapper._();

  static AidokuBackupHistoryMapper? _instance;
  static AidokuBackupHistoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuBackupHistoryMapper._());
      MapperContainer.globals.useAll([AidokuDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'AidokuBackupHistory';

  static DateTime _$dateRead(AidokuBackupHistory v) => v.dateRead;
  static const Field<AidokuBackupHistory, DateTime> _f$dateRead = Field('dateRead', _$dateRead);
  static String _$sourceId(AidokuBackupHistory v) => v.sourceId;
  static const Field<AidokuBackupHistory, String> _f$sourceId = Field('sourceId', _$sourceId);
  static String _$chapterId(AidokuBackupHistory v) => v.chapterId;
  static const Field<AidokuBackupHistory, String> _f$chapterId = Field('chapterId', _$chapterId);
  static String _$mangaId(AidokuBackupHistory v) => v.mangaId;
  static const Field<AidokuBackupHistory, String> _f$mangaId = Field('mangaId', _$mangaId);
  static int? _$progress(AidokuBackupHistory v) => v.progress;
  static const Field<AidokuBackupHistory, int> _f$progress = Field('progress', _$progress);
  static int? _$total(AidokuBackupHistory v) => v.total;
  static const Field<AidokuBackupHistory, int> _f$total = Field('total', _$total);
  static bool _$completed(AidokuBackupHistory v) => v.completed;
  static const Field<AidokuBackupHistory, bool> _f$completed = Field('completed', _$completed);

  @override
  final MappableFields<AidokuBackupHistory> fields = const {
    #dateRead: _f$dateRead,
    #sourceId: _f$sourceId,
    #chapterId: _f$chapterId,
    #mangaId: _f$mangaId,
    #progress: _f$progress,
    #total: _f$total,
    #completed: _f$completed,
  };
  @override
  final bool ignoreNull = true;

  static AidokuBackupHistory _instantiate(DecodingData data) {
    return AidokuBackupHistory(
      dateRead: data.dec(_f$dateRead),
      sourceId: data.dec(_f$sourceId),
      chapterId: data.dec(_f$chapterId),
      mangaId: data.dec(_f$mangaId),
      progress: data.dec(_f$progress),
      total: data.dec(_f$total),
      completed: data.dec(_f$completed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AidokuBackupHistory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AidokuBackupHistory>(map);
  }

  static AidokuBackupHistory fromJson(String json) {
    return ensureInitialized().decodeJson<AidokuBackupHistory>(json);
  }
}

mixin AidokuBackupHistoryMappable {
  String toJson() {
    return AidokuBackupHistoryMapper.ensureInitialized().encodeJson<AidokuBackupHistory>(this as AidokuBackupHistory);
  }

  Map<String, dynamic> toMap() {
    return AidokuBackupHistoryMapper.ensureInitialized().encodeMap<AidokuBackupHistory>(this as AidokuBackupHistory);
  }

  AidokuBackupHistoryCopyWith<AidokuBackupHistory, AidokuBackupHistory, AidokuBackupHistory> get copyWith =>
      _AidokuBackupHistoryCopyWithImpl(this as AidokuBackupHistory, $identity, $identity);
  @override
  String toString() {
    return AidokuBackupHistoryMapper.ensureInitialized().stringifyValue(this as AidokuBackupHistory);
  }

  @override
  bool operator ==(Object other) {
    return AidokuBackupHistoryMapper.ensureInitialized().equalsValue(this as AidokuBackupHistory, other);
  }

  @override
  int get hashCode {
    return AidokuBackupHistoryMapper.ensureInitialized().hashValue(this as AidokuBackupHistory);
  }
}

extension AidokuBackupHistoryValueCopy<$R, $Out> on ObjectCopyWith<$R, AidokuBackupHistory, $Out> {
  AidokuBackupHistoryCopyWith<$R, AidokuBackupHistory, $Out> get $asAidokuBackupHistory =>
      $base.as((v, t, t2) => _AidokuBackupHistoryCopyWithImpl(v, t, t2));
}

abstract class AidokuBackupHistoryCopyWith<$R, $In extends AidokuBackupHistory, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    DateTime? dateRead,
    String? sourceId,
    String? chapterId,
    String? mangaId,
    int? progress,
    int? total,
    bool? completed,
  });
  AidokuBackupHistoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AidokuBackupHistoryCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, AidokuBackupHistory, $Out>
    implements AidokuBackupHistoryCopyWith<$R, AidokuBackupHistory, $Out> {
  _AidokuBackupHistoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AidokuBackupHistory> $mapper = AidokuBackupHistoryMapper.ensureInitialized();
  @override
  $R call({
    DateTime? dateRead,
    String? sourceId,
    String? chapterId,
    String? mangaId,
    Object? progress = $none,
    Object? total = $none,
    bool? completed,
  }) => $apply(
    FieldCopyWithData({
      if (dateRead != null) #dateRead: dateRead,
      if (sourceId != null) #sourceId: sourceId,
      if (chapterId != null) #chapterId: chapterId,
      if (mangaId != null) #mangaId: mangaId,
      if (progress != $none) #progress: progress,
      if (total != $none) #total: total,
      if (completed != null) #completed: completed,
    }),
  );
  @override
  AidokuBackupHistory $make(CopyWithData data) => AidokuBackupHistory(
    dateRead: data.get(#dateRead, or: $value.dateRead),
    sourceId: data.get(#sourceId, or: $value.sourceId),
    chapterId: data.get(#chapterId, or: $value.chapterId),
    mangaId: data.get(#mangaId, or: $value.mangaId),
    progress: data.get(#progress, or: $value.progress),
    total: data.get(#total, or: $value.total),
    completed: data.get(#completed, or: $value.completed),
  );

  @override
  AidokuBackupHistoryCopyWith<$R2, AidokuBackupHistory, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AidokuBackupHistoryCopyWithImpl($value, $cast, t);
}

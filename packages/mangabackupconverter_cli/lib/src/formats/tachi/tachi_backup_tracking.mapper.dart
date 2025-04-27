// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_tracking.dart';

class TachiBackupTrackingMapper extends ClassMapperBase<TachiBackupTracking> {
  TachiBackupTrackingMapper._();

  static TachiBackupTrackingMapper? _instance;
  static TachiBackupTrackingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiBackupTrackingMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupTracking';

  static int _$syncId(TachiBackupTracking v) => v.syncId;
  static const Field<TachiBackupTracking, int> _f$syncId = Field(
    'syncId',
    _$syncId,
  );
  static int _$libraryId(TachiBackupTracking v) => v.libraryId;
  static const Field<TachiBackupTracking, int> _f$libraryId = Field(
    'libraryId',
    _$libraryId,
  );
  static int _$mediaIdInt(TachiBackupTracking v) => v.mediaIdInt;
  static const Field<TachiBackupTracking, int> _f$mediaIdInt = Field(
    'mediaIdInt',
    _$mediaIdInt,
  );
  static String _$trackingUrl(TachiBackupTracking v) => v.trackingUrl;
  static const Field<TachiBackupTracking, String> _f$trackingUrl = Field(
    'trackingUrl',
    _$trackingUrl,
  );
  static String _$title(TachiBackupTracking v) => v.title;
  static const Field<TachiBackupTracking, String> _f$title = Field(
    'title',
    _$title,
  );
  static double _$lastChapterRead(TachiBackupTracking v) => v.lastChapterRead;
  static const Field<TachiBackupTracking, double> _f$lastChapterRead = Field(
    'lastChapterRead',
    _$lastChapterRead,
  );
  static int _$totalChapters(TachiBackupTracking v) => v.totalChapters;
  static const Field<TachiBackupTracking, int> _f$totalChapters = Field(
    'totalChapters',
    _$totalChapters,
  );
  static double _$score(TachiBackupTracking v) => v.score;
  static const Field<TachiBackupTracking, double> _f$score = Field(
    'score',
    _$score,
  );
  static int _$status(TachiBackupTracking v) => v.status;
  static const Field<TachiBackupTracking, int> _f$status = Field(
    'status',
    _$status,
  );
  static int _$startedReadingDate(TachiBackupTracking v) =>
      v.startedReadingDate;
  static const Field<TachiBackupTracking, int> _f$startedReadingDate = Field(
    'startedReadingDate',
    _$startedReadingDate,
  );
  static int _$finishedReadingDate(TachiBackupTracking v) =>
      v.finishedReadingDate;
  static const Field<TachiBackupTracking, int> _f$finishedReadingDate = Field(
    'finishedReadingDate',
    _$finishedReadingDate,
  );
  static int _$mediaId(TachiBackupTracking v) => v.mediaId;
  static const Field<TachiBackupTracking, int> _f$mediaId = Field(
    'mediaId',
    _$mediaId,
  );

  @override
  final MappableFields<TachiBackupTracking> fields = const {
    #syncId: _f$syncId,
    #libraryId: _f$libraryId,
    #mediaIdInt: _f$mediaIdInt,
    #trackingUrl: _f$trackingUrl,
    #title: _f$title,
    #lastChapterRead: _f$lastChapterRead,
    #totalChapters: _f$totalChapters,
    #score: _f$score,
    #status: _f$status,
    #startedReadingDate: _f$startedReadingDate,
    #finishedReadingDate: _f$finishedReadingDate,
    #mediaId: _f$mediaId,
  };

  static TachiBackupTracking _instantiate(DecodingData data) {
    return TachiBackupTracking(
      syncId: data.dec(_f$syncId),
      libraryId: data.dec(_f$libraryId),
      mediaIdInt: data.dec(_f$mediaIdInt),
      trackingUrl: data.dec(_f$trackingUrl),
      title: data.dec(_f$title),
      lastChapterRead: data.dec(_f$lastChapterRead),
      totalChapters: data.dec(_f$totalChapters),
      score: data.dec(_f$score),
      status: data.dec(_f$status),
      startedReadingDate: data.dec(_f$startedReadingDate),
      finishedReadingDate: data.dec(_f$finishedReadingDate),
      mediaId: data.dec(_f$mediaId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupTracking fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupTracking>(map);
  }

  static TachiBackupTracking fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupTracking>(json);
  }
}

mixin TachiBackupTrackingMappable {
  String toJson() {
    return TachiBackupTrackingMapper.ensureInitialized()
        .encodeJson<TachiBackupTracking>(this as TachiBackupTracking);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupTrackingMapper.ensureInitialized()
        .encodeMap<TachiBackupTracking>(this as TachiBackupTracking);
  }

  TachiBackupTrackingCopyWith<
    TachiBackupTracking,
    TachiBackupTracking,
    TachiBackupTracking
  >
  get copyWith => _TachiBackupTrackingCopyWithImpl(
    this as TachiBackupTracking,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return TachiBackupTrackingMapper.ensureInitialized().stringifyValue(
      this as TachiBackupTracking,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupTrackingMapper.ensureInitialized().equalsValue(
      this as TachiBackupTracking,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiBackupTrackingMapper.ensureInitialized().hashValue(
      this as TachiBackupTracking,
    );
  }
}

extension TachiBackupTrackingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupTracking, $Out> {
  TachiBackupTrackingCopyWith<$R, TachiBackupTracking, $Out>
  get $asTachiBackupTracking =>
      $base.as((v, t, t2) => _TachiBackupTrackingCopyWithImpl(v, t, t2));
}

abstract class TachiBackupTrackingCopyWith<
  $R,
  $In extends TachiBackupTracking,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? syncId,
    int? libraryId,
    int? mediaIdInt,
    String? trackingUrl,
    String? title,
    double? lastChapterRead,
    int? totalChapters,
    double? score,
    int? status,
    int? startedReadingDate,
    int? finishedReadingDate,
    int? mediaId,
  });
  TachiBackupTrackingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachiBackupTrackingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupTracking, $Out>
    implements TachiBackupTrackingCopyWith<$R, TachiBackupTracking, $Out> {
  _TachiBackupTrackingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupTracking> $mapper =
      TachiBackupTrackingMapper.ensureInitialized();
  @override
  $R call({
    int? syncId,
    int? libraryId,
    int? mediaIdInt,
    String? trackingUrl,
    String? title,
    double? lastChapterRead,
    int? totalChapters,
    double? score,
    int? status,
    int? startedReadingDate,
    int? finishedReadingDate,
    int? mediaId,
  }) => $apply(
    FieldCopyWithData({
      if (syncId != null) #syncId: syncId,
      if (libraryId != null) #libraryId: libraryId,
      if (mediaIdInt != null) #mediaIdInt: mediaIdInt,
      if (trackingUrl != null) #trackingUrl: trackingUrl,
      if (title != null) #title: title,
      if (lastChapterRead != null) #lastChapterRead: lastChapterRead,
      if (totalChapters != null) #totalChapters: totalChapters,
      if (score != null) #score: score,
      if (status != null) #status: status,
      if (startedReadingDate != null) #startedReadingDate: startedReadingDate,
      if (finishedReadingDate != null)
        #finishedReadingDate: finishedReadingDate,
      if (mediaId != null) #mediaId: mediaId,
    }),
  );
  @override
  TachiBackupTracking $make(CopyWithData data) => TachiBackupTracking(
    syncId: data.get(#syncId, or: $value.syncId),
    libraryId: data.get(#libraryId, or: $value.libraryId),
    mediaIdInt: data.get(#mediaIdInt, or: $value.mediaIdInt),
    trackingUrl: data.get(#trackingUrl, or: $value.trackingUrl),
    title: data.get(#title, or: $value.title),
    lastChapterRead: data.get(#lastChapterRead, or: $value.lastChapterRead),
    totalChapters: data.get(#totalChapters, or: $value.totalChapters),
    score: data.get(#score, or: $value.score),
    status: data.get(#status, or: $value.status),
    startedReadingDate: data.get(
      #startedReadingDate,
      or: $value.startedReadingDate,
    ),
    finishedReadingDate: data.get(
      #finishedReadingDate,
      or: $value.finishedReadingDate,
    ),
    mediaId: data.get(#mediaId, or: $value.mediaId),
  );

  @override
  TachiBackupTrackingCopyWith<$R2, TachiBackupTracking, $Out2> $chain<
    $R2,
    $Out2
  >(Then<$Out2, $R2> t) => _TachiBackupTrackingCopyWithImpl($value, $cast, t);
}

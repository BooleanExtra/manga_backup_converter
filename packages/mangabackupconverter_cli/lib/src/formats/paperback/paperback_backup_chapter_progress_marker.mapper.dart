// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup_chapter_progress_marker.dart';

class PaperbackBackupChapterProgressMarkerMapper extends ClassMapperBase<PaperbackBackupChapterProgressMarker> {
  PaperbackBackupChapterProgressMarkerMapper._();

  static PaperbackBackupChapterProgressMarkerMapper? _instance;
  static PaperbackBackupChapterProgressMarkerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaperbackBackupChapterProgressMarkerMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      PaperbackBackupItemReferenceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupChapterProgressMarker';

  static int _$totalPages(PaperbackBackupChapterProgressMarker v) => v.totalPages;
  static const Field<PaperbackBackupChapterProgressMarker, int> _f$totalPages = Field('totalPages', _$totalPages);
  static bool _$completed(PaperbackBackupChapterProgressMarker v) => v.completed;
  static const Field<PaperbackBackupChapterProgressMarker, bool> _f$completed = Field('completed', _$completed);
  static PaperbackBackupItemReference _$chapter(PaperbackBackupChapterProgressMarker v) => v.chapter;
  static const Field<PaperbackBackupChapterProgressMarker, PaperbackBackupItemReference> _f$chapter = Field(
    'chapter',
    _$chapter,
  );
  static int _$lastPage(PaperbackBackupChapterProgressMarker v) => v.lastPage;
  static const Field<PaperbackBackupChapterProgressMarker, int> _f$lastPage = Field('lastPage', _$lastPage);
  static DateTime _$time(PaperbackBackupChapterProgressMarker v) => v.time;
  static const Field<PaperbackBackupChapterProgressMarker, DateTime> _f$time = Field('time', _$time);
  static bool _$hidden(PaperbackBackupChapterProgressMarker v) => v.hidden;
  static const Field<PaperbackBackupChapterProgressMarker, bool> _f$hidden = Field('hidden', _$hidden);

  @override
  final MappableFields<PaperbackBackupChapterProgressMarker> fields = const {
    #totalPages: _f$totalPages,
    #completed: _f$completed,
    #chapter: _f$chapter,
    #lastPage: _f$lastPage,
    #time: _f$time,
    #hidden: _f$hidden,
  };

  static PaperbackBackupChapterProgressMarker _instantiate(DecodingData data) {
    return PaperbackBackupChapterProgressMarker(
      totalPages: data.dec(_f$totalPages),
      completed: data.dec(_f$completed),
      chapter: data.dec(_f$chapter),
      lastPage: data.dec(_f$lastPage),
      time: data.dec(_f$time),
      hidden: data.dec(_f$hidden),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupChapterProgressMarker fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupChapterProgressMarker>(map);
  }

  static PaperbackBackupChapterProgressMarker fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupChapterProgressMarker>(json);
  }
}

mixin PaperbackBackupChapterProgressMarkerMappable {
  String toJson() {
    return PaperbackBackupChapterProgressMarkerMapper.ensureInitialized()
        .encodeJson<PaperbackBackupChapterProgressMarker>(this as PaperbackBackupChapterProgressMarker);
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupChapterProgressMarkerMapper.ensureInitialized()
        .encodeMap<PaperbackBackupChapterProgressMarker>(this as PaperbackBackupChapterProgressMarker);
  }

  PaperbackBackupChapterProgressMarkerCopyWith<
    PaperbackBackupChapterProgressMarker,
    PaperbackBackupChapterProgressMarker,
    PaperbackBackupChapterProgressMarker
  >
  get copyWith => _PaperbackBackupChapterProgressMarkerCopyWithImpl(
    this as PaperbackBackupChapterProgressMarker,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PaperbackBackupChapterProgressMarkerMapper.ensureInitialized().stringifyValue(
      this as PaperbackBackupChapterProgressMarker,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupChapterProgressMarkerMapper.ensureInitialized().equalsValue(
      this as PaperbackBackupChapterProgressMarker,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackBackupChapterProgressMarkerMapper.ensureInitialized().hashValue(
      this as PaperbackBackupChapterProgressMarker,
    );
  }
}

extension PaperbackBackupChapterProgressMarkerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaperbackBackupChapterProgressMarker, $Out> {
  PaperbackBackupChapterProgressMarkerCopyWith<$R, PaperbackBackupChapterProgressMarker, $Out>
  get $asPaperbackBackupChapterProgressMarker =>
      $base.as((v, t, t2) => _PaperbackBackupChapterProgressMarkerCopyWithImpl(v, t, t2));
}

abstract class PaperbackBackupChapterProgressMarkerCopyWith<$R, $In extends PaperbackBackupChapterProgressMarker, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference> get chapter;
  $R call({
    int? totalPages,
    bool? completed,
    PaperbackBackupItemReference? chapter,
    int? lastPage,
    DateTime? time,
    bool? hidden,
  });
  PaperbackBackupChapterProgressMarkerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PaperbackBackupChapterProgressMarkerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackupChapterProgressMarker, $Out>
    implements PaperbackBackupChapterProgressMarkerCopyWith<$R, PaperbackBackupChapterProgressMarker, $Out> {
  _PaperbackBackupChapterProgressMarkerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaperbackBackupChapterProgressMarker> $mapper =
      PaperbackBackupChapterProgressMarkerMapper.ensureInitialized();
  @override
  PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference> get chapter =>
      $value.chapter.copyWith.$chain((v) => call(chapter: v));
  @override
  $R call({
    int? totalPages,
    bool? completed,
    PaperbackBackupItemReference? chapter,
    int? lastPage,
    DateTime? time,
    bool? hidden,
  }) => $apply(
    FieldCopyWithData({
      if (totalPages != null) #totalPages: totalPages,
      if (completed != null) #completed: completed,
      if (chapter != null) #chapter: chapter,
      if (lastPage != null) #lastPage: lastPage,
      if (time != null) #time: time,
      if (hidden != null) #hidden: hidden,
    }),
  );
  @override
  PaperbackBackupChapterProgressMarker $make(CopyWithData data) => PaperbackBackupChapterProgressMarker(
    totalPages: data.get(#totalPages, or: $value.totalPages),
    completed: data.get(#completed, or: $value.completed),
    chapter: data.get(#chapter, or: $value.chapter),
    lastPage: data.get(#lastPage, or: $value.lastPage),
    time: data.get(#time, or: $value.time),
    hidden: data.get(#hidden, or: $value.hidden),
  );

  @override
  PaperbackBackupChapterProgressMarkerCopyWith<$R2, PaperbackBackupChapterProgressMarker, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PaperbackBackupChapterProgressMarkerCopyWithImpl($value, $cast, t);
}

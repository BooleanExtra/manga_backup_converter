// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup_chapter.dart';

class PaperbackBackupChapterMapper extends ClassMapperBase<PaperbackBackupChapter> {
  PaperbackBackupChapterMapper._();

  static PaperbackBackupChapterMapper? _instance;
  static PaperbackBackupChapterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaperbackBackupChapterMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      PaperbackBackupItemReferenceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupChapter';

  static num _$volume(PaperbackBackupChapter v) => v.volume;
  static const Field<PaperbackBackupChapter, num> _f$volume = Field('volume', _$volume);
  static String _$langCode(PaperbackBackupChapter v) => v.langCode;
  static const Field<PaperbackBackupChapter, String> _f$langCode = Field('langCode', _$langCode);
  static String _$group(PaperbackBackupChapter v) => v.group;
  static const Field<PaperbackBackupChapter, String> _f$group = Field('group', _$group);
  static int _$sortingIndex(PaperbackBackupChapter v) => v.sortingIndex;
  static const Field<PaperbackBackupChapter, int> _f$sortingIndex = Field('sortingIndex', _$sortingIndex);
  static String _$id(PaperbackBackupChapter v) => v.id;
  static const Field<PaperbackBackupChapter, String> _f$id = Field('id', _$id);
  static num _$chapNum(PaperbackBackupChapter v) => v.chapNum;
  static const Field<PaperbackBackupChapter, num> _f$chapNum = Field('chapNum', _$chapNum);
  static String _$chapterId(PaperbackBackupChapter v) => v.chapterId;
  static const Field<PaperbackBackupChapter, String> _f$chapterId = Field('chapterId', _$chapterId);
  static DateTime _$time(PaperbackBackupChapter v) => v.time;
  static const Field<PaperbackBackupChapter, DateTime> _f$time = Field('time', _$time);
  static bool _$isNew(PaperbackBackupChapter v) => v.isNew;
  static const Field<PaperbackBackupChapter, bool> _f$isNew = Field('isNew', _$isNew);
  static String _$name(PaperbackBackupChapter v) => v.name;
  static const Field<PaperbackBackupChapter, String> _f$name = Field('name', _$name);
  static PaperbackBackupItemReference _$sourceManga(PaperbackBackupChapter v) => v.sourceManga;
  static const Field<PaperbackBackupChapter, PaperbackBackupItemReference> _f$sourceManga = Field(
    'sourceManga',
    _$sourceManga,
  );

  @override
  final MappableFields<PaperbackBackupChapter> fields = const {
    #volume: _f$volume,
    #langCode: _f$langCode,
    #group: _f$group,
    #sortingIndex: _f$sortingIndex,
    #id: _f$id,
    #chapNum: _f$chapNum,
    #chapterId: _f$chapterId,
    #time: _f$time,
    #isNew: _f$isNew,
    #name: _f$name,
    #sourceManga: _f$sourceManga,
  };

  static PaperbackBackupChapter _instantiate(DecodingData data) {
    return PaperbackBackupChapter(
      volume: data.dec(_f$volume),
      langCode: data.dec(_f$langCode),
      group: data.dec(_f$group),
      sortingIndex: data.dec(_f$sortingIndex),
      id: data.dec(_f$id),
      chapNum: data.dec(_f$chapNum),
      chapterId: data.dec(_f$chapterId),
      time: data.dec(_f$time),
      isNew: data.dec(_f$isNew),
      name: data.dec(_f$name),
      sourceManga: data.dec(_f$sourceManga),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupChapter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupChapter>(map);
  }

  static PaperbackBackupChapter fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupChapter>(json);
  }
}

mixin PaperbackBackupChapterMappable {
  String toJson() {
    return PaperbackBackupChapterMapper.ensureInitialized().encodeJson<PaperbackBackupChapter>(
      this as PaperbackBackupChapter,
    );
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupChapterMapper.ensureInitialized().encodeMap<PaperbackBackupChapter>(
      this as PaperbackBackupChapter,
    );
  }

  PaperbackBackupChapterCopyWith<PaperbackBackupChapter, PaperbackBackupChapter, PaperbackBackupChapter> get copyWith =>
      _PaperbackBackupChapterCopyWithImpl(this as PaperbackBackupChapter, $identity, $identity);
  @override
  String toString() {
    return PaperbackBackupChapterMapper.ensureInitialized().stringifyValue(this as PaperbackBackupChapter);
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupChapterMapper.ensureInitialized().equalsValue(this as PaperbackBackupChapter, other);
  }

  @override
  int get hashCode {
    return PaperbackBackupChapterMapper.ensureInitialized().hashValue(this as PaperbackBackupChapter);
  }
}

extension PaperbackBackupChapterValueCopy<$R, $Out> on ObjectCopyWith<$R, PaperbackBackupChapter, $Out> {
  PaperbackBackupChapterCopyWith<$R, PaperbackBackupChapter, $Out> get $asPaperbackBackupChapter =>
      $base.as((v, t, t2) => _PaperbackBackupChapterCopyWithImpl(v, t, t2));
}

abstract class PaperbackBackupChapterCopyWith<$R, $In extends PaperbackBackupChapter, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference> get sourceManga;
  $R call({
    num? volume,
    String? langCode,
    String? group,
    int? sortingIndex,
    String? id,
    num? chapNum,
    String? chapterId,
    DateTime? time,
    bool? isNew,
    String? name,
    PaperbackBackupItemReference? sourceManga,
  });
  PaperbackBackupChapterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PaperbackBackupChapterCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, PaperbackBackupChapter, $Out>
    implements PaperbackBackupChapterCopyWith<$R, PaperbackBackupChapter, $Out> {
  _PaperbackBackupChapterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaperbackBackupChapter> $mapper = PaperbackBackupChapterMapper.ensureInitialized();
  @override
  PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference>
  get sourceManga => $value.sourceManga.copyWith.$chain((v) => call(sourceManga: v));
  @override
  $R call({
    num? volume,
    String? langCode,
    String? group,
    int? sortingIndex,
    String? id,
    num? chapNum,
    String? chapterId,
    DateTime? time,
    bool? isNew,
    String? name,
    PaperbackBackupItemReference? sourceManga,
  }) => $apply(
    FieldCopyWithData({
      if (volume != null) #volume: volume,
      if (langCode != null) #langCode: langCode,
      if (group != null) #group: group,
      if (sortingIndex != null) #sortingIndex: sortingIndex,
      if (id != null) #id: id,
      if (chapNum != null) #chapNum: chapNum,
      if (chapterId != null) #chapterId: chapterId,
      if (time != null) #time: time,
      if (isNew != null) #isNew: isNew,
      if (name != null) #name: name,
      if (sourceManga != null) #sourceManga: sourceManga,
    }),
  );
  @override
  PaperbackBackupChapter $make(CopyWithData data) => PaperbackBackupChapter(
    volume: data.get(#volume, or: $value.volume),
    langCode: data.get(#langCode, or: $value.langCode),
    group: data.get(#group, or: $value.group),
    sortingIndex: data.get(#sortingIndex, or: $value.sortingIndex),
    id: data.get(#id, or: $value.id),
    chapNum: data.get(#chapNum, or: $value.chapNum),
    chapterId: data.get(#chapterId, or: $value.chapterId),
    time: data.get(#time, or: $value.time),
    isNew: data.get(#isNew, or: $value.isNew),
    name: data.get(#name, or: $value.name),
    sourceManga: data.get(#sourceManga, or: $value.sourceManga),
  );

  @override
  PaperbackBackupChapterCopyWith<$R2, PaperbackBackupChapter, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaperbackBackupChapterCopyWithImpl($value, $cast, t);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'aidoku_backup_chapter.dart';

class AidokuBackupChapterMapper extends ClassMapperBase<AidokuBackupChapter> {
  AidokuBackupChapterMapper._();

  static AidokuBackupChapterMapper? _instance;
  static AidokuBackupChapterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuBackupChapterMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'AidokuBackupChapter';

  static String _$sourceId(AidokuBackupChapter v) => v.sourceId;
  static const Field<AidokuBackupChapter, String> _f$sourceId =
      Field('sourceId', _$sourceId);
  static String _$mangaId(AidokuBackupChapter v) => v.mangaId;
  static const Field<AidokuBackupChapter, String> _f$mangaId =
      Field('mangaId', _$mangaId);
  static String _$id(AidokuBackupChapter v) => v.id;
  static const Field<AidokuBackupChapter, String> _f$id = Field('id', _$id);
  static String? _$title(AidokuBackupChapter v) => v.title;
  static const Field<AidokuBackupChapter, String> _f$title =
      Field('title', _$title);
  static String? _$scanlator(AidokuBackupChapter v) => v.scanlator;
  static const Field<AidokuBackupChapter, String> _f$scanlator =
      Field('scanlator', _$scanlator);
  static String _$lang(AidokuBackupChapter v) => v.lang;
  static const Field<AidokuBackupChapter, String> _f$lang =
      Field('lang', _$lang);
  static double? _$chapter(AidokuBackupChapter v) => v.chapter;
  static const Field<AidokuBackupChapter, double> _f$chapter =
      Field('chapter', _$chapter);
  static double? _$volume(AidokuBackupChapter v) => v.volume;
  static const Field<AidokuBackupChapter, double> _f$volume =
      Field('volume', _$volume);
  static DateTime? _$dateUploaded(AidokuBackupChapter v) => v.dateUploaded;
  static const Field<AidokuBackupChapter, DateTime> _f$dateUploaded =
      Field('dateUploaded', _$dateUploaded);
  static int _$sourceOrder(AidokuBackupChapter v) => v.sourceOrder;
  static const Field<AidokuBackupChapter, int> _f$sourceOrder =
      Field('sourceOrder', _$sourceOrder);

  @override
  final MappableFields<AidokuBackupChapter> fields = const {
    #sourceId: _f$sourceId,
    #mangaId: _f$mangaId,
    #id: _f$id,
    #title: _f$title,
    #scanlator: _f$scanlator,
    #lang: _f$lang,
    #chapter: _f$chapter,
    #volume: _f$volume,
    #dateUploaded: _f$dateUploaded,
    #sourceOrder: _f$sourceOrder,
  };
  @override
  final bool ignoreNull = true;

  static AidokuBackupChapter _instantiate(DecodingData data) {
    return AidokuBackupChapter(
        sourceId: data.dec(_f$sourceId),
        mangaId: data.dec(_f$mangaId),
        id: data.dec(_f$id),
        title: data.dec(_f$title),
        scanlator: data.dec(_f$scanlator),
        lang: data.dec(_f$lang),
        chapter: data.dec(_f$chapter),
        volume: data.dec(_f$volume),
        dateUploaded: data.dec(_f$dateUploaded),
        sourceOrder: data.dec(_f$sourceOrder));
  }

  @override
  final Function instantiate = _instantiate;

  static AidokuBackupChapter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AidokuBackupChapter>(map);
  }

  static AidokuBackupChapter fromJson(String json) {
    return ensureInitialized().decodeJson<AidokuBackupChapter>(json);
  }
}

mixin AidokuBackupChapterMappable {
  String toJson() {
    return AidokuBackupChapterMapper.ensureInitialized()
        .encodeJson<AidokuBackupChapter>(this as AidokuBackupChapter);
  }

  Map<String, dynamic> toMap() {
    return AidokuBackupChapterMapper.ensureInitialized()
        .encodeMap<AidokuBackupChapter>(this as AidokuBackupChapter);
  }

  AidokuBackupChapterCopyWith<AidokuBackupChapter, AidokuBackupChapter,
          AidokuBackupChapter>
      get copyWith => _AidokuBackupChapterCopyWithImpl(
          this as AidokuBackupChapter, $identity, $identity);
  @override
  String toString() {
    return AidokuBackupChapterMapper.ensureInitialized()
        .stringifyValue(this as AidokuBackupChapter);
  }

  @override
  bool operator ==(Object other) {
    return AidokuBackupChapterMapper.ensureInitialized()
        .equalsValue(this as AidokuBackupChapter, other);
  }

  @override
  int get hashCode {
    return AidokuBackupChapterMapper.ensureInitialized()
        .hashValue(this as AidokuBackupChapter);
  }
}

extension AidokuBackupChapterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AidokuBackupChapter, $Out> {
  AidokuBackupChapterCopyWith<$R, AidokuBackupChapter, $Out>
      get $asAidokuBackupChapter =>
          $base.as((v, t, t2) => _AidokuBackupChapterCopyWithImpl(v, t, t2));
}

abstract class AidokuBackupChapterCopyWith<$R, $In extends AidokuBackupChapter,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? sourceId,
      String? mangaId,
      String? id,
      String? title,
      String? scanlator,
      String? lang,
      double? chapter,
      double? volume,
      DateTime? dateUploaded,
      int? sourceOrder});
  AidokuBackupChapterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AidokuBackupChapterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AidokuBackupChapter, $Out>
    implements AidokuBackupChapterCopyWith<$R, AidokuBackupChapter, $Out> {
  _AidokuBackupChapterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AidokuBackupChapter> $mapper =
      AidokuBackupChapterMapper.ensureInitialized();
  @override
  $R call(
          {String? sourceId,
          String? mangaId,
          String? id,
          Object? title = $none,
          Object? scanlator = $none,
          String? lang,
          Object? chapter = $none,
          Object? volume = $none,
          Object? dateUploaded = $none,
          int? sourceOrder}) =>
      $apply(FieldCopyWithData({
        if (sourceId != null) #sourceId: sourceId,
        if (mangaId != null) #mangaId: mangaId,
        if (id != null) #id: id,
        if (title != $none) #title: title,
        if (scanlator != $none) #scanlator: scanlator,
        if (lang != null) #lang: lang,
        if (chapter != $none) #chapter: chapter,
        if (volume != $none) #volume: volume,
        if (dateUploaded != $none) #dateUploaded: dateUploaded,
        if (sourceOrder != null) #sourceOrder: sourceOrder
      }));
  @override
  AidokuBackupChapter $make(CopyWithData data) => AidokuBackupChapter(
      sourceId: data.get(#sourceId, or: $value.sourceId),
      mangaId: data.get(#mangaId, or: $value.mangaId),
      id: data.get(#id, or: $value.id),
      title: data.get(#title, or: $value.title),
      scanlator: data.get(#scanlator, or: $value.scanlator),
      lang: data.get(#lang, or: $value.lang),
      chapter: data.get(#chapter, or: $value.chapter),
      volume: data.get(#volume, or: $value.volume),
      dateUploaded: data.get(#dateUploaded, or: $value.dateUploaded),
      sourceOrder: data.get(#sourceOrder, or: $value.sourceOrder));

  @override
  AidokuBackupChapterCopyWith<$R2, AidokuBackupChapter, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AidokuBackupChapterCopyWithImpl($value, $cast, t);
}

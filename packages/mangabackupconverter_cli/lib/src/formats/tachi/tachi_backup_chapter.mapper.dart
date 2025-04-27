// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_chapter.dart';

class TachiBackupChapterMapper extends ClassMapperBase<TachiBackupChapter> {
  TachiBackupChapterMapper._();

  static TachiBackupChapterMapper? _instance;
  static TachiBackupChapterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiBackupChapterMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupChapter';

  static String _$url(TachiBackupChapter v) => v.url;
  static const Field<TachiBackupChapter, String> _f$url = Field('url', _$url);
  static String _$name(TachiBackupChapter v) => v.name;
  static const Field<TachiBackupChapter, String> _f$name =
      Field('name', _$name);
  static String _$scanlator(TachiBackupChapter v) => v.scanlator;
  static const Field<TachiBackupChapter, String> _f$scanlator =
      Field('scanlator', _$scanlator);
  static bool _$read(TachiBackupChapter v) => v.read;
  static const Field<TachiBackupChapter, bool> _f$read = Field('read', _$read);
  static bool _$bookmark(TachiBackupChapter v) => v.bookmark;
  static const Field<TachiBackupChapter, bool> _f$bookmark =
      Field('bookmark', _$bookmark);
  static int _$lastPageRead(TachiBackupChapter v) => v.lastPageRead;
  static const Field<TachiBackupChapter, int> _f$lastPageRead =
      Field('lastPageRead', _$lastPageRead);
  static int _$dateFetch(TachiBackupChapter v) => v.dateFetch;
  static const Field<TachiBackupChapter, int> _f$dateFetch =
      Field('dateFetch', _$dateFetch);
  static int _$dateUpload(TachiBackupChapter v) => v.dateUpload;
  static const Field<TachiBackupChapter, int> _f$dateUpload =
      Field('dateUpload', _$dateUpload);
  static double _$chapterNumber(TachiBackupChapter v) => v.chapterNumber;
  static const Field<TachiBackupChapter, double> _f$chapterNumber =
      Field('chapterNumber', _$chapterNumber);
  static int _$sourceOrder(TachiBackupChapter v) => v.sourceOrder;
  static const Field<TachiBackupChapter, int> _f$sourceOrder =
      Field('sourceOrder', _$sourceOrder);
  static int? _$lastModifiedAt(TachiBackupChapter v) => v.lastModifiedAt;
  static const Field<TachiBackupChapter, int> _f$lastModifiedAt =
      Field('lastModifiedAt', _$lastModifiedAt, opt: true);
  static int? _$version(TachiBackupChapter v) => v.version;
  static const Field<TachiBackupChapter, int> _f$version =
      Field('version', _$version, opt: true);
  static int? _$pagesLeft(TachiBackupChapter v) => v.pagesLeft;
  static const Field<TachiBackupChapter, int> _f$pagesLeft =
      Field('pagesLeft', _$pagesLeft, opt: true);

  @override
  final MappableFields<TachiBackupChapter> fields = const {
    #url: _f$url,
    #name: _f$name,
    #scanlator: _f$scanlator,
    #read: _f$read,
    #bookmark: _f$bookmark,
    #lastPageRead: _f$lastPageRead,
    #dateFetch: _f$dateFetch,
    #dateUpload: _f$dateUpload,
    #chapterNumber: _f$chapterNumber,
    #sourceOrder: _f$sourceOrder,
    #lastModifiedAt: _f$lastModifiedAt,
    #version: _f$version,
    #pagesLeft: _f$pagesLeft,
  };

  static TachiBackupChapter _instantiate(DecodingData data) {
    return TachiBackupChapter(
        url: data.dec(_f$url),
        name: data.dec(_f$name),
        scanlator: data.dec(_f$scanlator),
        read: data.dec(_f$read),
        bookmark: data.dec(_f$bookmark),
        lastPageRead: data.dec(_f$lastPageRead),
        dateFetch: data.dec(_f$dateFetch),
        dateUpload: data.dec(_f$dateUpload),
        chapterNumber: data.dec(_f$chapterNumber),
        sourceOrder: data.dec(_f$sourceOrder),
        lastModifiedAt: data.dec(_f$lastModifiedAt),
        version: data.dec(_f$version),
        pagesLeft: data.dec(_f$pagesLeft));
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupChapter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupChapter>(map);
  }

  static TachiBackupChapter fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupChapter>(json);
  }
}

mixin TachiBackupChapterMappable {
  String toJson() {
    return TachiBackupChapterMapper.ensureInitialized()
        .encodeJson<TachiBackupChapter>(this as TachiBackupChapter);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupChapterMapper.ensureInitialized()
        .encodeMap<TachiBackupChapter>(this as TachiBackupChapter);
  }

  TachiBackupChapterCopyWith<TachiBackupChapter, TachiBackupChapter,
          TachiBackupChapter>
      get copyWith => _TachiBackupChapterCopyWithImpl(
          this as TachiBackupChapter, $identity, $identity);
  @override
  String toString() {
    return TachiBackupChapterMapper.ensureInitialized()
        .stringifyValue(this as TachiBackupChapter);
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupChapterMapper.ensureInitialized()
        .equalsValue(this as TachiBackupChapter, other);
  }

  @override
  int get hashCode {
    return TachiBackupChapterMapper.ensureInitialized()
        .hashValue(this as TachiBackupChapter);
  }
}

extension TachiBackupChapterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupChapter, $Out> {
  TachiBackupChapterCopyWith<$R, TachiBackupChapter, $Out>
      get $asTachiBackupChapter =>
          $base.as((v, t, t2) => _TachiBackupChapterCopyWithImpl(v, t, t2));
}

abstract class TachiBackupChapterCopyWith<$R, $In extends TachiBackupChapter,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? url,
      String? name,
      String? scanlator,
      bool? read,
      bool? bookmark,
      int? lastPageRead,
      int? dateFetch,
      int? dateUpload,
      double? chapterNumber,
      int? sourceOrder,
      int? lastModifiedAt,
      int? version,
      int? pagesLeft});
  TachiBackupChapterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachiBackupChapterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupChapter, $Out>
    implements TachiBackupChapterCopyWith<$R, TachiBackupChapter, $Out> {
  _TachiBackupChapterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupChapter> $mapper =
      TachiBackupChapterMapper.ensureInitialized();
  @override
  $R call(
          {String? url,
          String? name,
          String? scanlator,
          bool? read,
          bool? bookmark,
          int? lastPageRead,
          int? dateFetch,
          int? dateUpload,
          double? chapterNumber,
          int? sourceOrder,
          Object? lastModifiedAt = $none,
          Object? version = $none,
          Object? pagesLeft = $none}) =>
      $apply(FieldCopyWithData({
        if (url != null) #url: url,
        if (name != null) #name: name,
        if (scanlator != null) #scanlator: scanlator,
        if (read != null) #read: read,
        if (bookmark != null) #bookmark: bookmark,
        if (lastPageRead != null) #lastPageRead: lastPageRead,
        if (dateFetch != null) #dateFetch: dateFetch,
        if (dateUpload != null) #dateUpload: dateUpload,
        if (chapterNumber != null) #chapterNumber: chapterNumber,
        if (sourceOrder != null) #sourceOrder: sourceOrder,
        if (lastModifiedAt != $none) #lastModifiedAt: lastModifiedAt,
        if (version != $none) #version: version,
        if (pagesLeft != $none) #pagesLeft: pagesLeft
      }));
  @override
  TachiBackupChapter $make(CopyWithData data) => TachiBackupChapter(
      url: data.get(#url, or: $value.url),
      name: data.get(#name, or: $value.name),
      scanlator: data.get(#scanlator, or: $value.scanlator),
      read: data.get(#read, or: $value.read),
      bookmark: data.get(#bookmark, or: $value.bookmark),
      lastPageRead: data.get(#lastPageRead, or: $value.lastPageRead),
      dateFetch: data.get(#dateFetch, or: $value.dateFetch),
      dateUpload: data.get(#dateUpload, or: $value.dateUpload),
      chapterNumber: data.get(#chapterNumber, or: $value.chapterNumber),
      sourceOrder: data.get(#sourceOrder, or: $value.sourceOrder),
      lastModifiedAt: data.get(#lastModifiedAt, or: $value.lastModifiedAt),
      version: data.get(#version, or: $value.version),
      pagesLeft: data.get(#pagesLeft, or: $value.pagesLeft));

  @override
  TachiBackupChapterCopyWith<$R2, TachiBackupChapter, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TachiBackupChapterCopyWithImpl($value, $cast, t);
}

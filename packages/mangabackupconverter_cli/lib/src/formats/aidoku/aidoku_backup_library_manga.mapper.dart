// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'aidoku_backup_library_manga.dart';

class AidokuBackupLibraryMangaMapper
    extends ClassMapperBase<AidokuBackupLibraryManga> {
  AidokuBackupLibraryMangaMapper._();

  static AidokuBackupLibraryMangaMapper? _instance;
  static AidokuBackupLibraryMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = AidokuBackupLibraryMangaMapper._());
      MapperContainer.globals.useAll([AidokuDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'AidokuBackupLibraryManga';

  static DateTime _$lastOpened(AidokuBackupLibraryManga v) => v.lastOpened;
  static const Field<AidokuBackupLibraryManga, DateTime> _f$lastOpened =
      Field('lastOpened', _$lastOpened);
  static DateTime _$lastUpdated(AidokuBackupLibraryManga v) => v.lastUpdated;
  static const Field<AidokuBackupLibraryManga, DateTime> _f$lastUpdated =
      Field('lastUpdated', _$lastUpdated);
  static DateTime? _$lastRead(AidokuBackupLibraryManga v) => v.lastRead;
  static const Field<AidokuBackupLibraryManga, DateTime> _f$lastRead =
      Field('lastRead', _$lastRead);
  static DateTime _$dateAdded(AidokuBackupLibraryManga v) => v.dateAdded;
  static const Field<AidokuBackupLibraryManga, DateTime> _f$dateAdded =
      Field('dateAdded', _$dateAdded);
  static List<String> _$categories(AidokuBackupLibraryManga v) => v.categories;
  static const Field<AidokuBackupLibraryManga, List<String>> _f$categories =
      Field('categories', _$categories);
  static String _$mangaId(AidokuBackupLibraryManga v) => v.mangaId;
  static const Field<AidokuBackupLibraryManga, String> _f$mangaId =
      Field('mangaId', _$mangaId);
  static String _$sourceId(AidokuBackupLibraryManga v) => v.sourceId;
  static const Field<AidokuBackupLibraryManga, String> _f$sourceId =
      Field('sourceId', _$sourceId);

  @override
  final MappableFields<AidokuBackupLibraryManga> fields = const {
    #lastOpened: _f$lastOpened,
    #lastUpdated: _f$lastUpdated,
    #lastRead: _f$lastRead,
    #dateAdded: _f$dateAdded,
    #categories: _f$categories,
    #mangaId: _f$mangaId,
    #sourceId: _f$sourceId,
  };
  @override
  final bool ignoreNull = true;

  static AidokuBackupLibraryManga _instantiate(DecodingData data) {
    return AidokuBackupLibraryManga(
        lastOpened: data.dec(_f$lastOpened),
        lastUpdated: data.dec(_f$lastUpdated),
        lastRead: data.dec(_f$lastRead),
        dateAdded: data.dec(_f$dateAdded),
        categories: data.dec(_f$categories),
        mangaId: data.dec(_f$mangaId),
        sourceId: data.dec(_f$sourceId));
  }

  @override
  final Function instantiate = _instantiate;

  static AidokuBackupLibraryManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AidokuBackupLibraryManga>(map);
  }

  static AidokuBackupLibraryManga fromJson(String json) {
    return ensureInitialized().decodeJson<AidokuBackupLibraryManga>(json);
  }
}

mixin AidokuBackupLibraryMangaMappable {
  String toJson() {
    return AidokuBackupLibraryMangaMapper.ensureInitialized()
        .encodeJson<AidokuBackupLibraryManga>(this as AidokuBackupLibraryManga);
  }

  Map<String, dynamic> toMap() {
    return AidokuBackupLibraryMangaMapper.ensureInitialized()
        .encodeMap<AidokuBackupLibraryManga>(this as AidokuBackupLibraryManga);
  }

  AidokuBackupLibraryMangaCopyWith<AidokuBackupLibraryManga,
          AidokuBackupLibraryManga, AidokuBackupLibraryManga>
      get copyWith => _AidokuBackupLibraryMangaCopyWithImpl(
          this as AidokuBackupLibraryManga, $identity, $identity);
  @override
  String toString() {
    return AidokuBackupLibraryMangaMapper.ensureInitialized()
        .stringifyValue(this as AidokuBackupLibraryManga);
  }

  @override
  bool operator ==(Object other) {
    return AidokuBackupLibraryMangaMapper.ensureInitialized()
        .equalsValue(this as AidokuBackupLibraryManga, other);
  }

  @override
  int get hashCode {
    return AidokuBackupLibraryMangaMapper.ensureInitialized()
        .hashValue(this as AidokuBackupLibraryManga);
  }
}

extension AidokuBackupLibraryMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AidokuBackupLibraryManga, $Out> {
  AidokuBackupLibraryMangaCopyWith<$R, AidokuBackupLibraryManga, $Out>
      get $asAidokuBackupLibraryManga => $base
          .as((v, t, t2) => _AidokuBackupLibraryMangaCopyWithImpl(v, t, t2));
}

abstract class AidokuBackupLibraryMangaCopyWith<
    $R,
    $In extends AidokuBackupLibraryManga,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categories;
  $R call(
      {DateTime? lastOpened,
      DateTime? lastUpdated,
      DateTime? lastRead,
      DateTime? dateAdded,
      List<String>? categories,
      String? mangaId,
      String? sourceId});
  AidokuBackupLibraryMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AidokuBackupLibraryMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AidokuBackupLibraryManga, $Out>
    implements
        AidokuBackupLibraryMangaCopyWith<$R, AidokuBackupLibraryManga, $Out> {
  _AidokuBackupLibraryMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AidokuBackupLibraryManga> $mapper =
      AidokuBackupLibraryMangaMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categories =>
      ListCopyWith($value.categories, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(categories: v));
  @override
  $R call(
          {DateTime? lastOpened,
          DateTime? lastUpdated,
          Object? lastRead = $none,
          DateTime? dateAdded,
          List<String>? categories,
          String? mangaId,
          String? sourceId}) =>
      $apply(FieldCopyWithData({
        if (lastOpened != null) #lastOpened: lastOpened,
        if (lastUpdated != null) #lastUpdated: lastUpdated,
        if (lastRead != $none) #lastRead: lastRead,
        if (dateAdded != null) #dateAdded: dateAdded,
        if (categories != null) #categories: categories,
        if (mangaId != null) #mangaId: mangaId,
        if (sourceId != null) #sourceId: sourceId
      }));
  @override
  AidokuBackupLibraryManga $make(CopyWithData data) => AidokuBackupLibraryManga(
      lastOpened: data.get(#lastOpened, or: $value.lastOpened),
      lastUpdated: data.get(#lastUpdated, or: $value.lastUpdated),
      lastRead: data.get(#lastRead, or: $value.lastRead),
      dateAdded: data.get(#dateAdded, or: $value.dateAdded),
      categories: data.get(#categories, or: $value.categories),
      mangaId: data.get(#mangaId, or: $value.mangaId),
      sourceId: data.get(#sourceId, or: $value.sourceId));

  @override
  AidokuBackupLibraryMangaCopyWith<$R2, AidokuBackupLibraryManga, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AidokuBackupLibraryMangaCopyWithImpl($value, $cast, t);
}

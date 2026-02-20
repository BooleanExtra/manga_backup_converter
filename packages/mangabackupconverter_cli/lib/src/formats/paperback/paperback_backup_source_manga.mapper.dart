// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup_source_manga.dart';

class PaperbackBackupSourceMangaMapper
    extends ClassMapperBase<PaperbackBackupSourceManga> {
  PaperbackBackupSourceMangaMapper._();

  static PaperbackBackupSourceMangaMapper? _instance;
  static PaperbackBackupSourceMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PaperbackBackupSourceMangaMapper._(),
      );
      MapperContainer.globals.useAll(<MapperBase<Object>>[
        SecondsEpochDateTimeMapper(),
      ]);
      PaperbackBackupItemReferenceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupSourceManga';

  static String _$sourceId(PaperbackBackupSourceManga v) => v.sourceId;
  static const Field<PaperbackBackupSourceManga, String> _f$sourceId = Field(
    'sourceId',
    _$sourceId,
  );
  static String _$mangaId(PaperbackBackupSourceManga v) => v.mangaId;
  static const Field<PaperbackBackupSourceManga, String> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
  );
  static String _$id(PaperbackBackupSourceManga v) => v.id;
  static const Field<PaperbackBackupSourceManga, String> _f$id = Field(
    'id',
    _$id,
  );
  static PaperbackBackupItemReference _$mangaInfo(
    PaperbackBackupSourceManga v,
  ) => v.mangaInfo;
  static const Field<PaperbackBackupSourceManga, PaperbackBackupItemReference>
  _f$mangaInfo = Field('mangaInfo', _$mangaInfo);

  @override
  final MappableFields<PaperbackBackupSourceManga> fields = const {
    #sourceId: _f$sourceId,
    #mangaId: _f$mangaId,
    #id: _f$id,
    #mangaInfo: _f$mangaInfo,
  };

  static PaperbackBackupSourceManga _instantiate(DecodingData data) {
    return PaperbackBackupSourceManga(
      sourceId: data.dec(_f$sourceId),
      mangaId: data.dec(_f$mangaId),
      id: data.dec(_f$id),
      mangaInfo: data.dec(_f$mangaInfo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupSourceManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupSourceManga>(map);
  }

  static PaperbackBackupSourceManga fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupSourceManga>(json);
  }
}

mixin PaperbackBackupSourceMangaMappable {
  String toJson() {
    return PaperbackBackupSourceMangaMapper.ensureInitialized()
        .encodeJson<PaperbackBackupSourceManga>(
          this as PaperbackBackupSourceManga,
        );
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupSourceMangaMapper.ensureInitialized()
        .encodeMap<PaperbackBackupSourceManga>(
          this as PaperbackBackupSourceManga,
        );
  }

  PaperbackBackupSourceMangaCopyWith<
    PaperbackBackupSourceManga,
    PaperbackBackupSourceManga,
    PaperbackBackupSourceManga
  >
  get copyWith =>
      _PaperbackBackupSourceMangaCopyWithImpl<
        PaperbackBackupSourceManga,
        PaperbackBackupSourceManga
      >(this as PaperbackBackupSourceManga, $identity, $identity);
  @override
  String toString() {
    return PaperbackBackupSourceMangaMapper.ensureInitialized().stringifyValue(
      this as PaperbackBackupSourceManga,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupSourceMangaMapper.ensureInitialized().equalsValue(
      this as PaperbackBackupSourceManga,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackBackupSourceMangaMapper.ensureInitialized().hashValue(
      this as PaperbackBackupSourceManga,
    );
  }
}

extension PaperbackBackupSourceMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaperbackBackupSourceManga, $Out> {
  PaperbackBackupSourceMangaCopyWith<$R, PaperbackBackupSourceManga, $Out>
  get $asPaperbackBackupSourceManga => $base.as(
    (v, t, t2) => _PaperbackBackupSourceMangaCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PaperbackBackupSourceMangaCopyWith<
  $R,
  $In extends PaperbackBackupSourceManga,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PaperbackBackupItemReferenceCopyWith<
    $R,
    PaperbackBackupItemReference,
    PaperbackBackupItemReference
  >
  get mangaInfo;
  $R call({
    String? sourceId,
    String? mangaId,
    String? id,
    PaperbackBackupItemReference? mangaInfo,
  });
  PaperbackBackupSourceMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaperbackBackupSourceMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackupSourceManga, $Out>
    implements
        PaperbackBackupSourceMangaCopyWith<
          $R,
          PaperbackBackupSourceManga,
          $Out
        > {
  _PaperbackBackupSourceMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaperbackBackupSourceManga> $mapper =
      PaperbackBackupSourceMangaMapper.ensureInitialized();
  @override
  PaperbackBackupItemReferenceCopyWith<
    $R,
    PaperbackBackupItemReference,
    PaperbackBackupItemReference
  >
  get mangaInfo => $value.mangaInfo.copyWith.$chain((v) => call(mangaInfo: v));
  @override
  $R call({
    String? sourceId,
    String? mangaId,
    String? id,
    PaperbackBackupItemReference? mangaInfo,
  }) => $apply(
    FieldCopyWithData({
      if (sourceId != null) #sourceId: sourceId,
      if (mangaId != null) #mangaId: mangaId,
      if (id != null) #id: id,
      if (mangaInfo != null) #mangaInfo: mangaInfo,
    }),
  );
  @override
  PaperbackBackupSourceManga $make(CopyWithData data) =>
      PaperbackBackupSourceManga(
        sourceId: data.get(#sourceId, or: $value.sourceId),
        mangaId: data.get(#mangaId, or: $value.mangaId),
        id: data.get(#id, or: $value.id),
        mangaInfo: data.get(#mangaInfo, or: $value.mangaInfo),
      );

  @override
  PaperbackBackupSourceMangaCopyWith<$R2, PaperbackBackupSourceManga, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaperbackBackupSourceMangaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


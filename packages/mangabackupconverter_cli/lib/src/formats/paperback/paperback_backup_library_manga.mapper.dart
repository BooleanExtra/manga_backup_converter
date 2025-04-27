// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup_library_manga.dart';

class PaperbackBackupLibraryMangaMapper extends ClassMapperBase<PaperbackBackupLibraryManga> {
  PaperbackBackupLibraryMangaMapper._();

  static PaperbackBackupLibraryMangaMapper? _instance;
  static PaperbackBackupLibraryMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaperbackBackupLibraryMangaMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      PaperbackBackupLibraryTabMapper.ensureInitialized();
      PaperbackBackupItemReferenceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupLibraryManga';

  static List<PaperbackBackupLibraryTab> _$libraryTabs(PaperbackBackupLibraryManga v) => v.libraryTabs;
  static const Field<PaperbackBackupLibraryManga, List<PaperbackBackupLibraryTab>> _f$libraryTabs = Field(
    'libraryTabs',
    _$libraryTabs,
  );
  static DateTime? _$lastRead(PaperbackBackupLibraryManga v) => v.lastRead;
  static const Field<PaperbackBackupLibraryManga, DateTime> _f$lastRead = Field('lastRead', _$lastRead);
  static PaperbackBackupItemReference _$primarySource(PaperbackBackupLibraryManga v) => v.primarySource;
  static const Field<PaperbackBackupLibraryManga, PaperbackBackupItemReference> _f$primarySource = Field(
    'primarySource',
    _$primarySource,
  );
  static DateTime? _$dateBookmarked(PaperbackBackupLibraryManga v) => v.dateBookmarked;
  static const Field<PaperbackBackupLibraryManga, DateTime> _f$dateBookmarked = Field(
    'dateBookmarked',
    _$dateBookmarked,
  );
  static List<PaperbackBackupItemReference> _$trackedSources(PaperbackBackupLibraryManga v) => v.trackedSources;
  static const Field<PaperbackBackupLibraryManga, List<PaperbackBackupItemReference>> _f$trackedSources = Field(
    'trackedSources',
    _$trackedSources,
  );
  static String _$id(PaperbackBackupLibraryManga v) => v.id;
  static const Field<PaperbackBackupLibraryManga, String> _f$id = Field('id', _$id);
  static List<PaperbackBackupItemReference> _$secondarySources(PaperbackBackupLibraryManga v) => v.secondarySources;
  static const Field<PaperbackBackupLibraryManga, List<PaperbackBackupItemReference>> _f$secondarySources = Field(
    'secondarySources',
    _$secondarySources,
  );

  @override
  final MappableFields<PaperbackBackupLibraryManga> fields = const {
    #libraryTabs: _f$libraryTabs,
    #lastRead: _f$lastRead,
    #primarySource: _f$primarySource,
    #dateBookmarked: _f$dateBookmarked,
    #trackedSources: _f$trackedSources,
    #id: _f$id,
    #secondarySources: _f$secondarySources,
  };

  static PaperbackBackupLibraryManga _instantiate(DecodingData data) {
    return PaperbackBackupLibraryManga(
      libraryTabs: data.dec(_f$libraryTabs),
      lastRead: data.dec(_f$lastRead),
      primarySource: data.dec(_f$primarySource),
      dateBookmarked: data.dec(_f$dateBookmarked),
      trackedSources: data.dec(_f$trackedSources),
      id: data.dec(_f$id),
      secondarySources: data.dec(_f$secondarySources),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupLibraryManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupLibraryManga>(map);
  }

  static PaperbackBackupLibraryManga fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupLibraryManga>(json);
  }
}

mixin PaperbackBackupLibraryMangaMappable {
  String toJson() {
    return PaperbackBackupLibraryMangaMapper.ensureInitialized().encodeJson<PaperbackBackupLibraryManga>(
      this as PaperbackBackupLibraryManga,
    );
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupLibraryMangaMapper.ensureInitialized().encodeMap<PaperbackBackupLibraryManga>(
      this as PaperbackBackupLibraryManga,
    );
  }

  PaperbackBackupLibraryMangaCopyWith<
    PaperbackBackupLibraryManga,
    PaperbackBackupLibraryManga,
    PaperbackBackupLibraryManga
  >
  get copyWith => _PaperbackBackupLibraryMangaCopyWithImpl(this as PaperbackBackupLibraryManga, $identity, $identity);
  @override
  String toString() {
    return PaperbackBackupLibraryMangaMapper.ensureInitialized().stringifyValue(this as PaperbackBackupLibraryManga);
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupLibraryMangaMapper.ensureInitialized().equalsValue(
      this as PaperbackBackupLibraryManga,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackBackupLibraryMangaMapper.ensureInitialized().hashValue(this as PaperbackBackupLibraryManga);
  }
}

extension PaperbackBackupLibraryMangaValueCopy<$R, $Out> on ObjectCopyWith<$R, PaperbackBackupLibraryManga, $Out> {
  PaperbackBackupLibraryMangaCopyWith<$R, PaperbackBackupLibraryManga, $Out> get $asPaperbackBackupLibraryManga =>
      $base.as((v, t, t2) => _PaperbackBackupLibraryMangaCopyWithImpl(v, t, t2));
}

abstract class PaperbackBackupLibraryMangaCopyWith<$R, $In extends PaperbackBackupLibraryManga, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    PaperbackBackupLibraryTab,
    PaperbackBackupLibraryTabCopyWith<$R, PaperbackBackupLibraryTab, PaperbackBackupLibraryTab>
  >
  get libraryTabs;
  PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference>
  get primarySource;
  ListCopyWith<
    $R,
    PaperbackBackupItemReference,
    PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference>
  >
  get trackedSources;
  ListCopyWith<
    $R,
    PaperbackBackupItemReference,
    PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference>
  >
  get secondarySources;
  $R call({
    List<PaperbackBackupLibraryTab>? libraryTabs,
    DateTime? lastRead,
    PaperbackBackupItemReference? primarySource,
    DateTime? dateBookmarked,
    List<PaperbackBackupItemReference>? trackedSources,
    String? id,
    List<PaperbackBackupItemReference>? secondarySources,
  });
  PaperbackBackupLibraryMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PaperbackBackupLibraryMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackupLibraryManga, $Out>
    implements PaperbackBackupLibraryMangaCopyWith<$R, PaperbackBackupLibraryManga, $Out> {
  _PaperbackBackupLibraryMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaperbackBackupLibraryManga> $mapper =
      PaperbackBackupLibraryMangaMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    PaperbackBackupLibraryTab,
    PaperbackBackupLibraryTabCopyWith<$R, PaperbackBackupLibraryTab, PaperbackBackupLibraryTab>
  >
  get libraryTabs => ListCopyWith($value.libraryTabs, (v, t) => v.copyWith.$chain(t), (v) => call(libraryTabs: v));
  @override
  PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference>
  get primarySource => $value.primarySource.copyWith.$chain((v) => call(primarySource: v));
  @override
  ListCopyWith<
    $R,
    PaperbackBackupItemReference,
    PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference>
  >
  get trackedSources =>
      ListCopyWith($value.trackedSources, (v, t) => v.copyWith.$chain(t), (v) => call(trackedSources: v));
  @override
  ListCopyWith<
    $R,
    PaperbackBackupItemReference,
    PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, PaperbackBackupItemReference>
  >
  get secondarySources =>
      ListCopyWith($value.secondarySources, (v, t) => v.copyWith.$chain(t), (v) => call(secondarySources: v));
  @override
  $R call({
    List<PaperbackBackupLibraryTab>? libraryTabs,
    Object? lastRead = $none,
    PaperbackBackupItemReference? primarySource,
    Object? dateBookmarked = $none,
    List<PaperbackBackupItemReference>? trackedSources,
    String? id,
    List<PaperbackBackupItemReference>? secondarySources,
  }) => $apply(
    FieldCopyWithData({
      if (libraryTabs != null) #libraryTabs: libraryTabs,
      if (lastRead != $none) #lastRead: lastRead,
      if (primarySource != null) #primarySource: primarySource,
      if (dateBookmarked != $none) #dateBookmarked: dateBookmarked,
      if (trackedSources != null) #trackedSources: trackedSources,
      if (id != null) #id: id,
      if (secondarySources != null) #secondarySources: secondarySources,
    }),
  );
  @override
  PaperbackBackupLibraryManga $make(CopyWithData data) => PaperbackBackupLibraryManga(
    libraryTabs: data.get(#libraryTabs, or: $value.libraryTabs),
    lastRead: data.get(#lastRead, or: $value.lastRead),
    primarySource: data.get(#primarySource, or: $value.primarySource),
    dateBookmarked: data.get(#dateBookmarked, or: $value.dateBookmarked),
    trackedSources: data.get(#trackedSources, or: $value.trackedSources),
    id: data.get(#id, or: $value.id),
    secondarySources: data.get(#secondarySources, or: $value.secondarySources),
  );

  @override
  PaperbackBackupLibraryMangaCopyWith<$R2, PaperbackBackupLibraryManga, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaperbackBackupLibraryMangaCopyWithImpl($value, $cast, t);
}

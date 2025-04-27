// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup.dart';

class PaperbackBackupMapper extends ClassMapperBase<PaperbackBackup> {
  PaperbackBackupMapper._();

  static PaperbackBackupMapper? _instance;
  static PaperbackBackupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaperbackBackupMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      PaperbackBackupChapterProgressMarkerMapper.ensureInitialized();
      PaperbackBackupChapterMapper.ensureInitialized();
      PaperbackBackupLibraryMangaMapper.ensureInitialized();
      PaperbackBackupMangaInfoMapper.ensureInitialized();
      PaperbackBackupSourceMangaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackup';

  static List<PaperbackBackupChapterProgressMarker>? _$chapterProgressMarker(
    PaperbackBackup v,
  ) => v.chapterProgressMarker;
  static const Field<
    PaperbackBackup,
    List<PaperbackBackupChapterProgressMarker>
  >
  _f$chapterProgressMarker = Field(
    'chapterProgressMarker',
    _$chapterProgressMarker,
    opt: true,
  );
  static List<PaperbackBackupChapter>? _$chapters(PaperbackBackup v) =>
      v.chapters;
  static const Field<PaperbackBackup, List<PaperbackBackupChapter>>
  _f$chapters = Field('chapters', _$chapters, opt: true);
  static List<PaperbackBackupLibraryManga>? _$libraryManga(PaperbackBackup v) =>
      v.libraryManga;
  static const Field<PaperbackBackup, List<PaperbackBackupLibraryManga>>
  _f$libraryManga = Field('libraryManga', _$libraryManga, opt: true);
  static List<PaperbackBackupMangaInfo>? _$mangaInfo(PaperbackBackup v) =>
      v.mangaInfo;
  static const Field<PaperbackBackup, List<PaperbackBackupMangaInfo>>
  _f$mangaInfo = Field('mangaInfo', _$mangaInfo, opt: true);
  static List<PaperbackBackupSourceManga>? _$sourceManga(PaperbackBackup v) =>
      v.sourceManga;
  static const Field<PaperbackBackup, List<PaperbackBackupSourceManga>>
  _f$sourceManga = Field('sourceManga', _$sourceManga, opt: true);
  static String? _$name(PaperbackBackup v) => v.name;
  static const Field<PaperbackBackup, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );

  @override
  final MappableFields<PaperbackBackup> fields = const {
    #chapterProgressMarker: _f$chapterProgressMarker,
    #chapters: _f$chapters,
    #libraryManga: _f$libraryManga,
    #mangaInfo: _f$mangaInfo,
    #sourceManga: _f$sourceManga,
    #name: _f$name,
  };

  static PaperbackBackup _instantiate(DecodingData data) {
    return PaperbackBackup(
      chapterProgressMarker: data.dec(_f$chapterProgressMarker),
      chapters: data.dec(_f$chapters),
      libraryManga: data.dec(_f$libraryManga),
      mangaInfo: data.dec(_f$mangaInfo),
      sourceManga: data.dec(_f$sourceManga),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackup fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackup>(map);
  }

  static PaperbackBackup fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackup>(json);
  }
}

mixin PaperbackBackupMappable {
  String toJson() {
    return PaperbackBackupMapper.ensureInitialized()
        .encodeJson<PaperbackBackup>(this as PaperbackBackup);
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupMapper.ensureInitialized().encodeMap<PaperbackBackup>(
      this as PaperbackBackup,
    );
  }

  PaperbackBackupCopyWith<PaperbackBackup, PaperbackBackup, PaperbackBackup>
  get copyWith => _PaperbackBackupCopyWithImpl(
    this as PaperbackBackup,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PaperbackBackupMapper.ensureInitialized().stringifyValue(
      this as PaperbackBackup,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupMapper.ensureInitialized().equalsValue(
      this as PaperbackBackup,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackBackupMapper.ensureInitialized().hashValue(
      this as PaperbackBackup,
    );
  }
}

extension PaperbackBackupValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaperbackBackup, $Out> {
  PaperbackBackupCopyWith<$R, PaperbackBackup, $Out> get $asPaperbackBackup =>
      $base.as((v, t, t2) => _PaperbackBackupCopyWithImpl(v, t, t2));
}

abstract class PaperbackBackupCopyWith<$R, $In extends PaperbackBackup, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    PaperbackBackupChapterProgressMarker,
    PaperbackBackupChapterProgressMarkerCopyWith<
      $R,
      PaperbackBackupChapterProgressMarker,
      PaperbackBackupChapterProgressMarker
    >
  >?
  get chapterProgressMarker;
  ListCopyWith<
    $R,
    PaperbackBackupChapter,
    PaperbackBackupChapterCopyWith<
      $R,
      PaperbackBackupChapter,
      PaperbackBackupChapter
    >
  >?
  get chapters;
  ListCopyWith<
    $R,
    PaperbackBackupLibraryManga,
    PaperbackBackupLibraryMangaCopyWith<
      $R,
      PaperbackBackupLibraryManga,
      PaperbackBackupLibraryManga
    >
  >?
  get libraryManga;
  ListCopyWith<
    $R,
    PaperbackBackupMangaInfo,
    PaperbackBackupMangaInfoCopyWith<
      $R,
      PaperbackBackupMangaInfo,
      PaperbackBackupMangaInfo
    >
  >?
  get mangaInfo;
  ListCopyWith<
    $R,
    PaperbackBackupSourceManga,
    PaperbackBackupSourceMangaCopyWith<
      $R,
      PaperbackBackupSourceManga,
      PaperbackBackupSourceManga
    >
  >?
  get sourceManga;
  $R call({
    List<PaperbackBackupChapterProgressMarker>? chapterProgressMarker,
    List<PaperbackBackupChapter>? chapters,
    List<PaperbackBackupLibraryManga>? libraryManga,
    List<PaperbackBackupMangaInfo>? mangaInfo,
    List<PaperbackBackupSourceManga>? sourceManga,
    String? name,
  });
  PaperbackBackupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaperbackBackupCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackup, $Out>
    implements PaperbackBackupCopyWith<$R, PaperbackBackup, $Out> {
  _PaperbackBackupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaperbackBackup> $mapper =
      PaperbackBackupMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    PaperbackBackupChapterProgressMarker,
    PaperbackBackupChapterProgressMarkerCopyWith<
      $R,
      PaperbackBackupChapterProgressMarker,
      PaperbackBackupChapterProgressMarker
    >
  >?
  get chapterProgressMarker =>
      $value.chapterProgressMarker != null
          ? ListCopyWith(
            $value.chapterProgressMarker!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(chapterProgressMarker: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    PaperbackBackupChapter,
    PaperbackBackupChapterCopyWith<
      $R,
      PaperbackBackupChapter,
      PaperbackBackupChapter
    >
  >?
  get chapters =>
      $value.chapters != null
          ? ListCopyWith(
            $value.chapters!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(chapters: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    PaperbackBackupLibraryManga,
    PaperbackBackupLibraryMangaCopyWith<
      $R,
      PaperbackBackupLibraryManga,
      PaperbackBackupLibraryManga
    >
  >?
  get libraryManga =>
      $value.libraryManga != null
          ? ListCopyWith(
            $value.libraryManga!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(libraryManga: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    PaperbackBackupMangaInfo,
    PaperbackBackupMangaInfoCopyWith<
      $R,
      PaperbackBackupMangaInfo,
      PaperbackBackupMangaInfo
    >
  >?
  get mangaInfo =>
      $value.mangaInfo != null
          ? ListCopyWith(
            $value.mangaInfo!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(mangaInfo: v),
          )
          : null;
  @override
  ListCopyWith<
    $R,
    PaperbackBackupSourceManga,
    PaperbackBackupSourceMangaCopyWith<
      $R,
      PaperbackBackupSourceManga,
      PaperbackBackupSourceManga
    >
  >?
  get sourceManga =>
      $value.sourceManga != null
          ? ListCopyWith(
            $value.sourceManga!,
            (v, t) => v.copyWith.$chain(t),
            (v) => call(sourceManga: v),
          )
          : null;
  @override
  $R call({
    Object? chapterProgressMarker = $none,
    Object? chapters = $none,
    Object? libraryManga = $none,
    Object? mangaInfo = $none,
    Object? sourceManga = $none,
    Object? name = $none,
  }) => $apply(
    FieldCopyWithData({
      if (chapterProgressMarker != $none)
        #chapterProgressMarker: chapterProgressMarker,
      if (chapters != $none) #chapters: chapters,
      if (libraryManga != $none) #libraryManga: libraryManga,
      if (mangaInfo != $none) #mangaInfo: mangaInfo,
      if (sourceManga != $none) #sourceManga: sourceManga,
      if (name != $none) #name: name,
    }),
  );
  @override
  PaperbackBackup $make(CopyWithData data) => PaperbackBackup(
    chapterProgressMarker: data.get(
      #chapterProgressMarker,
      or: $value.chapterProgressMarker,
    ),
    chapters: data.get(#chapters, or: $value.chapters),
    libraryManga: data.get(#libraryManga, or: $value.libraryManga),
    mangaInfo: data.get(#mangaInfo, or: $value.mangaInfo),
    sourceManga: data.get(#sourceManga, or: $value.sourceManga),
    name: data.get(#name, or: $value.name),
  );

  @override
  PaperbackBackupCopyWith<$R2, PaperbackBackup, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PaperbackBackupCopyWithImpl($value, $cast, t);
}

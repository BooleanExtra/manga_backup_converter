// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'aidoku_backup.dart';

class AidokuBackupMapper extends ClassMapperBase<AidokuBackup> {
  AidokuBackupMapper._();

  static AidokuBackupMapper? _instance;
  static AidokuBackupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuBackupMapper._());
      MapperContainer.globals.useAll([AidokuDateTimeMapper()]);
      AidokuBackupLibraryMangaMapper.ensureInitialized();
      AidokuBackupHistoryMapper.ensureInitialized();
      AidokuBackupMangaMapper.ensureInitialized();
      AidokuBackupChapterMapper.ensureInitialized();
      AidokuBackupTrackItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AidokuBackup';

  static Set<AidokuBackupLibraryManga>? _$library(AidokuBackup v) => v.library;
  static const Field<AidokuBackup, Set<AidokuBackupLibraryManga>> _f$library = Field('library', _$library);
  static Set<AidokuBackupHistory>? _$history(AidokuBackup v) => v.history;
  static const Field<AidokuBackup, Set<AidokuBackupHistory>> _f$history = Field('history', _$history);
  static Set<AidokuBackupManga>? _$manga(AidokuBackup v) => v.manga;
  static const Field<AidokuBackup, Set<AidokuBackupManga>> _f$manga = Field('manga', _$manga);
  static Set<AidokuBackupChapter>? _$chapters(AidokuBackup v) => v.chapters;
  static const Field<AidokuBackup, Set<AidokuBackupChapter>> _f$chapters = Field('chapters', _$chapters);
  static Set<AidokuBackupTrackItem>? _$trackItems(AidokuBackup v) => v.trackItems;
  static const Field<AidokuBackup, Set<AidokuBackupTrackItem>> _f$trackItems = Field('trackItems', _$trackItems);
  static Set<String>? _$categories(AidokuBackup v) => v.categories;
  static const Field<AidokuBackup, Set<String>> _f$categories = Field('categories', _$categories);
  static Set<String>? _$sources(AidokuBackup v) => v.sources;
  static const Field<AidokuBackup, Set<String>> _f$sources = Field('sources', _$sources);
  static DateTime _$date(AidokuBackup v) => v.date;
  static const Field<AidokuBackup, DateTime> _f$date = Field('date', _$date);
  static String? _$name(AidokuBackup v) => v.name;
  static const Field<AidokuBackup, String> _f$name = Field('name', _$name);
  static String? _$version(AidokuBackup v) => v.version;
  static const Field<AidokuBackup, String> _f$version = Field('version', _$version);

  @override
  final MappableFields<AidokuBackup> fields = const {
    #library: _f$library,
    #history: _f$history,
    #manga: _f$manga,
    #chapters: _f$chapters,
    #trackItems: _f$trackItems,
    #categories: _f$categories,
    #sources: _f$sources,
    #date: _f$date,
    #name: _f$name,
    #version: _f$version,
  };
  @override
  final bool ignoreNull = true;

  static AidokuBackup _instantiate(DecodingData data) {
    return AidokuBackup(
      library: data.dec(_f$library),
      history: data.dec(_f$history),
      manga: data.dec(_f$manga),
      chapters: data.dec(_f$chapters),
      trackItems: data.dec(_f$trackItems),
      categories: data.dec(_f$categories),
      sources: data.dec(_f$sources),
      date: data.dec(_f$date),
      name: data.dec(_f$name),
      version: data.dec(_f$version),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AidokuBackup fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AidokuBackup>(map);
  }

  static AidokuBackup fromJson(String json) {
    return ensureInitialized().decodeJson<AidokuBackup>(json);
  }
}

mixin AidokuBackupMappable {
  String toJson() {
    return AidokuBackupMapper.ensureInitialized().encodeJson<AidokuBackup>(this as AidokuBackup);
  }

  Map<String, dynamic> toMap() {
    return AidokuBackupMapper.ensureInitialized().encodeMap<AidokuBackup>(this as AidokuBackup);
  }

  AidokuBackupCopyWith<AidokuBackup, AidokuBackup, AidokuBackup> get copyWith =>
      _AidokuBackupCopyWithImpl(this as AidokuBackup, $identity, $identity);
  @override
  String toString() {
    return AidokuBackupMapper.ensureInitialized().stringifyValue(this as AidokuBackup);
  }

  @override
  bool operator ==(Object other) {
    return AidokuBackupMapper.ensureInitialized().equalsValue(this as AidokuBackup, other);
  }

  @override
  int get hashCode {
    return AidokuBackupMapper.ensureInitialized().hashValue(this as AidokuBackup);
  }
}

extension AidokuBackupValueCopy<$R, $Out> on ObjectCopyWith<$R, AidokuBackup, $Out> {
  AidokuBackupCopyWith<$R, AidokuBackup, $Out> get $asAidokuBackup =>
      $base.as((v, t, t2) => _AidokuBackupCopyWithImpl(v, t, t2));
}

abstract class AidokuBackupCopyWith<$R, $In extends AidokuBackup, $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Set<AidokuBackupLibraryManga>? library,
    Set<AidokuBackupHistory>? history,
    Set<AidokuBackupManga>? manga,
    Set<AidokuBackupChapter>? chapters,
    Set<AidokuBackupTrackItem>? trackItems,
    Set<String>? categories,
    Set<String>? sources,
    DateTime? date,
    String? name,
    String? version,
  });
  AidokuBackupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AidokuBackupCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, AidokuBackup, $Out>
    implements AidokuBackupCopyWith<$R, AidokuBackup, $Out> {
  _AidokuBackupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AidokuBackup> $mapper = AidokuBackupMapper.ensureInitialized();
  @override
  $R call({
    Object? library = $none,
    Object? history = $none,
    Object? manga = $none,
    Object? chapters = $none,
    Object? trackItems = $none,
    Object? categories = $none,
    Object? sources = $none,
    DateTime? date,
    Object? name = $none,
    Object? version = $none,
  }) => $apply(
    FieldCopyWithData({
      if (library != $none) #library: library,
      if (history != $none) #history: history,
      if (manga != $none) #manga: manga,
      if (chapters != $none) #chapters: chapters,
      if (trackItems != $none) #trackItems: trackItems,
      if (categories != $none) #categories: categories,
      if (sources != $none) #sources: sources,
      if (date != null) #date: date,
      if (name != $none) #name: name,
      if (version != $none) #version: version,
    }),
  );
  @override
  AidokuBackup $make(CopyWithData data) => AidokuBackup(
    library: data.get(#library, or: $value.library),
    history: data.get(#history, or: $value.history),
    manga: data.get(#manga, or: $value.manga),
    chapters: data.get(#chapters, or: $value.chapters),
    trackItems: data.get(#trackItems, or: $value.trackItems),
    categories: data.get(#categories, or: $value.categories),
    sources: data.get(#sources, or: $value.sources),
    date: data.get(#date, or: $value.date),
    name: data.get(#name, or: $value.name),
    version: data.get(#version, or: $value.version),
  );

  @override
  AidokuBackupCopyWith<$R2, AidokuBackup, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AidokuBackupCopyWithImpl($value, $cast, t);
}

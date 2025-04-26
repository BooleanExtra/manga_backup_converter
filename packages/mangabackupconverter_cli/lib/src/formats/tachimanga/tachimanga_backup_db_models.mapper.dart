// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachimanga_backup_db_models.dart';

class TachimangaBackupTableMapper extends EnumMapper<TachimangaBackupTable> {
  TachimangaBackupTableMapper._();

  static TachimangaBackupTableMapper? _instance;
  static TachimangaBackupTableMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaBackupTableMapper._());
    }
    return _instance!;
  }

  static TachimangaBackupTable fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  TachimangaBackupTable decode(dynamic value) {
    switch (value) {
      case 'Category':
        return TachimangaBackupTable.category;
      case 'CategoryMeta':
        return TachimangaBackupTable.categoryMeta;
      case 'CategoryManga':
        return TachimangaBackupTable.categoryManga;
      case 'Chapter':
        return TachimangaBackupTable.chapter;
      case 'ChapterMeta':
        return TachimangaBackupTable.chapterMeta;
      case 'Extension':
        return TachimangaBackupTable.extension;
      case 'History':
        return TachimangaBackupTable.history;
      case 'Manga':
        return TachimangaBackupTable.manga;
      case 'MangaMeta':
        return TachimangaBackupTable.mangaMeta;
      case 'Migrations':
        return TachimangaBackupTable.migrations;
      case 'Page':
        return TachimangaBackupTable.page;
      case 'Repo':
        return TachimangaBackupTable.repo;
      case 'Setting':
        return TachimangaBackupTable.setting;
      case 'Source':
        return TachimangaBackupTable.source;
      case 'TrackRecord':
        return TachimangaBackupTable.trackRecord;
      case 'SqliteSequence':
        return TachimangaBackupTable.sqlite_sequence;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(TachimangaBackupTable self) {
    switch (self) {
      case TachimangaBackupTable.category:
        return 'Category';
      case TachimangaBackupTable.categoryMeta:
        return 'CategoryMeta';
      case TachimangaBackupTable.categoryManga:
        return 'CategoryManga';
      case TachimangaBackupTable.chapter:
        return 'Chapter';
      case TachimangaBackupTable.chapterMeta:
        return 'ChapterMeta';
      case TachimangaBackupTable.extension:
        return 'Extension';
      case TachimangaBackupTable.history:
        return 'History';
      case TachimangaBackupTable.manga:
        return 'Manga';
      case TachimangaBackupTable.mangaMeta:
        return 'MangaMeta';
      case TachimangaBackupTable.migrations:
        return 'Migrations';
      case TachimangaBackupTable.page:
        return 'Page';
      case TachimangaBackupTable.repo:
        return 'Repo';
      case TachimangaBackupTable.setting:
        return 'Setting';
      case TachimangaBackupTable.source:
        return 'Source';
      case TachimangaBackupTable.trackRecord:
        return 'TrackRecord';
      case TachimangaBackupTable.sqlite_sequence:
        return 'SqliteSequence';
    }
  }
}

extension TachimangaBackupTableMapperExtension on TachimangaBackupTable {
  String toValue() {
    TachimangaBackupTableMapper.ensureInitialized();
    return MapperContainer.globals.toValue<TachimangaBackupTable>(this)
        as String;
  }
}

class TachimangaBackupCategoryMapper
    extends ClassMapperBase<TachimangaBackupCategory> {
  TachimangaBackupCategoryMapper._();

  static TachimangaBackupCategoryMapper? _instance;
  static TachimangaBackupCategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupCategoryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupCategory';

  static int _$id(TachimangaBackupCategory v) => v.id;
  static const Field<TachimangaBackupCategory, int> _f$id = Field('id', _$id);
  static String _$name(TachimangaBackupCategory v) => v.name;
  static const Field<TachimangaBackupCategory, String> _f$name =
      Field('name', _$name);
  static int _$order(TachimangaBackupCategory v) => v.order;
  static const Field<TachimangaBackupCategory, int> _f$order =
      Field('order', _$order);
  static bool _$isDefault(TachimangaBackupCategory v) => v.isDefault;
  static const Field<TachimangaBackupCategory, bool> _f$isDefault =
      Field('isDefault', _$isDefault, key: r'is_default');

  @override
  final MappableFields<TachimangaBackupCategory> fields = const {
    #id: _f$id,
    #name: _f$name,
    #order: _f$order,
    #isDefault: _f$isDefault,
  };

  static TachimangaBackupCategory _instantiate(DecodingData data) {
    return TachimangaBackupCategory(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        order: data.dec(_f$order),
        isDefault: data.dec(_f$isDefault));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupCategory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupCategory>(map);
  }

  static TachimangaBackupCategory fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupCategory>(json);
  }
}

mixin TachimangaBackupCategoryMappable {
  String toJson() {
    return TachimangaBackupCategoryMapper.ensureInitialized()
        .encodeJson<TachimangaBackupCategory>(this as TachimangaBackupCategory);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupCategoryMapper.ensureInitialized()
        .encodeMap<TachimangaBackupCategory>(this as TachimangaBackupCategory);
  }

  TachimangaBackupCategoryCopyWith<TachimangaBackupCategory,
          TachimangaBackupCategory, TachimangaBackupCategory>
      get copyWith => _TachimangaBackupCategoryCopyWithImpl(
          this as TachimangaBackupCategory, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupCategoryMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupCategory);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupCategoryMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupCategory, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupCategoryMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupCategory);
  }
}

extension TachimangaBackupCategoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupCategory, $Out> {
  TachimangaBackupCategoryCopyWith<$R, TachimangaBackupCategory, $Out>
      get $asTachimangaBackupCategory => $base
          .as((v, t, t2) => _TachimangaBackupCategoryCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupCategoryCopyWith<
    $R,
    $In extends TachimangaBackupCategory,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? name, int? order, bool? isDefault});
  TachimangaBackupCategoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupCategoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupCategory, $Out>
    implements
        TachimangaBackupCategoryCopyWith<$R, TachimangaBackupCategory, $Out> {
  _TachimangaBackupCategoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupCategory> $mapper =
      TachimangaBackupCategoryMapper.ensureInitialized();
  @override
  $R call({int? id, String? name, int? order, bool? isDefault}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (order != null) #order: order,
        if (isDefault != null) #isDefault: isDefault
      }));
  @override
  TachimangaBackupCategory $make(CopyWithData data) => TachimangaBackupCategory(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      order: data.get(#order, or: $value.order),
      isDefault: data.get(#isDefault, or: $value.isDefault));

  @override
  TachimangaBackupCategoryCopyWith<$R2, TachimangaBackupCategory, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupCategoryCopyWithImpl($value, $cast, t);
}

class TachimangaBackupCategoryMangaMapper
    extends ClassMapperBase<TachimangaBackupCategoryManga> {
  TachimangaBackupCategoryMangaMapper._();

  static TachimangaBackupCategoryMangaMapper? _instance;
  static TachimangaBackupCategoryMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupCategoryMangaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupCategoryManga';

  static int _$id(TachimangaBackupCategoryManga v) => v.id;
  static const Field<TachimangaBackupCategoryManga, int> _f$id =
      Field('id', _$id);
  static int _$category(TachimangaBackupCategoryManga v) => v.category;
  static const Field<TachimangaBackupCategoryManga, int> _f$category =
      Field('category', _$category);
  static int _$manga(TachimangaBackupCategoryManga v) => v.manga;
  static const Field<TachimangaBackupCategoryManga, int> _f$manga =
      Field('manga', _$manga);

  @override
  final MappableFields<TachimangaBackupCategoryManga> fields = const {
    #id: _f$id,
    #category: _f$category,
    #manga: _f$manga,
  };

  static TachimangaBackupCategoryManga _instantiate(DecodingData data) {
    return TachimangaBackupCategoryManga(
        id: data.dec(_f$id),
        category: data.dec(_f$category),
        manga: data.dec(_f$manga));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupCategoryManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupCategoryManga>(map);
  }

  static TachimangaBackupCategoryManga fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupCategoryManga>(json);
  }
}

mixin TachimangaBackupCategoryMangaMappable {
  String toJson() {
    return TachimangaBackupCategoryMangaMapper.ensureInitialized()
        .encodeJson<TachimangaBackupCategoryManga>(
            this as TachimangaBackupCategoryManga);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupCategoryMangaMapper.ensureInitialized()
        .encodeMap<TachimangaBackupCategoryManga>(
            this as TachimangaBackupCategoryManga);
  }

  TachimangaBackupCategoryMangaCopyWith<TachimangaBackupCategoryManga,
          TachimangaBackupCategoryManga, TachimangaBackupCategoryManga>
      get copyWith => _TachimangaBackupCategoryMangaCopyWithImpl(
          this as TachimangaBackupCategoryManga, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupCategoryMangaMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupCategoryManga);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupCategoryMangaMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupCategoryManga, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupCategoryMangaMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupCategoryManga);
  }
}

extension TachimangaBackupCategoryMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupCategoryManga, $Out> {
  TachimangaBackupCategoryMangaCopyWith<$R, TachimangaBackupCategoryManga, $Out>
      get $asTachimangaBackupCategoryManga => $base.as(
          (v, t, t2) => _TachimangaBackupCategoryMangaCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupCategoryMangaCopyWith<
    $R,
    $In extends TachimangaBackupCategoryManga,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, int? category, int? manga});
  TachimangaBackupCategoryMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupCategoryMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupCategoryManga, $Out>
    implements
        TachimangaBackupCategoryMangaCopyWith<$R, TachimangaBackupCategoryManga,
            $Out> {
  _TachimangaBackupCategoryMangaCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupCategoryManga> $mapper =
      TachimangaBackupCategoryMangaMapper.ensureInitialized();
  @override
  $R call({int? id, int? category, int? manga}) => $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (category != null) #category: category,
        if (manga != null) #manga: manga
      }));
  @override
  TachimangaBackupCategoryManga $make(CopyWithData data) =>
      TachimangaBackupCategoryManga(
          id: data.get(#id, or: $value.id),
          category: data.get(#category, or: $value.category),
          manga: data.get(#manga, or: $value.manga));

  @override
  TachimangaBackupCategoryMangaCopyWith<$R2, TachimangaBackupCategoryManga,
      $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TachimangaBackupCategoryMangaCopyWithImpl($value, $cast, t);
}

class TachimangaBackupCategoryMetaMapper
    extends ClassMapperBase<TachimangaBackupCategoryMeta> {
  TachimangaBackupCategoryMetaMapper._();

  static TachimangaBackupCategoryMetaMapper? _instance;
  static TachimangaBackupCategoryMetaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupCategoryMetaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupCategoryMeta';

  static int _$id(TachimangaBackupCategoryMeta v) => v.id;
  static const Field<TachimangaBackupCategoryMeta, int> _f$id =
      Field('id', _$id);
  static String _$key(TachimangaBackupCategoryMeta v) => v.key;
  static const Field<TachimangaBackupCategoryMeta, String> _f$key =
      Field('key', _$key);
  static String _$value(TachimangaBackupCategoryMeta v) => v.value;
  static const Field<TachimangaBackupCategoryMeta, String> _f$value =
      Field('value', _$value);
  static int _$categoryRef(TachimangaBackupCategoryMeta v) => v.categoryRef;
  static const Field<TachimangaBackupCategoryMeta, int> _f$categoryRef =
      Field('categoryRef', _$categoryRef, key: r'category_ref');

  @override
  final MappableFields<TachimangaBackupCategoryMeta> fields = const {
    #id: _f$id,
    #key: _f$key,
    #value: _f$value,
    #categoryRef: _f$categoryRef,
  };

  static TachimangaBackupCategoryMeta _instantiate(DecodingData data) {
    return TachimangaBackupCategoryMeta(
        id: data.dec(_f$id),
        key: data.dec(_f$key),
        value: data.dec(_f$value),
        categoryRef: data.dec(_f$categoryRef));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupCategoryMeta fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupCategoryMeta>(map);
  }

  static TachimangaBackupCategoryMeta fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupCategoryMeta>(json);
  }
}

mixin TachimangaBackupCategoryMetaMappable {
  String toJson() {
    return TachimangaBackupCategoryMetaMapper.ensureInitialized()
        .encodeJson<TachimangaBackupCategoryMeta>(
            this as TachimangaBackupCategoryMeta);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupCategoryMetaMapper.ensureInitialized()
        .encodeMap<TachimangaBackupCategoryMeta>(
            this as TachimangaBackupCategoryMeta);
  }

  TachimangaBackupCategoryMetaCopyWith<TachimangaBackupCategoryMeta,
          TachimangaBackupCategoryMeta, TachimangaBackupCategoryMeta>
      get copyWith => _TachimangaBackupCategoryMetaCopyWithImpl(
          this as TachimangaBackupCategoryMeta, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupCategoryMetaMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupCategoryMeta);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupCategoryMetaMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupCategoryMeta, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupCategoryMetaMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupCategoryMeta);
  }
}

extension TachimangaBackupCategoryMetaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupCategoryMeta, $Out> {
  TachimangaBackupCategoryMetaCopyWith<$R, TachimangaBackupCategoryMeta, $Out>
      get $asTachimangaBackupCategoryMeta => $base.as(
          (v, t, t2) => _TachimangaBackupCategoryMetaCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupCategoryMetaCopyWith<
    $R,
    $In extends TachimangaBackupCategoryMeta,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? key, String? value, int? categoryRef});
  TachimangaBackupCategoryMetaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupCategoryMetaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupCategoryMeta, $Out>
    implements
        TachimangaBackupCategoryMetaCopyWith<$R, TachimangaBackupCategoryMeta,
            $Out> {
  _TachimangaBackupCategoryMetaCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupCategoryMeta> $mapper =
      TachimangaBackupCategoryMetaMapper.ensureInitialized();
  @override
  $R call({int? id, String? key, String? value, int? categoryRef}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (key != null) #key: key,
        if (value != null) #value: value,
        if (categoryRef != null) #categoryRef: categoryRef
      }));
  @override
  TachimangaBackupCategoryMeta $make(CopyWithData data) =>
      TachimangaBackupCategoryMeta(
          id: data.get(#id, or: $value.id),
          key: data.get(#key, or: $value.key),
          value: data.get(#value, or: $value.value),
          categoryRef: data.get(#categoryRef, or: $value.categoryRef));

  @override
  TachimangaBackupCategoryMetaCopyWith<$R2, TachimangaBackupCategoryMeta, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupCategoryMetaCopyWithImpl($value, $cast, t);
}

class TachimangaBackupChapterMapper
    extends ClassMapperBase<TachimangaBackupChapter> {
  TachimangaBackupChapterMapper._();

  static TachimangaBackupChapterMapper? _instance;
  static TachimangaBackupChapterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupChapterMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupChapter';

  static int _$id(TachimangaBackupChapter v) => v.id;
  static const Field<TachimangaBackupChapter, int> _f$id = Field('id', _$id);
  static String _$url(TachimangaBackupChapter v) => v.url;
  static const Field<TachimangaBackupChapter, String> _f$url =
      Field('url', _$url);
  static String _$name(TachimangaBackupChapter v) => v.name;
  static const Field<TachimangaBackupChapter, String> _f$name =
      Field('name', _$name);
  static int _$dateUpload(TachimangaBackupChapter v) => v.dateUpload;
  static const Field<TachimangaBackupChapter, int> _f$dateUpload =
      Field('dateUpload', _$dateUpload, key: r'date_upload');
  static double _$chapterNumber(TachimangaBackupChapter v) => v.chapterNumber;
  static const Field<TachimangaBackupChapter, double> _f$chapterNumber =
      Field('chapterNumber', _$chapterNumber, key: r'chapter_number');
  static String? _$scanlator(TachimangaBackupChapter v) => v.scanlator;
  static const Field<TachimangaBackupChapter, String> _f$scanlator =
      Field('scanlator', _$scanlator);
  static bool _$read(TachimangaBackupChapter v) => v.read;
  static const Field<TachimangaBackupChapter, bool> _f$read =
      Field('read', _$read);
  static bool _$bookmark(TachimangaBackupChapter v) => v.bookmark;
  static const Field<TachimangaBackupChapter, bool> _f$bookmark =
      Field('bookmark', _$bookmark);
  static int _$lastPageRead(TachimangaBackupChapter v) => v.lastPageRead;
  static const Field<TachimangaBackupChapter, int> _f$lastPageRead =
      Field('lastPageRead', _$lastPageRead, key: r'last_page_read');
  static int _$lastReadAt(TachimangaBackupChapter v) => v.lastReadAt;
  static const Field<TachimangaBackupChapter, int> _f$lastReadAt =
      Field('lastReadAt', _$lastReadAt, key: r'last_read_at');
  static int _$fetchedAt(TachimangaBackupChapter v) => v.fetchedAt;
  static const Field<TachimangaBackupChapter, int> _f$fetchedAt =
      Field('fetchedAt', _$fetchedAt, key: r'fetched_at');
  static int _$sourceOrder(TachimangaBackupChapter v) => v.sourceOrder;
  static const Field<TachimangaBackupChapter, int> _f$sourceOrder =
      Field('sourceOrder', _$sourceOrder, key: r'source_order');
  static String? _$realUrl(TachimangaBackupChapter v) => v.realUrl;
  static const Field<TachimangaBackupChapter, String> _f$realUrl =
      Field('realUrl', _$realUrl, key: r'real_url');
  static bool _$isDownloaded(TachimangaBackupChapter v) => v.isDownloaded;
  static const Field<TachimangaBackupChapter, bool> _f$isDownloaded =
      Field('isDownloaded', _$isDownloaded, key: r'is_downloaded');
  static int _$pageCount(TachimangaBackupChapter v) => v.pageCount;
  static const Field<TachimangaBackupChapter, int> _f$pageCount =
      Field('pageCount', _$pageCount, key: r'page_count');
  static int _$manga(TachimangaBackupChapter v) => v.manga;
  static const Field<TachimangaBackupChapter, int> _f$manga =
      Field('manga', _$manga);

  @override
  final MappableFields<TachimangaBackupChapter> fields = const {
    #id: _f$id,
    #url: _f$url,
    #name: _f$name,
    #dateUpload: _f$dateUpload,
    #chapterNumber: _f$chapterNumber,
    #scanlator: _f$scanlator,
    #read: _f$read,
    #bookmark: _f$bookmark,
    #lastPageRead: _f$lastPageRead,
    #lastReadAt: _f$lastReadAt,
    #fetchedAt: _f$fetchedAt,
    #sourceOrder: _f$sourceOrder,
    #realUrl: _f$realUrl,
    #isDownloaded: _f$isDownloaded,
    #pageCount: _f$pageCount,
    #manga: _f$manga,
  };

  static TachimangaBackupChapter _instantiate(DecodingData data) {
    return TachimangaBackupChapter(
        id: data.dec(_f$id),
        url: data.dec(_f$url),
        name: data.dec(_f$name),
        dateUpload: data.dec(_f$dateUpload),
        chapterNumber: data.dec(_f$chapterNumber),
        scanlator: data.dec(_f$scanlator),
        read: data.dec(_f$read),
        bookmark: data.dec(_f$bookmark),
        lastPageRead: data.dec(_f$lastPageRead),
        lastReadAt: data.dec(_f$lastReadAt),
        fetchedAt: data.dec(_f$fetchedAt),
        sourceOrder: data.dec(_f$sourceOrder),
        realUrl: data.dec(_f$realUrl),
        isDownloaded: data.dec(_f$isDownloaded),
        pageCount: data.dec(_f$pageCount),
        manga: data.dec(_f$manga));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupChapter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupChapter>(map);
  }

  static TachimangaBackupChapter fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupChapter>(json);
  }
}

mixin TachimangaBackupChapterMappable {
  String toJson() {
    return TachimangaBackupChapterMapper.ensureInitialized()
        .encodeJson<TachimangaBackupChapter>(this as TachimangaBackupChapter);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupChapterMapper.ensureInitialized()
        .encodeMap<TachimangaBackupChapter>(this as TachimangaBackupChapter);
  }

  TachimangaBackupChapterCopyWith<TachimangaBackupChapter,
          TachimangaBackupChapter, TachimangaBackupChapter>
      get copyWith => _TachimangaBackupChapterCopyWithImpl(
          this as TachimangaBackupChapter, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupChapterMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupChapter);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupChapterMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupChapter, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupChapterMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupChapter);
  }
}

extension TachimangaBackupChapterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupChapter, $Out> {
  TachimangaBackupChapterCopyWith<$R, TachimangaBackupChapter, $Out>
      get $asTachimangaBackupChapter => $base
          .as((v, t, t2) => _TachimangaBackupChapterCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupChapterCopyWith<
    $R,
    $In extends TachimangaBackupChapter,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      String? url,
      String? name,
      int? dateUpload,
      double? chapterNumber,
      String? scanlator,
      bool? read,
      bool? bookmark,
      int? lastPageRead,
      int? lastReadAt,
      int? fetchedAt,
      int? sourceOrder,
      String? realUrl,
      bool? isDownloaded,
      int? pageCount,
      int? manga});
  TachimangaBackupChapterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupChapterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupChapter, $Out>
    implements
        TachimangaBackupChapterCopyWith<$R, TachimangaBackupChapter, $Out> {
  _TachimangaBackupChapterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupChapter> $mapper =
      TachimangaBackupChapterMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          String? url,
          String? name,
          int? dateUpload,
          double? chapterNumber,
          Object? scanlator = $none,
          bool? read,
          bool? bookmark,
          int? lastPageRead,
          int? lastReadAt,
          int? fetchedAt,
          int? sourceOrder,
          Object? realUrl = $none,
          bool? isDownloaded,
          int? pageCount,
          int? manga}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (url != null) #url: url,
        if (name != null) #name: name,
        if (dateUpload != null) #dateUpload: dateUpload,
        if (chapterNumber != null) #chapterNumber: chapterNumber,
        if (scanlator != $none) #scanlator: scanlator,
        if (read != null) #read: read,
        if (bookmark != null) #bookmark: bookmark,
        if (lastPageRead != null) #lastPageRead: lastPageRead,
        if (lastReadAt != null) #lastReadAt: lastReadAt,
        if (fetchedAt != null) #fetchedAt: fetchedAt,
        if (sourceOrder != null) #sourceOrder: sourceOrder,
        if (realUrl != $none) #realUrl: realUrl,
        if (isDownloaded != null) #isDownloaded: isDownloaded,
        if (pageCount != null) #pageCount: pageCount,
        if (manga != null) #manga: manga
      }));
  @override
  TachimangaBackupChapter $make(CopyWithData data) => TachimangaBackupChapter(
      id: data.get(#id, or: $value.id),
      url: data.get(#url, or: $value.url),
      name: data.get(#name, or: $value.name),
      dateUpload: data.get(#dateUpload, or: $value.dateUpload),
      chapterNumber: data.get(#chapterNumber, or: $value.chapterNumber),
      scanlator: data.get(#scanlator, or: $value.scanlator),
      read: data.get(#read, or: $value.read),
      bookmark: data.get(#bookmark, or: $value.bookmark),
      lastPageRead: data.get(#lastPageRead, or: $value.lastPageRead),
      lastReadAt: data.get(#lastReadAt, or: $value.lastReadAt),
      fetchedAt: data.get(#fetchedAt, or: $value.fetchedAt),
      sourceOrder: data.get(#sourceOrder, or: $value.sourceOrder),
      realUrl: data.get(#realUrl, or: $value.realUrl),
      isDownloaded: data.get(#isDownloaded, or: $value.isDownloaded),
      pageCount: data.get(#pageCount, or: $value.pageCount),
      manga: data.get(#manga, or: $value.manga));

  @override
  TachimangaBackupChapterCopyWith<$R2, TachimangaBackupChapter, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupChapterCopyWithImpl($value, $cast, t);
}

class TachimangaBackupChapterMetaMapper
    extends ClassMapperBase<TachimangaBackupChapterMeta> {
  TachimangaBackupChapterMetaMapper._();

  static TachimangaBackupChapterMetaMapper? _instance;
  static TachimangaBackupChapterMetaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupChapterMetaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupChapterMeta';

  static int _$id(TachimangaBackupChapterMeta v) => v.id;
  static const Field<TachimangaBackupChapterMeta, int> _f$id =
      Field('id', _$id);
  static String _$key(TachimangaBackupChapterMeta v) => v.key;
  static const Field<TachimangaBackupChapterMeta, String> _f$key =
      Field('key', _$key);
  static String _$value(TachimangaBackupChapterMeta v) => v.value;
  static const Field<TachimangaBackupChapterMeta, String> _f$value =
      Field('value', _$value);
  static int _$chapterRef(TachimangaBackupChapterMeta v) => v.chapterRef;
  static const Field<TachimangaBackupChapterMeta, int> _f$chapterRef =
      Field('chapterRef', _$chapterRef, key: r'chapter_ref');

  @override
  final MappableFields<TachimangaBackupChapterMeta> fields = const {
    #id: _f$id,
    #key: _f$key,
    #value: _f$value,
    #chapterRef: _f$chapterRef,
  };

  static TachimangaBackupChapterMeta _instantiate(DecodingData data) {
    return TachimangaBackupChapterMeta(
        id: data.dec(_f$id),
        key: data.dec(_f$key),
        value: data.dec(_f$value),
        chapterRef: data.dec(_f$chapterRef));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupChapterMeta fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupChapterMeta>(map);
  }

  static TachimangaBackupChapterMeta fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupChapterMeta>(json);
  }
}

mixin TachimangaBackupChapterMetaMappable {
  String toJson() {
    return TachimangaBackupChapterMetaMapper.ensureInitialized()
        .encodeJson<TachimangaBackupChapterMeta>(
            this as TachimangaBackupChapterMeta);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupChapterMetaMapper.ensureInitialized()
        .encodeMap<TachimangaBackupChapterMeta>(
            this as TachimangaBackupChapterMeta);
  }

  TachimangaBackupChapterMetaCopyWith<TachimangaBackupChapterMeta,
          TachimangaBackupChapterMeta, TachimangaBackupChapterMeta>
      get copyWith => _TachimangaBackupChapterMetaCopyWithImpl(
          this as TachimangaBackupChapterMeta, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupChapterMetaMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupChapterMeta);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupChapterMetaMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupChapterMeta, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupChapterMetaMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupChapterMeta);
  }
}

extension TachimangaBackupChapterMetaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupChapterMeta, $Out> {
  TachimangaBackupChapterMetaCopyWith<$R, TachimangaBackupChapterMeta, $Out>
      get $asTachimangaBackupChapterMeta => $base
          .as((v, t, t2) => _TachimangaBackupChapterMetaCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupChapterMetaCopyWith<
    $R,
    $In extends TachimangaBackupChapterMeta,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? key, String? value, int? chapterRef});
  TachimangaBackupChapterMetaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupChapterMetaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupChapterMeta, $Out>
    implements
        TachimangaBackupChapterMetaCopyWith<$R, TachimangaBackupChapterMeta,
            $Out> {
  _TachimangaBackupChapterMetaCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupChapterMeta> $mapper =
      TachimangaBackupChapterMetaMapper.ensureInitialized();
  @override
  $R call({int? id, String? key, String? value, int? chapterRef}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (key != null) #key: key,
        if (value != null) #value: value,
        if (chapterRef != null) #chapterRef: chapterRef
      }));
  @override
  TachimangaBackupChapterMeta $make(CopyWithData data) =>
      TachimangaBackupChapterMeta(
          id: data.get(#id, or: $value.id),
          key: data.get(#key, or: $value.key),
          value: data.get(#value, or: $value.value),
          chapterRef: data.get(#chapterRef, or: $value.chapterRef));

  @override
  TachimangaBackupChapterMetaCopyWith<$R2, TachimangaBackupChapterMeta, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupChapterMetaCopyWithImpl($value, $cast, t);
}

class TachimangaBackupExtensionMapper
    extends ClassMapperBase<TachimangaBackupExtension> {
  TachimangaBackupExtensionMapper._();

  static TachimangaBackupExtensionMapper? _instance;
  static TachimangaBackupExtensionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupExtensionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupExtension';

  static int _$id(TachimangaBackupExtension v) => v.id;
  static const Field<TachimangaBackupExtension, int> _f$id = Field('id', _$id);
  static String _$apkName(TachimangaBackupExtension v) => v.apkName;
  static const Field<TachimangaBackupExtension, String> _f$apkName =
      Field('apkName', _$apkName, key: r'apk_name');
  static String _$iconUrl(TachimangaBackupExtension v) => v.iconUrl;
  static const Field<TachimangaBackupExtension, String> _f$iconUrl =
      Field('iconUrl', _$iconUrl, key: r'icon_url');
  static String _$name(TachimangaBackupExtension v) => v.name;
  static const Field<TachimangaBackupExtension, String> _f$name =
      Field('name', _$name);
  static String _$pkgName(TachimangaBackupExtension v) => v.pkgName;
  static const Field<TachimangaBackupExtension, String> _f$pkgName =
      Field('pkgName', _$pkgName, key: r'pkg_name');
  static String _$versionName(TachimangaBackupExtension v) => v.versionName;
  static const Field<TachimangaBackupExtension, String> _f$versionName =
      Field('versionName', _$versionName, key: r'version_name');
  static int _$versionCode(TachimangaBackupExtension v) => v.versionCode;
  static const Field<TachimangaBackupExtension, int> _f$versionCode =
      Field('versionCode', _$versionCode, key: r'version_code');
  static String _$lang(TachimangaBackupExtension v) => v.lang;
  static const Field<TachimangaBackupExtension, String> _f$lang =
      Field('lang', _$lang);
  static bool _$isNsfw(TachimangaBackupExtension v) => v.isNsfw;
  static const Field<TachimangaBackupExtension, bool> _f$isNsfw =
      Field('isNsfw', _$isNsfw, key: r'is_nsfw');
  static bool _$isInstalled(TachimangaBackupExtension v) => v.isInstalled;
  static const Field<TachimangaBackupExtension, bool> _f$isInstalled =
      Field('isInstalled', _$isInstalled, key: r'is_installed');
  static bool _$hasUpdate(TachimangaBackupExtension v) => v.hasUpdate;
  static const Field<TachimangaBackupExtension, bool> _f$hasUpdate =
      Field('hasUpdate', _$hasUpdate, key: r'has_update');
  static bool _$isObsolete(TachimangaBackupExtension v) => v.isObsolete;
  static const Field<TachimangaBackupExtension, bool> _f$isObsolete =
      Field('isObsolete', _$isObsolete, key: r'is_obsolete');
  static String _$className(TachimangaBackupExtension v) => v.className;
  static const Field<TachimangaBackupExtension, String> _f$className =
      Field('className', _$className, key: r'class_name');
  static String? _$pkgFactory(TachimangaBackupExtension v) => v.pkgFactory;
  static const Field<TachimangaBackupExtension, String> _f$pkgFactory =
      Field('pkgFactory', _$pkgFactory, key: r'pkg_factory');
  static bool _$hasChangelog(TachimangaBackupExtension v) => v.hasChangelog;
  static const Field<TachimangaBackupExtension, bool> _f$hasChangelog =
      Field('hasChangelog', _$hasChangelog, key: r'has_changelog');
  static bool _$hasReadme(TachimangaBackupExtension v) => v.hasReadme;
  static const Field<TachimangaBackupExtension, bool> _f$hasReadme =
      Field('hasReadme', _$hasReadme, key: r'has_readme');
  static int _$repoId(TachimangaBackupExtension v) => v.repoId;
  static const Field<TachimangaBackupExtension, int> _f$repoId =
      Field('repoId', _$repoId, key: r'repo_id');

  @override
  final MappableFields<TachimangaBackupExtension> fields = const {
    #id: _f$id,
    #apkName: _f$apkName,
    #iconUrl: _f$iconUrl,
    #name: _f$name,
    #pkgName: _f$pkgName,
    #versionName: _f$versionName,
    #versionCode: _f$versionCode,
    #lang: _f$lang,
    #isNsfw: _f$isNsfw,
    #isInstalled: _f$isInstalled,
    #hasUpdate: _f$hasUpdate,
    #isObsolete: _f$isObsolete,
    #className: _f$className,
    #pkgFactory: _f$pkgFactory,
    #hasChangelog: _f$hasChangelog,
    #hasReadme: _f$hasReadme,
    #repoId: _f$repoId,
  };

  static TachimangaBackupExtension _instantiate(DecodingData data) {
    return TachimangaBackupExtension(
        id: data.dec(_f$id),
        apkName: data.dec(_f$apkName),
        iconUrl: data.dec(_f$iconUrl),
        name: data.dec(_f$name),
        pkgName: data.dec(_f$pkgName),
        versionName: data.dec(_f$versionName),
        versionCode: data.dec(_f$versionCode),
        lang: data.dec(_f$lang),
        isNsfw: data.dec(_f$isNsfw),
        isInstalled: data.dec(_f$isInstalled),
        hasUpdate: data.dec(_f$hasUpdate),
        isObsolete: data.dec(_f$isObsolete),
        className: data.dec(_f$className),
        pkgFactory: data.dec(_f$pkgFactory),
        hasChangelog: data.dec(_f$hasChangelog),
        hasReadme: data.dec(_f$hasReadme),
        repoId: data.dec(_f$repoId));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupExtension fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupExtension>(map);
  }

  static TachimangaBackupExtension fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupExtension>(json);
  }
}

mixin TachimangaBackupExtensionMappable {
  String toJson() {
    return TachimangaBackupExtensionMapper.ensureInitialized()
        .encodeJson<TachimangaBackupExtension>(
            this as TachimangaBackupExtension);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupExtensionMapper.ensureInitialized()
        .encodeMap<TachimangaBackupExtension>(
            this as TachimangaBackupExtension);
  }

  TachimangaBackupExtensionCopyWith<TachimangaBackupExtension,
          TachimangaBackupExtension, TachimangaBackupExtension>
      get copyWith => _TachimangaBackupExtensionCopyWithImpl(
          this as TachimangaBackupExtension, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupExtensionMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupExtension);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupExtensionMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupExtension, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupExtensionMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupExtension);
  }
}

extension TachimangaBackupExtensionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupExtension, $Out> {
  TachimangaBackupExtensionCopyWith<$R, TachimangaBackupExtension, $Out>
      get $asTachimangaBackupExtension => $base
          .as((v, t, t2) => _TachimangaBackupExtensionCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupExtensionCopyWith<
    $R,
    $In extends TachimangaBackupExtension,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      String? apkName,
      String? iconUrl,
      String? name,
      String? pkgName,
      String? versionName,
      int? versionCode,
      String? lang,
      bool? isNsfw,
      bool? isInstalled,
      bool? hasUpdate,
      bool? isObsolete,
      String? className,
      String? pkgFactory,
      bool? hasChangelog,
      bool? hasReadme,
      int? repoId});
  TachimangaBackupExtensionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupExtensionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupExtension, $Out>
    implements
        TachimangaBackupExtensionCopyWith<$R, TachimangaBackupExtension, $Out> {
  _TachimangaBackupExtensionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupExtension> $mapper =
      TachimangaBackupExtensionMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          String? apkName,
          String? iconUrl,
          String? name,
          String? pkgName,
          String? versionName,
          int? versionCode,
          String? lang,
          bool? isNsfw,
          bool? isInstalled,
          bool? hasUpdate,
          bool? isObsolete,
          String? className,
          Object? pkgFactory = $none,
          bool? hasChangelog,
          bool? hasReadme,
          int? repoId}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (apkName != null) #apkName: apkName,
        if (iconUrl != null) #iconUrl: iconUrl,
        if (name != null) #name: name,
        if (pkgName != null) #pkgName: pkgName,
        if (versionName != null) #versionName: versionName,
        if (versionCode != null) #versionCode: versionCode,
        if (lang != null) #lang: lang,
        if (isNsfw != null) #isNsfw: isNsfw,
        if (isInstalled != null) #isInstalled: isInstalled,
        if (hasUpdate != null) #hasUpdate: hasUpdate,
        if (isObsolete != null) #isObsolete: isObsolete,
        if (className != null) #className: className,
        if (pkgFactory != $none) #pkgFactory: pkgFactory,
        if (hasChangelog != null) #hasChangelog: hasChangelog,
        if (hasReadme != null) #hasReadme: hasReadme,
        if (repoId != null) #repoId: repoId
      }));
  @override
  TachimangaBackupExtension $make(CopyWithData data) =>
      TachimangaBackupExtension(
          id: data.get(#id, or: $value.id),
          apkName: data.get(#apkName, or: $value.apkName),
          iconUrl: data.get(#iconUrl, or: $value.iconUrl),
          name: data.get(#name, or: $value.name),
          pkgName: data.get(#pkgName, or: $value.pkgName),
          versionName: data.get(#versionName, or: $value.versionName),
          versionCode: data.get(#versionCode, or: $value.versionCode),
          lang: data.get(#lang, or: $value.lang),
          isNsfw: data.get(#isNsfw, or: $value.isNsfw),
          isInstalled: data.get(#isInstalled, or: $value.isInstalled),
          hasUpdate: data.get(#hasUpdate, or: $value.hasUpdate),
          isObsolete: data.get(#isObsolete, or: $value.isObsolete),
          className: data.get(#className, or: $value.className),
          pkgFactory: data.get(#pkgFactory, or: $value.pkgFactory),
          hasChangelog: data.get(#hasChangelog, or: $value.hasChangelog),
          hasReadme: data.get(#hasReadme, or: $value.hasReadme),
          repoId: data.get(#repoId, or: $value.repoId));

  @override
  TachimangaBackupExtensionCopyWith<$R2, TachimangaBackupExtension, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupExtensionCopyWithImpl($value, $cast, t);
}

class TachimangaBackupHistoryMapper
    extends ClassMapperBase<TachimangaBackupHistory> {
  TachimangaBackupHistoryMapper._();

  static TachimangaBackupHistoryMapper? _instance;
  static TachimangaBackupHistoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupHistoryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupHistory';

  static int _$id(TachimangaBackupHistory v) => v.id;
  static const Field<TachimangaBackupHistory, int> _f$id = Field('id', _$id);
  static int _$createAt(TachimangaBackupHistory v) => v.createAt;
  static const Field<TachimangaBackupHistory, int> _f$createAt =
      Field('createAt', _$createAt, key: r'create_at');
  static bool _$isDelete(TachimangaBackupHistory v) => v.isDelete;
  static const Field<TachimangaBackupHistory, bool> _f$isDelete =
      Field('isDelete', _$isDelete, key: r'is_delete');
  static int _$mangaId(TachimangaBackupHistory v) => v.mangaId;
  static const Field<TachimangaBackupHistory, int> _f$mangaId =
      Field('mangaId', _$mangaId, key: r'manga_id');
  static int _$lastChapterId(TachimangaBackupHistory v) => v.lastChapterId;
  static const Field<TachimangaBackupHistory, int> _f$lastChapterId =
      Field('lastChapterId', _$lastChapterId, key: r'last_chapter_id');
  static int _$lastReadAt(TachimangaBackupHistory v) => v.lastReadAt;
  static const Field<TachimangaBackupHistory, int> _f$lastReadAt =
      Field('lastReadAt', _$lastReadAt, key: r'last_read_at');

  @override
  final MappableFields<TachimangaBackupHistory> fields = const {
    #id: _f$id,
    #createAt: _f$createAt,
    #isDelete: _f$isDelete,
    #mangaId: _f$mangaId,
    #lastChapterId: _f$lastChapterId,
    #lastReadAt: _f$lastReadAt,
  };

  static TachimangaBackupHistory _instantiate(DecodingData data) {
    return TachimangaBackupHistory(
        id: data.dec(_f$id),
        createAt: data.dec(_f$createAt),
        isDelete: data.dec(_f$isDelete),
        mangaId: data.dec(_f$mangaId),
        lastChapterId: data.dec(_f$lastChapterId),
        lastReadAt: data.dec(_f$lastReadAt));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupHistory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupHistory>(map);
  }

  static TachimangaBackupHistory fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupHistory>(json);
  }
}

mixin TachimangaBackupHistoryMappable {
  String toJson() {
    return TachimangaBackupHistoryMapper.ensureInitialized()
        .encodeJson<TachimangaBackupHistory>(this as TachimangaBackupHistory);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupHistoryMapper.ensureInitialized()
        .encodeMap<TachimangaBackupHistory>(this as TachimangaBackupHistory);
  }

  TachimangaBackupHistoryCopyWith<TachimangaBackupHistory,
          TachimangaBackupHistory, TachimangaBackupHistory>
      get copyWith => _TachimangaBackupHistoryCopyWithImpl(
          this as TachimangaBackupHistory, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupHistoryMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupHistory);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupHistoryMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupHistory, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupHistoryMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupHistory);
  }
}

extension TachimangaBackupHistoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupHistory, $Out> {
  TachimangaBackupHistoryCopyWith<$R, TachimangaBackupHistory, $Out>
      get $asTachimangaBackupHistory => $base
          .as((v, t, t2) => _TachimangaBackupHistoryCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupHistoryCopyWith<
    $R,
    $In extends TachimangaBackupHistory,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      int? createAt,
      bool? isDelete,
      int? mangaId,
      int? lastChapterId,
      int? lastReadAt});
  TachimangaBackupHistoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupHistoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupHistory, $Out>
    implements
        TachimangaBackupHistoryCopyWith<$R, TachimangaBackupHistory, $Out> {
  _TachimangaBackupHistoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupHistory> $mapper =
      TachimangaBackupHistoryMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          int? createAt,
          bool? isDelete,
          int? mangaId,
          int? lastChapterId,
          int? lastReadAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createAt != null) #createAt: createAt,
        if (isDelete != null) #isDelete: isDelete,
        if (mangaId != null) #mangaId: mangaId,
        if (lastChapterId != null) #lastChapterId: lastChapterId,
        if (lastReadAt != null) #lastReadAt: lastReadAt
      }));
  @override
  TachimangaBackupHistory $make(CopyWithData data) => TachimangaBackupHistory(
      id: data.get(#id, or: $value.id),
      createAt: data.get(#createAt, or: $value.createAt),
      isDelete: data.get(#isDelete, or: $value.isDelete),
      mangaId: data.get(#mangaId, or: $value.mangaId),
      lastChapterId: data.get(#lastChapterId, or: $value.lastChapterId),
      lastReadAt: data.get(#lastReadAt, or: $value.lastReadAt));

  @override
  TachimangaBackupHistoryCopyWith<$R2, TachimangaBackupHistory, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupHistoryCopyWithImpl($value, $cast, t);
}

class TachimangaBackupMangaMapper
    extends ClassMapperBase<TachimangaBackupManga> {
  TachimangaBackupMangaMapper._();

  static TachimangaBackupMangaMapper? _instance;
  static TachimangaBackupMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaBackupMangaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupManga';

  static int _$id(TachimangaBackupManga v) => v.id;
  static const Field<TachimangaBackupManga, int> _f$id = Field('id', _$id);
  static String _$url(TachimangaBackupManga v) => v.url;
  static const Field<TachimangaBackupManga, String> _f$url =
      Field('url', _$url);
  static String _$title(TachimangaBackupManga v) => v.title;
  static const Field<TachimangaBackupManga, String> _f$title =
      Field('title', _$title);
  static bool _$initialized(TachimangaBackupManga v) => v.initialized;
  static const Field<TachimangaBackupManga, bool> _f$initialized =
      Field('initialized', _$initialized);
  static String? _$artist(TachimangaBackupManga v) => v.artist;
  static const Field<TachimangaBackupManga, String> _f$artist =
      Field('artist', _$artist);
  static String? _$author(TachimangaBackupManga v) => v.author;
  static const Field<TachimangaBackupManga, String> _f$author =
      Field('author', _$author);
  static String? _$description(TachimangaBackupManga v) => v.description;
  static const Field<TachimangaBackupManga, String> _f$description =
      Field('description', _$description);
  static String? _$genre(TachimangaBackupManga v) => v.genre;
  static const Field<TachimangaBackupManga, String> _f$genre =
      Field('genre', _$genre);
  static int _$status(TachimangaBackupManga v) => v.status;
  static const Field<TachimangaBackupManga, int> _f$status =
      Field('status', _$status);
  static String? _$thumbnailUrl(TachimangaBackupManga v) => v.thumbnailUrl;
  static const Field<TachimangaBackupManga, String> _f$thumbnailUrl =
      Field('thumbnailUrl', _$thumbnailUrl, key: r'thumbnail_url');
  static int _$thumbnailUrlLastFetched(TachimangaBackupManga v) =>
      v.thumbnailUrlLastFetched;
  static const Field<TachimangaBackupManga, int> _f$thumbnailUrlLastFetched =
      Field('thumbnailUrlLastFetched', _$thumbnailUrlLastFetched,
          key: r'thumbnail_url_last_fetched');
  static bool _$inLibrary(TachimangaBackupManga v) => v.inLibrary;
  static const Field<TachimangaBackupManga, bool> _f$inLibrary =
      Field('inLibrary', _$inLibrary, key: r'in_library');
  static bool _$defaultCategory(TachimangaBackupManga v) => v.defaultCategory;
  static const Field<TachimangaBackupManga, bool> _f$defaultCategory =
      Field('defaultCategory', _$defaultCategory, key: r'default_category');
  static int _$inLibraryAt(TachimangaBackupManga v) => v.inLibraryAt;
  static const Field<TachimangaBackupManga, int> _f$inLibraryAt =
      Field('inLibraryAt', _$inLibraryAt, key: r'in_library_at');
  static int _$source(TachimangaBackupManga v) => v.source;
  static const Field<TachimangaBackupManga, int> _f$source =
      Field('source', _$source);
  static String? _$realUrl(TachimangaBackupManga v) => v.realUrl;
  static const Field<TachimangaBackupManga, String> _f$realUrl =
      Field('realUrl', _$realUrl, key: r'real_url');
  static int _$lastFetchedAt(TachimangaBackupManga v) => v.lastFetchedAt;
  static const Field<TachimangaBackupManga, int> _f$lastFetchedAt =
      Field('lastFetchedAt', _$lastFetchedAt, key: r'last_fetched_at');
  static int _$chaptersLastFetchedAt(TachimangaBackupManga v) =>
      v.chaptersLastFetchedAt;
  static const Field<TachimangaBackupManga, int> _f$chaptersLastFetchedAt =
      Field('chaptersLastFetchedAt', _$chaptersLastFetchedAt,
          key: r'chapters_last_fetched_at');
  static String _$updateStrategy(TachimangaBackupManga v) => v.updateStrategy;
  static const Field<TachimangaBackupManga, String> _f$updateStrategy =
      Field('updateStrategy', _$updateStrategy, key: r'update_strategy');
  static int _$lastDownloadAt(TachimangaBackupManga v) => v.lastDownloadAt;
  static const Field<TachimangaBackupManga, int> _f$lastDownloadAt =
      Field('lastDownloadAt', _$lastDownloadAt, key: r'last_download_at');

  @override
  final MappableFields<TachimangaBackupManga> fields = const {
    #id: _f$id,
    #url: _f$url,
    #title: _f$title,
    #initialized: _f$initialized,
    #artist: _f$artist,
    #author: _f$author,
    #description: _f$description,
    #genre: _f$genre,
    #status: _f$status,
    #thumbnailUrl: _f$thumbnailUrl,
    #thumbnailUrlLastFetched: _f$thumbnailUrlLastFetched,
    #inLibrary: _f$inLibrary,
    #defaultCategory: _f$defaultCategory,
    #inLibraryAt: _f$inLibraryAt,
    #source: _f$source,
    #realUrl: _f$realUrl,
    #lastFetchedAt: _f$lastFetchedAt,
    #chaptersLastFetchedAt: _f$chaptersLastFetchedAt,
    #updateStrategy: _f$updateStrategy,
    #lastDownloadAt: _f$lastDownloadAt,
  };

  static TachimangaBackupManga _instantiate(DecodingData data) {
    return TachimangaBackupManga(
        id: data.dec(_f$id),
        url: data.dec(_f$url),
        title: data.dec(_f$title),
        initialized: data.dec(_f$initialized),
        artist: data.dec(_f$artist),
        author: data.dec(_f$author),
        description: data.dec(_f$description),
        genre: data.dec(_f$genre),
        status: data.dec(_f$status),
        thumbnailUrl: data.dec(_f$thumbnailUrl),
        thumbnailUrlLastFetched: data.dec(_f$thumbnailUrlLastFetched),
        inLibrary: data.dec(_f$inLibrary),
        defaultCategory: data.dec(_f$defaultCategory),
        inLibraryAt: data.dec(_f$inLibraryAt),
        source: data.dec(_f$source),
        realUrl: data.dec(_f$realUrl),
        lastFetchedAt: data.dec(_f$lastFetchedAt),
        chaptersLastFetchedAt: data.dec(_f$chaptersLastFetchedAt),
        updateStrategy: data.dec(_f$updateStrategy),
        lastDownloadAt: data.dec(_f$lastDownloadAt));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupManga>(map);
  }

  static TachimangaBackupManga fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupManga>(json);
  }
}

mixin TachimangaBackupMangaMappable {
  String toJson() {
    return TachimangaBackupMangaMapper.ensureInitialized()
        .encodeJson<TachimangaBackupManga>(this as TachimangaBackupManga);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupMangaMapper.ensureInitialized()
        .encodeMap<TachimangaBackupManga>(this as TachimangaBackupManga);
  }

  TachimangaBackupMangaCopyWith<TachimangaBackupManga, TachimangaBackupManga,
          TachimangaBackupManga>
      get copyWith => _TachimangaBackupMangaCopyWithImpl(
          this as TachimangaBackupManga, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupMangaMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupManga);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupMangaMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupManga, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupMangaMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupManga);
  }
}

extension TachimangaBackupMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupManga, $Out> {
  TachimangaBackupMangaCopyWith<$R, TachimangaBackupManga, $Out>
      get $asTachimangaBackupManga =>
          $base.as((v, t, t2) => _TachimangaBackupMangaCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupMangaCopyWith<
    $R,
    $In extends TachimangaBackupManga,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      String? url,
      String? title,
      bool? initialized,
      String? artist,
      String? author,
      String? description,
      String? genre,
      int? status,
      String? thumbnailUrl,
      int? thumbnailUrlLastFetched,
      bool? inLibrary,
      bool? defaultCategory,
      int? inLibraryAt,
      int? source,
      String? realUrl,
      int? lastFetchedAt,
      int? chaptersLastFetchedAt,
      String? updateStrategy,
      int? lastDownloadAt});
  TachimangaBackupMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupManga, $Out>
    implements TachimangaBackupMangaCopyWith<$R, TachimangaBackupManga, $Out> {
  _TachimangaBackupMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupManga> $mapper =
      TachimangaBackupMangaMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          String? url,
          String? title,
          bool? initialized,
          Object? artist = $none,
          Object? author = $none,
          Object? description = $none,
          Object? genre = $none,
          int? status,
          Object? thumbnailUrl = $none,
          int? thumbnailUrlLastFetched,
          bool? inLibrary,
          bool? defaultCategory,
          int? inLibraryAt,
          int? source,
          Object? realUrl = $none,
          int? lastFetchedAt,
          int? chaptersLastFetchedAt,
          String? updateStrategy,
          int? lastDownloadAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (url != null) #url: url,
        if (title != null) #title: title,
        if (initialized != null) #initialized: initialized,
        if (artist != $none) #artist: artist,
        if (author != $none) #author: author,
        if (description != $none) #description: description,
        if (genre != $none) #genre: genre,
        if (status != null) #status: status,
        if (thumbnailUrl != $none) #thumbnailUrl: thumbnailUrl,
        if (thumbnailUrlLastFetched != null)
          #thumbnailUrlLastFetched: thumbnailUrlLastFetched,
        if (inLibrary != null) #inLibrary: inLibrary,
        if (defaultCategory != null) #defaultCategory: defaultCategory,
        if (inLibraryAt != null) #inLibraryAt: inLibraryAt,
        if (source != null) #source: source,
        if (realUrl != $none) #realUrl: realUrl,
        if (lastFetchedAt != null) #lastFetchedAt: lastFetchedAt,
        if (chaptersLastFetchedAt != null)
          #chaptersLastFetchedAt: chaptersLastFetchedAt,
        if (updateStrategy != null) #updateStrategy: updateStrategy,
        if (lastDownloadAt != null) #lastDownloadAt: lastDownloadAt
      }));
  @override
  TachimangaBackupManga $make(CopyWithData data) => TachimangaBackupManga(
      id: data.get(#id, or: $value.id),
      url: data.get(#url, or: $value.url),
      title: data.get(#title, or: $value.title),
      initialized: data.get(#initialized, or: $value.initialized),
      artist: data.get(#artist, or: $value.artist),
      author: data.get(#author, or: $value.author),
      description: data.get(#description, or: $value.description),
      genre: data.get(#genre, or: $value.genre),
      status: data.get(#status, or: $value.status),
      thumbnailUrl: data.get(#thumbnailUrl, or: $value.thumbnailUrl),
      thumbnailUrlLastFetched: data.get(#thumbnailUrlLastFetched,
          or: $value.thumbnailUrlLastFetched),
      inLibrary: data.get(#inLibrary, or: $value.inLibrary),
      defaultCategory: data.get(#defaultCategory, or: $value.defaultCategory),
      inLibraryAt: data.get(#inLibraryAt, or: $value.inLibraryAt),
      source: data.get(#source, or: $value.source),
      realUrl: data.get(#realUrl, or: $value.realUrl),
      lastFetchedAt: data.get(#lastFetchedAt, or: $value.lastFetchedAt),
      chaptersLastFetchedAt:
          data.get(#chaptersLastFetchedAt, or: $value.chaptersLastFetchedAt),
      updateStrategy: data.get(#updateStrategy, or: $value.updateStrategy),
      lastDownloadAt: data.get(#lastDownloadAt, or: $value.lastDownloadAt));

  @override
  TachimangaBackupMangaCopyWith<$R2, TachimangaBackupManga, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupMangaCopyWithImpl($value, $cast, t);
}

class TachimangaBackupMangaMetaMapper
    extends ClassMapperBase<TachimangaBackupMangaMeta> {
  TachimangaBackupMangaMetaMapper._();

  static TachimangaBackupMangaMetaMapper? _instance;
  static TachimangaBackupMangaMetaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupMangaMetaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupMangaMeta';

  static int _$id(TachimangaBackupMangaMeta v) => v.id;
  static const Field<TachimangaBackupMangaMeta, int> _f$id = Field('id', _$id);
  static String _$key(TachimangaBackupMangaMeta v) => v.key;
  static const Field<TachimangaBackupMangaMeta, String> _f$key =
      Field('key', _$key);
  static String _$value(TachimangaBackupMangaMeta v) => v.value;
  static const Field<TachimangaBackupMangaMeta, String> _f$value =
      Field('value', _$value);
  static int _$mangaRef(TachimangaBackupMangaMeta v) => v.mangaRef;
  static const Field<TachimangaBackupMangaMeta, int> _f$mangaRef =
      Field('mangaRef', _$mangaRef, key: r'manga_ref');

  @override
  final MappableFields<TachimangaBackupMangaMeta> fields = const {
    #id: _f$id,
    #key: _f$key,
    #value: _f$value,
    #mangaRef: _f$mangaRef,
  };

  static TachimangaBackupMangaMeta _instantiate(DecodingData data) {
    return TachimangaBackupMangaMeta(
        id: data.dec(_f$id),
        key: data.dec(_f$key),
        value: data.dec(_f$value),
        mangaRef: data.dec(_f$mangaRef));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupMangaMeta fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupMangaMeta>(map);
  }

  static TachimangaBackupMangaMeta fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupMangaMeta>(json);
  }
}

mixin TachimangaBackupMangaMetaMappable {
  String toJson() {
    return TachimangaBackupMangaMetaMapper.ensureInitialized()
        .encodeJson<TachimangaBackupMangaMeta>(
            this as TachimangaBackupMangaMeta);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupMangaMetaMapper.ensureInitialized()
        .encodeMap<TachimangaBackupMangaMeta>(
            this as TachimangaBackupMangaMeta);
  }

  TachimangaBackupMangaMetaCopyWith<TachimangaBackupMangaMeta,
          TachimangaBackupMangaMeta, TachimangaBackupMangaMeta>
      get copyWith => _TachimangaBackupMangaMetaCopyWithImpl(
          this as TachimangaBackupMangaMeta, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupMangaMetaMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupMangaMeta);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupMangaMetaMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupMangaMeta, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupMangaMetaMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupMangaMeta);
  }
}

extension TachimangaBackupMangaMetaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupMangaMeta, $Out> {
  TachimangaBackupMangaMetaCopyWith<$R, TachimangaBackupMangaMeta, $Out>
      get $asTachimangaBackupMangaMeta => $base
          .as((v, t, t2) => _TachimangaBackupMangaMetaCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupMangaMetaCopyWith<
    $R,
    $In extends TachimangaBackupMangaMeta,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? key, String? value, int? mangaRef});
  TachimangaBackupMangaMetaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupMangaMetaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupMangaMeta, $Out>
    implements
        TachimangaBackupMangaMetaCopyWith<$R, TachimangaBackupMangaMeta, $Out> {
  _TachimangaBackupMangaMetaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupMangaMeta> $mapper =
      TachimangaBackupMangaMetaMapper.ensureInitialized();
  @override
  $R call({int? id, String? key, String? value, int? mangaRef}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (key != null) #key: key,
        if (value != null) #value: value,
        if (mangaRef != null) #mangaRef: mangaRef
      }));
  @override
  TachimangaBackupMangaMeta $make(CopyWithData data) =>
      TachimangaBackupMangaMeta(
          id: data.get(#id, or: $value.id),
          key: data.get(#key, or: $value.key),
          value: data.get(#value, or: $value.value),
          mangaRef: data.get(#mangaRef, or: $value.mangaRef));

  @override
  TachimangaBackupMangaMetaCopyWith<$R2, TachimangaBackupMangaMeta, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupMangaMetaCopyWithImpl($value, $cast, t);
}

class TachimangaBackupDbMigrationsMapper
    extends ClassMapperBase<TachimangaBackupDbMigrations> {
  TachimangaBackupDbMigrationsMapper._();

  static TachimangaBackupDbMigrationsMapper? _instance;
  static TachimangaBackupDbMigrationsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupDbMigrationsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupDbMigrations';

  static int _$version(TachimangaBackupDbMigrations v) => v.version;
  static const Field<TachimangaBackupDbMigrations, int> _f$version =
      Field('version', _$version);
  static String _$name(TachimangaBackupDbMigrations v) => v.name;
  static const Field<TachimangaBackupDbMigrations, String> _f$name =
      Field('name', _$name);
  static String _$executedAt(TachimangaBackupDbMigrations v) => v.executedAt;
  static const Field<TachimangaBackupDbMigrations, String> _f$executedAt =
      Field('executedAt', _$executedAt, key: r'executed_at');

  @override
  final MappableFields<TachimangaBackupDbMigrations> fields = const {
    #version: _f$version,
    #name: _f$name,
    #executedAt: _f$executedAt,
  };

  static TachimangaBackupDbMigrations _instantiate(DecodingData data) {
    return TachimangaBackupDbMigrations(
        version: data.dec(_f$version),
        name: data.dec(_f$name),
        executedAt: data.dec(_f$executedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupDbMigrations fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupDbMigrations>(map);
  }

  static TachimangaBackupDbMigrations fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupDbMigrations>(json);
  }
}

mixin TachimangaBackupDbMigrationsMappable {
  String toJson() {
    return TachimangaBackupDbMigrationsMapper.ensureInitialized()
        .encodeJson<TachimangaBackupDbMigrations>(
            this as TachimangaBackupDbMigrations);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupDbMigrationsMapper.ensureInitialized()
        .encodeMap<TachimangaBackupDbMigrations>(
            this as TachimangaBackupDbMigrations);
  }

  TachimangaBackupDbMigrationsCopyWith<TachimangaBackupDbMigrations,
          TachimangaBackupDbMigrations, TachimangaBackupDbMigrations>
      get copyWith => _TachimangaBackupDbMigrationsCopyWithImpl(
          this as TachimangaBackupDbMigrations, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupDbMigrationsMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupDbMigrations);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupDbMigrationsMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupDbMigrations, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupDbMigrationsMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupDbMigrations);
  }
}

extension TachimangaBackupDbMigrationsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupDbMigrations, $Out> {
  TachimangaBackupDbMigrationsCopyWith<$R, TachimangaBackupDbMigrations, $Out>
      get $asTachimangaBackupDbMigrations => $base.as(
          (v, t, t2) => _TachimangaBackupDbMigrationsCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupDbMigrationsCopyWith<
    $R,
    $In extends TachimangaBackupDbMigrations,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? version, String? name, String? executedAt});
  TachimangaBackupDbMigrationsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupDbMigrationsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupDbMigrations, $Out>
    implements
        TachimangaBackupDbMigrationsCopyWith<$R, TachimangaBackupDbMigrations,
            $Out> {
  _TachimangaBackupDbMigrationsCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupDbMigrations> $mapper =
      TachimangaBackupDbMigrationsMapper.ensureInitialized();
  @override
  $R call({int? version, String? name, String? executedAt}) =>
      $apply(FieldCopyWithData({
        if (version != null) #version: version,
        if (name != null) #name: name,
        if (executedAt != null) #executedAt: executedAt
      }));
  @override
  TachimangaBackupDbMigrations $make(CopyWithData data) =>
      TachimangaBackupDbMigrations(
          version: data.get(#version, or: $value.version),
          name: data.get(#name, or: $value.name),
          executedAt: data.get(#executedAt, or: $value.executedAt));

  @override
  TachimangaBackupDbMigrationsCopyWith<$R2, TachimangaBackupDbMigrations, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupDbMigrationsCopyWithImpl($value, $cast, t);
}

class TachimangaBackupPageMapper extends ClassMapperBase<TachimangaBackupPage> {
  TachimangaBackupPageMapper._();

  static TachimangaBackupPageMapper? _instance;
  static TachimangaBackupPageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaBackupPageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupPage';

  static int _$id(TachimangaBackupPage v) => v.id;
  static const Field<TachimangaBackupPage, int> _f$id = Field('id', _$id);
  static int _$index(TachimangaBackupPage v) => v.index;
  static const Field<TachimangaBackupPage, int> _f$index =
      Field('index', _$index);
  static String _$url(TachimangaBackupPage v) => v.url;
  static const Field<TachimangaBackupPage, String> _f$url = Field('url', _$url);
  static String? _$imageUrl(TachimangaBackupPage v) => v.imageUrl;
  static const Field<TachimangaBackupPage, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl);
  static int _$chapter(TachimangaBackupPage v) => v.chapter;
  static const Field<TachimangaBackupPage, int> _f$chapter =
      Field('chapter', _$chapter);

  @override
  final MappableFields<TachimangaBackupPage> fields = const {
    #id: _f$id,
    #index: _f$index,
    #url: _f$url,
    #imageUrl: _f$imageUrl,
    #chapter: _f$chapter,
  };

  static TachimangaBackupPage _instantiate(DecodingData data) {
    return TachimangaBackupPage(
        id: data.dec(_f$id),
        index: data.dec(_f$index),
        url: data.dec(_f$url),
        imageUrl: data.dec(_f$imageUrl),
        chapter: data.dec(_f$chapter));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupPage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupPage>(map);
  }

  static TachimangaBackupPage fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupPage>(json);
  }
}

mixin TachimangaBackupPageMappable {
  String toJson() {
    return TachimangaBackupPageMapper.ensureInitialized()
        .encodeJson<TachimangaBackupPage>(this as TachimangaBackupPage);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupPageMapper.ensureInitialized()
        .encodeMap<TachimangaBackupPage>(this as TachimangaBackupPage);
  }

  TachimangaBackupPageCopyWith<TachimangaBackupPage, TachimangaBackupPage,
          TachimangaBackupPage>
      get copyWith => _TachimangaBackupPageCopyWithImpl(
          this as TachimangaBackupPage, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupPageMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupPage);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupPageMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupPage, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupPageMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupPage);
  }
}

extension TachimangaBackupPageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupPage, $Out> {
  TachimangaBackupPageCopyWith<$R, TachimangaBackupPage, $Out>
      get $asTachimangaBackupPage =>
          $base.as((v, t, t2) => _TachimangaBackupPageCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupPageCopyWith<
    $R,
    $In extends TachimangaBackupPage,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, int? index, String? url, String? imageUrl, int? chapter});
  TachimangaBackupPageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupPageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupPage, $Out>
    implements TachimangaBackupPageCopyWith<$R, TachimangaBackupPage, $Out> {
  _TachimangaBackupPageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupPage> $mapper =
      TachimangaBackupPageMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          int? index,
          String? url,
          Object? imageUrl = $none,
          int? chapter}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (index != null) #index: index,
        if (url != null) #url: url,
        if (imageUrl != $none) #imageUrl: imageUrl,
        if (chapter != null) #chapter: chapter
      }));
  @override
  TachimangaBackupPage $make(CopyWithData data) => TachimangaBackupPage(
      id: data.get(#id, or: $value.id),
      index: data.get(#index, or: $value.index),
      url: data.get(#url, or: $value.url),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      chapter: data.get(#chapter, or: $value.chapter));

  @override
  TachimangaBackupPageCopyWith<$R2, TachimangaBackupPage, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupPageCopyWithImpl($value, $cast, t);
}

class TachimangaBackupRepoMapper extends ClassMapperBase<TachimangaBackupRepo> {
  TachimangaBackupRepoMapper._();

  static TachimangaBackupRepoMapper? _instance;
  static TachimangaBackupRepoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaBackupRepoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupRepo';

  static int _$id(TachimangaBackupRepo v) => v.id;
  static const Field<TachimangaBackupRepo, int> _f$id = Field('id', _$id);
  static int _$type(TachimangaBackupRepo v) => v.type;
  static const Field<TachimangaBackupRepo, int> _f$type = Field('type', _$type);
  static String _$name(TachimangaBackupRepo v) => v.name;
  static const Field<TachimangaBackupRepo, String> _f$name =
      Field('name', _$name);
  static String _$metaUrl(TachimangaBackupRepo v) => v.metaUrl;
  static const Field<TachimangaBackupRepo, String> _f$metaUrl =
      Field('metaUrl', _$metaUrl, key: r'meta_url');
  static String _$baseUrl(TachimangaBackupRepo v) => v.baseUrl;
  static const Field<TachimangaBackupRepo, String> _f$baseUrl =
      Field('baseUrl', _$baseUrl, key: r'base_url');
  static String? _$homepage(TachimangaBackupRepo v) => v.homepage;
  static const Field<TachimangaBackupRepo, String> _f$homepage =
      Field('homepage', _$homepage);
  static bool _$deleted(TachimangaBackupRepo v) => v.deleted;
  static const Field<TachimangaBackupRepo, bool> _f$deleted =
      Field('deleted', _$deleted);
  static int _$createAt(TachimangaBackupRepo v) => v.createAt;
  static const Field<TachimangaBackupRepo, int> _f$createAt =
      Field('createAt', _$createAt, key: r'create_at');
  static int _$updateAt(TachimangaBackupRepo v) => v.updateAt;
  static const Field<TachimangaBackupRepo, int> _f$updateAt =
      Field('updateAt', _$updateAt, key: r'update_at');

  @override
  final MappableFields<TachimangaBackupRepo> fields = const {
    #id: _f$id,
    #type: _f$type,
    #name: _f$name,
    #metaUrl: _f$metaUrl,
    #baseUrl: _f$baseUrl,
    #homepage: _f$homepage,
    #deleted: _f$deleted,
    #createAt: _f$createAt,
    #updateAt: _f$updateAt,
  };

  static TachimangaBackupRepo _instantiate(DecodingData data) {
    return TachimangaBackupRepo(
        id: data.dec(_f$id),
        type: data.dec(_f$type),
        name: data.dec(_f$name),
        metaUrl: data.dec(_f$metaUrl),
        baseUrl: data.dec(_f$baseUrl),
        homepage: data.dec(_f$homepage),
        deleted: data.dec(_f$deleted),
        createAt: data.dec(_f$createAt),
        updateAt: data.dec(_f$updateAt));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupRepo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupRepo>(map);
  }

  static TachimangaBackupRepo fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupRepo>(json);
  }
}

mixin TachimangaBackupRepoMappable {
  String toJson() {
    return TachimangaBackupRepoMapper.ensureInitialized()
        .encodeJson<TachimangaBackupRepo>(this as TachimangaBackupRepo);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupRepoMapper.ensureInitialized()
        .encodeMap<TachimangaBackupRepo>(this as TachimangaBackupRepo);
  }

  TachimangaBackupRepoCopyWith<TachimangaBackupRepo, TachimangaBackupRepo,
          TachimangaBackupRepo>
      get copyWith => _TachimangaBackupRepoCopyWithImpl(
          this as TachimangaBackupRepo, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupRepoMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupRepo);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupRepoMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupRepo, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupRepoMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupRepo);
  }
}

extension TachimangaBackupRepoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupRepo, $Out> {
  TachimangaBackupRepoCopyWith<$R, TachimangaBackupRepo, $Out>
      get $asTachimangaBackupRepo =>
          $base.as((v, t, t2) => _TachimangaBackupRepoCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupRepoCopyWith<
    $R,
    $In extends TachimangaBackupRepo,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      int? type,
      String? name,
      String? metaUrl,
      String? baseUrl,
      String? homepage,
      bool? deleted,
      int? createAt,
      int? updateAt});
  TachimangaBackupRepoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupRepoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupRepo, $Out>
    implements TachimangaBackupRepoCopyWith<$R, TachimangaBackupRepo, $Out> {
  _TachimangaBackupRepoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupRepo> $mapper =
      TachimangaBackupRepoMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          int? type,
          String? name,
          String? metaUrl,
          String? baseUrl,
          Object? homepage = $none,
          bool? deleted,
          int? createAt,
          int? updateAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (type != null) #type: type,
        if (name != null) #name: name,
        if (metaUrl != null) #metaUrl: metaUrl,
        if (baseUrl != null) #baseUrl: baseUrl,
        if (homepage != $none) #homepage: homepage,
        if (deleted != null) #deleted: deleted,
        if (createAt != null) #createAt: createAt,
        if (updateAt != null) #updateAt: updateAt
      }));
  @override
  TachimangaBackupRepo $make(CopyWithData data) => TachimangaBackupRepo(
      id: data.get(#id, or: $value.id),
      type: data.get(#type, or: $value.type),
      name: data.get(#name, or: $value.name),
      metaUrl: data.get(#metaUrl, or: $value.metaUrl),
      baseUrl: data.get(#baseUrl, or: $value.baseUrl),
      homepage: data.get(#homepage, or: $value.homepage),
      deleted: data.get(#deleted, or: $value.deleted),
      createAt: data.get(#createAt, or: $value.createAt),
      updateAt: data.get(#updateAt, or: $value.updateAt));

  @override
  TachimangaBackupRepoCopyWith<$R2, TachimangaBackupRepo, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupRepoCopyWithImpl($value, $cast, t);
}

class TachimangaBackupSettingMapper
    extends ClassMapperBase<TachimangaBackupSetting> {
  TachimangaBackupSettingMapper._();

  static TachimangaBackupSettingMapper? _instance;
  static TachimangaBackupSettingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupSettingMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupSetting';

  static int _$id(TachimangaBackupSetting v) => v.id;
  static const Field<TachimangaBackupSetting, int> _f$id = Field('id', _$id);
  static int _$createAt(TachimangaBackupSetting v) => v.createAt;
  static const Field<TachimangaBackupSetting, int> _f$createAt =
      Field('createAt', _$createAt, key: r'create_at');
  static int _$updateAt(TachimangaBackupSetting v) => v.updateAt;
  static const Field<TachimangaBackupSetting, int> _f$updateAt =
      Field('updateAt', _$updateAt, key: r'update_at');
  static bool _$isDelete(TachimangaBackupSetting v) => v.isDelete;
  static const Field<TachimangaBackupSetting, bool> _f$isDelete =
      Field('isDelete', _$isDelete, key: r'is_delete');
  static String _$key(TachimangaBackupSetting v) => v.key;
  static const Field<TachimangaBackupSetting, String> _f$key =
      Field('key', _$key);
  static String _$value(TachimangaBackupSetting v) => v.value;
  static const Field<TachimangaBackupSetting, String> _f$value =
      Field('value', _$value);

  @override
  final MappableFields<TachimangaBackupSetting> fields = const {
    #id: _f$id,
    #createAt: _f$createAt,
    #updateAt: _f$updateAt,
    #isDelete: _f$isDelete,
    #key: _f$key,
    #value: _f$value,
  };

  static TachimangaBackupSetting _instantiate(DecodingData data) {
    return TachimangaBackupSetting(
        id: data.dec(_f$id),
        createAt: data.dec(_f$createAt),
        updateAt: data.dec(_f$updateAt),
        isDelete: data.dec(_f$isDelete),
        key: data.dec(_f$key),
        value: data.dec(_f$value));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupSetting fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupSetting>(map);
  }

  static TachimangaBackupSetting fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupSetting>(json);
  }
}

mixin TachimangaBackupSettingMappable {
  String toJson() {
    return TachimangaBackupSettingMapper.ensureInitialized()
        .encodeJson<TachimangaBackupSetting>(this as TachimangaBackupSetting);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupSettingMapper.ensureInitialized()
        .encodeMap<TachimangaBackupSetting>(this as TachimangaBackupSetting);
  }

  TachimangaBackupSettingCopyWith<TachimangaBackupSetting,
          TachimangaBackupSetting, TachimangaBackupSetting>
      get copyWith => _TachimangaBackupSettingCopyWithImpl(
          this as TachimangaBackupSetting, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupSettingMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupSetting);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupSettingMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupSetting, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupSettingMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupSetting);
  }
}

extension TachimangaBackupSettingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupSetting, $Out> {
  TachimangaBackupSettingCopyWith<$R, TachimangaBackupSetting, $Out>
      get $asTachimangaBackupSetting => $base
          .as((v, t, t2) => _TachimangaBackupSettingCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupSettingCopyWith<
    $R,
    $In extends TachimangaBackupSetting,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      int? createAt,
      int? updateAt,
      bool? isDelete,
      String? key,
      String? value});
  TachimangaBackupSettingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupSettingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupSetting, $Out>
    implements
        TachimangaBackupSettingCopyWith<$R, TachimangaBackupSetting, $Out> {
  _TachimangaBackupSettingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupSetting> $mapper =
      TachimangaBackupSettingMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          int? createAt,
          int? updateAt,
          bool? isDelete,
          String? key,
          String? value}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createAt != null) #createAt: createAt,
        if (updateAt != null) #updateAt: updateAt,
        if (isDelete != null) #isDelete: isDelete,
        if (key != null) #key: key,
        if (value != null) #value: value
      }));
  @override
  TachimangaBackupSetting $make(CopyWithData data) => TachimangaBackupSetting(
      id: data.get(#id, or: $value.id),
      createAt: data.get(#createAt, or: $value.createAt),
      updateAt: data.get(#updateAt, or: $value.updateAt),
      isDelete: data.get(#isDelete, or: $value.isDelete),
      key: data.get(#key, or: $value.key),
      value: data.get(#value, or: $value.value));

  @override
  TachimangaBackupSettingCopyWith<$R2, TachimangaBackupSetting, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupSettingCopyWithImpl($value, $cast, t);
}

class TachimangaBackupSourceMapper
    extends ClassMapperBase<TachimangaBackupSource> {
  TachimangaBackupSourceMapper._();

  static TachimangaBackupSourceMapper? _instance;
  static TachimangaBackupSourceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaBackupSourceMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupSource';

  static int _$id(TachimangaBackupSource v) => v.id;
  static const Field<TachimangaBackupSource, int> _f$id = Field('id', _$id);
  static String _$name(TachimangaBackupSource v) => v.name;
  static const Field<TachimangaBackupSource, String> _f$name =
      Field('name', _$name);
  static String _$lang(TachimangaBackupSource v) => v.lang;
  static const Field<TachimangaBackupSource, String> _f$lang =
      Field('lang', _$lang);
  static int _$extension(TachimangaBackupSource v) => v.extension;
  static const Field<TachimangaBackupSource, int> _f$extension =
      Field('extension', _$extension);
  static bool _$isNsfw(TachimangaBackupSource v) => v.isNsfw;
  static const Field<TachimangaBackupSource, bool> _f$isNsfw =
      Field('isNsfw', _$isNsfw, key: r'is_nsfw');
  static bool? _$isDirect(TachimangaBackupSource v) => v.isDirect;
  static const Field<TachimangaBackupSource, bool> _f$isDirect =
      Field('isDirect', _$isDirect, key: r'is_direct');
  static bool? _$randomUa(TachimangaBackupSource v) => v.randomUa;
  static const Field<TachimangaBackupSource, bool> _f$randomUa =
      Field('randomUa', _$randomUa, key: r'random_ua');

  @override
  final MappableFields<TachimangaBackupSource> fields = const {
    #id: _f$id,
    #name: _f$name,
    #lang: _f$lang,
    #extension: _f$extension,
    #isNsfw: _f$isNsfw,
    #isDirect: _f$isDirect,
    #randomUa: _f$randomUa,
  };

  static TachimangaBackupSource _instantiate(DecodingData data) {
    return TachimangaBackupSource(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        lang: data.dec(_f$lang),
        extension: data.dec(_f$extension),
        isNsfw: data.dec(_f$isNsfw),
        isDirect: data.dec(_f$isDirect),
        randomUa: data.dec(_f$randomUa));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupSource fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupSource>(map);
  }

  static TachimangaBackupSource fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupSource>(json);
  }
}

mixin TachimangaBackupSourceMappable {
  String toJson() {
    return TachimangaBackupSourceMapper.ensureInitialized()
        .encodeJson<TachimangaBackupSource>(this as TachimangaBackupSource);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupSourceMapper.ensureInitialized()
        .encodeMap<TachimangaBackupSource>(this as TachimangaBackupSource);
  }

  TachimangaBackupSourceCopyWith<TachimangaBackupSource, TachimangaBackupSource,
          TachimangaBackupSource>
      get copyWith => _TachimangaBackupSourceCopyWithImpl(
          this as TachimangaBackupSource, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupSourceMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupSource);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupSourceMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupSource, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupSourceMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupSource);
  }
}

extension TachimangaBackupSourceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupSource, $Out> {
  TachimangaBackupSourceCopyWith<$R, TachimangaBackupSource, $Out>
      get $asTachimangaBackupSource =>
          $base.as((v, t, t2) => _TachimangaBackupSourceCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupSourceCopyWith<
    $R,
    $In extends TachimangaBackupSource,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      String? name,
      String? lang,
      int? extension,
      bool? isNsfw,
      bool? isDirect,
      bool? randomUa});
  TachimangaBackupSourceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupSourceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupSource, $Out>
    implements
        TachimangaBackupSourceCopyWith<$R, TachimangaBackupSource, $Out> {
  _TachimangaBackupSourceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupSource> $mapper =
      TachimangaBackupSourceMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          String? name,
          String? lang,
          int? extension,
          bool? isNsfw,
          Object? isDirect = $none,
          Object? randomUa = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (lang != null) #lang: lang,
        if (extension != null) #extension: extension,
        if (isNsfw != null) #isNsfw: isNsfw,
        if (isDirect != $none) #isDirect: isDirect,
        if (randomUa != $none) #randomUa: randomUa
      }));
  @override
  TachimangaBackupSource $make(CopyWithData data) => TachimangaBackupSource(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      lang: data.get(#lang, or: $value.lang),
      extension: data.get(#extension, or: $value.extension),
      isNsfw: data.get(#isNsfw, or: $value.isNsfw),
      isDirect: data.get(#isDirect, or: $value.isDirect),
      randomUa: data.get(#randomUa, or: $value.randomUa));

  @override
  TachimangaBackupSourceCopyWith<$R2, TachimangaBackupSource, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupSourceCopyWithImpl($value, $cast, t);
}

class TachimangaBackupTrackRecordMapper
    extends ClassMapperBase<TachimangaBackupTrackRecord> {
  TachimangaBackupTrackRecordMapper._();

  static TachimangaBackupTrackRecordMapper? _instance;
  static TachimangaBackupTrackRecordMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupTrackRecordMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupTrackRecord';

  static int _$id(TachimangaBackupTrackRecord v) => v.id;
  static const Field<TachimangaBackupTrackRecord, int> _f$id =
      Field('id', _$id);
  static int _$mangaId(TachimangaBackupTrackRecord v) => v.mangaId;
  static const Field<TachimangaBackupTrackRecord, int> _f$mangaId =
      Field('mangaId', _$mangaId, key: r'manga_id');
  static int _$syncId(TachimangaBackupTrackRecord v) => v.syncId;
  static const Field<TachimangaBackupTrackRecord, int> _f$syncId =
      Field('syncId', _$syncId, key: r'sync_id');
  static int _$remoteId(TachimangaBackupTrackRecord v) => v.remoteId;
  static const Field<TachimangaBackupTrackRecord, int> _f$remoteId =
      Field('remoteId', _$remoteId, key: r'remote_id');
  static int? _$libraryId(TachimangaBackupTrackRecord v) => v.libraryId;
  static const Field<TachimangaBackupTrackRecord, int> _f$libraryId =
      Field('libraryId', _$libraryId, key: r'library_id');
  static String _$title(TachimangaBackupTrackRecord v) => v.title;
  static const Field<TachimangaBackupTrackRecord, String> _f$title =
      Field('title', _$title);
  static double _$lastChapterRead(TachimangaBackupTrackRecord v) =>
      v.lastChapterRead;
  static const Field<TachimangaBackupTrackRecord, double> _f$lastChapterRead =
      Field('lastChapterRead', _$lastChapterRead, key: r'last_chapter_read');
  static int _$totalChapters(TachimangaBackupTrackRecord v) => v.totalChapters;
  static const Field<TachimangaBackupTrackRecord, int> _f$totalChapters =
      Field('totalChapters', _$totalChapters, key: r'total_chapters');
  static int _$status(TachimangaBackupTrackRecord v) => v.status;
  static const Field<TachimangaBackupTrackRecord, int> _f$status =
      Field('status', _$status);
  static double _$score(TachimangaBackupTrackRecord v) => v.score;
  static const Field<TachimangaBackupTrackRecord, double> _f$score =
      Field('score', _$score);
  static String _$remoteUrl(TachimangaBackupTrackRecord v) => v.remoteUrl;
  static const Field<TachimangaBackupTrackRecord, String> _f$remoteUrl =
      Field('remoteUrl', _$remoteUrl, key: r'remote_url');
  static int _$startDate(TachimangaBackupTrackRecord v) => v.startDate;
  static const Field<TachimangaBackupTrackRecord, int> _f$startDate =
      Field('startDate', _$startDate, key: r'start_date');
  static int _$finishDate(TachimangaBackupTrackRecord v) => v.finishDate;
  static const Field<TachimangaBackupTrackRecord, int> _f$finishDate =
      Field('finishDate', _$finishDate, key: r'finish_date');

  @override
  final MappableFields<TachimangaBackupTrackRecord> fields = const {
    #id: _f$id,
    #mangaId: _f$mangaId,
    #syncId: _f$syncId,
    #remoteId: _f$remoteId,
    #libraryId: _f$libraryId,
    #title: _f$title,
    #lastChapterRead: _f$lastChapterRead,
    #totalChapters: _f$totalChapters,
    #status: _f$status,
    #score: _f$score,
    #remoteUrl: _f$remoteUrl,
    #startDate: _f$startDate,
    #finishDate: _f$finishDate,
  };

  static TachimangaBackupTrackRecord _instantiate(DecodingData data) {
    return TachimangaBackupTrackRecord(
        id: data.dec(_f$id),
        mangaId: data.dec(_f$mangaId),
        syncId: data.dec(_f$syncId),
        remoteId: data.dec(_f$remoteId),
        libraryId: data.dec(_f$libraryId),
        title: data.dec(_f$title),
        lastChapterRead: data.dec(_f$lastChapterRead),
        totalChapters: data.dec(_f$totalChapters),
        status: data.dec(_f$status),
        score: data.dec(_f$score),
        remoteUrl: data.dec(_f$remoteUrl),
        startDate: data.dec(_f$startDate),
        finishDate: data.dec(_f$finishDate));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupTrackRecord fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupTrackRecord>(map);
  }

  static TachimangaBackupTrackRecord fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupTrackRecord>(json);
  }
}

mixin TachimangaBackupTrackRecordMappable {
  String toJson() {
    return TachimangaBackupTrackRecordMapper.ensureInitialized()
        .encodeJson<TachimangaBackupTrackRecord>(
            this as TachimangaBackupTrackRecord);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupTrackRecordMapper.ensureInitialized()
        .encodeMap<TachimangaBackupTrackRecord>(
            this as TachimangaBackupTrackRecord);
  }

  TachimangaBackupTrackRecordCopyWith<TachimangaBackupTrackRecord,
          TachimangaBackupTrackRecord, TachimangaBackupTrackRecord>
      get copyWith => _TachimangaBackupTrackRecordCopyWithImpl(
          this as TachimangaBackupTrackRecord, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupTrackRecordMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupTrackRecord);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupTrackRecordMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupTrackRecord, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupTrackRecordMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupTrackRecord);
  }
}

extension TachimangaBackupTrackRecordValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupTrackRecord, $Out> {
  TachimangaBackupTrackRecordCopyWith<$R, TachimangaBackupTrackRecord, $Out>
      get $asTachimangaBackupTrackRecord => $base
          .as((v, t, t2) => _TachimangaBackupTrackRecordCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupTrackRecordCopyWith<
    $R,
    $In extends TachimangaBackupTrackRecord,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      int? mangaId,
      int? syncId,
      int? remoteId,
      int? libraryId,
      String? title,
      double? lastChapterRead,
      int? totalChapters,
      int? status,
      double? score,
      String? remoteUrl,
      int? startDate,
      int? finishDate});
  TachimangaBackupTrackRecordCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupTrackRecordCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupTrackRecord, $Out>
    implements
        TachimangaBackupTrackRecordCopyWith<$R, TachimangaBackupTrackRecord,
            $Out> {
  _TachimangaBackupTrackRecordCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupTrackRecord> $mapper =
      TachimangaBackupTrackRecordMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          int? mangaId,
          int? syncId,
          int? remoteId,
          Object? libraryId = $none,
          String? title,
          double? lastChapterRead,
          int? totalChapters,
          int? status,
          double? score,
          String? remoteUrl,
          int? startDate,
          int? finishDate}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (mangaId != null) #mangaId: mangaId,
        if (syncId != null) #syncId: syncId,
        if (remoteId != null) #remoteId: remoteId,
        if (libraryId != $none) #libraryId: libraryId,
        if (title != null) #title: title,
        if (lastChapterRead != null) #lastChapterRead: lastChapterRead,
        if (totalChapters != null) #totalChapters: totalChapters,
        if (status != null) #status: status,
        if (score != null) #score: score,
        if (remoteUrl != null) #remoteUrl: remoteUrl,
        if (startDate != null) #startDate: startDate,
        if (finishDate != null) #finishDate: finishDate
      }));
  @override
  TachimangaBackupTrackRecord $make(CopyWithData data) =>
      TachimangaBackupTrackRecord(
          id: data.get(#id, or: $value.id),
          mangaId: data.get(#mangaId, or: $value.mangaId),
          syncId: data.get(#syncId, or: $value.syncId),
          remoteId: data.get(#remoteId, or: $value.remoteId),
          libraryId: data.get(#libraryId, or: $value.libraryId),
          title: data.get(#title, or: $value.title),
          lastChapterRead:
              data.get(#lastChapterRead, or: $value.lastChapterRead),
          totalChapters: data.get(#totalChapters, or: $value.totalChapters),
          status: data.get(#status, or: $value.status),
          score: data.get(#score, or: $value.score),
          remoteUrl: data.get(#remoteUrl, or: $value.remoteUrl),
          startDate: data.get(#startDate, or: $value.startDate),
          finishDate: data.get(#finishDate, or: $value.finishDate));

  @override
  TachimangaBackupTrackRecordCopyWith<$R2, TachimangaBackupTrackRecord, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _TachimangaBackupTrackRecordCopyWithImpl($value, $cast, t);
}

class TachimangaBackupSqliteSequenceMapper
    extends ClassMapperBase<TachimangaBackupSqliteSequence> {
  TachimangaBackupSqliteSequenceMapper._();

  static TachimangaBackupSqliteSequenceMapper? _instance;
  static TachimangaBackupSqliteSequenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = TachimangaBackupSqliteSequenceMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachimangaBackupSqliteSequence';

  static String? _$name(TachimangaBackupSqliteSequence v) => v.name;
  static const Field<TachimangaBackupSqliteSequence, String> _f$name =
      Field('name', _$name);
  static int? _$seq(TachimangaBackupSqliteSequence v) => v.seq;
  static const Field<TachimangaBackupSqliteSequence, int> _f$seq =
      Field('seq', _$seq);

  @override
  final MappableFields<TachimangaBackupSqliteSequence> fields = const {
    #name: _f$name,
    #seq: _f$seq,
  };

  static TachimangaBackupSqliteSequence _instantiate(DecodingData data) {
    return TachimangaBackupSqliteSequence(
        name: data.dec(_f$name), seq: data.dec(_f$seq));
  }

  @override
  final Function instantiate = _instantiate;

  static TachimangaBackupSqliteSequence fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachimangaBackupSqliteSequence>(map);
  }

  static TachimangaBackupSqliteSequence fromJson(String json) {
    return ensureInitialized().decodeJson<TachimangaBackupSqliteSequence>(json);
  }
}

mixin TachimangaBackupSqliteSequenceMappable {
  String toJson() {
    return TachimangaBackupSqliteSequenceMapper.ensureInitialized()
        .encodeJson<TachimangaBackupSqliteSequence>(
            this as TachimangaBackupSqliteSequence);
  }

  Map<String, dynamic> toMap() {
    return TachimangaBackupSqliteSequenceMapper.ensureInitialized()
        .encodeMap<TachimangaBackupSqliteSequence>(
            this as TachimangaBackupSqliteSequence);
  }

  TachimangaBackupSqliteSequenceCopyWith<TachimangaBackupSqliteSequence,
          TachimangaBackupSqliteSequence, TachimangaBackupSqliteSequence>
      get copyWith => _TachimangaBackupSqliteSequenceCopyWithImpl(
          this as TachimangaBackupSqliteSequence, $identity, $identity);
  @override
  String toString() {
    return TachimangaBackupSqliteSequenceMapper.ensureInitialized()
        .stringifyValue(this as TachimangaBackupSqliteSequence);
  }

  @override
  bool operator ==(Object other) {
    return TachimangaBackupSqliteSequenceMapper.ensureInitialized()
        .equalsValue(this as TachimangaBackupSqliteSequence, other);
  }

  @override
  int get hashCode {
    return TachimangaBackupSqliteSequenceMapper.ensureInitialized()
        .hashValue(this as TachimangaBackupSqliteSequence);
  }
}

extension TachimangaBackupSqliteSequenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachimangaBackupSqliteSequence, $Out> {
  TachimangaBackupSqliteSequenceCopyWith<$R, TachimangaBackupSqliteSequence,
          $Out>
      get $asTachimangaBackupSqliteSequence => $base.as(
          (v, t, t2) => _TachimangaBackupSqliteSequenceCopyWithImpl(v, t, t2));
}

abstract class TachimangaBackupSqliteSequenceCopyWith<
    $R,
    $In extends TachimangaBackupSqliteSequence,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, int? seq});
  TachimangaBackupSqliteSequenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _TachimangaBackupSqliteSequenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachimangaBackupSqliteSequence, $Out>
    implements
        TachimangaBackupSqliteSequenceCopyWith<$R,
            TachimangaBackupSqliteSequence, $Out> {
  _TachimangaBackupSqliteSequenceCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachimangaBackupSqliteSequence> $mapper =
      TachimangaBackupSqliteSequenceMapper.ensureInitialized();
  @override
  $R call({Object? name = $none, Object? seq = $none}) =>
      $apply(FieldCopyWithData(
          {if (name != $none) #name: name, if (seq != $none) #seq: seq}));
  @override
  TachimangaBackupSqliteSequence $make(CopyWithData data) =>
      TachimangaBackupSqliteSequence(
          name: data.get(#name, or: $value.name),
          seq: data.get(#seq, or: $value.seq));

  @override
  TachimangaBackupSqliteSequenceCopyWith<$R2, TachimangaBackupSqliteSequence,
      $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TachimangaBackupSqliteSequenceCopyWithImpl($value, $cast, t);
}

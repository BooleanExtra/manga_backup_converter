// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'neko_backup_merge_manga.dart';

class NekoBackupMergeMangaMapper extends ClassMapperBase<NekoBackupMergeManga> {
  NekoBackupMergeMangaMapper._();

  static NekoBackupMergeMangaMapper? _instance;
  static NekoBackupMergeMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NekoBackupMergeMangaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NekoBackupMergeManga';

  static String _$url(NekoBackupMergeManga v) => v.url;
  static const Field<NekoBackupMergeManga, String> _f$url = Field('url', _$url);
  static String _$title(NekoBackupMergeManga v) => v.title;
  static const Field<NekoBackupMergeManga, String> _f$title =
      Field('title', _$title);
  static String _$coverUrl(NekoBackupMergeManga v) => v.coverUrl;
  static const Field<NekoBackupMergeManga, String> _f$coverUrl =
      Field('coverUrl', _$coverUrl);
  static int _$mergeType(NekoBackupMergeManga v) => v.mergeType;
  static const Field<NekoBackupMergeManga, int> _f$mergeType =
      Field('mergeType', _$mergeType);

  @override
  final MappableFields<NekoBackupMergeManga> fields = const {
    #url: _f$url,
    #title: _f$title,
    #coverUrl: _f$coverUrl,
    #mergeType: _f$mergeType,
  };

  static NekoBackupMergeManga _instantiate(DecodingData data) {
    return NekoBackupMergeManga(
        url: data.dec(_f$url),
        title: data.dec(_f$title),
        coverUrl: data.dec(_f$coverUrl),
        mergeType: data.dec(_f$mergeType));
  }

  @override
  final Function instantiate = _instantiate;

  static NekoBackupMergeManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NekoBackupMergeManga>(map);
  }

  static NekoBackupMergeManga fromJson(String json) {
    return ensureInitialized().decodeJson<NekoBackupMergeManga>(json);
  }
}

mixin NekoBackupMergeMangaMappable {
  String toJson() {
    return NekoBackupMergeMangaMapper.ensureInitialized()
        .encodeJson<NekoBackupMergeManga>(this as NekoBackupMergeManga);
  }

  Map<String, dynamic> toMap() {
    return NekoBackupMergeMangaMapper.ensureInitialized()
        .encodeMap<NekoBackupMergeManga>(this as NekoBackupMergeManga);
  }

  NekoBackupMergeMangaCopyWith<NekoBackupMergeManga, NekoBackupMergeManga,
          NekoBackupMergeManga>
      get copyWith => _NekoBackupMergeMangaCopyWithImpl(
          this as NekoBackupMergeManga, $identity, $identity);
  @override
  String toString() {
    return NekoBackupMergeMangaMapper.ensureInitialized()
        .stringifyValue(this as NekoBackupMergeManga);
  }

  @override
  bool operator ==(Object other) {
    return NekoBackupMergeMangaMapper.ensureInitialized()
        .equalsValue(this as NekoBackupMergeManga, other);
  }

  @override
  int get hashCode {
    return NekoBackupMergeMangaMapper.ensureInitialized()
        .hashValue(this as NekoBackupMergeManga);
  }
}

extension NekoBackupMergeMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NekoBackupMergeManga, $Out> {
  NekoBackupMergeMangaCopyWith<$R, NekoBackupMergeManga, $Out>
      get $asNekoBackupMergeManga =>
          $base.as((v, t, t2) => _NekoBackupMergeMangaCopyWithImpl(v, t, t2));
}

abstract class NekoBackupMergeMangaCopyWith<
    $R,
    $In extends NekoBackupMergeManga,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? url, String? title, String? coverUrl, int? mergeType});
  NekoBackupMergeMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NekoBackupMergeMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NekoBackupMergeManga, $Out>
    implements NekoBackupMergeMangaCopyWith<$R, NekoBackupMergeManga, $Out> {
  _NekoBackupMergeMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NekoBackupMergeManga> $mapper =
      NekoBackupMergeMangaMapper.ensureInitialized();
  @override
  $R call({String? url, String? title, String? coverUrl, int? mergeType}) =>
      $apply(FieldCopyWithData({
        if (url != null) #url: url,
        if (title != null) #title: title,
        if (coverUrl != null) #coverUrl: coverUrl,
        if (mergeType != null) #mergeType: mergeType
      }));
  @override
  NekoBackupMergeManga $make(CopyWithData data) => NekoBackupMergeManga(
      url: data.get(#url, or: $value.url),
      title: data.get(#title, or: $value.title),
      coverUrl: data.get(#coverUrl, or: $value.coverUrl),
      mergeType: data.get(#mergeType, or: $value.mergeType));

  @override
  NekoBackupMergeMangaCopyWith<$R2, NekoBackupMergeManga, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _NekoBackupMergeMangaCopyWithImpl($value, $cast, t);
}

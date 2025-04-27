// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'aidoku_backup_track_item.dart';

class AidokuBackupTrackItemMapper extends ClassMapperBase<AidokuBackupTrackItem> {
  AidokuBackupTrackItemMapper._();

  static AidokuBackupTrackItemMapper? _instance;
  static AidokuBackupTrackItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuBackupTrackItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AidokuBackupTrackItem';

  static String _$id(AidokuBackupTrackItem v) => v.id;
  static const Field<AidokuBackupTrackItem, String> _f$id = Field('id', _$id);
  static String _$trackerId(AidokuBackupTrackItem v) => v.trackerId;
  static const Field<AidokuBackupTrackItem, String> _f$trackerId = Field('trackerId', _$trackerId);
  static String _$mangaId(AidokuBackupTrackItem v) => v.mangaId;
  static const Field<AidokuBackupTrackItem, String> _f$mangaId = Field('mangaId', _$mangaId);
  static String _$sourceId(AidokuBackupTrackItem v) => v.sourceId;
  static const Field<AidokuBackupTrackItem, String> _f$sourceId = Field('sourceId', _$sourceId);
  static String? _$title(AidokuBackupTrackItem v) => v.title;
  static const Field<AidokuBackupTrackItem, String> _f$title = Field('title', _$title);

  @override
  final MappableFields<AidokuBackupTrackItem> fields = const {
    #id: _f$id,
    #trackerId: _f$trackerId,
    #mangaId: _f$mangaId,
    #sourceId: _f$sourceId,
    #title: _f$title,
  };
  @override
  final bool ignoreNull = true;

  static AidokuBackupTrackItem _instantiate(DecodingData data) {
    return AidokuBackupTrackItem(
      id: data.dec(_f$id),
      trackerId: data.dec(_f$trackerId),
      mangaId: data.dec(_f$mangaId),
      sourceId: data.dec(_f$sourceId),
      title: data.dec(_f$title),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AidokuBackupTrackItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AidokuBackupTrackItem>(map);
  }

  static AidokuBackupTrackItem fromJson(String json) {
    return ensureInitialized().decodeJson<AidokuBackupTrackItem>(json);
  }
}

mixin AidokuBackupTrackItemMappable {
  String toJson() {
    return AidokuBackupTrackItemMapper.ensureInitialized().encodeJson<AidokuBackupTrackItem>(
      this as AidokuBackupTrackItem,
    );
  }

  Map<String, dynamic> toMap() {
    return AidokuBackupTrackItemMapper.ensureInitialized().encodeMap<AidokuBackupTrackItem>(
      this as AidokuBackupTrackItem,
    );
  }

  AidokuBackupTrackItemCopyWith<AidokuBackupTrackItem, AidokuBackupTrackItem, AidokuBackupTrackItem> get copyWith =>
      _AidokuBackupTrackItemCopyWithImpl(this as AidokuBackupTrackItem, $identity, $identity);
  @override
  String toString() {
    return AidokuBackupTrackItemMapper.ensureInitialized().stringifyValue(this as AidokuBackupTrackItem);
  }

  @override
  bool operator ==(Object other) {
    return AidokuBackupTrackItemMapper.ensureInitialized().equalsValue(this as AidokuBackupTrackItem, other);
  }

  @override
  int get hashCode {
    return AidokuBackupTrackItemMapper.ensureInitialized().hashValue(this as AidokuBackupTrackItem);
  }
}

extension AidokuBackupTrackItemValueCopy<$R, $Out> on ObjectCopyWith<$R, AidokuBackupTrackItem, $Out> {
  AidokuBackupTrackItemCopyWith<$R, AidokuBackupTrackItem, $Out> get $asAidokuBackupTrackItem =>
      $base.as((v, t, t2) => _AidokuBackupTrackItemCopyWithImpl(v, t, t2));
}

abstract class AidokuBackupTrackItemCopyWith<$R, $In extends AidokuBackupTrackItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? trackerId, String? mangaId, String? sourceId, String? title});
  AidokuBackupTrackItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AidokuBackupTrackItemCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, AidokuBackupTrackItem, $Out>
    implements AidokuBackupTrackItemCopyWith<$R, AidokuBackupTrackItem, $Out> {
  _AidokuBackupTrackItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AidokuBackupTrackItem> $mapper = AidokuBackupTrackItemMapper.ensureInitialized();
  @override
  $R call({String? id, String? trackerId, String? mangaId, String? sourceId, Object? title = $none}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (trackerId != null) #trackerId: trackerId,
      if (mangaId != null) #mangaId: mangaId,
      if (sourceId != null) #sourceId: sourceId,
      if (title != $none) #title: title,
    }),
  );
  @override
  AidokuBackupTrackItem $make(CopyWithData data) => AidokuBackupTrackItem(
    id: data.get(#id, or: $value.id),
    trackerId: data.get(#trackerId, or: $value.trackerId),
    mangaId: data.get(#mangaId, or: $value.mangaId),
    sourceId: data.get(#sourceId, or: $value.sourceId),
    title: data.get(#title, or: $value.title),
  );

  @override
  AidokuBackupTrackItemCopyWith<$R2, AidokuBackupTrackItem, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AidokuBackupTrackItemCopyWithImpl($value, $cast, t);
}

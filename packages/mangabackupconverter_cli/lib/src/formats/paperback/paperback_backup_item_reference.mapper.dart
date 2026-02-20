// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup_item_reference.dart';

class PaperbackBackupItemReferenceMapper
    extends ClassMapperBase<PaperbackBackupItemReference> {
  PaperbackBackupItemReferenceMapper._();

  static PaperbackBackupItemReferenceMapper? _instance;
  static PaperbackBackupItemReferenceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PaperbackBackupItemReferenceMapper._(),
      );
      MapperContainer.globals.useAll(<MapperBase<Object>>[
        SecondsEpochDateTimeMapper(),
      ]);
      PaperbackBackupItemTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupItemReference';

  static PaperbackBackupItemType _$type(PaperbackBackupItemReference v) =>
      v.type;
  static const Field<PaperbackBackupItemReference, PaperbackBackupItemType>
  _f$type = Field('type', _$type);
  static String _$id(PaperbackBackupItemReference v) => v.id;
  static const Field<PaperbackBackupItemReference, String> _f$id = Field(
    'id',
    _$id,
  );

  @override
  final MappableFields<PaperbackBackupItemReference> fields = const {
    #type: _f$type,
    #id: _f$id,
  };

  static PaperbackBackupItemReference _instantiate(DecodingData data) {
    return PaperbackBackupItemReference(
      type: data.dec(_f$type),
      id: data.dec(_f$id),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupItemReference fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupItemReference>(map);
  }

  static PaperbackBackupItemReference fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupItemReference>(json);
  }
}

mixin PaperbackBackupItemReferenceMappable {
  String toJson() {
    return PaperbackBackupItemReferenceMapper.ensureInitialized()
        .encodeJson<PaperbackBackupItemReference>(
          this as PaperbackBackupItemReference,
        );
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupItemReferenceMapper.ensureInitialized()
        .encodeMap<PaperbackBackupItemReference>(
          this as PaperbackBackupItemReference,
        );
  }

  PaperbackBackupItemReferenceCopyWith<
    PaperbackBackupItemReference,
    PaperbackBackupItemReference,
    PaperbackBackupItemReference
  >
  get copyWith =>
      _PaperbackBackupItemReferenceCopyWithImpl<
        PaperbackBackupItemReference,
        PaperbackBackupItemReference
      >(this as PaperbackBackupItemReference, $identity, $identity);
  @override
  String toString() {
    return PaperbackBackupItemReferenceMapper.ensureInitialized()
        .stringifyValue(this as PaperbackBackupItemReference);
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupItemReferenceMapper.ensureInitialized().equalsValue(
      this as PaperbackBackupItemReference,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackBackupItemReferenceMapper.ensureInitialized().hashValue(
      this as PaperbackBackupItemReference,
    );
  }
}

extension PaperbackBackupItemReferenceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaperbackBackupItemReference, $Out> {
  PaperbackBackupItemReferenceCopyWith<$R, PaperbackBackupItemReference, $Out>
  get $asPaperbackBackupItemReference => $base.as(
    (v, t, t2) => _PaperbackBackupItemReferenceCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PaperbackBackupItemReferenceCopyWith<
  $R,
  $In extends PaperbackBackupItemReference,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({PaperbackBackupItemType? type, String? id});
  PaperbackBackupItemReferenceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaperbackBackupItemReferenceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackupItemReference, $Out>
    implements
        PaperbackBackupItemReferenceCopyWith<
          $R,
          PaperbackBackupItemReference,
          $Out
        > {
  _PaperbackBackupItemReferenceCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PaperbackBackupItemReference> $mapper =
      PaperbackBackupItemReferenceMapper.ensureInitialized();
  @override
  $R call({PaperbackBackupItemType? type, String? id}) => $apply(
    FieldCopyWithData({if (type != null) #type: type, if (id != null) #id: id}),
  );
  @override
  PaperbackBackupItemReference $make(CopyWithData data) =>
      PaperbackBackupItemReference(
        type: data.get(#type, or: $value.type),
        id: data.get(#id, or: $value.id),
      );

  @override
  PaperbackBackupItemReferenceCopyWith<$R2, PaperbackBackupItemReference, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaperbackBackupItemReferenceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup_library_tab.dart';

class PaperbackBackupLibraryTabMapper
    extends ClassMapperBase<PaperbackBackupLibraryTab> {
  PaperbackBackupLibraryTabMapper._();

  static PaperbackBackupLibraryTabMapper? _instance;
  static PaperbackBackupLibraryTabMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PaperbackBackupLibraryTabMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'PaperbackBackupLibraryTab';

  static int _$sortOrder(PaperbackBackupLibraryTab v) => v.sortOrder;
  static const Field<PaperbackBackupLibraryTab, int> _f$sortOrder = Field(
    'sortOrder',
    _$sortOrder,
  );
  static String _$id(PaperbackBackupLibraryTab v) => v.id;
  static const Field<PaperbackBackupLibraryTab, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$name(PaperbackBackupLibraryTab v) => v.name;
  static const Field<PaperbackBackupLibraryTab, String> _f$name = Field(
    'name',
    _$name,
  );

  @override
  final MappableFields<PaperbackBackupLibraryTab> fields = const {
    #sortOrder: _f$sortOrder,
    #id: _f$id,
    #name: _f$name,
  };

  static PaperbackBackupLibraryTab _instantiate(DecodingData data) {
    return PaperbackBackupLibraryTab(
      sortOrder: data.dec(_f$sortOrder),
      id: data.dec(_f$id),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaperbackBackupLibraryTab fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaperbackBackupLibraryTab>(map);
  }

  static PaperbackBackupLibraryTab fromJson(String json) {
    return ensureInitialized().decodeJson<PaperbackBackupLibraryTab>(json);
  }
}

mixin PaperbackBackupLibraryTabMappable {
  String toJson() {
    return PaperbackBackupLibraryTabMapper.ensureInitialized()
        .encodeJson<PaperbackBackupLibraryTab>(
          this as PaperbackBackupLibraryTab,
        );
  }

  Map<String, dynamic> toMap() {
    return PaperbackBackupLibraryTabMapper.ensureInitialized()
        .encodeMap<PaperbackBackupLibraryTab>(
          this as PaperbackBackupLibraryTab,
        );
  }

  PaperbackBackupLibraryTabCopyWith<
    PaperbackBackupLibraryTab,
    PaperbackBackupLibraryTab,
    PaperbackBackupLibraryTab
  >
  get copyWith => _PaperbackBackupLibraryTabCopyWithImpl(
    this as PaperbackBackupLibraryTab,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PaperbackBackupLibraryTabMapper.ensureInitialized().stringifyValue(
      this as PaperbackBackupLibraryTab,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaperbackBackupLibraryTabMapper.ensureInitialized().equalsValue(
      this as PaperbackBackupLibraryTab,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackBackupLibraryTabMapper.ensureInitialized().hashValue(
      this as PaperbackBackupLibraryTab,
    );
  }
}

extension PaperbackBackupLibraryTabValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaperbackBackupLibraryTab, $Out> {
  PaperbackBackupLibraryTabCopyWith<$R, PaperbackBackupLibraryTab, $Out>
  get $asPaperbackBackupLibraryTab =>
      $base.as((v, t, t2) => _PaperbackBackupLibraryTabCopyWithImpl(v, t, t2));
}

abstract class PaperbackBackupLibraryTabCopyWith<
  $R,
  $In extends PaperbackBackupLibraryTab,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? sortOrder, String? id, String? name});
  PaperbackBackupLibraryTabCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaperbackBackupLibraryTabCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaperbackBackupLibraryTab, $Out>
    implements
        PaperbackBackupLibraryTabCopyWith<$R, PaperbackBackupLibraryTab, $Out> {
  _PaperbackBackupLibraryTabCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaperbackBackupLibraryTab> $mapper =
      PaperbackBackupLibraryTabMapper.ensureInitialized();
  @override
  $R call({int? sortOrder, String? id, String? name}) => $apply(
    FieldCopyWithData({
      if (sortOrder != null) #sortOrder: sortOrder,
      if (id != null) #id: id,
      if (name != null) #name: name,
    }),
  );
  @override
  PaperbackBackupLibraryTab $make(CopyWithData data) =>
      PaperbackBackupLibraryTab(
        sortOrder: data.get(#sortOrder, or: $value.sortOrder),
        id: data.get(#id, or: $value.id),
        name: data.get(#name, or: $value.name),
      );

  @override
  PaperbackBackupLibraryTabCopyWith<$R2, PaperbackBackupLibraryTab, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaperbackBackupLibraryTabCopyWithImpl($value, $cast, t);
}

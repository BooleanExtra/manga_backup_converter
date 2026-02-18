// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_backup_category.dart';

class TachiBackupCategoryMapper extends ClassMapperBase<TachiBackupCategory> {
  TachiBackupCategoryMapper._();

  static TachiBackupCategoryMapper? _instance;
  static TachiBackupCategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiBackupCategoryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TachiBackupCategory';

  static String _$name(TachiBackupCategory v) => v.name;
  static const Field<TachiBackupCategory, String> _f$name = Field(
    'name',
    _$name,
  );
  static int _$order(TachiBackupCategory v) => v.order;
  static const Field<TachiBackupCategory, int> _f$order = Field(
    'order',
    _$order,
  );
  static int _$flags(TachiBackupCategory v) => v.flags;
  static const Field<TachiBackupCategory, int> _f$flags = Field(
    'flags',
    _$flags,
  );
  static String? _$mangaSort(TachiBackupCategory v) => v.mangaSort;
  static const Field<TachiBackupCategory, String> _f$mangaSort = Field(
    'mangaSort',
    _$mangaSort,
    opt: true,
  );

  @override
  final MappableFields<TachiBackupCategory> fields = const {
    #name: _f$name,
    #order: _f$order,
    #flags: _f$flags,
    #mangaSort: _f$mangaSort,
  };

  static TachiBackupCategory _instantiate(DecodingData data) {
    return TachiBackupCategory(
      name: data.dec(_f$name),
      order: data.dec(_f$order),
      flags: data.dec(_f$flags),
      mangaSort: data.dec(_f$mangaSort),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TachiBackupCategory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiBackupCategory>(map);
  }

  static TachiBackupCategory fromJson(String json) {
    return ensureInitialized().decodeJson<TachiBackupCategory>(json);
  }
}

mixin TachiBackupCategoryMappable {
  String toJson() {
    return TachiBackupCategoryMapper.ensureInitialized()
        .encodeJson<TachiBackupCategory>(this as TachiBackupCategory);
  }

  Map<String, dynamic> toMap() {
    return TachiBackupCategoryMapper.ensureInitialized()
        .encodeMap<TachiBackupCategory>(this as TachiBackupCategory);
  }

  TachiBackupCategoryCopyWith<
    TachiBackupCategory,
    TachiBackupCategory,
    TachiBackupCategory
  >
  get copyWith =>
      _TachiBackupCategoryCopyWithImpl<
        TachiBackupCategory,
        TachiBackupCategory
      >(this as TachiBackupCategory, $identity, $identity);
  @override
  String toString() {
    return TachiBackupCategoryMapper.ensureInitialized().stringifyValue(
      this as TachiBackupCategory,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiBackupCategoryMapper.ensureInitialized().equalsValue(
      this as TachiBackupCategory,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiBackupCategoryMapper.ensureInitialized().hashValue(
      this as TachiBackupCategory,
    );
  }
}

extension TachiBackupCategoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiBackupCategory, $Out> {
  TachiBackupCategoryCopyWith<$R, TachiBackupCategory, $Out>
  get $asTachiBackupCategory => $base.as(
    (v, t, t2) => _TachiBackupCategoryCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TachiBackupCategoryCopyWith<
  $R,
  $In extends TachiBackupCategory,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, int? order, int? flags, String? mangaSort});
  TachiBackupCategoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TachiBackupCategoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiBackupCategory, $Out>
    implements TachiBackupCategoryCopyWith<$R, TachiBackupCategory, $Out> {
  _TachiBackupCategoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiBackupCategory> $mapper =
      TachiBackupCategoryMapper.ensureInitialized();
  @override
  $R call({String? name, int? order, int? flags, Object? mangaSort = $none}) =>
      $apply(
        FieldCopyWithData({
          if (name != null) #name: name,
          if (order != null) #order: order,
          if (flags != null) #flags: flags,
          if (mangaSort != $none) #mangaSort: mangaSort,
        }),
      );
  @override
  TachiBackupCategory $make(CopyWithData data) => TachiBackupCategory(
    name: data.get(#name, or: $value.name),
    order: data.get(#order, or: $value.order),
    flags: data.get(#flags, or: $value.flags),
    mangaSort: data.get(#mangaSort, or: $value.mangaSort),
  );

  @override
  TachiBackupCategoryCopyWith<$R2, TachiBackupCategory, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TachiBackupCategoryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


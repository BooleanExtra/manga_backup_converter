// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'backup_format.dart';

class BackupFormatMapper extends ClassMapperBase<BackupFormat> {
  BackupFormatMapper._();

  static BackupFormatMapper? _instance;
  static BackupFormatMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackupFormatMapper._());
      AidokuMapper.ensureInitialized();
      PaperbackMapper.ensureInitialized();
      TachiyomiMapper.ensureInitialized();
      TachimangaMapper.ensureInitialized();
      MangayomiMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BackupFormat';

  @override
  final MappableFields<BackupFormat> fields = const {};

  static BackupFormat _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'BackupFormat',
      'type',
      '${data.value['type']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BackupFormat fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BackupFormat>(map);
  }

  static BackupFormat fromJson(String json) {
    return ensureInitialized().decodeJson<BackupFormat>(json);
  }
}

mixin BackupFormatMappable {
  String toJson();
  Map<String, dynamic> toMap();
  BackupFormatCopyWith<BackupFormat, BackupFormat, BackupFormat> get copyWith;
}

abstract class BackupFormatCopyWith<$R, $In extends BackupFormat, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  BackupFormatCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class AidokuMapper extends SubClassMapperBase<Aidoku> {
  AidokuMapper._();

  static AidokuMapper? _instance;
  static AidokuMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuMapper._());
      BackupFormatMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'Aidoku';

  @override
  final MappableFields<Aidoku> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'aidoku';
  @override
  late final ClassMapperBase superMapper =
      BackupFormatMapper.ensureInitialized();

  static Aidoku _instantiate(DecodingData data) {
    return Aidoku();
  }

  @override
  final Function instantiate = _instantiate;

  static Aidoku fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Aidoku>(map);
  }

  static Aidoku fromJson(String json) {
    return ensureInitialized().decodeJson<Aidoku>(json);
  }
}

mixin AidokuMappable {
  String toJson() {
    return AidokuMapper.ensureInitialized().encodeJson<Aidoku>(this as Aidoku);
  }

  Map<String, dynamic> toMap() {
    return AidokuMapper.ensureInitialized().encodeMap<Aidoku>(this as Aidoku);
  }

  AidokuCopyWith<Aidoku, Aidoku, Aidoku> get copyWith =>
      _AidokuCopyWithImpl<Aidoku, Aidoku>(this as Aidoku, $identity, $identity);
  @override
  String toString() {
    return AidokuMapper.ensureInitialized().stringifyValue(this as Aidoku);
  }

  @override
  bool operator ==(Object other) {
    return AidokuMapper.ensureInitialized().equalsValue(this as Aidoku, other);
  }

  @override
  int get hashCode {
    return AidokuMapper.ensureInitialized().hashValue(this as Aidoku);
  }
}

extension AidokuValueCopy<$R, $Out> on ObjectCopyWith<$R, Aidoku, $Out> {
  AidokuCopyWith<$R, Aidoku, $Out> get $asAidoku =>
      $base.as((v, t, t2) => _AidokuCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AidokuCopyWith<$R, $In extends Aidoku, $Out>
    implements BackupFormatCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AidokuCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AidokuCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Aidoku, $Out>
    implements AidokuCopyWith<$R, Aidoku, $Out> {
  _AidokuCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Aidoku> $mapper = AidokuMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  Aidoku $make(CopyWithData data) => Aidoku();

  @override
  AidokuCopyWith<$R2, Aidoku, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AidokuCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PaperbackMapper extends SubClassMapperBase<Paperback> {
  PaperbackMapper._();

  static PaperbackMapper? _instance;
  static PaperbackMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaperbackMapper._());
      BackupFormatMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'Paperback';

  @override
  final MappableFields<Paperback> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'paperback';
  @override
  late final ClassMapperBase superMapper =
      BackupFormatMapper.ensureInitialized();

  static Paperback _instantiate(DecodingData data) {
    return Paperback();
  }

  @override
  final Function instantiate = _instantiate;

  static Paperback fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Paperback>(map);
  }

  static Paperback fromJson(String json) {
    return ensureInitialized().decodeJson<Paperback>(json);
  }
}

mixin PaperbackMappable {
  String toJson() {
    return PaperbackMapper.ensureInitialized().encodeJson<Paperback>(
      this as Paperback,
    );
  }

  Map<String, dynamic> toMap() {
    return PaperbackMapper.ensureInitialized().encodeMap<Paperback>(
      this as Paperback,
    );
  }

  PaperbackCopyWith<Paperback, Paperback, Paperback> get copyWith =>
      _PaperbackCopyWithImpl<Paperback, Paperback>(
        this as Paperback,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PaperbackMapper.ensureInitialized().stringifyValue(
      this as Paperback,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaperbackMapper.ensureInitialized().equalsValue(
      this as Paperback,
      other,
    );
  }

  @override
  int get hashCode {
    return PaperbackMapper.ensureInitialized().hashValue(this as Paperback);
  }
}

extension PaperbackValueCopy<$R, $Out> on ObjectCopyWith<$R, Paperback, $Out> {
  PaperbackCopyWith<$R, Paperback, $Out> get $asPaperback =>
      $base.as((v, t, t2) => _PaperbackCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PaperbackCopyWith<$R, $In extends Paperback, $Out>
    implements BackupFormatCopyWith<$R, $In, $Out> {
  @override
  $R call();
  PaperbackCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PaperbackCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Paperback, $Out>
    implements PaperbackCopyWith<$R, Paperback, $Out> {
  _PaperbackCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Paperback> $mapper =
      PaperbackMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  Paperback $make(CopyWithData data) => Paperback();

  @override
  PaperbackCopyWith<$R2, Paperback, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PaperbackCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TachiyomiMapper extends SubClassMapperBase<Tachiyomi> {
  TachiyomiMapper._();

  static TachiyomiMapper? _instance;
  static TachiyomiMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiyomiMapper._());
      BackupFormatMapper.ensureInitialized().addSubMapper(_instance!);
      MihonMapper.ensureInitialized();
      TachiSyMapper.ensureInitialized();
      TachiJ2kMapper.ensureInitialized();
      TachiYokaiMapper.ensureInitialized();
      TachiNekoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Tachiyomi';

  @override
  final MappableFields<Tachiyomi> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'Tachiyomi';
  @override
  late final ClassMapperBase superMapper =
      BackupFormatMapper.ensureInitialized();

  static Tachiyomi _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'Tachiyomi',
      'type',
      '${data.value['type']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Tachiyomi fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Tachiyomi>(map);
  }

  static Tachiyomi fromJson(String json) {
    return ensureInitialized().decodeJson<Tachiyomi>(json);
  }
}

mixin TachiyomiMappable {
  String toJson();
  Map<String, dynamic> toMap();
  TachiyomiCopyWith<Tachiyomi, Tachiyomi, Tachiyomi> get copyWith;
}

abstract class TachiyomiCopyWith<$R, $In extends Tachiyomi, $Out>
    implements BackupFormatCopyWith<$R, $In, $Out> {
  @override
  $R call();
  TachiyomiCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class MihonMapper extends SubClassMapperBase<Mihon> {
  MihonMapper._();

  static MihonMapper? _instance;
  static MihonMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MihonMapper._());
      TachiyomiMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'Mihon';

  @override
  final MappableFields<Mihon> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'mihon';
  @override
  late final ClassMapperBase superMapper = TachiyomiMapper.ensureInitialized();

  static Mihon _instantiate(DecodingData data) {
    return Mihon();
  }

  @override
  final Function instantiate = _instantiate;

  static Mihon fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Mihon>(map);
  }

  static Mihon fromJson(String json) {
    return ensureInitialized().decodeJson<Mihon>(json);
  }
}

mixin MihonMappable {
  String toJson() {
    return MihonMapper.ensureInitialized().encodeJson<Mihon>(this as Mihon);
  }

  Map<String, dynamic> toMap() {
    return MihonMapper.ensureInitialized().encodeMap<Mihon>(this as Mihon);
  }

  MihonCopyWith<Mihon, Mihon, Mihon> get copyWith =>
      _MihonCopyWithImpl<Mihon, Mihon>(this as Mihon, $identity, $identity);
  @override
  String toString() {
    return MihonMapper.ensureInitialized().stringifyValue(this as Mihon);
  }

  @override
  bool operator ==(Object other) {
    return MihonMapper.ensureInitialized().equalsValue(this as Mihon, other);
  }

  @override
  int get hashCode {
    return MihonMapper.ensureInitialized().hashValue(this as Mihon);
  }
}

extension MihonValueCopy<$R, $Out> on ObjectCopyWith<$R, Mihon, $Out> {
  MihonCopyWith<$R, Mihon, $Out> get $asMihon =>
      $base.as((v, t, t2) => _MihonCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MihonCopyWith<$R, $In extends Mihon, $Out>
    implements TachiyomiCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MihonCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MihonCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Mihon, $Out>
    implements MihonCopyWith<$R, Mihon, $Out> {
  _MihonCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Mihon> $mapper = MihonMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  Mihon $make(CopyWithData data) => Mihon();

  @override
  MihonCopyWith<$R2, Mihon, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MihonCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TachiSyMapper extends SubClassMapperBase<TachiSy> {
  TachiSyMapper._();

  static TachiSyMapper? _instance;
  static TachiSyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiSyMapper._());
      TachiyomiMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'TachiSy';

  @override
  final MappableFields<TachiSy> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'sy';
  @override
  late final ClassMapperBase superMapper = TachiyomiMapper.ensureInitialized();

  static TachiSy _instantiate(DecodingData data) {
    return TachiSy();
  }

  @override
  final Function instantiate = _instantiate;

  static TachiSy fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiSy>(map);
  }

  static TachiSy fromJson(String json) {
    return ensureInitialized().decodeJson<TachiSy>(json);
  }
}

mixin TachiSyMappable {
  String toJson() {
    return TachiSyMapper.ensureInitialized().encodeJson<TachiSy>(
      this as TachiSy,
    );
  }

  Map<String, dynamic> toMap() {
    return TachiSyMapper.ensureInitialized().encodeMap<TachiSy>(
      this as TachiSy,
    );
  }

  TachiSyCopyWith<TachiSy, TachiSy, TachiSy> get copyWith =>
      _TachiSyCopyWithImpl<TachiSy, TachiSy>(
        this as TachiSy,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TachiSyMapper.ensureInitialized().stringifyValue(this as TachiSy);
  }

  @override
  bool operator ==(Object other) {
    return TachiSyMapper.ensureInitialized().equalsValue(
      this as TachiSy,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiSyMapper.ensureInitialized().hashValue(this as TachiSy);
  }
}

extension TachiSyValueCopy<$R, $Out> on ObjectCopyWith<$R, TachiSy, $Out> {
  TachiSyCopyWith<$R, TachiSy, $Out> get $asTachiSy =>
      $base.as((v, t, t2) => _TachiSyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TachiSyCopyWith<$R, $In extends TachiSy, $Out>
    implements TachiyomiCopyWith<$R, $In, $Out> {
  @override
  $R call();
  TachiSyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TachiSyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiSy, $Out>
    implements TachiSyCopyWith<$R, TachiSy, $Out> {
  _TachiSyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiSy> $mapper =
      TachiSyMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  TachiSy $make(CopyWithData data) => TachiSy();

  @override
  TachiSyCopyWith<$R2, TachiSy, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TachiSyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TachiJ2kMapper extends SubClassMapperBase<TachiJ2k> {
  TachiJ2kMapper._();

  static TachiJ2kMapper? _instance;
  static TachiJ2kMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiJ2kMapper._());
      TachiyomiMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'TachiJ2k';

  @override
  final MappableFields<TachiJ2k> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'j2k';
  @override
  late final ClassMapperBase superMapper = TachiyomiMapper.ensureInitialized();

  static TachiJ2k _instantiate(DecodingData data) {
    return TachiJ2k();
  }

  @override
  final Function instantiate = _instantiate;

  static TachiJ2k fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiJ2k>(map);
  }

  static TachiJ2k fromJson(String json) {
    return ensureInitialized().decodeJson<TachiJ2k>(json);
  }
}

mixin TachiJ2kMappable {
  String toJson() {
    return TachiJ2kMapper.ensureInitialized().encodeJson<TachiJ2k>(
      this as TachiJ2k,
    );
  }

  Map<String, dynamic> toMap() {
    return TachiJ2kMapper.ensureInitialized().encodeMap<TachiJ2k>(
      this as TachiJ2k,
    );
  }

  TachiJ2kCopyWith<TachiJ2k, TachiJ2k, TachiJ2k> get copyWith =>
      _TachiJ2kCopyWithImpl<TachiJ2k, TachiJ2k>(
        this as TachiJ2k,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TachiJ2kMapper.ensureInitialized().stringifyValue(this as TachiJ2k);
  }

  @override
  bool operator ==(Object other) {
    return TachiJ2kMapper.ensureInitialized().equalsValue(
      this as TachiJ2k,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiJ2kMapper.ensureInitialized().hashValue(this as TachiJ2k);
  }
}

extension TachiJ2kValueCopy<$R, $Out> on ObjectCopyWith<$R, TachiJ2k, $Out> {
  TachiJ2kCopyWith<$R, TachiJ2k, $Out> get $asTachiJ2k =>
      $base.as((v, t, t2) => _TachiJ2kCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TachiJ2kCopyWith<$R, $In extends TachiJ2k, $Out>
    implements TachiyomiCopyWith<$R, $In, $Out> {
  @override
  $R call();
  TachiJ2kCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TachiJ2kCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiJ2k, $Out>
    implements TachiJ2kCopyWith<$R, TachiJ2k, $Out> {
  _TachiJ2kCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiJ2k> $mapper =
      TachiJ2kMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  TachiJ2k $make(CopyWithData data) => TachiJ2k();

  @override
  TachiJ2kCopyWith<$R2, TachiJ2k, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachiJ2kCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TachiYokaiMapper extends SubClassMapperBase<TachiYokai> {
  TachiYokaiMapper._();

  static TachiYokaiMapper? _instance;
  static TachiYokaiMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiYokaiMapper._());
      TachiyomiMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'TachiYokai';

  @override
  final MappableFields<TachiYokai> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'yokai';
  @override
  late final ClassMapperBase superMapper = TachiyomiMapper.ensureInitialized();

  static TachiYokai _instantiate(DecodingData data) {
    return TachiYokai();
  }

  @override
  final Function instantiate = _instantiate;

  static TachiYokai fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiYokai>(map);
  }

  static TachiYokai fromJson(String json) {
    return ensureInitialized().decodeJson<TachiYokai>(json);
  }
}

mixin TachiYokaiMappable {
  String toJson() {
    return TachiYokaiMapper.ensureInitialized().encodeJson<TachiYokai>(
      this as TachiYokai,
    );
  }

  Map<String, dynamic> toMap() {
    return TachiYokaiMapper.ensureInitialized().encodeMap<TachiYokai>(
      this as TachiYokai,
    );
  }

  TachiYokaiCopyWith<TachiYokai, TachiYokai, TachiYokai> get copyWith =>
      _TachiYokaiCopyWithImpl<TachiYokai, TachiYokai>(
        this as TachiYokai,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TachiYokaiMapper.ensureInitialized().stringifyValue(
      this as TachiYokai,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiYokaiMapper.ensureInitialized().equalsValue(
      this as TachiYokai,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiYokaiMapper.ensureInitialized().hashValue(this as TachiYokai);
  }
}

extension TachiYokaiValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TachiYokai, $Out> {
  TachiYokaiCopyWith<$R, TachiYokai, $Out> get $asTachiYokai =>
      $base.as((v, t, t2) => _TachiYokaiCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TachiYokaiCopyWith<$R, $In extends TachiYokai, $Out>
    implements TachiyomiCopyWith<$R, $In, $Out> {
  @override
  $R call();
  TachiYokaiCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TachiYokaiCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiYokai, $Out>
    implements TachiYokaiCopyWith<$R, TachiYokai, $Out> {
  _TachiYokaiCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiYokai> $mapper =
      TachiYokaiMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  TachiYokai $make(CopyWithData data) => TachiYokai();

  @override
  TachiYokaiCopyWith<$R2, TachiYokai, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachiYokaiCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TachiNekoMapper extends SubClassMapperBase<TachiNeko> {
  TachiNekoMapper._();

  static TachiNekoMapper? _instance;
  static TachiNekoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiNekoMapper._());
      TachiyomiMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'TachiNeko';

  @override
  final MappableFields<TachiNeko> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'neko';
  @override
  late final ClassMapperBase superMapper = TachiyomiMapper.ensureInitialized();

  static TachiNeko _instantiate(DecodingData data) {
    return TachiNeko();
  }

  @override
  final Function instantiate = _instantiate;

  static TachiNeko fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TachiNeko>(map);
  }

  static TachiNeko fromJson(String json) {
    return ensureInitialized().decodeJson<TachiNeko>(json);
  }
}

mixin TachiNekoMappable {
  String toJson() {
    return TachiNekoMapper.ensureInitialized().encodeJson<TachiNeko>(
      this as TachiNeko,
    );
  }

  Map<String, dynamic> toMap() {
    return TachiNekoMapper.ensureInitialized().encodeMap<TachiNeko>(
      this as TachiNeko,
    );
  }

  TachiNekoCopyWith<TachiNeko, TachiNeko, TachiNeko> get copyWith =>
      _TachiNekoCopyWithImpl<TachiNeko, TachiNeko>(
        this as TachiNeko,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TachiNekoMapper.ensureInitialized().stringifyValue(
      this as TachiNeko,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachiNekoMapper.ensureInitialized().equalsValue(
      this as TachiNeko,
      other,
    );
  }

  @override
  int get hashCode {
    return TachiNekoMapper.ensureInitialized().hashValue(this as TachiNeko);
  }
}

extension TachiNekoValueCopy<$R, $Out> on ObjectCopyWith<$R, TachiNeko, $Out> {
  TachiNekoCopyWith<$R, TachiNeko, $Out> get $asTachiNeko =>
      $base.as((v, t, t2) => _TachiNekoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TachiNekoCopyWith<$R, $In extends TachiNeko, $Out>
    implements TachiyomiCopyWith<$R, $In, $Out> {
  @override
  $R call();
  TachiNekoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TachiNekoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TachiNeko, $Out>
    implements TachiNekoCopyWith<$R, TachiNeko, $Out> {
  _TachiNekoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TachiNeko> $mapper =
      TachiNekoMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  TachiNeko $make(CopyWithData data) => TachiNeko();

  @override
  TachiNekoCopyWith<$R2, TachiNeko, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachiNekoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TachimangaMapper extends SubClassMapperBase<Tachimanga> {
  TachimangaMapper._();

  static TachimangaMapper? _instance;
  static TachimangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachimangaMapper._());
      BackupFormatMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'Tachimanga';

  @override
  final MappableFields<Tachimanga> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'tachimanga';
  @override
  late final ClassMapperBase superMapper =
      BackupFormatMapper.ensureInitialized();

  static Tachimanga _instantiate(DecodingData data) {
    return Tachimanga();
  }

  @override
  final Function instantiate = _instantiate;

  static Tachimanga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Tachimanga>(map);
  }

  static Tachimanga fromJson(String json) {
    return ensureInitialized().decodeJson<Tachimanga>(json);
  }
}

mixin TachimangaMappable {
  String toJson() {
    return TachimangaMapper.ensureInitialized().encodeJson<Tachimanga>(
      this as Tachimanga,
    );
  }

  Map<String, dynamic> toMap() {
    return TachimangaMapper.ensureInitialized().encodeMap<Tachimanga>(
      this as Tachimanga,
    );
  }

  TachimangaCopyWith<Tachimanga, Tachimanga, Tachimanga> get copyWith =>
      _TachimangaCopyWithImpl<Tachimanga, Tachimanga>(
        this as Tachimanga,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TachimangaMapper.ensureInitialized().stringifyValue(
      this as Tachimanga,
    );
  }

  @override
  bool operator ==(Object other) {
    return TachimangaMapper.ensureInitialized().equalsValue(
      this as Tachimanga,
      other,
    );
  }

  @override
  int get hashCode {
    return TachimangaMapper.ensureInitialized().hashValue(this as Tachimanga);
  }
}

extension TachimangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Tachimanga, $Out> {
  TachimangaCopyWith<$R, Tachimanga, $Out> get $asTachimanga =>
      $base.as((v, t, t2) => _TachimangaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TachimangaCopyWith<$R, $In extends Tachimanga, $Out>
    implements BackupFormatCopyWith<$R, $In, $Out> {
  @override
  $R call();
  TachimangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TachimangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Tachimanga, $Out>
    implements TachimangaCopyWith<$R, Tachimanga, $Out> {
  _TachimangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Tachimanga> $mapper =
      TachimangaMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  Tachimanga $make(CopyWithData data) => Tachimanga();

  @override
  TachimangaCopyWith<$R2, Tachimanga, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TachimangaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MangayomiMapper extends SubClassMapperBase<Mangayomi> {
  MangayomiMapper._();

  static MangayomiMapper? _instance;
  static MangayomiMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MangayomiMapper._());
      BackupFormatMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'Mangayomi';

  @override
  final MappableFields<Mangayomi> fields = const {};

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'mangayomi';
  @override
  late final ClassMapperBase superMapper =
      BackupFormatMapper.ensureInitialized();

  static Mangayomi _instantiate(DecodingData data) {
    return Mangayomi();
  }

  @override
  final Function instantiate = _instantiate;

  static Mangayomi fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Mangayomi>(map);
  }

  static Mangayomi fromJson(String json) {
    return ensureInitialized().decodeJson<Mangayomi>(json);
  }
}

mixin MangayomiMappable {
  String toJson() {
    return MangayomiMapper.ensureInitialized().encodeJson<Mangayomi>(
      this as Mangayomi,
    );
  }

  Map<String, dynamic> toMap() {
    return MangayomiMapper.ensureInitialized().encodeMap<Mangayomi>(
      this as Mangayomi,
    );
  }

  MangayomiCopyWith<Mangayomi, Mangayomi, Mangayomi> get copyWith =>
      _MangayomiCopyWithImpl<Mangayomi, Mangayomi>(
        this as Mangayomi,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MangayomiMapper.ensureInitialized().stringifyValue(
      this as Mangayomi,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiMapper.ensureInitialized().equalsValue(
      this as Mangayomi,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiMapper.ensureInitialized().hashValue(this as Mangayomi);
  }
}

extension MangayomiValueCopy<$R, $Out> on ObjectCopyWith<$R, Mangayomi, $Out> {
  MangayomiCopyWith<$R, Mangayomi, $Out> get $asMangayomi =>
      $base.as((v, t, t2) => _MangayomiCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MangayomiCopyWith<$R, $In extends Mangayomi, $Out>
    implements BackupFormatCopyWith<$R, $In, $Out> {
  @override
  $R call();
  MangayomiCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MangayomiCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Mangayomi, $Out>
    implements MangayomiCopyWith<$R, Mangayomi, $Out> {
  _MangayomiCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Mangayomi> $mapper =
      MangayomiMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  Mangayomi $make(CopyWithData data) => Mangayomi();

  @override
  MangayomiCopyWith<$R2, Mangayomi, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MangayomiCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


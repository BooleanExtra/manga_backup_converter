// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_fork.dart';

class TachiForkMapper extends EnumMapper<TachiFork> {
  TachiForkMapper._();

  static TachiForkMapper? _instance;
  static TachiForkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiForkMapper._());
    }
    return _instance!;
  }

  static TachiFork fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  TachiFork decode(dynamic value) {
    switch (value) {
      case r'mihon':
        return TachiFork.mihon;
      case r'sy':
        return TachiFork.sy;
      case r'j2k':
        return TachiFork.j2k;
      case r'yokai':
        return TachiFork.yokai;
      case r'neko':
        return TachiFork.neko;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(TachiFork self) {
    switch (self) {
      case TachiFork.mihon:
        return r'mihon';
      case TachiFork.sy:
        return r'sy';
      case TachiFork.j2k:
        return r'j2k';
      case TachiFork.yokai:
        return r'yokai';
      case TachiFork.neko:
        return r'neko';
    }
  }
}

extension TachiForkMapperExtension on TachiFork {
  String toValue() {
    TachiForkMapper.ensureInitialized();
    return MapperContainer.globals.toValue<TachiFork>(this) as String;
  }
}


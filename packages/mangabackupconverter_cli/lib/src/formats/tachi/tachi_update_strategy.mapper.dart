// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'tachi_update_strategy.dart';

class TachiUpdateStrategyMapper extends EnumMapper<TachiUpdateStrategy> {
  TachiUpdateStrategyMapper._();

  static TachiUpdateStrategyMapper? _instance;
  static TachiUpdateStrategyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TachiUpdateStrategyMapper._());
    }
    return _instance!;
  }

  static TachiUpdateStrategy fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  TachiUpdateStrategy decode(dynamic value) {
    switch (value) {
      case 0:
        return TachiUpdateStrategy.alwaysUpdate;
      case 1:
        return TachiUpdateStrategy.onlyFetchOnce;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(TachiUpdateStrategy self) {
    switch (self) {
      case TachiUpdateStrategy.alwaysUpdate:
        return 0;
      case TachiUpdateStrategy.onlyFetchOnce:
        return 1;
    }
  }
}

extension TachiUpdateStrategyMapperExtension on TachiUpdateStrategy {
  dynamic toValue() {
    TachiUpdateStrategyMapper.ensureInitialized();
    return MapperContainer.globals.toValue<TachiUpdateStrategy>(this);
  }
}

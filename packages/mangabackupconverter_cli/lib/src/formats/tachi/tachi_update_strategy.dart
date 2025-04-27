import 'package:dart_mappable/dart_mappable.dart';

part 'tachi_update_strategy.mapper.dart';

@MappableEnum(mode: ValuesMode.named, caseStyle: CaseStyle.upperSnakeCase)
enum TachiUpdateStrategy { alwaysUpdate, onlyFetchOnce }

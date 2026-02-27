import 'package:freezed_annotation/freezed_annotation.dart';

part 'id.freezed.dart';

class Id {
  const Id(this.value);
  final String value;

  bool get isValid => value.isNotEmpty;
}

@freezed
sealed class IdValidFailure with _$IdValidFailure {
  const factory IdValidFailure.invalid() = _Invalid;
}

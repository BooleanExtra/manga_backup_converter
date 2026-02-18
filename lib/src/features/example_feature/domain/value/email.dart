import 'package:freezed_annotation/freezed_annotation.dart';

part 'email.freezed.dart';

class Email {
  const Email(this.value);
  final String value;

  bool get isValid => value.isNotEmpty;
}

@freezed
sealed class EmailAvailableFailure with _$EmailAvailableFailure {
  const factory EmailAvailableFailure.taken() = _Taken;
  const factory EmailAvailableFailure.reserved() = _Reserved;
  const factory EmailAvailableFailure.banned() = _Banned;
}

@freezed
sealed class EmailFormatFailure with _$EmailFormatFailure {
  const factory EmailFormatFailure.invalid() = _Invalid;
}

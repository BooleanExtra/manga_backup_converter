import 'package:freezed_annotation/freezed_annotation.dart';

part 'name.freezed.dart';

class Name {
  const Name({
    required this.firstName,
    required this.lastName,
    this.middleName = '',
  });
  final String firstName;
  final String lastName;
  final String middleName;

  bool get isValid => firstName.isNotEmpty && lastName.isNotEmpty;
}

@freezed
sealed class NameValidFailure with _$NameValidFailure {
  const factory NameValidFailure.illegalCharacters() = _IllegalCharacters;
  const factory NameValidFailure.obscene() = _Obscene;
  const factory NameValidFailure.empty() = _Empty;
}

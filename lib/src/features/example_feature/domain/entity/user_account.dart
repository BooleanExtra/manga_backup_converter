import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mangabackupconverter/src/features/example_feature/domain/value/email.dart';
import 'package:mangabackupconverter/src/features/example_feature/domain/value/id.dart';
import 'package:mangabackupconverter/src/features/example_feature/domain/value/name.dart';

part 'user_account.freezed.dart';

@freezed
sealed class UserAccount with _$UserAccount {
  const factory UserAccount({
    required Id id,
    required Name name,
    required Email email,
  }) = _UserAccount;
}

@freezed
sealed class UserAccountValidFailure with _$UserAccountValidFailure {
  const factory UserAccountValidFailure.invalid() = _Invalid;
}

const userExample = UserAccount(
  id: Id('id'),
  name: Name(firstName: 'firstName', lastName: 'lastName'),
  email: Email('email'),
);

import 'package:mangabackupconverter_cli/src/exceptions/base_exeption.dart';

class MigrationException extends MangaConverterException {
  const MigrationException([super.message]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'MigrationException';
    return 'MigrationException: $message';
  }
}

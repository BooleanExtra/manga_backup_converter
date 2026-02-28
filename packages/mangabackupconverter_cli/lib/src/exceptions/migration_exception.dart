import 'package:mangabackupconverter_cli/src/exceptions/base_exception.dart';

class MigrationException extends MangaConverterException {
  const MigrationException([super.message, super.cause, super.stackTrace]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'MigrationException';
    return 'MigrationException: $message';
  }
}

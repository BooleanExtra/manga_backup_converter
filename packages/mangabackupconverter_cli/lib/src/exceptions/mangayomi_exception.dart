import 'package:mangabackupconverter_cli/src/exceptions/base_exception.dart';

class MangayomiException extends MangaConverterException {
  const MangayomiException([super.message, super.cause, super.stackTrace]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'MangayomiException';
    return 'MangayomiException: $message';
  }
}

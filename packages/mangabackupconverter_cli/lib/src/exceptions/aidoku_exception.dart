import 'package:mangabackupconverter_cli/src/exceptions/base_exception.dart';

class AidokuException extends MangaConverterException {
  const AidokuException([super.message, super.cause, super.stackTrace]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'AidokuException';
    return 'AidokuException: $message';
  }
}
